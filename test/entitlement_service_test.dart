import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/config/monetization_config.dart';
import 'package:salary_currency_pro/models/entitlement.dart';
import 'package:salary_currency_pro/services/entitlement_service.dart';

/// A fully in-memory stand-in for `in_app_purchase`'s platform channel, the
/// same `PlatformInterface` test-double approach already used for
/// mobile_scanner in this app's test suite — no store/hardware dependency.
class FakeInAppPurchasePlatform extends InAppPurchasePlatform {
  bool availableResult = true;
  bool throwOnIsAvailable = false;
  bool throwOnRestore = false;

  final _controller = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _controller.stream;

  @override
  Future<bool> isAvailable() async {
    if (throwOnIsAvailable) throw StateError('store unavailable');
    return availableResult;
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async {
    return ProductDetailsResponse(productDetails: const [], notFoundIDs: identifiers.toList());
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    emitPurchase(
      productID: purchaseParam.productDetails.id,
      status: PurchaseStatus.purchased,
    );
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    if (throwOnRestore) throw StateError('restore failed');
    // Real behavior: if there's nothing to restore, no stream event fires
    // at all — callers here simulate "found something" by calling
    // emitPurchase separately before/after invoking restore.
  }

  void emitPurchase({
    required String productID,
    required PurchaseStatus status,
    DateTime? transactionDate,
  }) {
    _controller.add([
      PurchaseDetails(
        productID: productID,
        status: status,
        transactionDate:
            (transactionDate ?? DateTime.now()).millisecondsSinceEpoch.toString(),
        verificationData: PurchaseVerificationData(
          localVerificationData: 'local',
          serverVerificationData: 'server',
          source: 'fake',
        ),
      ),
    ]);
  }
}

void main() {
  late FakeInAppPurchasePlatform fake;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fake = FakeInAppPurchasePlatform();
    // Injected directly into EntitlementService below — this test never
    // touches InAppPurchase.instance (the facade class), which is exactly
    // the point of EntitlementService depending on InAppPurchasePlatform
    // directly: InAppPurchase.instance's first access unconditionally
    // self-registers the real Android/iOS platform as a side effect and
    // opens a real platform-channel connection, which fails asynchronously
    // in a plain Dart test with no real platform available.
    InAppPurchasePlatform.instance = fake;
  });

  EntitlementService service({Duration timeout = const Duration(milliseconds: 50)}) =>
      EntitlementService(platform: fake, verifyResponseTimeout: timeout);

  test('constructing a service with no injected platform never touches the '
      'real platform (would crash on desktop/web dev builds otherwise)', () {
    // Deliberately does NOT set platform: — this must not throw or hang,
    // because platform resolution is lazy (only touched by start()/
    // isAvailable/etc., none of which this test calls). Regression test for
    // a real bug: an earlier version resolved the real platform eagerly in
    // the constructor's initializer list, which would have crashed the app
    // immediately on any platform in_app_purchase doesn't support.
    expect(() => EntitlementService(), returnsNormally);
  });

  test('default state is free with no access', () async {
    final s = service();
    await s.start();
    expect(s.state.value.status, EntitlementStatus.free);
    expect(s.state.value.hasFullAccess, isFalse);
    s.dispose();
  });

  test('a fresh annual purchase is trialing, not pro, for the first 7 days', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proAnnualSubscriptionId,
      status: PurchaseStatus.purchased,
      transactionDate: DateTime.now(),
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.trialing);
    expect(s.state.value.hasFullAccess, isTrue);
    s.dispose();
  });

  test('an annual purchase older than the trial window is pro, not trialing', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proAnnualSubscriptionId,
      status: PurchaseStatus.restored,
      transactionDate: DateTime.now().subtract(const Duration(days: 30)),
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.pro);
    s.dispose();
  });

  test('the monthly plan is pro immediately — no trial regardless of age', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
      transactionDate: DateTime.now(),
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.pro);
    s.dispose();
  });

  test('a lifetime purchase grants lifetime status', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proLifetimePurchaseId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.lifetime);
    expect(s.state.value.hasFullAccess, isTrue);
    s.dispose();
  });

  test('the support-the-developer purchase never changes entitlement status', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.supportDeveloperPurchaseId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.free);
    s.dispose();
  });

  test('entitlement persists across a fresh service instance (SharedPreferences cache)',
      () async {
    final first = service();
    await first.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proLifetimePurchaseId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();
    first.dispose();

    final second = service();
    await second.start();
    expect(second.state.value.status, EntitlementStatus.lifetime);
    second.dispose();
  });

  test('verify() leaves cached state untouched when the store is unavailable '
      '(offline grace)', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();
    expect(s.state.value.status, EntitlementStatus.pro);

    fake.availableResult = false;
    await s.verify();

    expect(s.state.value.status, EntitlementStatus.pro);
    s.dispose();
  });

  test('verify() leaves cached state untouched when isAvailable() throws '
      '(offline grace)', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    fake.throwOnIsAvailable = true;
    await s.verify();

    expect(s.state.value.status, EntitlementStatus.pro);
    s.dispose();
  });

  test('verify() leaves cached state untouched when restorePurchases() throws '
      '(offline grace)', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    fake.throwOnRestore = true;
    await s.verify();

    expect(s.state.value.status, EntitlementStatus.pro);
    s.dispose();
  });

  test('verify() downgrades to expired when the store is reachable but '
      'confirms nothing to restore', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();
    expect(s.state.value.status, EntitlementStatus.pro);

    // fake.restorePurchases() succeeds but emits nothing — same as the real
    // plugin's behavior when there is genuinely nothing to restore.
    await s.verify();

    expect(s.state.value.status, EntitlementStatus.expired);
    expect(s.state.value.hasFullAccess, isFalse);
    s.dispose();
  });

  test('verify() keeps (and refreshes) an active entitlement the store '
      'confirms is still present', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    unawaited(s.verify());
    await pumpEventQueue();
    fake.emitPurchase(
      productID: MonetizationConfig.proMonthlySubscriptionId,
      status: PurchaseStatus.restored,
    );
    await pumpEventQueue();

    expect(s.state.value.status, EntitlementStatus.pro);
    expect(s.state.value.lastVerifiedAt, isNotNull);
    s.dispose();
  });

  test('verify() never downgrades a lifetime purchase, even if the store '
      'confirms nothing', () async {
    final s = service();
    await s.start();
    fake.emitPurchase(
      productID: MonetizationConfig.proLifetimePurchaseId,
      status: PurchaseStatus.purchased,
    );
    await pumpEventQueue();

    await s.verify();

    expect(s.state.value.status, EntitlementStatus.lifetime);
    s.dispose();
  });
}

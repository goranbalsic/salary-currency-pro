import 'dart:async';

import 'package:bilans/app/app_config.dart';
import 'package:bilans/core/storage/store.dart';
import 'package:bilans/features/pro/billing_gateway.dart';
import 'package:bilans/features/pro/pro_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

PurchaseDetails purchase(String id, PurchaseStatus status, {bool pendingComplete = false}) {
  return PurchaseDetails(
    purchaseID: 'p-$id',
    productID: id,
    verificationData: PurchaseVerificationData(localVerificationData: '', serverVerificationData: '', source: 'test'),
    transactionDate: '0',
    status: status,
  )..pendingCompletePurchase = pendingComplete;
}

class FakeGateway implements BillingGateway {
  // ignore: close_sinks — lives for the test process.
  final controller = StreamController<List<PurchaseDetails>>.broadcast();
  bool available = true;
  List<PurchaseDetails>? owned = const [];
  List<StoreProduct> products = const [
    StoreProduct(id: AppConfig.proMonthly, price: '349 RSD', rawPrice: 349, currencyCode: 'RSD'),
    StoreProduct(id: AppConfig.proYearly, price: '2.490 RSD', rawPrice: 2490, currencyCode: 'RSD', hasFreeTrial: true, freeTrialDays: 7),
    StoreProduct(id: AppConfig.proLifetime, price: '4.990 RSD', rawPrice: 4990, currencyCode: 'RSD'),
  ];
  final completed = <String>[];
  final bought = <String>[];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<List<StoreProduct>> queryProducts(Set<String> ids) async => products.where((p) => ids.contains(p.id)).toList();
  @override
  Future<bool> buy(StoreProduct product) async {
    bought.add(product.id);
    return true;
  }

  @override
  Future<void> complete(PurchaseDetails purchase) async => completed.add(purchase.productID);
  @override
  Future<List<PurchaseDetails>?> queryOwned() async => owned;
}

Future<Store> freshStore([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return Store.open();
}

void main() {
  late DateTime now;
  DateTime clock() => now;

  setUp(() => now = DateTime(2026, 9, 25, 12));

  test('starts free and unlocks when Play reports an owned subscription', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..owned = [purchase(AppConfig.proYearly, PurchaseStatus.purchased, pendingComplete: true)];
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    expect(pro.isPro, isFalse);
    await pro.start();
    expect(pro.isPro, isTrue);
    expect(pro.productId, AppConfig.proYearly);
    expect(pro.isSubscription, isTrue);
    expect(gateway.completed, [AppConfig.proYearly], reason: 'unacknowledged purchases are acknowledged');
    expect(ProController(store, billingSupported: false, clock: clock).isPro, isTrue, reason: 'cached for the next start');
  });

  test('revokes when Play no longer reports the purchase', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..owned = [purchase(AppConfig.proMonthly, PurchaseStatus.purchased)];
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    expect(pro.isPro, isTrue);
    gateway.owned = const [];
    await pro.reconcile();
    expect(pro.isPro, isFalse);
  });

  test('keeps a cached subscription offline within the grace period only', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..owned = [purchase(AppConfig.proMonthly, PurchaseStatus.purchased)];
    await ProController(store, gateway: gateway, billingSupported: true, clock: clock).start();

    now = now.add(const Duration(days: 20));
    final offline = FakeGateway()..owned = null;
    final later = ProController(store, gateway: offline, billingSupported: true, clock: clock);
    await later.start();
    expect(later.isPro, isTrue, reason: 'Play unreachable: cache still inside the grace');

    now = now.add(const Duration(days: 2));
    expect(ProController(store, billingSupported: false, clock: clock).isPro, isFalse, reason: 'grace expired');
  });

  test('a lifetime purchase survives past the offline grace', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..owned = [purchase(AppConfig.proLifetime, PurchaseStatus.purchased)];
    await ProController(store, gateway: gateway, billingSupported: true, clock: clock).start();
    now = now.add(const Duration(days: 400));
    expect(ProController(store, billingSupported: false, clock: clock).isPro, isTrue);
  });

  test('lifetime wins over a subscription in the owned list', () async {
    final store = await freshStore();
    final gateway = FakeGateway()
      ..owned = [purchase(AppConfig.proLifetime, PurchaseStatus.purchased), purchase(AppConfig.proMonthly, PurchaseStatus.purchased)];
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    expect(pro.productId, AppConfig.proLifetime);
    expect(pro.isSubscription, isFalse);
  });

  test('purchase flow: products, buy, pending, then purchased', () async {
    final store = await freshStore();
    final gateway = FakeGateway();
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    await pro.loadProducts();
    expect(pro.products.length, 3);
    expect(pro.product(AppConfig.proYearly)!.hasFreeTrial, isTrue);

    await pro.buy(pro.product(AppConfig.proYearly)!);
    expect(gateway.bought, [AppConfig.proYearly]);
    expect(pro.flow, PurchaseFlow.purchasing);

    gateway.controller.add([purchase(AppConfig.proYearly, PurchaseStatus.pending)]);
    await pumpEventQueue();
    expect(pro.flow, PurchaseFlow.pending);
    expect(pro.isPro, isFalse);

    gateway.controller.add([purchase(AppConfig.proYearly, PurchaseStatus.purchased, pendingComplete: true)]);
    await pumpEventQueue();
    expect(pro.flow, PurchaseFlow.success);
    expect(pro.isPro, isTrue);
    expect(gateway.completed, contains(AppConfig.proYearly));
    pro.dispose();
  });

  test('cancel and error leave Pro locked and are acknowledged', () async {
    final store = await freshStore();
    final gateway = FakeGateway();
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    gateway.controller.add([purchase(AppConfig.proMonthly, PurchaseStatus.canceled, pendingComplete: true)]);
    await pumpEventQueue();
    expect(pro.flow, PurchaseFlow.cancelled);
    expect(pro.isPro, isFalse);
    expect(gateway.completed, [AppConfig.proMonthly]);
    pro.acknowledgeFlow();
    expect(pro.flow, PurchaseFlow.idle);

    gateway.controller.add([purchase(AppConfig.proMonthly, PurchaseStatus.error)]);
    await pumpEventQueue();
    expect(pro.flow, PurchaseFlow.error);
    expect(pro.isPro, isFalse);
    pro.dispose();
  });

  test('unknown products never unlock Pro', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..owned = [purchase('some_other_sku', PurchaseStatus.purchased)];
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    expect(pro.isPro, isFalse);
  });

  test('store unavailable: products cannot load and restore reports false', () async {
    final store = await freshStore();
    final gateway = FakeGateway()..available = false;
    final pro = ProController(store, gateway: gateway, billingSupported: true, clock: clock);
    await pro.start();
    await pro.loadProducts();
    expect(pro.flow, PurchaseFlow.error);
    expect(await pro.restore(), isFalse);
  });

  test('without billing (web, tests) start is a no-op', () async {
    final store = await freshStore();
    final pro = ProController(store, billingSupported: false, clock: clock);
    await pro.start();
    expect(pro.isPro, isFalse);
    expect(pro.storeAvailable, isFalse);
  });
}

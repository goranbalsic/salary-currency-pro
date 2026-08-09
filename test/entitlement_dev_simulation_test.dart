import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/entitlement.dart';
import 'package:salary_currency_pro/services/entitlement_service.dart';

/// A minimal `InAppPurchasePlatform` double — same
/// `PlatformInterface`-injection reasoning as
/// `entitlement_service_test.dart`'s own `FakeInAppPurchasePlatform`, kept
/// separate and deliberately minimal here since these tests only need
/// `start()` to complete safely for a *non*-dev-simulated instance, never
/// exercising a real purchase.
class _NoopPlatform extends InAppPurchasePlatform {
  final _controller = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _controller.stream;

  @override
  Future<bool> isAvailable() async => false;
}

/// PROMPT-003J checkpoint 1/2: EntitlementService's dev-simulation mode
/// never touches the real store at all — see entitlement_service_test.dart
/// for the real-store-backed test suite this deliberately doesn't overlap
/// with (devSimulationEnabled short-circuits start() before any platform
/// access happens). The handful of tests below that construct a
/// *non*-dev-simulated instance (to prove the two modes don't cross-talk)
/// inject [_NoopPlatform] for the same reason
/// entitlement_service_test.dart does: touching the real platform in a
/// plain Dart test fails asynchronously and misattributes to whatever
/// test is running.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    InAppPurchasePlatform.instance = _NoopPlatform();
  });

  test('devSimulationEnabled defaults to fully unlocked Pro with nothing '
      'explicitly simulated yet', () async {
    final service = EntitlementService(devSimulationEnabled: true);
    await service.start();

    expect(service.state.value.status, EntitlementStatus.pro);
    expect(service.state.value.hasFullAccess, isTrue);
  });

  test('setDevSimulatedStatus updates state immediately for every status',
      () async {
    final service = EntitlementService(devSimulationEnabled: true);
    await service.start();

    for (final status in EntitlementStatus.values) {
      await service.setDevSimulatedStatus(status);
      expect(service.state.value.status, status);
    }
  });

  test('a simulated status persists across a fresh service instance '
      '(restart)', () async {
    final first = EntitlementService(devSimulationEnabled: true);
    await first.start();
    await first.setDevSimulatedStatus(EntitlementStatus.expired);

    final second = EntitlementService(devSimulationEnabled: true);
    await second.start();

    expect(second.state.value.status, EntitlementStatus.expired);
  });

  test('setDevSimulatedStatus is a no-op when devSimulationEnabled is false '
      '(defense in depth beyond UI-level gating)', () async {
    final service = EntitlementService(platform: _NoopPlatform());
    await service.start();
    final before = service.state.value.status;

    await service.setDevSimulatedStatus(EntitlementStatus.lifetime);

    expect(service.state.value.status, before);
    expect(service.state.value.status, isNot(EntitlementStatus.lifetime));
  });

  test('the dev-simulated override is stored separately from the real '
      'cache key, so a prod build never picks up a stray simulated value',
      () async {
    final dev = EntitlementService(devSimulationEnabled: true);
    await dev.start();
    await dev.setDevSimulatedStatus(EntitlementStatus.lifetime);

    // A prod-mode instance reads the real cache key only.
    final prod = EntitlementService(platform: _NoopPlatform());
    await prod.start();

    expect(prod.state.value.status, EntitlementStatus.free);
  });
}

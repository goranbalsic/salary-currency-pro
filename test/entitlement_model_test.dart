import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/entitlement.dart';

void main() {
  test('hasFullAccess is true for trialing, pro, and lifetime only', () {
    expect(const EntitlementState(status: EntitlementStatus.free).hasFullAccess, isFalse);
    expect(const EntitlementState(status: EntitlementStatus.trialing).hasFullAccess, isTrue);
    expect(const EntitlementState(status: EntitlementStatus.pro).hasFullAccess, isTrue);
    expect(const EntitlementState(status: EntitlementStatus.lifetime).hasFullAccess, isTrue);
    expect(const EntitlementState(status: EntitlementStatus.expired).hasFullAccess, isFalse);
  });

  test('toJson/fromJson round-trips every field', () {
    final now = DateTime(2026, 8, 9, 12, 30);
    const state = EntitlementState(
      status: EntitlementStatus.pro,
      productId: 'pro_annual',
    );
    final withDates = state.copyWith(purchaseDate: now, lastVerifiedAt: now);

    final restored = EntitlementState.fromJson(withDates.toJson());

    expect(restored.status, EntitlementStatus.pro);
    expect(restored.productId, 'pro_annual');
    expect(restored.purchaseDate, now);
    expect(restored.lastVerifiedAt, now);
  });

  test('fromJson tolerates an unrecognized status and defaults to free', () {
    final restored = EntitlementState.fromJson({
      'status': 'not_a_real_status',
    });
    expect(restored.status, EntitlementStatus.free);
  });

  test('copyWith changes only the given fields', () {
    const original = EntitlementState(status: EntitlementStatus.free);
    final updated = original.copyWith(status: EntitlementStatus.lifetime, productId: 'pro_lifetime');

    expect(updated.status, EntitlementStatus.lifetime);
    expect(updated.productId, 'pro_lifetime');
    expect(original.status, EntitlementStatus.free);
  });
}

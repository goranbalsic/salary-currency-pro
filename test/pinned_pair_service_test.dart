import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/services/pinned_pair_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('a fresh install defaults to EUR -> RSD', () async {
    final service = PinnedPairService();
    final (from, to) = await service.loadPair();
    expect(from, 'EUR');
    expect(to, 'RSD');
  });

  test('setPair persists and is reflected by a later loadPair', () async {
    final service = PinnedPairService();
    await service.setPair('USD', 'BGN');

    final (from, to) = await service.loadPair();
    expect(from, 'USD');
    expect(to, 'BGN');
  });

  test('setPair bumps the changes notifier', () async {
    final service = PinnedPairService();
    final before = PinnedPairService.changes.value;

    await service.setPair('GBP', 'HRK');

    expect(PinnedPairService.changes.value, before + 1);
  });
}

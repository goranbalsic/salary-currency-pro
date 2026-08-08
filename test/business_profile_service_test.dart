import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/business_profile.dart';
import 'package:salary_currency_pro/services/business_profile_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('load() on a fresh install returns an empty profile', () async {
    final service = BusinessProfileService();
    final profile = await service.load();
    expect(profile.isEmpty, isTrue);
  });

  test('save() then load() round-trips every field', () async {
    final service = BusinessProfileService();
    await service.save(const BusinessProfile(
      businessName: 'Čigra doo',
      addressLine1: 'Bulevar 12',
      addressLine2: 'Leskovac',
      bankAccountNumber: '840000000095584510',
      defaultPaymentCode: '289',
    ));

    final reloaded = await service.load();
    expect(reloaded.businessName, 'Čigra doo');
    expect(reloaded.addressLine1, 'Bulevar 12');
    expect(reloaded.addressLine2, 'Leskovac');
    expect(reloaded.bankAccountNumber, '840000000095584510');
    expect(reloaded.defaultPaymentCode, '289');
    expect(reloaded.isEmpty, isFalse);
  });

  test('save() overwrites the single record rather than appending', () async {
    final service = BusinessProfileService();
    await service.save(const BusinessProfile(businessName: 'First'));
    await service.save(const BusinessProfile(businessName: 'Second'));

    final reloaded = await service.load();
    expect(reloaded.businessName, 'Second');
  });

  test('corrupt locally-stored JSON degrades to an empty profile rather than '
      'throwing', () async {
    SharedPreferences.setMockInitialValues({'business_profile_v1': '{not valid json'});
    final service = BusinessProfileService();
    final profile = await service.load();
    expect(profile.isEmpty, isTrue);
  });

  test('save() bumps the changes notifier', () async {
    final service = BusinessProfileService();
    final before = BusinessProfileService.changes.value;
    await service.save(const BusinessProfile(businessName: 'X'));
    expect(BusinessProfileService.changes.value, before + 1);
  });
}

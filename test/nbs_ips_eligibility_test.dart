import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/logic/nbs_ips_eligibility.dart';
import 'package:salary_currency_pro/models/business_profile.dart';
import 'package:salary_currency_pro/models/invoice.dart';

Invoice _invoice({String currencyCode = 'RSD', double amount = 1000}) => Invoice(
      id: 'x',
      clientName: 'Acme',
      amount: amount,
      currencyCode: currencyCode,
      issueDate: DateTime(2026, 1, 1),
      dueDate: DateTime(2026, 1, 15),
    );

const _validProfile = BusinessProfile(
  businessName: 'Čigra doo',
  bankAccountNumber: '840-955845-10',
  defaultPaymentCode: '289',
);

void main() {
  group('NbsIpsEligibility.evaluate — non-RSD invoices', () {
    test('every non-RSD currency is notRsd, regardless of profile state', () {
      for (final currency in ['EUR', 'USD', 'BAM', 'MKD']) {
        final result = NbsIpsEligibility.evaluate(
          _invoice(currencyCode: currency),
          _validProfile,
        );
        expect(result.reason, NbsIpsEligibilityReason.notRsd, reason: currency);
        expect(result.isEligible, isFalse);
        expect(result.payload, isNull);
      }
    });
  });

  group('NbsIpsEligibility.evaluate — RSD invoices', () {
    test('a fully valid profile + invoice is eligible with a real payload', () {
      final result = NbsIpsEligibility.evaluate(_invoice(), _validProfile);
      expect(result.reason, NbsIpsEligibilityReason.eligible);
      expect(result.isEligible, isTrue);
      expect(result.payload, isNotNull);
      expect(result.payload, startsWith('K:PR|V:01|C:1|'));
    });

    test('an empty business profile is missingOrInvalidData, not eligible '
        '— a normal (non-QR) PDF must still be generatable', () {
      final result = NbsIpsEligibility.evaluate(_invoice(), const BusinessProfile());
      expect(result.reason, NbsIpsEligibilityReason.missingOrInvalidData);
      expect(result.isEligible, isFalse);
      expect(result.payload, isNull);
      expect(result.fieldErrors, isNotEmpty);
    });

    test('a profile missing only the bank account is missingOrInvalidData',
        () {
      final result = NbsIpsEligibility.evaluate(
        _invoice(),
        const BusinessProfile(businessName: 'Čigra doo', defaultPaymentCode: '289'),
      );
      expect(result.isEligible, isFalse);
    });

    test('a zero/invalid invoice amount is missingOrInvalidData even with a '
        'complete profile', () {
      final result = NbsIpsEligibility.evaluate(_invoice(amount: 0), _validProfile);
      expect(result.isEligible, isFalse);
    });
  });
}

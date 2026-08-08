import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/logic/nbs_ips_payload_builder.dart';

/// Spec source for every fixture/rule below: NBS "Preporuke"
/// (Recommendations) PDF, © 2020 Narodna banka Srbije,
/// https://ips.nbs.rs/PDF/pdfPreporukeValidacijaLat.pdf — see
/// DECISIONS.md for the full field-rule citation.
void main() {
  group('normalizeAccountNumber — the source document\'s own worked examples', () {
    test('840-955845-10 -> 840000000095584510', () {
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840-955845-10'),
          '840000000095584510');
    });

    test('165-55-74 -> 165000000000005574', () {
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('165-55-74'),
          '165000000000005574');
    });

    test('310-1234567891211-86 -> 310123456789121186 (already 13-digit '
        'account, no padding needed)', () {
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('310-1234567891211-86'),
          '310123456789121186');
    });

    test('an already-18-digit account passes through unchanged', () {
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840000000095584510'),
          '840000000095584510');
    });

    test('rejects a wrong segment count, non-digit content, and an '
        'oversized account/bank/control part rather than guessing', () {
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840-955845'), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840-955845-10-1'), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('84X-955845-10'), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840-12345678901234-10'), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('840-955845-1'), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber(''), isNull);
      expect(NbsIpsPayloadBuilder.normalizeAccountNumber('not an account'), isNull);
    });
  });

  NbsIpsInput validInput({
    String accountNumber = '840-955845-10',
    String recipientName = 'Čigra doo',
    double amountRsd = 1025.12,
    String paymentCode = '289',
    String? payerName,
    String? purpose,
    String? paymentReference,
  }) =>
      NbsIpsInput(
        accountNumber: accountNumber,
        recipientName: recipientName,
        amountRsd: amountRsd,
        paymentCode: paymentCode,
        payerName: payerName,
        purpose: purpose,
        paymentReference: paymentReference,
      );

  group('NbsIpsPayloadBuilder.build — valid payloads', () {
    test('mandatory-only fields produce the exact expected pipe-delimited '
        'payload, in field order', () {
      final result = NbsIpsPayloadBuilder.build(validInput());
      expect(result.isValid, isTrue);
      expect(
        result.payload,
        'K:PR|V:01|C:1|R:840000000095584510|N:Čigra doo|I:RSD1025,12|SF:289',
      );
    });

    test('optional P/S/RO are included, in order, only when provided', () {
      final result = NbsIpsPayloadBuilder.build(validInput(
        payerName: 'Marko Marković',
        purpose: 'Website redesign',
        paymentReference: '979714123412',
      ));
      expect(result.isValid, isTrue);
      expect(
        result.payload,
        'K:PR|V:01|C:1|R:840000000095584510|N:Čigra doo|I:RSD1025,12'
        '|P:Marko Marković|SF:289|S:Website redesign|RO:979714123412',
      );
    });

    test('amount always renders with exactly 2 decimal places and a comma',
        () {
      final result = NbsIpsPayloadBuilder.build(validInput(amountRsd: 500));
      expect(result.payload, contains('I:RSD500,00'));
    });

    test('a floating-point-artifact-prone amount still renders a clean, '
        'deterministic 2-decimal value', () {
      // 3 * 0.1 is 0.30000000000000004 in raw double arithmetic.
      final result = NbsIpsPayloadBuilder.build(validInput(amountRsd: 3 * 0.1));
      expect(result.payload, contains('I:RSD0,30'));
    });
  });

  group('NbsIpsPayloadBuilder.build — account (R)', () {
    test('missing account is reported distinctly from an invalid one', () {
      expect(NbsIpsPayloadBuilder.build(validInput(accountNumber: '')).errors,
          contains(NbsIpsFieldError.accountMissing));
      expect(
          NbsIpsPayloadBuilder.build(validInput(accountNumber: 'garbage')).errors,
          contains(NbsIpsFieldError.accountInvalid));
    });
  });

  group('NbsIpsPayloadBuilder.build — recipient name (N)', () {
    test('missing is rejected', () {
      expect(NbsIpsPayloadBuilder.build(validInput(recipientName: '')).errors,
          contains(NbsIpsFieldError.recipientNameMissing));
    });

    test('over 70 characters is rejected', () {
      final result = NbsIpsPayloadBuilder.build(validInput(recipientName: 'A' * 71));
      expect(result.errors, contains(NbsIpsFieldError.recipientNameTooLong));
    });

    test('exactly 70 characters is accepted', () {
      final result = NbsIpsPayloadBuilder.build(validInput(recipientName: 'A' * 70));
      expect(result.isValid, isTrue);
    });

    test('more than 3 lines is rejected', () {
      final result =
          NbsIpsPayloadBuilder.build(validInput(recipientName: 'A\nB\nC\nD'));
      expect(result.errors, contains(NbsIpsFieldError.recipientNameTooManyLines));
    });

    test('exactly 3 lines (name + street + city) is accepted', () {
      final result = NbsIpsPayloadBuilder.build(
        validInput(recipientName: 'Čigra doo\nBulevar 12\nLeskovac'),
      );
      expect(result.isValid, isTrue);
    });

    test('the reserved "|" delimiter is rejected — an unescaped pipe would '
        'corrupt the payload\'s field structure', () {
      final result =
          NbsIpsPayloadBuilder.build(validInput(recipientName: 'Bad|Name'));
      expect(result.errors, contains(NbsIpsFieldError.recipientNameInvalidCharacter));
    });
  });

  group('NbsIpsPayloadBuilder.build — amount (I)', () {
    test('zero is rejected — a QR payment code needs a positive amount', () {
      expect(NbsIpsPayloadBuilder.build(validInput(amountRsd: 0)).errors,
          contains(NbsIpsFieldError.amountInvalid));
    });

    test('negative is rejected', () {
      expect(NbsIpsPayloadBuilder.build(validInput(amountRsd: -5)).errors,
          contains(NbsIpsFieldError.amountInvalid));
    });

    test('NaN/Infinity are rejected rather than producing a malformed field',
        () {
      expect(
          NbsIpsPayloadBuilder.build(validInput(amountRsd: double.nan)).errors,
          contains(NbsIpsFieldError.amountInvalid));
      expect(
          NbsIpsPayloadBuilder.build(validInput(amountRsd: double.infinity)).errors,
          contains(NbsIpsFieldError.amountInvalid));
    });
  });

  group('NbsIpsPayloadBuilder.build — payment code (SF)', () {
    test('missing is rejected', () {
      expect(NbsIpsPayloadBuilder.build(validInput(paymentCode: '')).errors,
          contains(NbsIpsFieldError.paymentCodeMissing));
    });

    test('not exactly 3 digits is rejected', () {
      expect(NbsIpsPayloadBuilder.build(validInput(paymentCode: '28')).errors,
          contains(NbsIpsFieldError.paymentCodeInvalid));
      expect(NbsIpsPayloadBuilder.build(validInput(paymentCode: '2891')).errors,
          contains(NbsIpsFieldError.paymentCodeInvalid));
      expect(NbsIpsPayloadBuilder.build(validInput(paymentCode: 'abc')).errors,
          contains(NbsIpsFieldError.paymentCodeInvalid));
    });
  });

  group('NbsIpsPayloadBuilder.build — payer (P), optional', () {
    test('omitted entirely when not provided (never emitted as empty "P:")',
        () {
      final result = NbsIpsPayloadBuilder.build(validInput());
      expect(result.payload, isNot(contains('P:')));
    });

    test('over 70 characters is rejected', () {
      final result = NbsIpsPayloadBuilder.build(validInput(payerName: 'A' * 71));
      expect(result.errors, contains(NbsIpsFieldError.payerNameTooLong));
    });
  });

  group('NbsIpsPayloadBuilder.build — purpose (S), optional', () {
    test('omitted entirely when not provided', () {
      final result = NbsIpsPayloadBuilder.build(validInput());
      expect(result.payload, isNot(contains('S:')));
    });

    test('over 35 characters is rejected', () {
      final result = NbsIpsPayloadBuilder.build(validInput(purpose: 'A' * 36));
      expect(result.errors, contains(NbsIpsFieldError.purposeTooLong));
    });

    test('exactly 35 characters is accepted', () {
      final result = NbsIpsPayloadBuilder.build(validInput(purpose: 'A' * 35));
      expect(result.isValid, isTrue);
    });

    test('a newline is rejected — purpose is single-line only', () {
      final result = NbsIpsPayloadBuilder.build(validInput(purpose: 'Line1\nLine2'));
      expect(result.errors, contains(NbsIpsFieldError.purposeMultiline));
    });
  });

  group('NbsIpsPayloadBuilder.build — payment reference (RO), optional', () {
    test('omitted entirely when not provided', () {
      final result = NbsIpsPayloadBuilder.build(validInput());
      expect(result.payload, isNot(contains('RO:')));
    });

    test('must start with a 2-digit model prefix', () {
      final result = NbsIpsPayloadBuilder.build(validInput(paymentReference: 'AB1234'));
      expect(result.errors, contains(NbsIpsFieldError.paymentReferenceInvalidFormat));
    });

    test('"00" (no model) with digits is accepted', () {
      final result = NbsIpsPayloadBuilder.build(validInput(paymentReference: '001234'));
      expect(result.isValid, isTrue);
      expect(result.payload, contains('RO:001234'));
    });

    test('a non-97 model may use a dash to separate character groups', () {
      final result = NbsIpsPayloadBuilder.build(validInput(paymentReference: '11-0014-1234-12'));
      expect(result.isValid, isTrue);
    });

    test('model 97 must not use a dash — its own check-digit rules forbid it',
        () {
      final result = NbsIpsPayloadBuilder.build(validInput(paymentReference: '97-14123412'));
      expect(result.errors, contains(NbsIpsFieldError.paymentReferenceInvalidFormat));
    });

    test('model 97 without a dash is accepted (no checksum verification — '
        'deliberately out of scope, see OPEN_QUESTIONS.md)', () {
      final result = NbsIpsPayloadBuilder.build(validInput(paymentReference: '9714123412'));
      expect(result.isValid, isTrue);
    });

    test('over 25 characters is rejected', () {
      final result =
          NbsIpsPayloadBuilder.build(validInput(paymentReference: '00${'1' * 24}'));
      expect(result.errors, contains(NbsIpsFieldError.paymentReferenceTooLong));
    });
  });

  test('multiple invalid fields are all reported together, not just the '
      'first one found', () {
    final result = NbsIpsPayloadBuilder.build(validInput(
      accountNumber: '',
      recipientName: '',
      paymentCode: '',
    ));
    expect(result.isValid, isFalse);
    expect(result.errors, containsAll([
      NbsIpsFieldError.accountMissing,
      NbsIpsFieldError.recipientNameMissing,
      NbsIpsFieldError.paymentCodeMissing,
    ]));
  });

  test('never throws on garbage input — always returns a typed failure', () {
    expect(
      () => NbsIpsPayloadBuilder.build(NbsIpsInput(
        accountNumber: '!!!',
        recipientName: '',
        amountRsd: double.nan,
        paymentCode: '',
        purpose: '\n\n\n',
        paymentReference: '###',
      )),
      returnsNormally,
    );
  });
}

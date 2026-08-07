import 'package:flutter_test/flutter_test.dart';
import 'package:salary_currency_pro/utils/validators.dart';

void main() {
  group('parseAmountInput', () {
    test('rejects null/empty input without crashing', () {
      expect(parseAmountInput(null).issue, AmountIssue.empty);
      expect(parseAmountInput('').issue, AmountIssue.empty);
      expect(parseAmountInput('   ').issue, AmountIssue.empty);
    });

    test('rejects garbage input', () {
      expect(parseAmountInput('abc').issue, AmountIssue.invalid);
      expect(parseAmountInput('12x34').issue, AmountIssue.invalid);
    });

    test('rejects negative numbers', () {
      final result = parseAmountInput('-50');
      expect(result.issue, AmountIssue.negative);
      expect(result.value, -50);
    });

    test('accepts zero when allowZero is true (default)', () {
      final result = parseAmountInput('0');
      expect(result.isValid, isTrue);
      expect(result.value, 0);
    });

    test('rejects zero when allowZero is false', () {
      final result = parseAmountInput('0', allowZero: false);
      expect(result.issue, AmountIssue.zeroNotAllowed);
    });

    test('flags absurdly large values instead of silently accepting them',
        () {
      final result = parseAmountInput('999999999999', max: 100000000);
      expect(result.issue, AmountIssue.tooLarge);
    });

    test('accepts a normal decimal amount, comma or dot', () {
      expect(parseAmountInput('1234.56').value, 1234.56);
      expect(parseAmountInput('1234,56').value, 1234.56);
    });

    test('rejects NaN/Infinity-producing input', () {
      expect(parseAmountInput('Infinity').issue, AmountIssue.invalid);
      expect(parseAmountInput('NaN').issue, AmountIssue.invalid);
    });
  });
}

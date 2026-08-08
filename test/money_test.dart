import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/invoice_line_item.dart';
import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/utils/money.dart';

void main() {
  group('roundToMinorUnits', () {
    test('rounds a clean amount exactly', () {
      expect(roundToMinorUnits(1025.12), 102512);
    });

    test('rounds away a floating-point artifact instead of truncating it',
        () {
      // 3 * 0.1 is 0.30000000000000004 in raw double arithmetic.
      expect(roundToMinorUnits(3 * 0.1), 30);
    });

    test('half-up rounds a fractional cent', () {
      expect(roundToMinorUnits(1.005), 101);
      expect(roundToMinorUnits(1.004), 100);
    });
  });

  group('sumMinorUnits / minorUnitsToAmount', () {
    test('sums integer cents with no drift across many lines', () {
      final cents = List.generate(7, (_) => roundToMinorUnits(341.71));
      expect(sumMinorUnits(cents), 34171 * 7);
      expect(minorUnitsToAmount(sumMinorUnits(cents)), 2391.97);
    });

    test('never produces a non-terminating-looking artifact for a repeating '
        'input', () {
      // quantity/unitPrice chosen so raw double math would carry a long
      // fractional tail (1/3-style) if rounded only at the end.
      final line = InvoiceLineItem(description: 'x', quantity: 3, unitPrice: 341.706666);
      // Rounded once, to the nearest cent, at the line level.
      expect(line.subtotalMinorUnits, roundToMinorUnits(3 * 341.706666));
      final formatted = formatMinorUnits(line.subtotalMinorUnits);
      expect(formatted, matches(RegExp(r'^\d+\.\d{2}$')));
    });
  });

  group('formatMinorUnits', () {
    test('formats with a dot by default', () {
      expect(formatMinorUnits(102512), '1025.12');
    });

    test('formats with a comma for the NBS IPS "I" tag', () {
      expect(formatMinorUnits(102512, decimalSeparator: ','), '1025,12');
    });

    test('pads a single-digit cent value', () {
      expect(formatMinorUnits(102501, decimalSeparator: ','), '1025,01');
    });

    test('formats a negative amount with the sign before the digits', () {
      expect(formatMinorUnits(-150), '-1.50');
    });
  });

  group('Invoice.totalFromItems', () {
    test('is the deterministic rounded sum of all line subtotals', () {
      final items = [
        const InvoiceLineItem(description: 'A', quantity: 3, unitPrice: 0.1),
        const InvoiceLineItem(description: 'B', quantity: 1, unitPrice: 99.99),
      ];
      // 3 * 0.1 rounds to 0.30 (not a raw-double 0.30000000000000004), so
      // the total is exactly 100.29, not something like 100.28999999999999.
      expect(Invoice.totalFromItems(items), 100.29);
    });

    test('is zero for an empty item list', () {
      expect(Invoice.totalFromItems(const []), 0.0);
    });
  });
}

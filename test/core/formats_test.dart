import 'package:bilans/core/format/amount_input.dart';
import 'package:bilans/core/format/formats.dart';
import 'package:bilans/core/money/money.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const nbsp = ' ';

/// Types [text] one character at a time through [f], as a keyboard would.
String type(AmountInputFormatter f, String text, {String start = ''}) {
  var value = TextEditingValue(text: start, selection: TextSelection.collapsed(offset: start.length));
  for (final ch in text.split('')) {
    final next = value.text.substring(0, value.selection.baseOffset) + ch + value.text.substring(value.selection.baseOffset);
    value = f.formatEditUpdate(value, TextEditingValue(text: next, selection: TextSelection.collapsed(offset: value.selection.baseOffset + 1)));
  }
  return value.text;
}

void main() {
  group('Money', () {
    test('rounds half away from zero despite binary floats', () {
      expect(Money.round(1.005), 1.01);
      expect(Money.round(2.675), 2.68);
      expect(Money.round(-1.005), -1.01);
      expect(Money.round(0.125, 2), 0.13);
      expect(Money.round(1234.5, 0), 1235);
    });

    test('sums in minor units without drift', () {
      expect(Money.sum([0.1, 0.2]), 0.3);
      expect(Money.sum(List.filled(1000, 0.01)), 10.0);
      expect(Money.sub(0.3, 0.1), 0.2);
    });
  });

  group('Formats', () {
    final en = Formats('en');
    final sr = Formats('sr');
    final bg = Formats('bg');

    test('numbers use each language’s separators', () {
      expect(en.number(1234567.891), '1,234,567.89');
      expect(sr.number(1234567.891), '1.234.567,89');
      expect(bg.number(1234.5), '1${nbsp}234,50');
      expect(sr.number(0.004), '0,00');
      expect(sr.number(-0.004), '0,00', reason: 'no negative zero');
      expect(sr.number(-12.5), '−12,50');
      expect(sr.number(double.nan), '—');
    });

    test('money puts the symbol where each language expects it', () {
      expect(en.money(1234.5, 'EUR'), '€1,234.50');
      expect(en.money(-5, 'EUR'), '−€5.00');
      expect(sr.money(1234.5, 'EUR'), '1.234,50$nbsp€');
      expect(sr.money(108572.1, 'RSD'), '108.572,10${nbsp}RSD');
      expect(sr.money(100, 'BAM'), '100,00${nbsp}KM');
      expect(Formats('mk').money(100, 'MKD'), '100,00$nbspден');
      expect(Formats('ro').money(100, 'RON'), '100,00${nbsp}lei');
      expect(en.money(1000, 'JPY'), '1,000${nbsp}JPY');
    });

    test('percent from a fraction and from a percentage', () {
      expect(sr.percent(0.3714), '37,1%');
      expect(en.percentValue(7.49), '7.49%');
    });

    test('dates follow local convention', () {
      final d = DateTime(2026, 9, 5);
      expect(sr.date(d), '05.09.2026.');
      expect(Formats('hr').date(d), '05.09.2026.');
      expect(Formats('sl').date(d), '05.09.2026');
      expect(en.date(d), '5 Sep 2026');
      expect(sr.shortDate(d), '05.09.');
    });

    test('parseLoose reads any common style', () {
      expect(Formats.parseLoose('1.234,56'), 1234.56);
      expect(Formats.parseLoose('1,234.56'), 1234.56);
      expect(Formats.parseLoose('1234.56'), 1234.56);
      expect(Formats.parseLoose('1 234,56'), 1234.56);
      expect(Formats.parseLoose('1${nbsp}234,56 €'), 1234.56);
      expect(Formats.parseLoose('1.234'), 1234);
      expect(Formats.parseLoose('1,5'), 1.5);
      expect(Formats.parseLoose('1.234.567'), 1234567);
      expect(Formats.parseLoose('−12,5'), -12.5);
      expect(Formats.parseLoose('RSD'), isNull);
      expect(Formats.parseLoose(''), isNull);
    });
  });

  group('AmountInputFormatter', () {
    final sr = AmountInputFormatter(formats: Formats('sr'));
    final en = AmountInputFormatter(formats: Formats('en'));

    test('groups thousands live while typing', () {
      expect(type(sr, '1234567'), '1.234.567');
      expect(type(en, '1234567'), '1,234,567');
    });

    test('either . or , starts the decimals', () {
      expect(type(sr, '1234,5'), '1.234,5');
      expect(type(sr, '1234.5'), '1.234,5');
      expect(type(en, '1234,5'), '1,234.5');
      expect(type(en, '1234.56'), '1,234.56');
    });

    test('limits decimals and integer digits', () {
      expect(type(sr, '1,999'), '1,99');
      final short = AmountInputFormatter(formats: Formats('sr'), maxIntegerDigits: 3);
      expect(type(short, '1234'), '123');
      final whole = AmountInputFormatter(formats: Formats('sr'), decimals: 0);
      expect(type(whole, '12,5'), '125');
    });

    test('a leading separator becomes 0,', () {
      expect(type(sr, ',5'), '0,5');
    });

    test('strips leading zeros', () {
      expect(type(sr, '0007'), '7');
    });

    test('pasting a formatted number re-formats it', () {
      final out = sr.formatEditUpdate(TextEditingValue.empty, const TextEditingValue(text: '1,234.56', selection: TextSelection.collapsed(offset: 8)));
      expect(out.text, '1.234,56');
    });

    test('backspace over a group separator removes the digit before it', () {
      const old = TextEditingValue(text: '1.234', selection: TextSelection.collapsed(offset: 2));
      // The user deletes the '.' at index 1 (cursor after it).
      const deleted = TextEditingValue(text: '1234', selection: TextSelection.collapsed(offset: 1));
      final out = sr.formatEditUpdate(old, deleted);
      expect(out.text, '234');
    });

    test('round-trips values for editing', () {
      expect(sr.formatNumberForEditing(1234.5), '1.234,5');
      expect(sr.formatNumberForEditing(1234), '1.234');
      expect(sr.formatNumberForEditing(0), '');
      expect(sr.parse('1.234,5'), 1234.5);
      expect(en.parse('1,234.5'), 1234.5);
      expect(sr.parse(''), isNull);
    });

    test('signed fields accept a leading minus', () {
      final signed = AmountInputFormatter(formats: Formats('sr'), allowNegative: true);
      expect(type(signed, '-'), '−');
      expect(type(signed, '-1234'), '−1.234');
      expect(signed.parse('−1.234,5'), -1234.5);
      expect(signed.formatNumberForEditing(-1500), '−1.500');
      // Unsigned fields ignore the minus.
      expect(type(sr, '-12'), '12');
    });
  });
}

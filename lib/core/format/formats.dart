import 'package:intl/intl.dart';

/// Locale-aware number, money, percent and date formatting.
///
/// Uses a fixed separator table instead of intl's CLDR data for the few
/// languages the app ships in, so the output is identical on every device
/// (some Android builds ship divergent ICU data for Balkan locales).
class Formats {
  Formats(this.languageCode, {this.script});

  final String languageCode;
  final String? script;

  static const _nbsp = ' ';

  bool get isEnglish => languageCode == 'en';

  /// Decimal separator used for display and input.
  String get decimal => isEnglish ? '.' : ',';

  /// Thousands separator.
  String get group => switch (languageCode) {
        'en' => ',',
        'bg' => _nbsp,
        _ => '.',
      };

  String number(double value, {int decimals = 2, bool grouping = true}) {
    if (!value.isFinite) return '—';
    final negative = value < 0 && _roundAbs(value, decimals) != 0;
    final abs = value.abs();
    final fixed = abs.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = grouping ? _groupDigits(parts[0]) : parts[0];
    final body = decimals > 0 ? '$intPart$decimal${parts[1]}' : intPart;
    return negative ? '−$body' : body;
  }

  static double _roundAbs(double v, int d) => double.parse(v.abs().toStringAsFixed(d));

  String _groupDigits(String digits) {
    final b = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) b.write(group);
      b.write(digits[i]);
    }
    return b.toString();
  }

  /// Display symbol or code for a currency.
  String currencySymbol(String code) => switch (code) {
        'EUR' => '€',
        'USD' when isEnglish => r'$',
        'GBP' when isEnglish => '£',
        'BAM' => 'KM',
        'MKD' when languageCode == 'mk' => 'ден',
        'RON' when languageCode == 'ro' => 'lei',
        'BGN' when languageCode == 'bg' => 'лв.',
        _ => code,
      };

  /// Decimals conventionally shown for a currency.
  static int currencyDecimals(String code) => switch (code) {
        'JPY' || 'KRW' || 'ISK' || 'IDR' || 'HUF' => 0,
        'KWD' => 3,
        _ => 2,
      };

  /// "108.572,10 RSD", "240,40 €", or "€240.40" in English.
  String money(double value, String currency, {int? decimals}) {
    final d = decimals ?? currencyDecimals(currency);
    final n = number(value, decimals: d);
    final symbol = currencySymbol(currency);
    if (isEnglish && (symbol == '€' || symbol == r'$' || symbol == '£')) {
      return n.startsWith('−') ? '−$symbol${n.substring(1)}' : '$symbol$n';
    }
    return '$n$_nbsp$symbol';
  }

  /// Percent from a fraction: 0.3714 → "37,1%".
  String percent(double fraction, {int decimals = 1}) => '${number(fraction * 100, decimals: decimals)}%';

  /// Percent from a percentage value: 7.49 → "7,49%".
  String percentValue(double percent, {int decimals = 2}) => '${number(percent, decimals: decimals)}%';

  /// Exchange rate with 4 decimals, no grouping below 1000.
  String rate(double value, {int decimals = 4}) => number(value, decimals: decimals);

  /// Numeric date: "25.09.2026." (sr/hr/bs), "25.09.2026" (sl/mk/bg/ro),
  /// "25 Sep 2026" (en).
  String date(DateTime d) {
    if (isEnglish) return DateFormat('d MMM yyyy', 'en').format(d);
    final core = '${_two(d.day)}.${_two(d.month)}.${d.year}';
    return switch (languageCode) {
      'sr' || 'hr' || 'bs' => '$core.',
      _ => core,
    };
  }

  /// Short date without year: "25.09." / "25 Sep".
  String shortDate(DateTime d) {
    if (isEnglish) return DateFormat('d MMM', 'en').format(d);
    return '${_two(d.day)}.${_two(d.month)}.';
  }

  static String _two(int v) => v.toString().padLeft(2, '0');

  /// Parses user-entered or pasted numbers in any common style:
  /// "1.234,56", "1,234.56", "1234.56", "1 234,56". Returns null if the
  /// text holds no number.
  static double? parseLoose(String input) {
    var s = input.trim().replaceAll(RegExp(r'[\s   ]'), '');
    s = s.replaceAll('−', '-');
    final negative = s.startsWith('-');
    s = s.replaceAll(RegExp(r'[^0-9.,]'), '');
    if (s.isEmpty || !RegExp(r'\d').hasMatch(s)) return null;
    final lastDot = s.lastIndexOf('.');
    final lastComma = s.lastIndexOf(',');
    String normalized;
    if (lastDot >= 0 && lastComma >= 0) {
      final decimalChar = lastDot > lastComma ? '.' : ',';
      final groupChar = decimalChar == '.' ? ',' : '.';
      normalized = s.replaceAll(groupChar, '').replaceAll(decimalChar, '.');
    } else if (lastDot >= 0 || lastComma >= 0) {
      final sep = lastDot >= 0 ? '.' : ',';
      final count = sep.allMatches(s).length;
      final after = s.length - s.lastIndexOf(sep) - 1;
      if (count > 1 || after == 3) {
        normalized = s.replaceAll(sep, '');
      } else {
        normalized = s.replaceAll(sep, '.');
      }
    } else {
      normalized = s;
    }
    final v = double.tryParse(normalized);
    if (v == null || !v.isFinite) return null;
    return negative ? -v : v;
  }
}

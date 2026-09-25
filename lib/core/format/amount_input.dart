import 'package:flutter/services.dart';

import 'formats.dart';

/// Live-grouping numeric input: the person types digits and either '.' or
/// ',' for the decimal point; thousands separators are inserted for them.
///
/// Group separators are never typed, which is what makes a lone '.' or ','
/// keypress unambiguous — it always means "decimal point", whatever the
/// locale's convention. Pastes are parsed loosely ("1.234,56", "1234.56").
class AmountInputFormatter extends TextInputFormatter {
  AmountInputFormatter({
    required this.formats,
    this.decimals = 2,
    this.maxIntegerDigits = 12,
    this.allowNegative = false,
  });

  final Formats formats;
  final int decimals;
  final int maxIntegerDigits;

  /// Accept a leading minus (typed as '-' or '−'), shown as '−'.
  final bool allowNegative;

  static const _minus = '−';

  /// Cleared field with the caret at the start (a -1 offset would drop it).
  static const _empty = TextEditingValue(selection: TextSelection.collapsed(offset: 0));

  String get _group => formats.group;
  String get _decimal => formats.decimal;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!allowNegative) return _format(oldValue, newValue);
    // Peel off a leading sign, format the magnitude, then put it back.
    String strip(String t) => t.startsWith('-') || t.startsWith(_minus) ? t.substring(1) : t;
    bool signed(String t) => t.startsWith('-') || t.startsWith(_minus);
    final negative = signed(newValue.text);
    if (negative && newValue.text.length == 1) {
      return const TextEditingValue(text: _minus, selection: TextSelection.collapsed(offset: 1));
    }
    int shift(TextSelection sel, bool neg) => sel.isValid && neg ? (sel.baseOffset - 1).clamp(0, 1 << 30) : sel.baseOffset;
    final oldNeg = signed(oldValue.text);
    final innerOld = TextEditingValue(
      text: strip(oldValue.text),
      selection: TextSelection.collapsed(offset: shift(oldValue.selection, oldNeg)),
    );
    final innerNew = TextEditingValue(
      text: strip(newValue.text),
      selection: TextSelection.collapsed(offset: shift(newValue.selection, negative)),
    );
    final out = _format(innerOld, innerNew);
    if (!negative) return out;
    return TextEditingValue(
      text: '$_minus${out.text}',
      selection: TextSelection.collapsed(offset: out.selection.baseOffset + 1),
    );
  }

  TextEditingValue _format(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.isEmpty) return _empty;

    var cursor = newValue.selection.isValid ? newValue.selection.baseOffset : newText.length;
    cursor = cursor.clamp(0, newText.length);
    final inserted = newText.length - oldValue.text.length;

    // A multi-character insert is a paste: parse it loosely.
    if (inserted > 1) {
      final v = Formats.parseLoose(newText);
      if (v == null) return oldValue;
      final text = formatNumberForEditing(v.abs());
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    var working = newText;
    // Backspace over a thousands separator deletes the digit before it.
    if (inserted == -1 && oldValue.selection.isCollapsed && cursor < oldValue.text.length && oldValue.text[cursor] == _group && cursor > 0) {
      working = newText.substring(0, cursor - 1) + newText.substring(cursor);
      cursor -= 1;
    }

    final typedIndex = inserted == 1 && cursor > 0 ? cursor - 1 : -1;
    final typedSeparator = typedIndex >= 0 && (working[typedIndex] == '.' || working[typedIndex] == ',');

    final intDigits = StringBuffer();
    final decDigits = StringBuffer();
    var hasDecimal = false;
    var significantBeforeCursor = 0;

    for (var i = 0; i < working.length; i++) {
      final ch = working[i];
      final isDigit = ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
      var countsAsSignificant = false;
      if (isDigit) {
        if (hasDecimal) {
          if (decDigits.length < decimals) {
            decDigits.write(ch);
            countsAsSignificant = true;
          }
        } else {
          intDigits.write(ch);
          countsAsSignificant = true;
        }
      } else {
        final isDecimalMark = typedSeparator && i == typedIndex ? true : (ch == _decimal && ch != _group);
        if (isDecimalMark && decimals > 0 && !hasDecimal) {
          hasDecimal = true;
          countsAsSignificant = true;
        }
      }
      if (countsAsSignificant && i < cursor) significantBeforeCursor++;
    }

    var intPart = intDigits.toString().replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (intPart.length > maxIntegerDigits) return oldValue;
    if (intPart.isEmpty && hasDecimal) {
      intPart = '0';
      significantBeforeCursor++;
    }
    if (intPart.isEmpty && !hasDecimal) return _empty;

    // Leading-zero stripping removed characters before the cursor.
    final removedZeros = intDigits.length - intPart.length;
    if (removedZeros > 0) significantBeforeCursor = (significantBeforeCursor - removedZeros).clamp(0, 1 << 30);

    final grouped = _groupDigits(intPart);
    final text = hasDecimal ? '$grouped$_decimal$decDigits' : grouped;

    var offset = 0;
    var seen = 0;
    while (offset < text.length && seen < significantBeforeCursor) {
      if (text[offset] != _group) seen++;
      offset++;
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  String _groupDigits(String digits) {
    final b = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) b.write(_group);
      b.write(digits[i]);
    }
    return b.toString();
  }

  /// Text for putting a stored value back into a field: grouped, with
  /// decimals only when non-zero.
  String formatNumberForEditing(double value) {
    if (allowNegative && value < 0 && value.isFinite) {
      final body = formatNumberForEditing(-value);
      return body.isEmpty ? '' : '$_minus$body';
    }
    if (!value.isFinite || value <= 0) return '';
    final fixed = value.toStringAsFixed(decimals);
    var parts = fixed.split('.');
    var dec = parts.length > 1 ? parts[1].replaceFirst(RegExp(r'0+$'), '') : '';
    final intPart = parts[0];
    if (intPart.length > maxIntegerDigits) return '';
    parts = [intPart, dec];
    dec = parts[1];
    final grouped = _groupDigits(intPart);
    return dec.isEmpty ? grouped : '$grouped$_decimal$dec';
  }

  /// Reads the numeric value of text produced by this formatter.
  double? parse(String text) {
    var t = text;
    var sign = 1.0;
    if (allowNegative && (t.startsWith(_minus) || t.startsWith('-'))) {
      sign = -1;
      t = t.substring(1);
    }
    final cleaned = t.replaceAll(_group, '').replaceAll(_decimal, '.');
    if (cleaned.isEmpty) return null;
    final v = double.tryParse(cleaned);
    return v == null ? null : sign * v;
  }
}

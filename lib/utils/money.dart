/// Deterministic money rounding shared by invoice line-item totals, PDF
/// rendering, and the NBS IPS QR amount ("I") field. Repeated `double`
/// arithmetic (e.g. quantity * unitPrice, summed across several lines)
/// can produce artifacts like `1025.119999999999` — those must never
/// reach a stored total, a rendered PDF, or a QR payload. The fix is to
/// round each amount to the nearest cent exactly once, then do all
/// summation in integer minor units (cents); only convert back to a
/// `double`/formatted string at the final display/storage boundary.
library;

/// Rounds a [double] amount to the nearest integer minor unit (cent),
/// half-up. This is the only place a money `double` should be rounded —
/// every other money computation should work in minor units afterward.
///
/// A tiny epsilon is applied before rounding to counteract binary
/// floating-point representation error (e.g. the double closest to 1.005
/// is actually ~1.00499999999999989, which would otherwise round down to
/// 100 instead of the intended 101). The epsilon is far smaller than any
/// real monetary distinction (a whole minor unit), so it only cancels
/// representation noise and never changes a genuinely different amount.
int roundToMinorUnits(double amount) {
  const epsilon = 1e-9;
  final scaled = amount * 100;
  return (scaled.isNegative ? scaled - epsilon : scaled + epsilon).round();
}

/// Converts minor units back to a `double` amount for storage/display.
double minorUnitsToAmount(int minorUnits) => minorUnits / 100;

/// Sums already-rounded minor units with exact integer arithmetic — no
/// floating-point drift possible.
int sumMinorUnits(Iterable<int> values) =>
    values.fold(0, (sum, v) => sum + v);

/// Formats minor units as a fixed 2-decimal-place string, e.g. `1025.12`.
/// Pass [decimalSeparator]: `,` for the NBS IPS QR "I" tag, which requires
/// a decimal comma rather than a decimal point.
String formatMinorUnits(int minorUnits, {String decimalSeparator = '.'}) {
  final negative = minorUnits < 0;
  final abs = minorUnits.abs();
  final major = abs ~/ 100;
  final minor = abs % 100;
  final sign = negative ? '-' : '';
  return '$sign$major$decimalSeparator${minor.toString().padLeft(2, '0')}';
}

import 'dart:math' as math;

/// Money rounding and summation helpers.
///
/// All calculators work in `double`, but every amount that a person would
/// see on a payslip, loan schedule or invoice is rounded exactly once, half
/// away from zero, to the currency's minor unit. Sums of already-rounded
/// amounts go through integer minor units so they never drift.
abstract final class Money {
  static const _pow10 = <int>[1, 10, 100, 1000, 10000, 100000, 1000000];

  /// Rounds [value] half away from zero to [decimals] places (0–6).
  ///
  /// A tiny, magnitude-relative nudge cancels binary representation error
  /// (1.005 is stored as 1.00499999…, which would otherwise round down).
  static double round(double value, [int decimals = 2]) {
    if (value.isNaN || value.isInfinite) return value;
    assert(decimals >= 0 && decimals < _pow10.length);
    final factor = _pow10[decimals];
    final scaled = value * factor;
    final nudge = 1e-9 + scaled.abs() * 4e-15;
    final rounded = scaled.isNegative ? -((-scaled) + nudge).round() : (scaled + nudge).round();
    return rounded / factor;
  }

  /// Converts an amount to integer minor units (e.g. cents), rounding it.
  static int toMinor(double value, [int decimals = 2]) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError.value(value, 'value', 'must be finite');
    }
    return (round(value, decimals) * _pow10[decimals]).round();
  }

  static double fromMinor(int minor, [int decimals = 2]) => minor / _pow10[decimals];

  /// Exact sum of amounts that are each rounded to [decimals] first.
  static double sum(Iterable<double> values, [int decimals = 2]) {
    var total = 0;
    for (final v in values) {
      total += toMinor(v, decimals);
    }
    return fromMinor(total, decimals);
  }

  /// Exact difference `a - b` at [decimals] precision.
  static double sub(double a, double b, [int decimals = 2]) =>
      fromMinor(toMinor(a, decimals) - toMinor(b, decimals), decimals);

  static double clamp(double value, double? min, double? max) {
    var v = value;
    if (min != null && v < min) v = min;
    if (max != null && v > max) v = max;
    return v;
  }

  /// Smallest representable step at [decimals] precision (0.01 for 2).
  static double unit(int decimals) => 1 / _pow10[decimals];

  static bool isFinitePositive(double v) => v.isFinite && v > 0;

  static double maxOf(double a, double b) => math.max(a, b);
}

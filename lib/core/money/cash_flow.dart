import 'dart:math' as math;

/// Net present value and internal rate of return over evenly spaced
/// periods. Flow index 0 is "now"; index t is discounted by (1 + r)^t.
abstract final class CashFlow {
  static double npv(double rate, List<double> flows) {
    if (rate <= -1) return double.nan;
    var total = 0.0;
    var factor = 1.0;
    final step = 1 + rate;
    for (final f in flows) {
      total += f / factor;
      factor *= step;
    }
    return total;
  }

  /// The periodic rate where [npv] is zero, or null when the flows have no
  /// sign change or no root exists in (-99.99 %, 1000 %) per period.
  ///
  /// Uses a sign-change bracket search followed by bisection, so it cannot
  /// diverge the way plain Newton iteration can.
  static double? irr(List<double> flows) {
    if (flows.length < 2) return null;
    final hasPositive = flows.any((f) => f > 0);
    final hasNegative = flows.any((f) => f < 0);
    if (!hasPositive || !hasNegative) return null;

    // Candidate bracket points, dense near zero where real rates live.
    final points = <double>[
      -0.9999,
      -0.99,
      -0.95,
      -0.9,
      -0.75,
      -0.5,
      -0.25,
      -0.1,
      -0.05,
      -0.02,
      -0.01,
      -0.001,
      0,
      0.0001,
      0.001,
      0.002,
      0.005,
      0.01,
      0.02,
      0.03,
      0.05,
      0.075,
      0.1,
      0.15,
      0.2,
      0.3,
      0.5,
      0.75,
      1,
      2,
      3,
      5,
      10,
    ];
    // Prefer the root closest to zero: search outward from 0.
    final zeroIndex = points.indexOf(0);
    double? bestLo;
    double? bestHi;
    var bestDistance = double.infinity;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      final fa = npv(a, flows);
      final fb = npv(b, flows);
      if (!fa.isFinite || !fb.isFinite) continue;
      if (fa == 0) return a;
      if (fa.sign != fb.sign) {
        final distance = math.min(a.abs(), b.abs()) + (i < zeroIndex ? 1e-9 : 0);
        if (distance < bestDistance) {
          bestDistance = distance;
          bestLo = a;
          bestHi = b;
        }
      }
    }
    if (bestLo == null || bestHi == null) return null;

    var lo = bestLo;
    var hi = bestHi;
    var flo = npv(lo, flows);
    for (var i = 0; i < 300; i++) {
      final mid = (lo + hi) / 2;
      final fm = npv(mid, flows);
      if (fm == 0 || (hi - lo).abs() < 1e-14) return mid;
      if (fm.sign == flo.sign) {
        lo = mid;
        flo = fm;
      } else {
        hi = mid;
      }
    }
    return (lo + hi) / 2;
  }

  /// Converts a monthly periodic rate to an effective annual rate.
  static double annualize(double monthlyRate) => math.pow(1 + monthlyRate, 12).toDouble() - 1;
}

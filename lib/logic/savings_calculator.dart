import 'dart:math';

class SavingsGrowthResult {
  final double futureValue;
  final double totalContributed;
  final double totalInterestEarned;

  const SavingsGrowthResult({
    required this.futureValue,
    required this.totalContributed,
    required this.totalInterestEarned,
  });
}

/// Compound-growth math for a lump sum plus optional recurring monthly
/// contributions — currency-agnostic, pure arithmetic.
class SavingsCalculator {
  SavingsCalculator._();

  /// Future value of [principal] plus a recurring [monthlyContribution]
  /// (contributed at the end of each month), compounded monthly at
  /// [annualRatePercent] for [years].
  static SavingsGrowthResult project({
    required double principal,
    required double monthlyContribution,
    required double annualRatePercent,
    required double years,
  }) {
    final months = (years * 12).round();
    if (months <= 0) {
      return SavingsGrowthResult(
        futureValue: principal,
        totalContributed: principal,
        totalInterestEarned: 0,
      );
    }

    final r = annualRatePercent / 100 / 12;
    double fvPrincipal;
    double fvContributions;
    if (r == 0) {
      fvPrincipal = principal;
      fvContributions = monthlyContribution * months;
    } else {
      final factor = pow(1 + r, months);
      fvPrincipal = principal * factor;
      fvContributions = monthlyContribution * ((factor - 1) / r);
    }

    final futureValue = fvPrincipal + fvContributions;
    final totalContributed = principal + monthlyContribution * months;

    return SavingsGrowthResult(
      futureValue: futureValue,
      totalContributed: totalContributed,
      totalInterestEarned: futureValue - totalContributed,
    );
  }
}

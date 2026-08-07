import '../models/tax_config.dart';

/// Computes the personal allowance (the amount subtracted from the taxable
/// base before tax is applied) for one monthly gross salary.
abstract class AllowanceStrategy {
  double compute(double grossMonthly);
}

class FlatAllowanceStrategy implements AllowanceStrategy {
  final double amount;
  const FlatAllowanceStrategy(this.amount);

  @override
  double compute(double grossMonthly) => amount;
}

/// Slovenia's "splošna olajšava" (general allowance) is larger for lower
/// earners and shrinks above an income threshold. The real statutory rule
/// is a multi-point sliding scale; this models it as the two representative
/// tiers documented in the country's tax config sources (a simplified
/// approximation, disclosed in the app's tax disclaimer) rather than
/// reproducing every bend point of the formula.
class SloveniaGeneralAllowanceStrategy implements AllowanceStrategy {
  final double lowerAnnualIncomeThreshold;
  final double higherAllowanceAnnual;
  final double lowerAllowanceAnnual;

  const SloveniaGeneralAllowanceStrategy({
    required this.lowerAnnualIncomeThreshold,
    required this.higherAllowanceAnnual,
    required this.lowerAllowanceAnnual,
  });

  @override
  double compute(double grossMonthly) {
    final annualGross = grossMonthly * 12;
    final annualAllowance = annualGross >= lowerAnnualIncomeThreshold
        ? lowerAllowanceAnnual
        : higherAllowanceAnnual;
    return annualAllowance / 12;
  }
}

/// Romania's personal deduction ("deducere personală") is a percentage of
/// gross salary that decreases as gross rises above minimum wage, boosted
/// per dependent. Modeled for a single filer with no dependents (0), which
/// is the common case and keeps this from requiring a dependents input
/// across every other country's calculator — a documented v1 scope
/// decision, not an oversight.
class RomaniaPersonalDeductionStrategy implements AllowanceStrategy {
  final double minimumWage;
  final double baseRatePercent;
  final double perDependentBonusPercent;
  final double leiStep;
  final double percentDecreasePerStep;
  final double ceiling;
  final int dependents;

  const RomaniaPersonalDeductionStrategy({
    required this.minimumWage,
    required this.baseRatePercent,
    required this.perDependentBonusPercent,
    required this.leiStep,
    required this.percentDecreasePerStep,
    required this.ceiling,
    this.dependents = 0,
  });

  @override
  double compute(double grossMonthly) {
    if (grossMonthly > ceiling) return 0;
    final delta = (grossMonthly - minimumWage).clamp(0, double.infinity);
    final steps = delta / leiStep;
    final ratePercent = (baseRatePercent +
            dependents * perDependentBonusPercent -
            steps * percentDecreasePerStep)
        .clamp(0, 100);
    return grossMonthly * (ratePercent / 100);
  }
}

/// Selects the right [AllowanceStrategy] for a country's config. Adding a
/// new country with a flat allowance needs no change here — only a country
/// whose allowance depends on income (like Slovenia or Romania above) needs
/// a new case.
AllowanceStrategy allowanceStrategyFor(CountryTaxConfig config) {
  if (config.allowanceType == AllowanceType.flat) {
    return FlatAllowanceStrategy(config.flatAllowanceAmount ?? 0);
  }

  final params = config.allowanceParams ?? const <String, dynamic>{};
  switch (config.countryId) {
    case 'si':
      return SloveniaGeneralAllowanceStrategy(
        lowerAnnualIncomeThreshold:
            (params['lowerAnnualIncomeThreshold'] as num).toDouble(),
        higherAllowanceAnnual:
            (params['higherAllowanceAnnual'] as num).toDouble(),
        lowerAllowanceAnnual:
            (params['lowerAllowanceAnnual'] as num).toDouble(),
      );
    case 'ro':
      return RomaniaPersonalDeductionStrategy(
        minimumWage: (params['minimumWage'] as num).toDouble(),
        baseRatePercent: (params['baseRatePercent'] as num).toDouble(),
        perDependentBonusPercent:
            (params['perDependentBonusPercent'] as num).toDouble(),
        leiStep: (params['leiStep'] as num).toDouble(),
        percentDecreasePerStep:
            (params['percentDecreasePerStep'] as num).toDouble(),
        ceiling: (params['ceiling'] as num).toDouble(),
      );
    default:
      throw StateError(
        'No formula allowance strategy registered for country '
        '"${config.countryId}"',
      );
  }
}

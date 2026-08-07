import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// North Macedonia — самостојна дејност, annual, MKD. Flat 10% tax with an
/// optional investment-reduction deduction (30% of qualifying investment,
/// capped at 50% of the base), via `input.options['qualifyingInvestment']`
/// (default 0). Contributions run on a monthly base clamped to the
/// statutory min/max, forced to 100% of the national average for regulated
/// professions (`input.options['regulatedProfession']`, default false) —
/// uses the July–Dec 2026 contribution rates (28.0% total), the
/// most-recently-effective figures in the sourced data.
class MkFreelanceStrategy implements FreelanceTaxStrategy {
  const MkFreelanceStrategy();

  @override
  String get regimeId => 'mk';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final qualifyingInvestment = input.option('qualifyingInvestment', 0.0);
    final regulatedProfession = input.option('regulatedProfession', false);

    final reductionPercent = rules.field('investmentReductionPercent').asDouble!;
    final reductionCapPercent = rules.field('investmentReductionCapPercentOfBase').asDouble!;
    final reduction = clampD(
      qualifyingInvestment * reductionPercent,
      0,
      income * reductionCapPercent,
    );

    final taxableBase = (income - reduction).clamp(0, double.infinity).toDouble();
    final taxRate = rules.field('taxRate').asDouble!;
    final incomeTax = taxableBase * taxRate;

    final minMonthly = regulatedProfession
        ? rules.field('regulatedProfessionsMinBaseMonthly').asDouble!
        : rules.field('minContributionBaseMonthly').asDouble!;
    final maxMonthly = rules.field('maxContributionBaseMonthly').asDouble!;
    final monthlyBase = clampD(income / 12, minMonthly, maxMonthly);

    final pio = monthlyBase * rules.field('contributionRatePio').asDouble! * 12;
    final health = monthlyBase * rules.field('contributionRateHealth').asDouble! * 12;
    final injury = monthlyBase * rules.field('contributionRateInjury').asDouble! * 12;
    final unemployment = monthlyBase * rules.field('contributionRateUnemployment').asDouble! * 12;
    final totalContributions = pio + health + injury + unemployment;

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdAnnual').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: reduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {
        'pio': pio,
        'health': health,
        'injury': injury,
        'unemployment': unemployment,
      },
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
      ],
    );
  }
}

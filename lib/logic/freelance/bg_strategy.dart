import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Bulgaria — свободна професия (free-lance profession), annual, EUR (the
/// leva peg ended with euro adoption 1 Jan 2026 — seed figures are already
/// in EUR). Order of operations: deduct the 25% statutory expense allowance
/// FIRST, compute social contributions on the reduced amount, THEN deduct
/// those contributions again to reach the final taxable base — the one
/// double-deduction step among all 10 regimes.
///
/// `input.options['bornBefore1960']` (bool, default false) selects the
/// pension-rate table; `input.options['includeSickness']` (bool, default
/// false) includes the optional 3.5% sickness contribution.
class BgFreelanceStrategy implements FreelanceTaxStrategy {
  const BgFreelanceStrategy();

  @override
  String get regimeId => 'bg';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final bornBefore1960 = input.option('bornBefore1960', false);
    final includeSickness = input.option('includeSickness', false);

    final expensePercent = rules.field('normativeExpensePercent').asDouble!;
    final reducedIncome = income * (1 - expensePercent);
    final deduction = income - reducedIncome;

    final minAnnual = rules.field('minMonthlyInsuranceBaseEur').asDouble! * 12;
    final maxAnnual = rules.field('maxMonthlyInsuranceBaseEur').asDouble! * 12;
    final contributionBase = clampD(reducedIncome, minAnnual, maxAnnual);

    final pensionRate = bornBefore1960
        ? rules.field('pensionRateBornBefore1960').asDouble!
        : rules.field('pensionRateBornFrom1960').asDouble! +
            rules.field('upfSupplementaryRateBornFrom1960').asDouble!;
    final pension = contributionBase * pensionRate;
    final health = contributionBase * rules.field('healthContributionRate').asDouble!;
    final sickness = includeSickness
        ? contributionBase * rules.field('sicknessContributionRateOptional').asDouble!
        : 0.0;
    final totalContributions = pension + health + sickness;

    final taxableBase = (reducedIncome - totalContributions).clamp(0, double.infinity).toDouble();
    final taxRate = rules.field('taxRate').asDouble!;
    final incomeTax = taxableBase * taxRate;
    final netIncome = income - incomeTax - totalContributions;

    final vatThreshold = rules.field('vatThresholdAnnualEur').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {
        'pension': pension,
        'health': health,
        if (includeSickness) 'sickness': sickness,
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

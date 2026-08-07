import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Serbia — Samooporezivanje frilensera (PP OPO-K), quarterly. The
/// normative deduction is applied once to reach the taxable base, and BOTH
/// income tax and social contributions are charged on that same base —
/// contributions are not deductible, unlike every other modeled regime.
/// Two standardized-expense models exist and may be freely picked quarter
/// to quarter; [compute] takes whichever is requested via
/// `input.options['model']` ('model1' default, or 'model2'), and
/// [cheaperModel] compares both for the same income.
class RsFreelanceStrategy implements FreelanceTaxStrategy {
  const RsFreelanceStrategy();

  @override
  String get regimeId => 'rs';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.quarterly;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final model = input.option('model', 'model1');
    final income = input.income;

    final double deduction;
    final double taxRate;
    if (model == 'model2') {
      final fixed = rules.field('model2FixedDeductionQuarterly').asDouble!;
      final percent = rules.field('model2PercentDeduction').asDouble!;
      deduction = fixed + income * percent;
      taxRate = rules.field('model2TaxRate').asDouble!;
    } else {
      deduction = rules.field('model1NormativeExpenseQuarterly').asDouble!;
      taxRate = rules.field('model1TaxRate').asDouble!;
    }

    final taxableBase = (income - deduction).clamp(0, double.infinity).toDouble();
    final incomeTax = taxableBase * taxRate;

    final minMonthly = rules.field('minMonthlyContributionBase').asDouble!;
    final maxMonthly = rules.field('maxMonthlyContributionBase').asDouble!;
    final quarterlyMultiple =
        rules.field('pioMinBaseQuarterlyMultiple').asDouble!;
    final contributionBase = clampD(
      taxableBase,
      minMonthly * quarterlyMultiple,
      maxMonthly * quarterlyMultiple,
    );

    final pio = contributionBase * rules.field('pioContributionRate').asDouble!;
    final health =
        contributionBase * rules.field('healthContributionRate').asDouble!;
    final unemployment = contributionBase *
        rules.field('unemploymentContributionRate').asDouble!;
    final totalContributions = pio + health + unemployment;

    final netIncome = income - incomeTax - totalContributions;

    final annualizedIncome = income * 4;
    final vatThreshold = rules.field('vatThresholdRolling12m').asDouble!;
    final pausalCeiling = rules.field('pausalCeilingAnnual').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {
        'pio': pio,
        'health': health,
        'unemployment': unemployment,
      },
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: annualizedIncome >= vatThreshold,
        ),
        FreelanceCliffFlag(
          id: FreelanceCliffId.serbiaPausalCeiling,
          threshold: pausalCeiling,
          crossed: annualizedIncome >= pausalCeiling,
        ),
      ],
      extra: {'model': model},
    );
  }

  /// Which model produces less total burden (tax + contributions) for a
  /// given quarterly gross — freely mixed quarter to quarter, so this is a
  /// genuinely useful comparison rather than academic.
  String cheaperModel(FreelanceRegimeRules rules, double income) {
    final m1 = compute(rules, FreelanceTaxInput(income: income, options: const {'model': 'model1'}));
    final m2 = compute(rules, FreelanceTaxInput(income: income, options: const {'model': 'model2'}));
    final m1Burden = m1.incomeTax + m1.totalContributions;
    final m2Burden = m2.incomeTax + m2.totalContributions;
    return m2Burden <= m1Burden ? 'model2' : 'model1';
  }
}

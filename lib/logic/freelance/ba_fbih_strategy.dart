import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Bosnia and Herzegovina — Federation of BiH, samostalna djelatnost,
/// annual (GIP form), BAM. No normative expense deduction; instead a
/// personal allowance (scaled by dependant coefficients via
/// `input.options['dependantCoefficientSum']`, default 0) plus social
/// contributions — computed on a FIXED statutory monthly base that depends
/// on activity category (`input.options['activityCategory']`, one of
/// 'freeProfessions' (default), 'obrt', 'agriculture', 'lumpSumObrt',
/// 'traditionalCraftsTaxi'), never on actual income — are BOTH deducted
/// before the flat 10% tax rate applies.
class BaFbihFreelanceStrategy implements FreelanceTaxStrategy {
  const BaFbihFreelanceStrategy();

  @override
  String get regimeId => 'ba_fbih';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  static const _statutoryBaseFields = {
    'freeProfessions': 'statutoryBaseFreeProfessionsMonthly',
    'obrt': 'statutoryBaseObrtMonthly',
    'agriculture': 'statutoryBaseAgricultureMonthly',
    'lumpSumObrt': 'statutoryBaseLumpSumObrtMonthly',
    'traditionalCraftsTaxi': 'statutoryBaseTraditionalCraftsTaxiMonthly',
  };

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final dependantCoefficientSum = input.option('dependantCoefficientSum', 0.0);
    final activityCategory = input.option('activityCategory', 'freeProfessions');

    final personalAllowanceAnnual = rules.field('personalAllowanceAnnual').asDouble!;
    final personalAllowance = personalAllowanceAnnual * (1 + dependantCoefficientSum);

    final baseField = _statutoryBaseFields[activityCategory] ??
        _statutoryBaseFields['freeProfessions']!;
    final statutoryBaseMonthly = rules.field(baseField).asDouble!;
    final contributionTotalRate = rules.field('contributionTotalRate').asDouble!;
    final pioRate = rules.field('contributionRatePio').asDouble!;
    final healthRate = rules.field('contributionRateHealth').asDouble!;
    final unemploymentRate = rules.field('contributionRateUnemployment').asDouble!;

    final pio = statutoryBaseMonthly * pioRate * 12;
    final health = statutoryBaseMonthly * healthRate * 12;
    final unemployment = statutoryBaseMonthly * unemploymentRate * 12;
    final totalContributions = pio + health + unemployment;
    // Sanity-consistent with contributionTotalRate; kept as three named
    // lines above since that's how FBiH's own paperwork itemizes them.
    assert((pio + health + unemployment - statutoryBaseMonthly * 12 * contributionTotalRate).abs() < 0.01);

    final deduction = personalAllowance + totalContributions;
    final taxableBase = (income - deduction).clamp(0, double.infinity).toDouble();
    final taxRate = rules.field('taxRate').asDouble!;
    final incomeTax = taxableBase * taxRate;
    final netIncome = income - incomeTax - totalContributions;

    final vatThreshold = rules.field('vatThresholdAnnual').asDouble!;

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
          crossed: income >= vatThreshold,
        ),
      ],
      extra: {'activityCategory': activityCategory},
    );
  }
}

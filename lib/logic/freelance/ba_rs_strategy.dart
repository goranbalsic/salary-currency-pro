import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Bosnia and Herzegovina — Republika Srpska, "mali preduzetnik" (small
/// entrepreneur), annual, BAM. Below BAM 100,000 revenue the "tax" is a
/// small flat annual fee (banded by revenue, not a percentage); above it,
/// 10% applies to real profit — this calculator approximates real profit
/// as the entered income for the above-ceiling case, since expense
/// bookkeeping is out of scope, and discloses that in [FreelanceTaxResult
/// .extra]. Contributions run on a FIXED base (a percentage of the prior
/// year's average gross salary, not on actual income) selected via
/// `input.options['category']`: 'standard' (default), 'independentProfessions',
/// or 'supplementaryActivity' (PIO only).
class BaRsFreelanceStrategy implements FreelanceTaxStrategy {
  const BaRsFreelanceStrategy();

  @override
  String get regimeId => 'ba_rs';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final category = input.option('category', 'standard');

    final lowCeiling = rules.field('smallEntrepreneurLowBandRevenueCeiling').asDouble!;
    final midCeiling = rules.field('smallEntrepreneurMidBandRevenueCeiling').asDouble!;

    final bool isRealProfitRegime;
    final double incomeTax;
    if (income <= lowCeiling) {
      incomeTax = rules.field('smallEntrepreneurFlatTaxLowBandAnnual').asDouble!;
      isRealProfitRegime = false;
    } else if (income <= midCeiling) {
      incomeTax = rules.field('smallEntrepreneurFlatTaxMidBandAnnual').asDouble!;
      isRealProfitRegime = false;
    } else {
      incomeTax = income * rules.field('realProfitTaxRateAboveMidBand').asDouble!;
      isRealProfitRegime = true;
    }

    final double contributions;
    final String contributionLabel;
    switch (category) {
      case 'independentProfessions':
        contributions = rules.field('independentProfessionsContributionMonthly').asDouble! * 12;
        contributionLabel = 'independentProfessions';
        break;
      case 'supplementaryActivity':
        contributions = rules.field('supplementaryActivityPioOnlyMonthly').asDouble! * 12;
        contributionLabel = 'supplementaryActivityPioOnly';
        break;
      default:
        contributions = rules.field('contributionMonthlyAmount').asDouble! * 12;
        contributionLabel = 'standard';
    }

    final netIncome = income - incomeTax - contributions;
    final vatThreshold = rules.field('vatThresholdAnnual').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: 0,
      taxableBase: income,
      incomeTax: incomeTax,
      contributions: {contributionLabel: contributions},
      totalContributions: contributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
      ],
      extra: {
        'isRealProfitRegime': isRealProfitRegime,
        'category': category,
      },
    );
  }
}

import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Slovenia — two distinct deemed-expense regimes selected via
/// `input.options['variant']`: 'normirani' (default, full self-employment)
/// or 'popoldanski' (a side activity alongside other work). Both use a
/// deemed-expense percentage of revenue rather than real bookkeeping, then
/// a two-tier tax rate on what remains — but the percentage bands, tax
/// thresholds, and contribution structure (base-scaled for normirani,
/// flat for popoldanski) genuinely differ, so they're two formulas, not one
/// formula with a parameter.
///
/// Contribution formula for normirani was cross-checked against the
/// sourced fixed reference points: `monthlyBase * totalRate + flatOzp`
/// reproduces both the published min (EUR 651.04) and max (EUR 3,607.57)
/// monthly figures when `monthlyBase` is clamped to its own min/max —
/// confirms the two independently-sourced numbers (rate table vs. min/max
/// examples) are internally consistent, not just copied in parallel.
class SiFreelanceStrategy implements FreelanceTaxStrategy {
  const SiFreelanceStrategy();

  @override
  String get regimeId => 'si';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final variant = input.option('variant', 'normirani');
    return variant == 'popoldanski'
        ? _computePopoldanski(rules, input)
        : _computeNormirani(rules, input);
  }

  FreelanceTaxResult _computeNormirani(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final revenueThreshold = rules.field('normiraniRevenueThresholdEur').asDouble!;
    final overThreshold = income > revenueThreshold;

    final deemedExpensePercent = rules.field('normiraniDeemedExpensePercent').asDouble!;
    final expenseCap = rules.field('normiraniDeemedExpenseCapEur').asDouble!;
    final deduction = overThreshold ? 0.0 : clampD(income * deemedExpensePercent, 0, expenseCap);

    final taxableBase = (income - deduction).clamp(0, double.infinity).toDouble();
    final taxBaseThreshold = rules.field('normiraniTaxBaseThresholdEur').asDouble!;
    final rateLow = rules.field('normiraniTaxRateLow').asDouble!;
    final rateHigh = rules.field('normiraniTaxRateHigh').asDouble!;
    final incomeTax = taxableBase <= taxBaseThreshold
        ? taxableBase * rateLow
        : taxBaseThreshold * rateLow + (taxableBase - taxBaseThreshold) * rateHigh;

    final minBase = rules.field('normiraniMinBaseMonthly').asDouble!;
    final maxBase = rules.field('normiraniMaxBaseMonthly').asDouble!;
    final monthlyBase = clampD(taxableBase / 12, minBase, maxBase);
    final totalRate = rules.field('normiraniContributionTotalRate').asDouble!;
    final flatOzp = rules.field('normiraniFlatOzpMonthly').asDouble!;
    final monthlyContribution = monthlyBase * totalRate + flatOzp;
    final totalContributions = monthlyContribution * 12;

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdEur').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {'piz_zzzs_ltc_parental_ozp': totalContributions},
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
        FreelanceCliffFlag(
          id: FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff,
          threshold: revenueThreshold,
          crossed: overThreshold,
        ),
      ],
      extra: {'variant': 'normirani'},
    );
  }

  FreelanceTaxResult _computePopoldanski(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final lowThreshold = rules.field('popoldanskiDeemedExpenseLowThresholdEur').asDouble!;
    final highThreshold = rules.field('popoldanskiDeemedExpenseHighThresholdEur').asDouble!;
    final entryCeiling = rules.field('popoldanskiEntryCeilingEur').asDouble!;
    final cap = rules.field('popoldanskiDeemedExpenseCapEur').asDouble!;
    final lowRate = rules.field('popoldanskiDeemedExpensePercentLow').asDouble!;
    final highRate = rules.field('popoldanskiDeemedExpensePercentHigh').asDouble!;

    double deduction;
    if (income <= lowThreshold) {
      deduction = income * lowRate;
    } else if (income <= highThreshold) {
      deduction = lowThreshold * lowRate + (income - lowThreshold) * highRate;
    } else {
      deduction = cap;
    }
    final overEntryCeiling = income > entryCeiling;

    final taxableBase = (income - deduction).clamp(0, double.infinity).toDouble();
    final taxBaseThreshold = rules.field('popoldanskiTaxBaseThresholdEur').asDouble!;
    final rateLow = rules.field('popoldanskiTaxRateLow').asDouble!;
    final rateHigh = rules.field('popoldanskiTaxRateHigh').asDouble!;
    final incomeTax = taxableBase <= taxBaseThreshold
        ? taxableBase * rateLow
        : taxBaseThreshold * rateLow + (taxableBase - taxBaseThreshold) * rateHigh;

    final monthlyContribution =
        rules.field('popoldanskiFlatContributionMonthlyFromApr2026').asDouble!;
    final totalContributions = monthlyContribution * 12;

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdEur').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {'flatMonthly': totalContributions},
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
        FreelanceCliffFlag(
          id: FreelanceCliffId.sloveniaPopoldanskiDeemedExpenseCliff,
          threshold: entryCeiling,
          crossed: overEntryCeiling,
        ),
      ],
      extra: {'variant': 'popoldanski'},
    );
  }
}

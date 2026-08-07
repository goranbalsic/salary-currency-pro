import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Croatia — paušalni obrt, annual receipts, EUR. Unlike every other
/// modeled regime, the actual amount owed is not a smooth percentage of
/// income but a fixed annual fee looked up from a statutory receipts-band
/// table (`receiptBands`) — [taxableBase] is still shown continuously
/// (15% deemed-income rule) for a meaningful breakdown, but [incomeTax] is
/// the real fixed band amount, since that's what's actually paid.
/// Contributions are on a FIXED monthly base regardless of income (unless
/// this is a second activity alongside employment, `input.options
/// ['secondActivity']`, in which case they scale with the deemed base
/// instead). The paušal ceiling and VAT threshold are the same figure
/// (EUR 60,000) in this regime, so one [FreelanceCliffId.vatThreshold]
/// flag covers both.
class HrFreelanceStrategy implements FreelanceTaxStrategy {
  const HrFreelanceStrategy();

  @override
  String get regimeId => 'hr';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final secondActivity = input.option('secondActivity', false);

    final deemedIncomePercent = rules.field('deemedIncomePercent').asDouble!;
    final taxableBase = income * deemedIncomePercent;
    final deduction = income - taxableBase;

    final bands = rules.field('receiptBands').asMapList!;
    Map<String, dynamic>? band;
    for (final b in bands) {
      if (income <= (b['upTo'] as num).toDouble()) {
        band = b;
        break;
      }
    }
    final overCeiling = band == null;
    final effectiveBand = band ?? bands.last;
    final incomeTax = (effectiveBand['annualTax'] as num).toDouble();

    final double totalContributions;
    if (secondActivity) {
      final secondActivityRate =
          rules.field('secondActivityContributionPercentOfAnnualDeemedBase').asDouble!;
      totalContributions = taxableBase * secondActivityRate;
    } else {
      totalContributions = rules.field('contributionsFixedMonthlyTotal').asDouble! * 12;
    }

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdAnnual').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {
        secondActivity ? 'secondActivity' : 'fixedMonthly': totalContributions,
      },
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: overCeiling || income >= vatThreshold,
        ),
      ],
      extra: {'overPausalCeiling': overCeiling},
    );
  }
}

import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Albania — i vetëpunësuar (Law 29/2023), annual, ALL. An all-or-nothing
/// cliff: turnover up to ALL 14,000,000 pays 0% income tax; cross it and
/// the whole profit is taxed progressively (15% then 23%), not just the
/// excess. Social/health contributions are FIXED and income-independent
/// (a percentage of the minimum wage, not of actual earnings) and — like
/// FBiH and Republika Srpska — are treated as an ordinary deductible
/// business expense before the cliff's bracket table is applied (the 0%
/// cliff itself is evaluated against raw turnover, per the sourced
/// wording, not the post-contribution base).
class AlFreelanceStrategy implements FreelanceTaxStrategy {
  const AlFreelanceStrategy();

  @override
  String get regimeId => 'al';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  double _marginalTax(List<Map<String, dynamic>> brackets, double base) {
    var tax = 0.0;
    var lower = 0.0;
    for (final b in brackets) {
      final upToRaw = b['upTo'];
      final upTo = upToRaw == null ? double.infinity : (upToRaw as num).toDouble();
      final rate = (b['rate'] as num).toDouble();
      if (base <= lower) break;
      final sliceTop = base < upTo ? base : upTo;
      tax += (sliceTop - lower) * rate;
      lower = upTo;
      if (base <= upTo) break;
    }
    return tax;
  }

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;

    final fixedAnnualContribution = rules.field('fixedAnnualContributionAll').asDouble!;
    final totalContributions = fixedAnnualContribution;

    final taxableBase = (income - totalContributions).clamp(0, double.infinity).toDouble();

    final zeroTaxCeiling = rules.field('zeroTaxTurnoverCeilingAll').asDouble!;
    final overZeroTaxCeiling = income > zeroTaxCeiling;
    final double incomeTax;
    if (!overZeroTaxCeiling) {
      incomeTax = 0.0;
    } else {
      final brackets = rules.field('taxBracketsAboveZeroCeiling').asMapList!;
      incomeTax = _marginalTax(brackets, taxableBase);
    }

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdAll').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: totalContributions,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {'socialAndHealth': totalContributions},
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
        FreelanceCliffFlag(
          id: FreelanceCliffId.albaniaZeroTaxCliff,
          threshold: zeroTaxCeiling,
          crossed: overZeroTaxCeiling,
        ),
      ],
    );
  }
}

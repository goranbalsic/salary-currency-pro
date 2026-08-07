import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Romania — PFA în sistem real, annual, RON. Contributions are computed on
/// statutory CEILINGS tied to multiples of the minimum gross salary — not
/// on actual income — and, unlike Serbia, ARE fully deductible from the tax
/// base: `taxableBase = income - CAS - CASS`, then 10% flat. The formula's
/// internal constants were cross-checked against the source's own worked
/// thresholds (e.g. `12 SM * casRate` reproduces the sourced
/// `threshold12SmCasRon` exactly), confirming the rate and the threshold
/// figures are mutually consistent, not just copied in parallel.
///
/// `input.options['earlyFiling']` (bool, default false) applies the 3%
/// bonification on the income-tax portion for filing by 15 April 2026.
///
/// Deliberately does NOT emit a "normă de venit ceiling" cliff flag: that
/// EUR 25,000 figure is sourced in EUR while this regime's income is RON,
/// and this app's currency-rate live-fetch path is explicitly out of scope
/// for this data layer (see PROMPT-004's own "do not touch the
/// currency-rate path" constraint) — showing a crossed/not-crossed flag
/// without a real conversion would be a fabricated comparison.
class RoFreelanceStrategy implements FreelanceTaxStrategy {
  const RoFreelanceStrategy();

  @override
  String get regimeId => 'ro';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final earlyFiling = input.option('earlyFiling', false);

    final sm = rules.field('minimumGrossSalaryMonthlyRon').asDouble!;
    final threshold12Sm = rules.field('casThresholdMultiple12').asDouble! * sm;
    final threshold24Sm = rules.field('casThresholdMultiple24').asDouble! * sm;
    final casRate = rules.field('casRate').asDouble!;

    final double cas;
    if (income < threshold12Sm) {
      cas = 0.0;
    } else if (income <= threshold24Sm) {
      cas = threshold12Sm * casRate;
    } else {
      cas = threshold24Sm * casRate;
    }

    final cassFloor = rules.field('cassFloorMultiple').asDouble! * sm;
    final cassCap = rules.field('cassCapRon2026').asDouble!;
    final cassBase = clampD(income, cassFloor, cassCap);
    final cass = cassBase * rules.field('cassRate').asDouble!;

    final deduction = cas + cass;
    final taxableBase = (income - deduction).clamp(0, double.infinity).toDouble();
    var incomeTax = taxableBase * rules.field('taxRate').asDouble!;
    if (earlyFiling) {
      incomeTax *= (1 - rules.field('earlyFilingBonusPercent').asDouble!);
    }

    final totalContributions = cas + cass;
    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdRon').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: deduction,
      taxableBase: taxableBase,
      incomeTax: incomeTax,
      contributions: {'cas': cas, 'cass': cass},
      totalContributions: totalContributions,
      netIncome: netIncome,
      cliffFlags: [
        FreelanceCliffFlag(
          id: FreelanceCliffId.vatThreshold,
          threshold: vatThreshold,
          crossed: income >= vatThreshold,
        ),
      ],
      extra: {'earlyFiling': earlyFiling},
    );
  }
}

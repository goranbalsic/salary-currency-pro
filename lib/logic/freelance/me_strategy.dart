import '../../models/freelance_tax_rules.dart';
import 'freelance_tax_strategy.dart';

/// Montenegro — Preduzetnik, annual, EUR. Progressive marginal income tax
/// (0% / 9% / 15%) plus a municipal surtax levied on the tax amount itself
/// (not on income) — the rate depends on the municipality, selected via
/// `input.options['municipality']`: 'podgoricaCetinje' (default), 'budva',
/// or 'other' (most municipalities). Contributions have no defined min/max
/// base in the sourced data, so they apply directly to income.
class MeFreelanceStrategy implements FreelanceTaxStrategy {
  const MeFreelanceStrategy();

  @override
  String get regimeId => 'me';

  @override
  FreelanceIncomePeriod get period => FreelanceIncomePeriod.annual;

  double _marginalTax(List<Map<String, dynamic>> brackets, double income) {
    var tax = 0.0;
    var lower = 0.0;
    for (final b in brackets) {
      final upToRaw = b['upTo'];
      final upTo = upToRaw == null ? double.infinity : (upToRaw as num).toDouble();
      final rate = (b['rate'] as num).toDouble();
      if (income <= lower) break;
      final sliceTop = income < upTo ? income : upTo;
      tax += (sliceTop - lower) * rate;
      lower = upTo;
      if (income <= upTo) break;
    }
    return tax;
  }

  @override
  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input) {
    final income = input.income;
    final municipality = input.option('municipality', 'podgoricaCetinje');

    final brackets = rules.field('taxBrackets').asMapList!;
    final taxBeforeSurtax = _marginalTax(brackets, income);

    final surtaxRate = switch (municipality) {
      'budva' => rules.field('municipalSurtaxBudva').asDouble!,
      'other' => rules.field('municipalSurtaxMostMunicipalities').asDouble!,
      _ => rules.field('municipalSurtaxPodgoricaCetinje').asDouble!,
    };
    final municipalSurtax = taxBeforeSurtax * surtaxRate;
    final incomeTax = taxBeforeSurtax + municipalSurtax;

    final pio = income * rules.field('contributionRatePio').asDouble!;
    final health = income * rules.field('contributionRateHealth').asDouble!;
    final unemployment = income * rules.field('contributionRateUnemployment').asDouble!;
    final totalContributions = pio + health + unemployment;

    final netIncome = income - incomeTax - totalContributions;
    final vatThreshold = rules.field('vatThresholdAnnual').asDouble!;

    return FreelanceTaxResult(
      grossIncome: income,
      totalDeduction: 0,
      taxableBase: income,
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
      extra: {
        'taxBeforeSurtax': taxBeforeSurtax,
        'municipalSurtax': municipalSurtax,
        'municipality': municipality,
      },
    );
  }
}

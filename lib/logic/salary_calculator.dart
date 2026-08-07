import '../models/tax_config.dart';
import 'allowance_strategies.dart';

/// One social-contribution line's computed amounts for a single salary.
class ContributionLine {
  final String id;
  final String label;
  final double base;
  final double employeeAmount;
  final double employerAmount;

  const ContributionLine({
    required this.id,
    required this.label,
    required this.base,
    required this.employeeAmount,
    required this.employerAmount,
  });
}

/// Full transparent breakdown of one gross/net salary calculation, in the
/// selected country's local currency.
class SalaryBreakdown {
  final double bruto1; // gross salary paid to the employee before deductions
  final double allowanceAmount; // personal allowance subtracted from the tax base
  final double taxBase; // taxable base after contributions (if applicable) and allowance
  final double tax; // national income tax, before any local surtax
  final double localSurtaxAmount; // 0 for countries with no local surtax

  final List<ContributionLine> contributions;
  final double employeeContributionsTotal;
  final double employerContributionsTotal;

  final double neto; // what lands in the employee's account
  final double bruto2; // total cost to the employer (bruto1 + employer contributions)

  const SalaryBreakdown({
    required this.bruto1,
    required this.allowanceAmount,
    required this.taxBase,
    required this.tax,
    required this.localSurtaxAmount,
    required this.contributions,
    required this.employeeContributionsTotal,
    required this.employerContributionsTotal,
    required this.neto,
    required this.bruto2,
  });

  double get totalTax => tax + localSurtaxAmount;

  /// The highest per-line contribution base in effect — used to explain a
  /// non-positive neto (mandatory contributions on the minimum base alone
  /// can exceed a very low declared salary).
  double get highestContributionBase => contributions.isEmpty
      ? 0
      : contributions.map((c) => c.base).reduce((a, b) => a > b ? a : b);
}

/// Generic, config-driven payroll math shared by every modeled country.
/// Nothing here is a hardcoded tax number — everything comes from
/// [CountryTaxConfig] (see lib/models/tax_config.dart) and, for the two
/// countries with an income-dependent allowance, [AllowanceStrategy] (see
/// lib/logic/allowance_strategies.dart). Adding a new flat-allowance
/// country needs no changes to this file at all.
class SalaryCalculator {
  final CountryTaxConfig config;

  /// Overrides the country's default local surtax rate (Croatia only) —
  /// exposed so the UI can let the user pick their actual municipality
  /// rate instead of always using the config default.
  final double? localSurtaxRateOverride;

  late final AllowanceStrategy _allowance = allowanceStrategyFor(config);

  SalaryCalculator(this.config, {this.localSurtaxRateOverride});

  /// Marginal tax across [config.brackets]. A flat-tax country is just a
  /// single bracket with `upTo: null`, so this also covers the flat case.
  double _bracketTax(double base) {
    var tax = 0.0;
    var lower = 0.0;
    for (final bracket in config.brackets) {
      if (base <= lower) break;
      final upper = bracket.upTo ?? double.infinity;
      final segment = (base < upper ? base : upper) - lower;
      if (segment > 0) tax += segment * bracket.rate;
      lower = upper;
      if (base <= upper) break;
    }
    return tax;
  }

  /// Computes the full breakdown for a known gross salary (bruto1).
  SalaryBreakdown fromBruto(double bruto1) {
    final lines = <ContributionLine>[];
    var employeeTotal = 0.0;
    var employerTotal = 0.0;

    for (final c in config.contributions) {
      final base = c.clampBase(bruto1);
      final employeeAmount = base * c.employeeRate;
      final employerAmount = base * c.employerRate;
      employeeTotal += employeeAmount;
      employerTotal += employerAmount;
      lines.add(ContributionLine(
        id: c.id,
        label: c.label,
        base: base,
        employeeAmount: employeeAmount,
        employerAmount: employerAmount,
      ));
    }

    final allowanceAmount = _allowance.compute(bruto1);
    final preTaxDeduction = config.taxBaseDeductsContributions
        ? employeeTotal + allowanceAmount
        : allowanceAmount;
    final taxBase =
        (bruto1 - preTaxDeduction).clamp(0, double.infinity).toDouble();

    final tax = _bracketTax(taxBase);
    final surtaxRate =
        localSurtaxRateOverride ?? config.localSurtax?.defaultRate ?? 0;
    final localSurtaxAmount = tax * surtaxRate;

    final neto = bruto1 - employeeTotal - tax - localSurtaxAmount;
    final bruto2 = bruto1 + employerTotal;

    return SalaryBreakdown(
      bruto1: bruto1,
      allowanceAmount: allowanceAmount,
      taxBase: taxBase,
      tax: tax,
      localSurtaxAmount: localSurtaxAmount,
      contributions: lines,
      employeeContributionsTotal: employeeTotal,
      employerContributionsTotal: employerTotal,
      neto: neto,
      bruto2: bruto2,
    );
  }

  /// Solves for the gross salary that produces [targetNeto], by bisection
  /// over [fromBruto] — which is piecewise-linear and monotonically
  /// non-decreasing in bruto1 for every modeled country (contribution
  /// bases and tax brackets only ever grow with gross), so bisection
  /// converges to the exact inverse without needing a closed-form solve
  /// per country's breakpoints.
  SalaryBreakdown fromNeto(double targetNeto) {
    if (targetNeto <= 0) {
      return fromBruto(0);
    }

    double lo = 0;
    double hi = targetNeto * 2 + 1;
    while (fromBruto(hi).neto < targetNeto && hi < 1e13) {
      hi *= 2;
    }

    for (var i = 0; i < 100; i++) {
      final mid = (lo + hi) / 2;
      if (fromBruto(mid).neto < targetNeto) {
        lo = mid;
      } else {
        hi = mid;
      }
    }

    return fromBruto((lo + hi) / 2);
  }
}

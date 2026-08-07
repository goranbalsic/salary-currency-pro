/// A single marginal tax bracket. [upTo] is the monthly taxable-base
/// ceiling for this bracket in the country's local currency; null marks the
/// top (unbounded) bracket. Brackets must be supplied in ascending [upTo]
/// order — a flat-tax country is simply a single bracket with upTo: null.
class TaxBracket {
  final double? upTo;
  final double rate;

  const TaxBracket({required this.upTo, required this.rate});

  factory TaxBracket.fromJson(Map<String, dynamic> json) => TaxBracket(
        upTo: json['upTo'] == null ? null : (json['upTo'] as num).toDouble(),
        rate: (json['rate'] as num).toDouble(),
      );
}

/// One named social-contribution line (pension, health, unemployment, ...).
/// Employee and employer rates are independent — a contribution paid only
/// by the employer (e.g. Croatia's health insurance) simply has
/// employeeRate: 0, and vice versa. [minBase]/[maxBase] clamp the gross
/// salary independently per line, since countries cap different
/// contributions at different ceilings (or don't cap them at all).
class ContributionRate {
  final String id;
  final String label;
  final double employeeRate;
  final double employerRate;
  final double? minBase;
  final double? maxBase;

  const ContributionRate({
    required this.id,
    required this.label,
    required this.employeeRate,
    required this.employerRate,
    this.minBase,
    this.maxBase,
  });

  double clampBase(double grossMonthly) {
    var base = grossMonthly;
    if (minBase != null && base < minBase!) base = minBase!;
    if (maxBase != null && base > maxBase!) base = maxBase!;
    return base;
  }

  factory ContributionRate.fromJson(Map<String, dynamic> json) =>
      ContributionRate(
        id: json['id'] as String,
        label: json['label'] as String,
        employeeRate: (json['employeeRate'] as num?)?.toDouble() ?? 0,
        employerRate: (json['employerRate'] as num?)?.toDouble() ?? 0,
        minBase: (json['minBase'] as num?)?.toDouble(),
        maxBase: (json['maxBase'] as num?)?.toDouble(),
      );
}

/// A municipal/local surtax layered on top of the national income tax
/// (currently only Croatia's "prirez"). Stored as a default + max so the UI
/// can expose it as a user-adjustable field rather than a fixed number,
/// since the actual rate depends on the taxpayer's municipality.
class LocalSurtax {
  final double defaultRate;
  final double maxRate;

  const LocalSurtax({required this.defaultRate, required this.maxRate});

  factory LocalSurtax.fromJson(Map<String, dynamic> json) => LocalSurtax(
        defaultRate: (json['defaultRate'] as num).toDouble(),
        maxRate: (json['maxRate'] as num).toDouble(),
      );
}

enum AllowanceType { flat, formula }

/// Country/entity-agnostic payroll tax parameters, loaded from
/// assets/config/tax/<id>.json — never hardcoded into calculation logic so
/// tax law changes only require editing a JSON config (or swapping this
/// loader for a remote fetch later), never [SalaryCalculator] itself.
///
/// Adding a new country/entity is: write one JSON file matching this shape,
/// then register it in [kCountries] (lib/models/country.dart). No changes
/// to the calculator are needed unless the country's personal allowance
/// depends on income (see [AllowanceType.formula] and
/// lib/logic/allowance_strategies.dart).
class CountryTaxConfig {
  final String countryId;
  final int year;
  final DateTime effectiveFrom;

  /// Whether employee contributions are subtracted from gross before
  /// computing the taxable base (true for every modeled country except
  /// Serbia, where income tax and contributions are computed independently
  /// on the same gross figure).
  final bool taxBaseDeductsContributions;

  final AllowanceType allowanceType;

  /// Used when [allowanceType] is [AllowanceType.flat]; null otherwise
  /// (formula-based allowances are computed by
  /// lib/logic/allowance_strategies.dart, keyed by [countryId]).
  final double? flatAllowanceAmount;

  /// Numeric inputs for a formula-based allowance (see
  /// lib/logic/allowance_strategies.dart); null when [allowanceType] is
  /// [AllowanceType.flat].
  final Map<String, dynamic>? allowanceParams;

  final List<TaxBracket> brackets;
  final List<ContributionRate> contributions;
  final LocalSurtax? localSurtax;

  final List<String> sources;
  final DateTime lastUpdated;

  const CountryTaxConfig({
    required this.countryId,
    required this.year,
    required this.effectiveFrom,
    required this.taxBaseDeductsContributions,
    required this.allowanceType,
    required this.flatAllowanceAmount,
    required this.allowanceParams,
    required this.brackets,
    required this.contributions,
    required this.localSurtax,
    required this.sources,
    required this.lastUpdated,
  });

  factory CountryTaxConfig.fromJson(
    String countryId,
    Map<String, dynamic> json,
  ) {
    return CountryTaxConfig(
      countryId: countryId,
      year: json['year'] as int,
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      taxBaseDeductsContributions:
          json['taxBaseDeductsContributions'] as bool,
      allowanceType: (json['allowanceType'] as String) == 'formula'
          ? AllowanceType.formula
          : AllowanceType.flat,
      flatAllowanceAmount: (json['flatAllowanceAmount'] as num?)?.toDouble(),
      allowanceParams: (json['allowanceParams'] as Map?)?.cast<String, dynamic>(),
      brackets: (json['brackets'] as List)
          .map((b) => TaxBracket.fromJson(b as Map<String, dynamic>))
          .toList(),
      contributions: (json['contributions'] as List)
          .map((c) => ContributionRate.fromJson(c as Map<String, dynamic>))
          .toList(),
      localSurtax: json['localSurtax'] == null
          ? null
          : LocalSurtax.fromJson(json['localSurtax'] as Map<String, dynamic>),
      sources: (json['sources'] as List).cast<String>(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

class TaxConfigUnavailableException implements Exception {
  final String message;
  const TaxConfigUnavailableException(this.message);

  @override
  String toString() => message;
}

import '../logic/salary_calculator.dart';
import '../utils/money.dart';

/// See DECISIONS.md D-031 for the full "same gross"/comparison-currency
/// design record this model implements.
enum CrossBorderPayPeriod { monthly, annual }

/// Fixed comparison currency for the Cross-Border Pack (D-031) — not
/// user-selectable this item.
const crossBorderComparisonCurrency = 'EUR';

/// How the comparison-currency rate for one regime's local currency was
/// obtained. Always present on a successful [CrossBorderRegimeResult] —
/// a regime with no resolvable rate never becomes a result at all, it
/// becomes a [CrossBorderRegimeError] instead (see [CrossBorderComparisonService]).
class CrossBorderRateInfo {
  /// Comparison-currency -> local-currency rate (i.e. 1 EUR = [rate] local).
  final double rate;
  final String source;
  final DateTime asOf;

  /// True when the local currency already *is* the comparison currency —
  /// no cache lookup was needed or performed.
  final bool isSameCurrency;

  const CrossBorderRateInfo({
    required this.rate,
    required this.source,
    required this.asOf,
    this.isSameCurrency = false,
  });
}

/// One country/entity row's full, successfully-computed comparison result.
class CrossBorderRegimeResult {
  final String countryId;

  /// Non-null only for Bosnia's two entities.
  final String? entityId;

  final String currencyCode;

  /// The local-currency gross fed into [breakdown] — already scaled for
  /// [CrossBorderComparisonResult.payPeriod] (see [scaleBreakdownForPeriod]).
  final double grossLocal;

  /// Full local-currency breakdown from the country's own, unmodified
  /// [SalaryCalculator] — already period-scaled.
  final SalaryBreakdown breakdown;

  final CrossBorderRateInfo rateInfo;

  const CrossBorderRegimeResult({
    required this.countryId,
    this.entityId,
    required this.currencyCode,
    required this.grossLocal,
    required this.breakdown,
    required this.rateInfo,
  });

  /// [breakdown.neto] converted to [crossBorderComparisonCurrency], rounded
  /// once at this display boundary (money.dart) — the local-currency
  /// [breakdown] itself is never rounded beyond what [SalaryCalculator]
  /// already produced.
  double get netInComparisonCurrency =>
      minorUnitsToAmount(roundToMinorUnits(breakdown.neto / rateInfo.rate));

  double get employerCostInComparisonCurrency =>
      minorUnitsToAmount(roundToMinorUnits(breakdown.bruto2 / rateInfo.rate));

  /// Stable row id for widget keys/tests, e.g. "ba_fbih".
  String get rowId => entityId == null ? countryId : '${countryId}_$entityId';
}

/// Why one country/entity could not produce a comparison row at all — shown
/// as an explicit unavailable row, never silently dropped from the table.
enum CrossBorderUnavailableReason { configUnavailable, noCachedRate }

class CrossBorderRegimeError {
  final String countryId;
  final String? entityId;
  final String currencyCode;
  final CrossBorderUnavailableReason reason;
  final String message;

  const CrossBorderRegimeError({
    required this.countryId,
    this.entityId,
    required this.currencyCode,
    required this.reason,
    required this.message,
  });

  String get rowId => entityId == null ? countryId : '${countryId}_$entityId';
}

/// Full result of one comparison run: one entry per [kCountries] (see
/// lib/models/country.dart) in that list's fixed order, split between
/// [regimes] (succeeded) and [errors] (explicit unavailable state) —
/// together they always total exactly `kCountries.length` rows.
class CrossBorderComparisonResult {
  final double grossInputComparisonCurrency;
  final CrossBorderPayPeriod payPeriod;
  final String selectedBaEntityId;
  final List<CrossBorderRegimeResult> regimes;
  final List<CrossBorderRegimeError> errors;

  const CrossBorderComparisonResult({
    required this.grossInputComparisonCurrency,
    required this.payPeriod,
    required this.selectedBaEntityId,
    required this.regimes,
    required this.errors,
  });
}

/// Scales every money figure in [breakdown] by [factor] (12 for turning a
/// monthly engine result into an annual display figure — see D-031's "Pay
/// period" note: the engine itself is monthly-only, so annual mode is
/// always "compute the real monthly breakdown, then multiply for display",
/// never a separate annual-bracket calculation). Rounds once per field
/// through money.dart so the multiplication can't leave floating-point
/// artifacts in a displayed or stored figure.
SalaryBreakdown scaleBreakdownForPeriod(SalaryBreakdown breakdown, CrossBorderPayPeriod period) {
  if (period == CrossBorderPayPeriod.monthly) return breakdown;

  double scale(double v) => minorUnitsToAmount(roundToMinorUnits(v * 12));

  return SalaryBreakdown(
    bruto1: scale(breakdown.bruto1),
    allowanceAmount: scale(breakdown.allowanceAmount),
    taxBase: scale(breakdown.taxBase),
    tax: scale(breakdown.tax),
    localSurtaxAmount: scale(breakdown.localSurtaxAmount),
    contributions: [
      for (final c in breakdown.contributions)
        ContributionLine(
          id: c.id,
          label: c.label,
          base: scale(c.base),
          employeeAmount: scale(c.employeeAmount),
          employerAmount: scale(c.employerAmount),
        ),
    ],
    employeeContributionsTotal: scale(breakdown.employeeContributionsTotal),
    employerContributionsTotal: scale(breakdown.employerContributionsTotal),
    neto: scale(breakdown.neto),
    bruto2: scale(breakdown.bruto2),
  );
}

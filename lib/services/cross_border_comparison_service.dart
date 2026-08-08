import '../logic/salary_calculator.dart';
import '../models/country.dart';
import '../models/cross_border_comparison.dart';
import '../models/tax_config.dart';
import 'exchange_rate_service.dart';
import 'tax_config_service.dart';

/// Orchestrates the Cross-Border Pack: runs one "same gross" scenario
/// through every one of [kCountries]'s real, unmodified salary engines.
/// See DECISIONS.md D-031 for the full design record. Pure orchestration —
/// no payroll math and no currency-conversion math of its own lives here,
/// only reuse of [SalaryCalculator], [TaxConfigService], and
/// [ExchangeRateService.getCachedRateOnly].
class CrossBorderComparisonService {
  final TaxConfigService _configService;
  final ExchangeRateService _rateService;

  CrossBorderComparisonService({
    TaxConfigService? configService,
    ExchangeRateService? rateService,
  })  : _configService = configService ?? TaxConfigService(),
        _rateService = rateService ?? ExchangeRateService();

  /// [grossComparisonCurrency] is the "same gross" figure the user entered,
  /// in [crossBorderComparisonCurrency] (EUR), denominated for [payPeriod].
  /// [baEntityId] picks which of Bosnia's two entities (`fbih` or
  /// `republika_srpska`) fills that one row — falls back to the first
  /// entity if an unknown id is passed, matching
  /// [SalaryCalculatorProvider]'s existing convention.
  Future<CrossBorderComparisonResult> compare({
    required double grossComparisonCurrency,
    required CrossBorderPayPeriod payPeriod,
    required String baEntityId,
  }) async {
    final regimes = <CrossBorderRegimeResult>[];
    final errors = <CrossBorderRegimeError>[];

    for (final country in kCountries) {
      final entity = country.hasEntities
          ? country.entities!.firstWhere(
              (e) => e.id == baEntityId,
              orElse: () => country.entities!.first,
            )
          : null;
      final assetPath = entity?.taxConfigAsset ?? country.taxConfigAsset!;
      final configId = entity?.id ?? country.id;
      final currencyCode = country.currencyCode;

      final rateResult = await _rateService.getCachedRateOnly(
        crossBorderComparisonCurrency,
        currencyCode,
      );
      if (rateResult == null) {
        errors.add(CrossBorderRegimeError(
          countryId: country.id,
          entityId: entity?.id,
          currencyCode: currencyCode,
          reason: CrossBorderUnavailableReason.noCachedRate,
          message: 'No cached exchange rate for $currencyCode.',
        ));
        continue;
      }

      try {
        final config = await _configService.load(configId, assetPath);

        // rateResult.rate is EUR -> currencyCode (1 EUR = rate local units).
        final periodDivisor = payPeriod == CrossBorderPayPeriod.annual ? 12 : 1;
        final grossLocalMonthly =
            grossComparisonCurrency * rateResult.rate / periodDivisor;

        final monthlyBreakdown = SalaryCalculator(config).fromBruto(grossLocalMonthly);
        final breakdown = scaleBreakdownForPeriod(monthlyBreakdown, payPeriod);

        regimes.add(CrossBorderRegimeResult(
          countryId: country.id,
          entityId: entity?.id,
          currencyCode: currencyCode,
          grossLocal: breakdown.bruto1,
          breakdown: breakdown,
          rateInfo: CrossBorderRateInfo(
            rate: rateResult.rate,
            source: rateResult.source,
            asOf: rateResult.asOf,
            isSameCurrency: currencyCode == crossBorderComparisonCurrency,
          ),
        ));
      } on TaxConfigUnavailableException catch (e) {
        errors.add(CrossBorderRegimeError(
          countryId: country.id,
          entityId: entity?.id,
          currencyCode: currencyCode,
          reason: CrossBorderUnavailableReason.configUnavailable,
          message: e.message,
        ));
      }
    }

    return CrossBorderComparisonResult(
      grossInputComparisonCurrency: grossComparisonCurrency,
      payPeriod: payPeriod,
      selectedBaEntityId: baEntityId,
      regimes: regimes,
      errors: errors,
    );
  }
}

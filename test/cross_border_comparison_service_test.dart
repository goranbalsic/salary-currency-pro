import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/logic/salary_calculator.dart';
import 'package:salary_currency_pro/models/country.dart';
import 'package:salary_currency_pro/models/cross_border_comparison.dart';
import 'package:salary_currency_pro/models/rate_snapshot.dart';
import 'package:salary_currency_pro/services/cross_border_comparison_service.dart';
import 'package:salary_currency_pro/services/exchange_rate_service.dart';
import 'package:salary_currency_pro/services/rate_cache_service.dart';
import 'package:salary_currency_pro/services/rate_providers.dart';
import 'package:salary_currency_pro/services/tax_config_service.dart';

/// Never actually reached by [ExchangeRateService.getCachedRateOnly] — these
/// tests exist to prove that, so any accidental live-fetch attempt fails
/// loudly instead of silently working.
class _ForbiddenProvider implements RateProviderApi {
  @override
  final String id;
  const _ForbiddenProvider(this.id);

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    throw StateError('Cross-Border Pack must never trigger a live rate fetch ($id).');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ExchangeRateService serviceWithCache(RateCacheService cache) => ExchangeRateService(
        frankfurter: const _ForbiddenProvider('frankfurter'),
        openErApi: const _ForbiddenProvider('open_er_api'),
        cache: cache,
      );

  RateSnapshot eurBaseSnapshot({DateTime? asOf}) => RateSnapshot(
        base: 'EUR',
        rates: {'RSD': 117.3, 'RON': 4.98, 'BAM': 1.96, 'MKD': 61.5, 'ALL': 104.2},
        asOf: asOf ?? DateTime(2026, 8, 1),
        fetchedAt: asOf ?? DateTime(2026, 8, 1),
        source: 'ExchangeRate-API (open.er-api.com)',
      );

  group('all nine countries — inclusion and deterministic ordering', () {
    test('with a full cache, every country produces a row, in kCountries order', () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', eurBaseSnapshot());
      final service = CrossBorderComparisonService(
        rateService: serviceWithCache(cache),
      );

      final result = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );

      expect(result.errors, isEmpty);
      expect(result.regimes.length, kCountries.length);
      expect(result.regimes.map((r) => r.countryId).toList(), kCountries.map((c) => c.id).toList());
    });

    test('with an empty cache, only the EUR-native countries + identity pairs resolve; the '
        'rest are explicit "no cached rate" errors, never guessed', () async {
      final service = CrossBorderComparisonService(rateService: serviceWithCache(RateCacheService()));

      final result = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );

      final eurNativeIds = kCountries.where((c) => c.currencyCode == 'EUR').map((c) => c.id).toSet();
      expect(result.regimes.map((r) => r.countryId).toSet(), eurNativeIds);
      expect(result.errors.length, kCountries.length - eurNativeIds.length);
      expect(
        result.errors.every((e) => e.reason == CrossBorderUnavailableReason.noCachedRate),
        isTrue,
      );
      // Total rows (available + unavailable) always covers all nine countries.
      final allIds = {...result.regimes.map((r) => r.countryId), ...result.errors.map((e) => e.countryId)};
      expect(allIds, kCountries.map((c) => c.id).toSet());
    });
  });

  group('same-gross conversion semantics', () {
    test('EUR-native countries use identity rate 1.0 regardless of cache state', () async {
      final service = CrossBorderComparisonService(rateService: serviceWithCache(RateCacheService()));
      final result = await service.compare(
        grossComparisonCurrency: 2000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );

      final hr = result.regimes.firstWhere((r) => r.countryId == 'hr');
      expect(hr.rateInfo.isSameCurrency, isTrue);
      expect(hr.rateInfo.rate, 1.0);
      expect(hr.grossLocal, closeTo(2000, 0.01));
    });

    test('a non-EUR country converts the EUR gross into local currency before running the '
        'engine — comparing raw numbers across currencies is never done', () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', eurBaseSnapshot());
      final service = CrossBorderComparisonService(rateService: serviceWithCache(cache));

      final result = await service.compare(
        grossComparisonCurrency: 1000, // EUR
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );

      final rs = result.regimes.firstWhere((r) => r.countryId == 'rs');
      // 1000 EUR * 117.3 RSD/EUR = 117300 RSD gross, not literally 1000.
      expect(rs.grossLocal, closeTo(117300, 0.01));
      expect(rs.currencyCode, 'RSD');
    });

    test('comparison-currency equivalents are computed with the same rate used for the input '
        'conversion, so a round trip returns the original gross exactly for a 0% country', () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', eurBaseSnapshot());
      final service = CrossBorderComparisonService(rateService: serviceWithCache(cache));

      final result = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );
      final rs = result.regimes.firstWhere((r) => r.countryId == 'rs');
      // grossLocal / rate must reconstruct the original EUR gross exactly (to cent precision).
      expect(rs.grossLocal / rs.rateInfo.rate, closeTo(1000, 0.01));
    });
  });

  group('net-result propagation vs the real, directly-invoked engine', () {
    test('Croatia\'s cross-border row matches SalaryCalculator.fromBruto called directly with '
        'the same local gross — the orchestration never re-derives or re-rounds the engine\'s own math',
        () async {
      final service = CrossBorderComparisonService(rateService: serviceWithCache(RateCacheService()));
      final result = await service.compare(
        grossComparisonCurrency: 2000, // HR is EUR-native: 2000 EUR gross = 2000 EUR local
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );
      final hr = result.regimes.firstWhere((r) => r.countryId == 'hr');

      final directConfig = await TaxConfigService().load('hr', 'assets/config/tax/hr.json');
      final direct = SalaryCalculator(directConfig).fromBruto(2000);

      expect(hr.breakdown.neto, closeTo(direct.neto, 0.01));
      expect(hr.breakdown.bruto2, closeTo(direct.bruto2, 0.01));
      expect(hr.breakdown.tax, closeTo(direct.tax, 0.01));
    });
  });

  group('employer total-cost decomposition', () {
    test('employer cost (bruto2) is always >= gross for every available country, and every '
        'available row carries a distinct employee-deductions figure from gross to net',
        () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', eurBaseSnapshot());
      final service = CrossBorderComparisonService(rateService: serviceWithCache(cache));
      final result = await service.compare(
        grossComparisonCurrency: 1500,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );

      expect(result.regimes, isNotEmpty);
      for (final r in result.regimes) {
        expect(r.breakdown.bruto2, greaterThanOrEqualTo(r.breakdown.bruto1),
            reason: '${r.countryId}: employer cost must be >= gross');
        final employeeDeductions = r.breakdown.bruto1 - r.breakdown.neto;
        expect(employeeDeductions, greaterThanOrEqualTo(0),
            reason: '${r.countryId}: employee deductions must be non-negative');
      }
    });
  });

  group('Bosnia entity selection', () {
    test('choosing FBiH vs Republika Srpska changes the Bosnia row without touching any other row',
        () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', eurBaseSnapshot());
      final service = CrossBorderComparisonService(rateService: serviceWithCache(cache));

      final fbih = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );
      final rs = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'republika_srpska',
      );

      final baFbih = fbih.regimes.firstWhere((r) => r.countryId == 'ba');
      final baRs = rs.regimes.firstWhere((r) => r.countryId == 'ba');
      expect(baFbih.entityId, 'fbih');
      expect(baRs.entityId, 'republika_srpska');

      // Every non-Bosnia row must be identical between the two runs.
      for (final country in kCountries.where((c) => c.id != 'ba')) {
        final a = fbih.regimes.firstWhere((r) => r.countryId == country.id);
        final b = rs.regimes.firstWhere((r) => r.countryId == country.id);
        expect(a.breakdown.neto, b.breakdown.neto, reason: '${country.id} must be unaffected by the BA entity choice');
      }
    });

    test('an unrecognized BA entity id falls back to the first entity rather than failing', () async {
      final service = CrossBorderComparisonService(rateService: serviceWithCache(RateCacheService()));
      final result = await service.compare(
        grossComparisonCurrency: 1000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'not_a_real_entity',
      );
      // BAM has no cache in this test -> an explicit error row, but it must
      // still resolve *an* entity (the fallback), not crash the whole compare().
      final baError = result.errors.firstWhere((e) => e.countryId == 'ba');
      expect(baError.entityId, kCountries.firstWhere((c) => c.id == 'ba').entities!.first.id);
    });
  });

  group('annual pay period', () {
    test('annual gross is divided by 12 before conversion/calculation, then the result is '
        'scaled back up by 12 for display', () async {
      final service = CrossBorderComparisonService(rateService: serviceWithCache(RateCacheService()));
      final monthly = await service.compare(
        grossComparisonCurrency: 2000,
        payPeriod: CrossBorderPayPeriod.monthly,
        baEntityId: 'fbih',
      );
      final annual = await service.compare(
        grossComparisonCurrency: 24000,
        payPeriod: CrossBorderPayPeriod.annual,
        baEntityId: 'fbih',
      );

      final hrMonthly = monthly.regimes.firstWhere((r) => r.countryId == 'hr');
      final hrAnnual = annual.regimes.firstWhere((r) => r.countryId == 'hr');
      expect(hrAnnual.breakdown.neto, closeTo(hrMonthly.breakdown.neto * 12, 0.01));
      expect(hrAnnual.grossLocal, closeTo(24000, 0.01));
    });
  });
}

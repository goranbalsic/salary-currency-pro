import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/rate_snapshot.dart';
import 'package:salary_currency_pro/services/exchange_rate_service.dart';
import 'package:salary_currency_pro/services/rate_cache_service.dart';
import 'package:salary_currency_pro/services/rate_providers.dart';

/// Test double standing in for a real network provider so these tests never
/// hit the network, but exercise the exact same fallback logic the app uses.
class _FakeProvider implements RateProviderApi {
  @override
  final String id;

  final RateSnapshot? Function(String base) onFetch;

  _FakeProvider(this.id, this.onFetch);

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    final snapshot = onFetch(base);
    if (snapshot == null) {
      throw const RateUnavailableException('Simulated network failure.');
    }
    return snapshot;
  }
}

RateSnapshot _snapshot({
  required String base,
  required Map<String, double> rates,
  DateTime? asOf,
  DateTime? fetchedAt,
  String source = 'Fake Source',
}) {
  final now = DateTime.now();
  return RateSnapshot(
    base: base,
    rates: rates,
    asOf: asOf ?? now,
    fetchedAt: fetchedAt ?? now,
    source: source,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('returns a live rate on a successful call and marks it isLive=true',
      () async {
    final provider = _FakeProvider(
      'frankfurter',
      (base) => _snapshot(base: 'EUR', rates: {'USD': 1.1}),
    );
    final service = ExchangeRateService(
      frankfurter: provider,
      cache: RateCacheService(),
    );

    final result = await service.getRate('EUR', 'USD');

    expect(result.isLive, isTrue);
    expect(result.rate, 1.1);
    expect(result.source, 'Fake Source');
  });

  test(
      'falls back to the cached snapshot (isLive=false) when the live call fails, '
      'and never fabricates a number', () async {
    final cache = RateCacheService();
    // Prime the cache as if a previous successful call happened.
    await cache.save(
      'frankfurter',
      _snapshot(base: 'EUR', rates: {'USD': 1.23}, source: 'Cached Source'),
    );

    final failingProvider = _FakeProvider('frankfurter', (_) => null);
    final service = ExchangeRateService(
      frankfurter: failingProvider,
      cache: cache,
    );

    final result = await service.getRate('EUR', 'USD');

    expect(result.isLive, isFalse);
    expect(result.rate, 1.23);
    expect(result.source, 'Cached Source');
  });

  test(
      'throws RateUnavailableException (no fabricated rate) when the live call '
      'fails and there is no cache at all — e.g. first launch, offline',
      () async {
    final failingProvider = _FakeProvider('frankfurter', (_) => null);
    final service = ExchangeRateService(
      frankfurter: failingProvider,
      cache: RateCacheService(),
    );

    expect(
      () => service.getRate('EUR', 'USD'),
      throwsA(isA<RateUnavailableException>()),
    );
  });

  test('same-currency conversion short-circuits to rate 1.0 without a network call',
      () async {
    final provider = _FakeProvider(
      'frankfurter',
      (_) => throw StateError('should not be called for same-currency'),
    );
    final service = ExchangeRateService(
      frankfurter: provider,
      cache: RateCacheService(),
    );

    final result = await service.getRate('EUR', 'EUR');
    expect(result.rate, 1.0);
    expect(result.isLive, isTrue);
  });

  test('RSD pairs are routed to the RSD provider, not Frankfurter', () async {
    final frankfurter = _FakeProvider(
      'frankfurter',
      (_) => throw StateError('Frankfurter should not be used for RSD'),
    );
    final rsdProvider = _FakeProvider(
      'open_er_api',
      (base) => _snapshot(
        base: 'EUR',
        rates: {'RSD': 117.3},
        source: 'ExchangeRate-API (open.er-api.com)',
      ),
    );

    final service = ExchangeRateService(
      frankfurter: frankfurter,
      openErApi: rsdProvider,
      cache: RateCacheService(),
    );

    final result = await service.getRate('EUR', 'RSD');
    expect(result.rate, 117.3);
    expect(result.source, contains('open.er-api.com'));
  });
}

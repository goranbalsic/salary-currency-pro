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

  group('BGN — legacy pegged entry, never live-fetched (PROMPT-005 Part 3)', () {
    test('BGN -> EUR uses the fixed 1.95583 peg without touching any provider', () async {
      final frankfurter = _FakeProvider(
        'frankfurter',
        (_) => throw StateError('BGN must never reach a live provider'),
      );
      final service = ExchangeRateService(frankfurter: frankfurter, cache: RateCacheService());

      final result = await service.getRate('BGN', 'EUR');

      expect(result.rate, closeTo(1 / 1.95583, 0.00001));
      expect(result.isLive, isTrue);
      expect(result.source, contains('peg'));
    });

    test('EUR -> BGN uses the fixed 1.95583 peg', () async {
      final service = ExchangeRateService(
        frankfurter: _FakeProvider('frankfurter', (_) => throw StateError('should not be called')),
        cache: RateCacheService(),
      );

      final result = await service.getRate('EUR', 'BGN');
      expect(result.rate, closeTo(1.95583, 0.00001));
    });

    test('1000 BGN converts to exactly 511.30 EUR (the real redenomination amount)', () async {
      final service = ExchangeRateService(
        frankfurter: _FakeProvider('frankfurter', (_) => throw StateError('should not be called')),
        cache: RateCacheService(),
      );
      final result = await service.getRate('BGN', 'EUR');
      expect(1000 * result.rate, closeTo(511.30, 0.01));
    });

    test('BGN -> USD compounds the peg with a live EUR -> USD rate', () async {
      final frankfurter = _FakeProvider(
        'frankfurter',
        (base) => _snapshot(base: 'EUR', rates: {'USD': 1.1}),
      );
      final service = ExchangeRateService(frankfurter: frankfurter, cache: RateCacheService());

      final result = await service.getRate('BGN', 'USD');

      // 1 BGN = (1/1.95583) EUR = 0.51130 EUR = 0.51130 * 1.1 USD.
      expect(result.rate, closeTo((1 / 1.95583) * 1.1, 0.0001));
    });

    test('USD -> BGN compounds a live EUR -> USD rate with the peg (inverted)', () async {
      final frankfurter = _FakeProvider(
        'frankfurter',
        (base) => _snapshot(base: 'EUR', rates: {'USD': 1.1}),
      );
      final service = ExchangeRateService(frankfurter: frankfurter, cache: RateCacheService());

      final result = await service.getRate('USD', 'BGN');

      // 1 USD = (1/1.1) EUR = (1/1.1)*1.95583 BGN.
      expect(result.rate, closeTo((1 / 1.1) * 1.95583, 0.0001));
    });
  });

  group('getCachedRateOnly — never touches a provider (PROMPT-003G, D-031)', () {
    ExchangeRateService serviceWithProvidersThatMustNotBeCalled(RateCacheService cache) {
      return ExchangeRateService(
        frankfurter: _FakeProvider(
          'frankfurter',
          (_) => throw StateError('getCachedRateOnly must never call a live provider'),
        ),
        openErApi: _FakeProvider(
          'open_er_api',
          (_) => throw StateError('getCachedRateOnly must never call a live provider'),
        ),
        cache: cache,
      );
    }

    test('same-currency short-circuits to identity without touching the cache', () async {
      final service = serviceWithProvidersThatMustNotBeCalled(RateCacheService());
      final result = await service.getCachedRateOnly('EUR', 'EUR');
      expect(result!.rate, 1.0);
      expect(result.isLive, isFalse);
    });

    test('returns null (never a guessed rate) when nothing has ever been cached', () async {
      final service = serviceWithProvidersThatMustNotBeCalled(RateCacheService());
      final result = await service.getCachedRateOnly('EUR', 'RSD');
      expect(result, isNull);
    });

    test('reads a real prior cache entry for EUR -> RSD (routed to open_er_api only)', () async {
      final cache = RateCacheService();
      await cache.save('open_er_api', _snapshot(base: 'EUR', rates: {'RSD': 117.3, 'USD': 1.08}));
      final service = serviceWithProvidersThatMustNotBeCalled(cache);

      final result = await service.getCachedRateOnly('EUR', 'RSD');
      expect(result!.rate, 117.3);
      expect(result.isLive, isFalse);
    });

    test('an RSD pair never checks the frankfurter cache bucket, even if it exists', () async {
      final cache = RateCacheService();
      // Frankfurter cache happens to also carry an (incorrect, for this test)
      // RSD figure — must never be read for an RSD pair.
      await cache.save('frankfurter', _snapshot(base: 'EUR', rates: {'RSD': 999.0}));
      final service = serviceWithProvidersThatMustNotBeCalled(cache);

      final result = await service.getCachedRateOnly('EUR', 'RSD');
      expect(result, isNull);
    });

    test(
        'a non-RSD currency incidentally present in the open_er_api cache (from an '
        'unrelated RSD conversion) is still found — the whole point of D-031\'s design',
        () async {
      final cache = RateCacheService();
      await cache.save(
        'open_er_api',
        _snapshot(base: 'EUR', rates: {'RSD': 117.3, 'RON': 4.98, 'BAM': 1.96, 'MKD': 61.5}),
      );
      final service = serviceWithProvidersThatMustNotBeCalled(cache);

      expect((await service.getCachedRateOnly('EUR', 'RON'))!.rate, 4.98);
      expect((await service.getCachedRateOnly('EUR', 'BAM'))!.rate, 1.96);
      expect((await service.getCachedRateOnly('EUR', 'MKD'))!.rate, 61.5);
    });

    test('falls back to the frankfurter cache bucket for a non-RSD currency it holds', () async {
      final cache = RateCacheService();
      await cache.save('frankfurter', _snapshot(base: 'EUR', rates: {'RON': 4.97}));
      final service = serviceWithProvidersThatMustNotBeCalled(cache);

      final result = await service.getCachedRateOnly('EUR', 'RON');
      expect(result!.rate, 4.97);
    });

    test('BGN <-> EUR peg is available offline without any cache entry', () async {
      final service = serviceWithProvidersThatMustNotBeCalled(RateCacheService());
      expect((await service.getCachedRateOnly('BGN', 'EUR'))!.rate, closeTo(1 / 1.95583, 0.00001));
      expect((await service.getCachedRateOnly('EUR', 'BGN'))!.rate, closeTo(1.95583, 0.00001));
    });
  });
}

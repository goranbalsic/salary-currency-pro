import '../models/rate_snapshot.dart';
import 'rate_cache_service.dart';
import 'rate_providers.dart';

/// Currencies that must be routed to NBS-adjacent RSD data instead of
/// Frankfurter, which does not quote RSD at all.
const rsdCode = 'RSD';

/// Facade that picks the right provider for a currency pair, tries a live
/// fetch, and falls back to the last cached snapshot on failure. Never
/// returns or invents a rate that didn't come from a real API response.
class ExchangeRateService {
  final RateProviderApi _frankfurter;
  final RateProviderApi _openErApi;
  final RateCacheService _cache;

  ExchangeRateService({
    RateProviderApi? frankfurter,
    RateProviderApi? openErApi,
    RateCacheService? cache,
  })  : _frankfurter = frankfurter ?? FrankfurterRateProvider(),
        _openErApi = openErApi ?? OpenErApiRateProvider(),
        _cache = cache ?? RateCacheService();

  RateProviderApi _providerFor(String from, String to) {
    if (from == rsdCode || to == rsdCode) return _openErApi;
    return _frankfurter;
  }

  Future<RateResult> getRate(String from, String to) async {
    if (from == to) {
      final now = DateTime.now();
      return RateResult(
        from: from,
        to: to,
        rate: 1.0,
        asOf: now,
        fetchedAt: now,
        source: 'Same currency',
        isLive: true,
      );
    }

    final provider = _providerFor(from, to);

    try {
      final snapshot = await provider.fetchLatest(from);
      final rate = snapshot.rates[to];
      if (rate == null) {
        throw RateUnavailableException(
          '${provider.id == 'open_er_api' ? 'ExchangeRate-API' : 'Frankfurter'} '
          'does not quote $from -> $to.',
        );
      }
      await _cache.save(provider.id, snapshot);
      return RateResult(
        from: from,
        to: to,
        rate: rate,
        asOf: snapshot.asOf,
        fetchedAt: snapshot.fetchedAt,
        source: snapshot.source,
        isLive: true,
      );
    } catch (liveError) {
      final cached = await _cache.load(provider.id, from);
      if (cached == null) {
        throw RateUnavailableException(
          liveError is RateUnavailableException
              ? liveError.message
              : 'Could not fetch live rates and no cached rates are available yet.',
        );
      }
      final rate = cached.rates[to];
      if (rate == null) {
        throw RateUnavailableException(
          'No live connection, and the cached rates don\'t include $from -> $to.',
        );
      }
      return RateResult(
        from: from,
        to: to,
        rate: rate,
        asOf: cached.asOf,
        fetchedAt: cached.fetchedAt,
        source: cached.source,
        isLive: false,
      );
    }
  }
}

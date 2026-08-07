import '../models/rate_snapshot.dart';
import 'rate_cache_service.dart';
import 'rate_providers.dart';

/// Currencies that must be routed to NBS-adjacent RSD data instead of
/// Frankfurter, which does not quote RSD at all.
const rsdCode = 'RSD';

/// Bulgaria adopted the euro 1 Jan 2026 at this fixed, irrevocable rate.
/// Frankfurter (this app's EUR-quoting provider) has since removed BGN from
/// its rates entirely — confirmed live: a direct BGN query 404s and BGN is
/// absent from the full EUR rates list — so BGN can never be live-fetched
/// again. It's kept in the converter as a legacy/pegged entry only, always
/// computed from this constant, never from a network call. See
/// DECISIONS.md D-020.
const bgnCode = 'BGN';
const bgnPerEurPeg = 1.95583;

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

    if (from == bgnCode || to == bgnCode) {
      return _getRateInvolvingBgn(from, to);
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

  static const _bgnPegSource = 'Fixed peg (Bulgaria euro adoption, 1 Jan 2026)';

  /// BGN is legacy-only (see [bgnCode]'s doc comment) — never fetched live.
  /// BGN<->EUR is the fixed peg directly; any other pair compounds the peg
  /// with a live EUR<->other rate, so old BGN cash can still be compared
  /// against any currency the converter otherwise supports.
  Future<RateResult> _getRateInvolvingBgn(String from, String to) async {
    final now = DateTime.now();

    if (from == bgnCode && to == 'EUR') {
      return RateResult(
        from: from,
        to: to,
        rate: 1 / bgnPerEurPeg,
        asOf: now,
        fetchedAt: now,
        source: _bgnPegSource,
        isLive: true,
      );
    }
    if (from == 'EUR' && to == bgnCode) {
      return RateResult(
        from: from,
        to: to,
        rate: bgnPerEurPeg,
        asOf: now,
        fetchedAt: now,
        source: _bgnPegSource,
        isLive: true,
      );
    }

    // Compound: peg to/from EUR, then a live EUR<->other-currency rate.
    // eurToOther.rate is EUR->other; BGN->other needs (BGN->EUR)*(EUR->other),
    // other->BGN needs (other->EUR)*(EUR->BGN) = (1/eurToOther.rate)*bgnPerEurPeg.
    final other = from == bgnCode ? to : from;
    final eurToOther = await getRate('EUR', other);
    final rate = from == bgnCode
        ? (1 / bgnPerEurPeg) * eurToOther.rate
        : (1 / eurToOther.rate) * bgnPerEurPeg;

    return RateResult(
      from: from,
      to: to,
      rate: rate,
      asOf: eurToOther.asOf,
      fetchedAt: eurToOther.fetchedAt,
      source: '$_bgnPegSource + ${eurToOther.source}',
      isLive: eurToOther.isLive,
    );
  }
}

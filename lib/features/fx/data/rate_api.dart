import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/rates.dart';

class RateFetchException implements Exception {
  const RateFetchException(this.message);
  final String message;
  @override
  String toString() => 'RateFetchException: $message';
}

/// Network access to the two official rate sources. Every method either
/// returns real published data or throws — it never invents a rate.
abstract class RateApi {
  Future<RateTable> fetchNbs();
  Future<RateTable> fetchEcb();

  /// NBS middle rate (RSD per 1 unit) valid on [date].
  Future<RatePoint> fetchNbsOn(String code, DateTime date);

  /// Daily history, oldest first, of one unit of [code] in the source base.
  Future<List<RatePoint>> history(RateSource source, String code, DateTime from, DateTime to);
}

/// Currencies the NBS still quotes (the feed also carries legacy
/// pre-euro currencies with a middle rate only — those are dropped).
const _nbsLegacy = {
  'ATS', 'BEF', 'DEM', 'ESP', 'FIM', 'FRF', 'GRD', 'IEP', 'ITL', 'LUF', 'NLG', 'PTE', 'SIT', 'SKK', 'HRK', 'BGN', 'XDR',
};

class HttpRateApi implements RateApi {
  HttpRateApi({http.Client? client, this.timeout = const Duration(seconds: 12)}) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  static const _nbsHost = 'https://kurs.resenje.org/api/v1';
  static const _ecbHost = 'https://api.frankfurter.dev/v1';
  static const _headers = {'Accept': 'application/json', 'User-Agent': 'Bilans/2 (Android)'};

  Future<Object?> _getJson(Uri uri) async {
    http.Response res;
    try {
      res = await _client.get(uri, headers: _headers).timeout(timeout);
    } on TimeoutException {
      throw const RateFetchException('timeout');
    } catch (e) {
      throw RateFetchException('network: $e');
    }
    if (res.statusCode != 200) throw RateFetchException('HTTP ${res.statusCode}');
    try {
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      throw const RateFetchException('malformed response');
    }
  }

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static double? _pos(Object? v) => v is num && v.isFinite && v > 0 ? v.toDouble() : null;

  @override
  Future<RateTable> fetchNbs() async {
    final body = await _getJson(Uri.parse('$_nbsHost/rates/today'));
    if (body is! Map || body['rates'] is! List) throw const RateFetchException('unexpected NBS payload');
    final quotes = <String, Quote>{};
    DateTime? date;
    for (final r in body['rates'] as List) {
      if (r is! Map) continue;
      final code = r['code'];
      if (code is! String || _nbsLegacy.contains(code)) continue;
      final parity = (r['parity'] is num && (r['parity'] as num) > 0) ? (r['parity'] as num).toDouble() : 1.0;
      final middle = _pos(r['exchange_middle']);
      final buy = _pos(r['exchange_buy']);
      final sell = _pos(r['exchange_sell']);
      if (middle == null || buy == null || sell == null) continue;
      quotes[code] = Quote(middle: middle / parity, buy: buy / parity, sell: sell / parity);
      final d = r['date'] is String ? DateTime.tryParse(r['date'] as String) : null;
      if (d != null && (date == null || d.isAfter(date))) date = d;
    }
    if (quotes.length < 5 || date == null || !quotes.containsKey('EUR')) {
      throw const RateFetchException('incomplete NBS list');
    }
    return RateTable(
      source: RateSource.nbs,
      base: 'RSD',
      date: DateTime(date.year, date.month, date.day),
      fetchedAt: DateTime.now(),
      quotes: quotes,
    );
  }

  @override
  Future<RateTable> fetchEcb() async {
    final body = await _getJson(Uri.parse('$_ecbHost/latest?base=EUR'));
    if (body is! Map || body['rates'] is! Map || body['date'] is! String) {
      throw const RateFetchException('unexpected ECB payload');
    }
    final date = DateTime.tryParse(body['date'] as String);
    final quotes = <String, Quote>{};
    (body['rates'] as Map).forEach((k, v) {
      final value = _pos(v);
      if (k is String && value != null) quotes[k] = Quote(middle: value);
    });
    if (date == null || quotes.length < 5) throw const RateFetchException('incomplete ECB list');
    return RateTable(
      source: RateSource.ecb,
      base: 'EUR',
      date: DateTime(date.year, date.month, date.day),
      fetchedAt: DateTime.now(),
      quotes: quotes,
    );
  }

  @override
  Future<RatePoint> fetchNbsOn(String code, DateTime date) async {
    final body = await _getJson(Uri.parse('$_nbsHost/currencies/${code.toLowerCase()}/rates/${_ymd(date)}'));
    if (body is! Map) throw const RateFetchException('unexpected NBS payload');
    final middle = _pos(body['exchange_middle']);
    final parity = (body['parity'] is num && (body['parity'] as num) > 0) ? (body['parity'] as num).toDouble() : 1.0;
    final d = body['date'] is String ? DateTime.tryParse(body['date'] as String) : null;
    if (middle == null || d == null) throw const RateFetchException('no NBS rate for that date');
    return RatePoint(DateTime(d.year, d.month, d.day), middle / parity);
  }

  @override
  Future<List<RatePoint>> history(RateSource source, String code, DateTime from, DateTime to) async {
    if (source == RateSource.nbs) {
      final days = DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays + 1;
      final count = days.clamp(1, 400);
      final body = await _getJson(
        Uri.parse('$_nbsHost/currencies/${code.toLowerCase()}/rates/${_ymd(from)}/count/$count'),
      );
      final list = body is List ? body : (body is Map && body['rates'] is List ? body['rates'] as List : null);
      if (list == null) throw const RateFetchException('unexpected NBS history payload');
      final points = <RatePoint>[];
      for (final r in list) {
        if (r is! Map) continue;
        final middle = _pos(r['exchange_middle']);
        final parity = (r['parity'] is num && (r['parity'] as num) > 0) ? (r['parity'] as num).toDouble() : 1.0;
        final d = r['date'] is String ? DateTime.tryParse(r['date'] as String) : null;
        if (middle != null && d != null && !d.isAfter(to)) points.add(RatePoint(DateTime(d.year, d.month, d.day), middle / parity));
      }
      points.sort((a, b) => a.date.compareTo(b.date));
      return _dedupe(points);
    }
    final body = await _getJson(Uri.parse('$_ecbHost/${_ymd(from)}..${_ymd(to)}?base=EUR&symbols=$code'));
    if (body is! Map || body['rates'] is! Map) throw const RateFetchException('unexpected ECB history payload');
    final points = <RatePoint>[];
    (body['rates'] as Map).forEach((k, v) {
      final d = k is String ? DateTime.tryParse(k) : null;
      final value = v is Map ? _pos(v[code]) : null;
      // Express as the value of one unit of [code] in EUR, like NBS values in RSD.
      if (d != null && value != null) points.add(RatePoint(DateTime(d.year, d.month, d.day), 1 / value));
    });
    points.sort((a, b) => a.date.compareTo(b.date));
    return _dedupe(points);
  }

  static List<RatePoint> _dedupe(List<RatePoint> sorted) {
    final out = <RatePoint>[];
    for (final p in sorted) {
      if (out.isEmpty || out.last.date != p.date) out.add(p);
    }
    return out;
  }
}

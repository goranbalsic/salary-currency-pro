import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/rate_snapshot.dart';

/// A source of exchange rate data. Each implementation talks to exactly one
/// real API and must never return a fabricated rate — on any failure it
/// throws, and the caller falls back to cache.
abstract class RateProviderApi {
  /// Short stable identifier used as part of the cache key (not shown to users).
  String get id;

  Future<RateSnapshot> fetchLatest(String base);
}

const _timeout = Duration(seconds: 10);

/// General currency pairs via the Frankfurter API (ECB reference rates).
/// Does not cover RSD — see [OpenErApiRateProvider] for that.
class FrankfurterRateProvider implements RateProviderApi {
  @override
  String get id => 'frankfurter';

  static const _sourceLabel = 'Frankfurter (ECB reference rates)';

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    final uri = Uri.parse('https://api.frankfurter.app/latest?from=$base');
    http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } on SocketException {
      throw const RateUnavailableException('No internet connection.');
    } on HttpException {
      throw const RateUnavailableException('Frankfurter API is unreachable.');
    } catch (e) {
      throw RateUnavailableException('Failed to reach Frankfurter API: $e');
    }

    if (response.statusCode != 200) {
      throw RateUnavailableException(
        'Frankfurter API returned an error (HTTP ${response.statusCode}).',
      );
    }

    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw const RateUnavailableException(
        'Frankfurter API returned an unreadable response.',
      );
    }

    final ratesJson = body['rates'] as Map<String, dynamic>?;
    final dateStr = body['date'] as String?;
    if (ratesJson == null || ratesJson.isEmpty || dateStr == null) {
      throw const RateUnavailableException(
        'Frankfurter API response was missing rate data.',
      );
    }

    final now = DateTime.now();
    return RateSnapshot(
      base: base,
      rates: ratesJson.map((k, v) => MapEntry(k, (v as num).toDouble())),
      asOf: DateTime.tryParse(dateStr) ?? now,
      fetchedAt: now,
      source: _sourceLabel,
    );
  }
}

/// RSD-involving pairs via open.er-api.com (ExchangeRate-API's free, keyless
/// endpoint). Updates roughly once every 24 hours. This is NOT the National
/// Bank of Serbia's own feed — NBS's official webservice requires a mailed
/// paper application and postal credential delivery with no public keyless
/// tier, so this app uses this provider and discloses it honestly rather
/// than mislabeling the source or fabricating a rate.
class OpenErApiRateProvider implements RateProviderApi {
  @override
  String get id => 'open_er_api';

  static const _sourceLabel = 'ExchangeRate-API (open.er-api.com)';

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    final uri = Uri.parse('https://open.er-api.com/v6/latest/$base');
    http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } on SocketException {
      throw const RateUnavailableException('No internet connection.');
    } on HttpException {
      throw const RateUnavailableException(
        'ExchangeRate-API is unreachable.',
      );
    } catch (e) {
      throw RateUnavailableException('Failed to reach ExchangeRate-API: $e');
    }

    if (response.statusCode != 200) {
      throw RateUnavailableException(
        'ExchangeRate-API returned an error (HTTP ${response.statusCode}).',
      );
    }

    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw const RateUnavailableException(
        'ExchangeRate-API returned an unreadable response.',
      );
    }

    if (body['result'] != 'success') {
      throw const RateUnavailableException(
        'ExchangeRate-API reported an error for this request.',
      );
    }

    final ratesJson = body['rates'] as Map<String, dynamic>?;
    final updatedStr = body['time_last_update_utc'] as String?;
    if (ratesJson == null || ratesJson.isEmpty) {
      throw const RateUnavailableException(
        'ExchangeRate-API response was missing rate data.',
      );
    }

    final now = DateTime.now();
    DateTime asOf = now;
    if (updatedStr != null) {
      try {
        asOf = HttpDate.parse(updatedStr);
      } catch (_) {
        asOf = now;
      }
    }

    return RateSnapshot(
      base: base,
      rates: ratesJson.map((k, v) => MapEntry(k, (v as num).toDouble())),
      asOf: asOf,
      fetchedAt: now,
      source: _sourceLabel,
    );
  }
}

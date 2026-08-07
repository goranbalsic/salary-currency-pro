import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/finance_quote.dart';

/// Loads the bundled finance-quotes pack. Entirely offline: no network
/// call, no API key, so it works even with no connectivity at all.
class QuoteService {
  static const _assetPath = 'assets/config/finance_quotes.json';

  Future<List<FinanceQuote>> loadAll() async {
    // cache: false avoids a stale-Future hang across repeated widget-test
    // runs in one process — see the same fix in TaxConfigService.
    final raw = await rootBundle.loadString(_assetPath, cache: false);
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((q) => FinanceQuote.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  /// The same quote for everyone on a given calendar day, rotating through
  /// the pack by day-of-year — deterministic, no backend required.
  FinanceQuote quoteOfTheDay(List<FinanceQuote> quotes, {DateTime? now}) {
    if (quotes.isEmpty) {
      throw StateError('Quote pack is empty.');
    }
    final today = now ?? DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
}

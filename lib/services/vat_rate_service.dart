import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Loads each country's standard VAT rate (percent, e.g. 20.0 for 20%) from
/// assets/config/vat_rates.json — a single sourced, dated fact per country,
/// kept out of code for the same reason the payroll tax configs are.
class VatRateService {
  static const _assetPath = 'assets/config/vat_rates.json';

  /// Set as a side effect of [loadRates] — the same asset's `lastUpdated`
  /// field, so callers that already await [loadRates] don't need a second
  /// asset read just to disclose freshness.
  DateTime? lastUpdated;

  Future<Map<String, double>> loadRates() async {
    final raw = await rootBundle.loadString(_assetPath, cache: false);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final rates = decoded['rates'] as Map<String, dynamic>;
    lastUpdated = DateTime.parse(decoded['lastUpdated'] as String);
    return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }
}

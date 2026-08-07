import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/tax_config.dart';

/// Loads a country's tax parameters from its bundled JSON config asset.
/// Kept separate from [SalaryCalculator] so tax law changes only require
/// editing the relevant assets/config/tax/<id>.json file (or swapping this
/// loader for a remote fetch later) — never the calculation logic itself.
class TaxConfigService {
  Future<CountryTaxConfig> load(String countryId, String assetPath) async {
    String raw;
    try {
      // cache: false — repeatedly loading the same asset path across many
      // widget tests in one process can hang on a stale cached Future tied
      // to a prior test's now-torn-down binary messenger; a fresh read
      // every time avoids that without materially costing anything (these
      // are small JSON files).
      raw = await rootBundle.loadString(assetPath, cache: false);
    } catch (e) {
      throw TaxConfigUnavailableException(
        'Could not load tax configuration for "$countryId".',
      );
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CountryTaxConfig.fromJson(countryId, json);
    } catch (e) {
      throw TaxConfigUnavailableException(
        'Tax configuration for "$countryId" is malformed.',
      );
    }
  }
}

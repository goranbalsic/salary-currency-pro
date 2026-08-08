import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/freelance_tax_rules.dart';

/// Where the remote-updatable copy of [FreelanceTaxRules] is hosted — free
/// static hosting only (GitHub Pages / raw.githubusercontent.com), no
/// backend, no API key, per PROMPT-004's hard constraints.
///
/// A separate, small, PUBLIC repo — distinct from this app's own private
/// repo, since this file must be fetchable by anonymous clients. To
/// publish a rate change: edit `tools/rules-publish/tax_rules.json` in
/// the app repo (see that directory's own README for the full runbook),
/// validate it, then copy it over `tax_rules.json` in
/// https://github.com/goranbalsic/salary-currency-pro-rules and push.
/// Live-verified 2026-08-08 (`OPEN_QUESTIONS.md` QUESTION-005, resolved):
/// this URL resolves and serves valid, schema-correct JSON.
const String kFreelanceTaxRulesRemoteUrl =
    'https://raw.githubusercontent.com/goranbalsic/salary-currency-pro-rules/main/tax_rules.json';

const String _assetPath = 'assets/config/tax_rules.json';
const Duration _fetchTimeout = Duration(seconds: 5);
const Duration _minFetchInterval = Duration(hours: 24);

const String _prefsDownloadedRulesKey = 'freelance_tax_rules_downloaded_json';
const String _prefsLastFetchAttemptKey = 'freelance_tax_rules_last_fetch_attempt_ms';

enum FreelanceTaxRulesSource { bundle, updated }

class LoadedFreelanceTaxRules {
  final FreelanceTaxRules rules;
  final FreelanceTaxRulesSource source;
  const LoadedFreelanceTaxRules({required this.rules, required this.source});
}

/// Loads [FreelanceTaxRules] bundled-first, then opportunistically refreshes
/// from [kFreelanceTaxRulesRemoteUrl] at most once every 24h with a short
/// timeout — the same shape as the app's existing remote-with-fallback
/// patterns (`ExchangeRateService`/`RateCacheService` for currency,
/// `VatRateService` for VAT), applied to tax rules.
///
/// [load] never touches the network and always resolves immediately from
/// the bundled asset or a previously-validated downloaded copy. Call
/// [refreshInBackground] separately, fire-and-forget, to trigger the
/// opportunistic update check — never await it before showing UI.
class TaxRulesService {
  final http.Client _client;

  TaxRulesService({http.Client? client}) : _client = client ?? http.Client();

  Future<FreelanceTaxRules> _loadBundled() async {
    final raw = await rootBundle.loadString(_assetPath, cache: false);
    return FreelanceTaxRules.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  bool _isNewer(String candidateIsoDate, String currentIsoDate) {
    final candidate = DateTime.tryParse(candidateIsoDate);
    final current = DateTime.tryParse(currentIsoDate);
    if (candidate == null) return false;
    if (current == null) return true;
    return candidate.isAfter(current);
  }

  /// Bundled copy, unless a previously-downloaded copy exists, still parses,
  /// and is genuinely newer — precedence is always downloaded → bundled,
  /// never the reverse, and never a partial merge of the two.
  Future<LoadedFreelanceTaxRules> load() async {
    final bundled = await _loadBundled();

    final prefs = await SharedPreferences.getInstance();
    final downloadedRaw = prefs.getString(_prefsDownloadedRulesKey);
    if (downloadedRaw != null) {
      final downloaded = FreelanceTaxRules.tryParse(downloadedRaw);
      if (downloaded != null &&
          _isNewer(downloaded.rulesVersion, bundled.rulesVersion)) {
        return LoadedFreelanceTaxRules(
          rules: downloaded,
          source: FreelanceTaxRulesSource.updated,
        );
      }
    }
    return LoadedFreelanceTaxRules(
      rules: bundled,
      source: FreelanceTaxRulesSource.bundle,
    );
  }

  /// Fire-and-forget: respects the 24h cadence, attempts a short-timeout
  /// fetch, and persists the payload only if it validates against the
  /// schema and is genuinely newer than whatever is currently in effect.
  /// Every failure mode — offline, DNS failure, timeout, non-200, malformed
  /// JSON, a schema violation anywhere in the payload, or simply "not
  /// newer" — is swallowed silently; the previous good copy is always left
  /// in place and the caller is never told anything went wrong.
  Future<void> refreshInBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastAttemptMs = prefs.getInt(_prefsLastFetchAttemptKey);
      final now = DateTime.now();
      if (lastAttemptMs != null) {
        final last = DateTime.fromMillisecondsSinceEpoch(lastAttemptMs);
        if (now.difference(last) < _minFetchInterval) return;
      }
      await prefs.setInt(_prefsLastFetchAttemptKey, now.millisecondsSinceEpoch);

      final response = await _client
          .get(Uri.parse(kFreelanceTaxRulesRemoteUrl))
          .timeout(_fetchTimeout);
      if (response.statusCode != 200) return;

      final fetched = FreelanceTaxRules.tryParse(response.body);
      if (fetched == null) return;

      final current = await load();
      if (!_isNewer(fetched.rulesVersion, current.rules.rulesVersion)) return;

      await prefs.setString(_prefsDownloadedRulesKey, response.body);
    } catch (_) {
      // Deliberately silent — see doc comment above.
    }
  }
}

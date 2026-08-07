import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_entry.dart';
import '../models/scenario.dart';
import 'scenario_service.dart';

/// One-time, idempotent redenomination of any Bulgaria-tied [Scenario] data
/// saved before Bulgaria's `Country.currencyCode` changed from BGN to EUR
/// (euro adopted 1 Jan 2026 — see `lib/models/country.dart` and
/// `DECISIONS.md` D-020). [HistoryEntry] never stores raw amounts (summaries
/// only), so it needs no migration; a [Scenario]'s `summary` is a
/// deliberately frozen historical receipt (see `scenario.dart`'s own doc
/// comment) and is left untouched — only the `inputs` a reopened scenario
/// recalculates from are corrected, so reopening an old BGN-era scenario
/// and hitting Calculate again produces a correct EUR result instead of a
/// ~95% inflated one.
class BgEuroMigrationService {
  static const _prefsFlagKey = 'bg_bgn_to_eur_migration_v1_done';

  /// Bulgaria's fixed, irrevocable euro-adoption peg (1 Jan 2026) — never a
  /// live FX rate. This is a redenomination of the same money, not a
  /// currency conversion, so the exact statutory constant is used.
  static const double bgnPerEur = 1.95583;

  static const _amountFieldByToolId = {
    HistoryToolIds.salary: 'amountText',
    HistoryToolIds.vat: 'amount',
  };

  final ScenarioService _scenarioService;

  BgEuroMigrationService({ScenarioService? scenarioService})
      : _scenarioService = scenarioService ?? ScenarioService();

  Scenario? _migrateOne(Scenario s) {
    if (s.currencyCode != 'BGN') return null;
    final field = _amountFieldByToolId[s.toolId];
    if (field == null) return null;

    final raw = s.inputs[field];
    if (raw is! String) return null;
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null) return null;

    final convertedInputs = Map<String, dynamic>.from(s.inputs);
    convertedInputs[field] = (parsed / bgnPerEur).toString();

    return Scenario(
      id: s.id,
      schemaVersion: s.schemaVersion,
      toolId: s.toolId,
      name: s.name,
      createdAt: s.createdAt,
      countryId: s.countryId,
      currencyCode: 'EUR',
      summary: s.summary,
      inputs: convertedInputs,
    );
  }

  /// Safe to call on every app start — checks a persisted flag first and
  /// returns immediately once migration has happened, so a re-run, a crash
  /// mid-migration, or a reinstall restoring a backup can never convert the
  /// same scenario twice (which would silently halve its real value again).
  Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsFlagKey) == true) return;

    try {
      final all = await _scenarioService.loadAll();
      var changed = false;
      final migrated = <Scenario>[];
      for (final s in all) {
        final result = _migrateOne(s);
        if (result != null) changed = true;
        migrated.add(result ?? s);
      }

      if (changed) {
        await _scenarioService.replaceAll(migrated);
      }
    } finally {
      // Set the flag even if there was nothing to migrate (or loadAll
      // failed and degraded to an empty list) — either way, this is done.
      await prefs.setBool(_prefsFlagKey, true);
    }
  }
}

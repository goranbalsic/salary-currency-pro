import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_entry.dart';
import '../models/scenario.dart';
import 'scenario_service.dart';

/// One-time, idempotent migration of saved scenarios from the retired
/// Serbia-only "Freelancer Tax" tool (`toolId: 'samo'`) to the unified
/// "Freelancer Self-Assessment" engine's Serbia regime — see
/// `DECISIONS.md` D-022 (PROMPT-005 Part 4: two overlapping Serbia tools
/// consolidated into one). The old tool's income-tax-only formula is a
/// strict subset of the new Serbia regime's (which adds the social
/// contributions the old tool's own disclaimer said were missing), so
/// every old scenario has a faithful equivalent in the new engine's input
/// shape — this only translates field names/values, it never changes
/// what a reopened scenario's amount means.
class SamoToFreelanceTaxMigrationService {
  static const _prefsFlagKey = 'samo_to_freelance_tax_migration_v1_done';

  /// The old, now-removed screen's toolId — kept here as a literal
  /// (not a live `HistoryToolIds` constant) since it no longer has one.
  static const _oldToolId = 'samo';

  final ScenarioService _scenarioService;

  SamoToFreelanceTaxMigrationService({ScenarioService? scenarioService})
      : _scenarioService = scenarioService ?? ScenarioService();

  Scenario? _migrateOne(Scenario s) {
    if (s.toolId != _oldToolId) return null;

    final gross = s.inputs['gross'];
    final oldModel = s.inputs['model'];
    final serbiaModel = oldModel == 'fixedExpense' ? 'model1' : 'model2';

    return Scenario(
      id: s.id,
      schemaVersion: s.schemaVersion,
      toolId: HistoryToolIds.freelanceTax,
      name: s.name,
      createdAt: s.createdAt,
      countryId: s.countryId ?? 'rs',
      currencyCode: s.currencyCode ?? 'RSD',
      summary: s.summary,
      inputs: {
        'regimeId': 'rs',
        'income': gross,
        'serbiaModel': serbiaModel,
      },
    );
  }

  /// Safe to call on every app start — see BgEuroMigrationService's doc
  /// comment for the same idempotency contract (persisted flag checked
  /// first, set in a `finally` block regardless of outcome).
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
      await prefs.setBool(_prefsFlagKey, true);
    }
  }
}

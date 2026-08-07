import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/history_entry.dart';
import 'package:salary_currency_pro/services/samo_to_freelance_tax_migration_service.dart';
import 'package:salary_currency_pro/services/scenario_service.dart';

/// PROMPT-005 Part 4: consolidating the old Serbia-only "Freelancer Tax"
/// tool into the new unified engine must not orphan anyone's saved
/// scenarios — this is the same idempotency contract as
/// BgEuroMigrationService, applied to a toolId/input-shape translation
/// instead of a currency redenomination.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> addOldScenario(
    ScenarioService service, {
    required String gross,
    required String model,
  }) {
    return service.add(
      toolId: 'samo',
      name: 'Old samooporezivanje scenario',
      summary: 'frozen historical receipt',
      inputs: {'gross': gross, 'model': model},
      countryId: 'rs',
      isPro: true,
    );
  }

  test('translates a fixedExpense scenario into the new engine\'s model1 shape', () async {
    final scenarioService = ScenarioService();
    await addOldScenario(scenarioService, gross: '300000', model: 'fixedExpense');

    await SamoToFreelanceTaxMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all, hasLength(1));
    expect(all.first.toolId, HistoryToolIds.freelanceTax);
    expect(all.first.inputs['regimeId'], 'rs');
    expect(all.first.inputs['income'], '300000');
    expect(all.first.inputs['serbiaModel'], 'model1');
    expect(all.first.currencyCode, 'RSD');
    expect(all.first.countryId, 'rs');
  });

  test('translates a mixedExpense scenario into model2', () async {
    final scenarioService = ScenarioService();
    await addOldScenario(scenarioService, gross: '150000', model: 'mixedExpense');

    await SamoToFreelanceTaxMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.inputs['serbiaModel'], 'model2');
  });

  test('running the migration twice does not double-translate or duplicate', () async {
    final scenarioService = ScenarioService();
    await addOldScenario(scenarioService, gross: '300000', model: 'fixedExpense');

    final migration = SamoToFreelanceTaxMigrationService(scenarioService: scenarioService);
    await migration.migrateIfNeeded();
    await migration.migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all, hasLength(1));
    expect(all.first.toolId, HistoryToolIds.freelanceTax);
    expect(all.first.inputs['income'], '300000');
  });

  test('the frozen historical summary text is never rewritten, by design', () async {
    final scenarioService = ScenarioService();
    await addOldScenario(scenarioService, gross: '300000', model: 'fixedExpense');

    await SamoToFreelanceTaxMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.summary, 'frozen historical receipt');
  });

  test('a scenario from any other tool is left completely untouched', () async {
    final scenarioService = ScenarioService();
    await scenarioService.add(
      toolId: HistoryToolIds.loan,
      name: 'Loan scenario',
      summary: 'frozen historical receipt',
      inputs: {'principal': '10000'},
      isPro: true,
    );

    await SamoToFreelanceTaxMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.toolId, HistoryToolIds.loan);
    expect(all.first.inputs, {'principal': '10000'});
  });

  test('with no scenarios at all, migrateIfNeeded completes without error', () async {
    final scenarioService = ScenarioService();
    final migration = SamoToFreelanceTaxMigrationService(scenarioService: scenarioService);
    await migration.migrateIfNeeded();
    await migration.migrateIfNeeded();
    expect(await scenarioService.loadAll(), isEmpty);
  });
}

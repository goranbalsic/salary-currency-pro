import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/history_entry.dart';
import 'package:salary_currency_pro/models/scenario.dart';
import 'package:salary_currency_pro/services/bg_euro_migration_service.dart';
import 'package:salary_currency_pro/services/scenario_service.dart';

/// PROMPT-005 Part 3: the migration must redenominate any BGN-era saved
/// scenario exactly once — never twice (which would silently halve a
/// user's real financial history) — and must leave everything else alone.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<Scenario> addBgScenario(
    ScenarioService service, {
    required String toolId,
    required String amountField,
    required String amount,
  }) {
    return service.add(
      toolId: toolId,
      name: 'Old BGN scenario',
      summary: 'frozen historical receipt',
      inputs: {'countryId': 'bg', amountField: amount},
      countryId: 'bg',
      currencyCode: 'BGN',
      isPro: true,
    );
  }

  test('divides a BGN salary scenario amount by the fixed peg exactly once', () async {
    final scenarioService = ScenarioService();
    await addBgScenario(
      scenarioService,
      toolId: HistoryToolIds.salary,
      amountField: 'amountText',
      amount: '1955.83',
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all, hasLength(1));
    expect(all.first.currencyCode, 'EUR');
    expect(double.parse(all.first.inputs['amountText'] as String), closeTo(1000.0, 0.001));
  });

  test('divides a BGN VAT scenario amount by the fixed peg', () async {
    final scenarioService = ScenarioService();
    await addBgScenario(
      scenarioService,
      toolId: HistoryToolIds.vat,
      amountField: 'amount',
      amount: '195.583',
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(double.parse(all.first.inputs['amount'] as String), closeTo(100.0, 0.001));
    expect(all.first.currencyCode, 'EUR');
  });

  test('running the migration twice is a no-op the second time (idempotent)', () async {
    final scenarioService = ScenarioService();
    await addBgScenario(
      scenarioService,
      toolId: HistoryToolIds.salary,
      amountField: 'amountText',
      amount: '1955.83',
    );

    final migration = BgEuroMigrationService(scenarioService: scenarioService);
    await migration.migrateIfNeeded();
    final afterFirst = (await scenarioService.loadAll()).first.inputs['amountText'];

    // A second call (simulating a re-run, a crash-then-restart, or a
    // reinstall restoring a backup) must NOT divide by the peg again.
    await migration.migrateIfNeeded();
    final afterSecond = (await scenarioService.loadAll()).first.inputs['amountText'];

    expect(afterSecond, afterFirst);
    expect(double.parse(afterSecond as String), closeTo(1000.0, 0.001));
  });

  test('a fresh BgEuroMigrationService instance also respects the persisted flag', () async {
    // Simulates a real app restart: a new service instance, but the same
    // underlying SharedPreferences store.
    final scenarioService = ScenarioService();
    await addBgScenario(
      scenarioService,
      toolId: HistoryToolIds.salary,
      amountField: 'amountText',
      amount: '1955.83',
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();
    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final amount = double.parse(
      (await scenarioService.loadAll()).first.inputs['amountText'] as String,
    );
    expect(amount, closeTo(1000.0, 0.001));
  });

  test('non-Bulgaria scenarios (currencyCode != BGN) are left completely untouched', () async {
    final scenarioService = ScenarioService();
    await scenarioService.add(
      toolId: HistoryToolIds.salary,
      name: 'Serbia scenario',
      summary: 'frozen historical receipt',
      inputs: {'countryId': 'rs', 'amountText': '100000'},
      countryId: 'rs',
      currencyCode: 'RSD',
      isPro: true,
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.currencyCode, 'RSD');
    expect(all.first.inputs['amountText'], '100000');
  });

  test('a scenario already in EUR (never touched BGN) is left alone', () async {
    final scenarioService = ScenarioService();
    await scenarioService.add(
      toolId: HistoryToolIds.salary,
      name: 'Already-EUR Bulgaria scenario',
      summary: 'frozen historical receipt',
      inputs: {'countryId': 'bg', 'amountText': '1000'},
      countryId: 'bg',
      currencyCode: 'EUR',
      isPro: true,
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.inputs['amountText'], '1000');
  });

  test('the frozen historical summary text is never rewritten, by design', () async {
    final scenarioService = ScenarioService();
    await addBgScenario(
      scenarioService,
      toolId: HistoryToolIds.salary,
      amountField: 'amountText',
      amount: '1955.83',
    );

    await BgEuroMigrationService(scenarioService: scenarioService).migrateIfNeeded();

    final all = await scenarioService.loadAll();
    expect(all.first.summary, 'frozen historical receipt');
  });

  test('with no scenarios at all, migrateIfNeeded completes without error and sets the flag', () async {
    final scenarioService = ScenarioService();
    final migration = BgEuroMigrationService(scenarioService: scenarioService);
    await migration.migrateIfNeeded();
    await migration.migrateIfNeeded(); // still a no-op, still no error
    expect(await scenarioService.loadAll(), isEmpty);
  });
}

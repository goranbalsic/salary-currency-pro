import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/history_entry.dart';
import 'package:salary_currency_pro/services/scenario_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll on a fresh install returns an empty list, not null/crash',
      () async {
    final service = ScenarioService();
    expect(await service.loadAll(), isEmpty);
  });

  test('add() persists a scenario retrievable via loadAll', () async {
    final service = ScenarioService();
    await service.add(
      toolId: HistoryToolIds.salary,
      name: 'My Serbia salary',
      summary: 'Neto: 65,000 RSD',
      inputs: {'countryId': 'rs', 'amountText': '100000'},
      countryId: 'rs',
      isPro: false,
    );
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.toolId, HistoryToolIds.salary);
    expect(all.first.name, 'My Serbia salary');
    expect(all.first.summary, 'Neto: 65,000 RSD');
    expect(all.first.countryId, 'rs');
    expect(all.first.inputs['amountText'], '100000');
  });

  test('scenarios are returned newest-first', () async {
    final service = ScenarioService();
    await service.add(toolId: HistoryToolIds.loan, name: 'first', summary: 's', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.loan, name: 'second', summary: 's', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.loan, name: 'third', summary: 's', inputs: const {}, isPro: true);

    final all = await service.loadAll();
    expect(all.map((e) => e.name).toList(), ['third', 'second', 'first']);
  });

  test('unlike HistoryService, repeated saves with identical name/summary '
      'are never deduplicated — every save is intentional', () async {
    final service = ScenarioService();
    await service.add(toolId: HistoryToolIds.loan, name: 'dup', summary: 'same', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.loan, name: 'dup', summary: 'same', inputs: const {}, isPro: true);

    final all = await service.loadAll();
    expect(all, hasLength(2));
  });

  test('loadForTool filters to just that tool', () async {
    final service = ScenarioService();
    await service.add(toolId: HistoryToolIds.loan, name: 'a', summary: 's', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.salary, name: 'b', summary: 's', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.loan, name: 'c', summary: 's', inputs: const {}, isPro: true);

    final loanScenarios = await service.loadForTool(HistoryToolIds.loan);
    expect(loanScenarios.map((e) => e.name).toSet(), {'a', 'c'});
  });

  test('a free (non-Pro) account can save up to freeLimit scenarios, then '
      'the next add() throws ScenarioLimitReachedException', () async {
    final service = ScenarioService();
    for (var i = 0; i < ScenarioService.freeLimit; i++) {
      await service.add(
        toolId: HistoryToolIds.loan,
        name: 'scenario-$i',
        summary: 's',
        inputs: const {},
        isPro: false,
      );
    }
    expect(await service.loadAll(), hasLength(ScenarioService.freeLimit));

    expect(
      () => service.add(
        toolId: HistoryToolIds.loan,
        name: 'one-too-many',
        summary: 's',
        inputs: const {},
        isPro: false,
      ),
      throwsA(isA<ScenarioLimitReachedException>()),
    );
    // The rejected save must not have been persisted.
    expect(await service.loadAll(), hasLength(ScenarioService.freeLimit));
  });

  test('a Pro account is not capped by freeLimit', () async {
    final service = ScenarioService();
    for (var i = 0; i < ScenarioService.freeLimit + 5; i++) {
      await service.add(
        toolId: HistoryToolIds.loan,
        name: 'scenario-$i',
        summary: 's',
        inputs: const {},
        isPro: true,
      );
    }
    expect(await service.loadAll(), hasLength(ScenarioService.freeLimit + 5));
  });

  test('rename() updates the name in place without changing id/inputs',
      () async {
    final service = ScenarioService();
    final saved = await service.add(
      toolId: HistoryToolIds.savings,
      name: 'old name',
      summary: 's',
      inputs: {'years': '5'},
      isPro: true,
    );

    await service.rename(saved.id, 'new name');

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.id, saved.id);
    expect(all.first.name, 'new name');
    expect(all.first.inputs['years'], '5');
  });

  test('delete() removes only the targeted scenario', () async {
    final service = ScenarioService();
    final a = await service.add(toolId: HistoryToolIds.loan, name: 'a', summary: 's', inputs: const {}, isPro: true);
    await service.add(toolId: HistoryToolIds.loan, name: 'b', summary: 's', inputs: const {}, isPro: true);

    await service.delete(a.id);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.name, 'b');
  });

  test('clear() empties the list', () async {
    final service = ScenarioService();
    await service.add(toolId: HistoryToolIds.loan, name: 'a', summary: 's', inputs: const {}, isPro: true);
    expect(await service.loadAll(), isNotEmpty);

    await service.clear();
    expect(await service.loadAll(), isEmpty);
  });

  test('corrupt locally-stored JSON degrades to an empty list rather than '
      'throwing', () async {
    SharedPreferences.setMockInitialValues({
      'saved_scenarios_v1': 'not valid json {{{',
    });
    final service = ScenarioService();
    expect(await service.loadAll(), isEmpty);
  });
}

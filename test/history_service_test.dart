import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/history_entry.dart';
import 'package:salary_currency_pro/services/history_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll on a fresh install returns an empty list, not null/crash',
      () async {
    final service = HistoryService();
    expect(await service.loadAll(), isEmpty);
  });

  test('add() persists an entry retrievable via loadAll', () async {
    final service = HistoryService();
    await service.add(
      toolId: HistoryToolIds.salary,
      title: 'Salary',
      summary: 'Serbia · Gross → Net',
      countryId: 'rs',
    );
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.toolId, HistoryToolIds.salary);
    expect(all.first.summary, 'Serbia · Gross → Net');
    expect(all.first.countryId, 'rs');
  });

  test('entries are returned newest-first', () async {
    final service = HistoryService();
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'first');
    await service.add(toolId: HistoryToolIds.convert, title: 'Convert', summary: 'second');
    await service.add(toolId: HistoryToolIds.loan, title: 'Loan', summary: 'third');

    final all = await service.loadAll();
    expect(all.map((e) => e.summary).toList(), ['third', 'second', 'first']);
  });

  test('a repeated add() for the same tool + identical summary replaces the '
      'existing entry instead of appending a duplicate', () async {
    final service = HistoryService();
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'Serbia · Gross → Net');
    final firstId = (await service.loadAll()).first.id;

    // Simulate the user mashing Calculate again with unchanged inputs.
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'Serbia · Gross → Net');

    final all = await service.loadAll();
    expect(all, hasLength(1), reason: 'should not have appended a duplicate');
    expect(all.first.id, firstId, reason: 'should reuse the same entry id');
  });

  test('a different summary for the same tool does not get deduplicated',
      () async {
    final service = HistoryService();
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'Serbia · Gross → Net');
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'Croatia · Gross → Net');

    final all = await service.loadAll();
    expect(all, hasLength(2));
  });

  test('the log is capped at maxEntries, oldest evicted first', () async {
    final service = HistoryService();
    for (var i = 0; i < HistoryService.maxEntries + 10; i++) {
      await service.add(
        toolId: HistoryToolIds.convert,
        title: 'Convert',
        summary: 'entry-$i',
      );
    }
    final all = await service.loadAll();
    expect(all.length, HistoryService.maxEntries);
    // Newest entries survive; oldest ("entry-0"..) are evicted.
    expect(all.first.summary, 'entry-${HistoryService.maxEntries + 9}');
    expect(all.any((e) => e.summary == 'entry-0'), isFalse);
  });

  test('corrupt locally-stored JSON degrades to an empty list rather than '
      'throwing', () async {
    SharedPreferences.setMockInitialValues({
      'activity_history_v1': 'not valid json {{{',
    });
    final service = HistoryService();
    expect(await service.loadAll(), isEmpty);
  });

  test('latestForTool returns the most recent entry for that tool only',
      () async {
    final service = HistoryService();
    await service.add(toolId: HistoryToolIds.convert, title: 'Convert', summary: 'a');
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'Serbia · Gross → Net');
    await service.add(toolId: HistoryToolIds.convert, title: 'Convert', summary: 'b');

    final latestSalary = await service.latestForTool(HistoryToolIds.salary);
    expect(latestSalary?.summary, 'Serbia · Gross → Net');
  });

  test('latestForTool returns null when that tool has no history yet',
      () async {
    final service = HistoryService();
    expect(await service.latestForTool(HistoryToolIds.salary), isNull);
  });

  test('clear() empties the log and Home/Tools would see it immediately',
      () async {
    final service = HistoryService();
    await service.add(toolId: HistoryToolIds.salary, title: 'Salary', summary: 'x');
    expect(await service.loadAll(), isNotEmpty);

    await service.clear();
    expect(await service.loadAll(), isEmpty);
  });
}

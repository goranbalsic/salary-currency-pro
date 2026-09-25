import 'package:bilans/core/storage/store.dart';
import 'package:bilans/features/settings/data/backup.dart';
import 'package:bilans/features/settings/review_prompter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Store store;
  late DateTime now;
  late int requests;

  ReviewPrompter prompter({bool fails = false}) => ReviewPrompter(
    store,
    clock: () => now,
    request: () async {
      requests++;
      if (fails) throw StateError('Play unavailable');
    },
  );

  Future<void> openOnDays(ReviewPrompter p, int days) async {
    for (var i = 0; i < days; i++) {
      await p.recordOpen();
      now = now.add(const Duration(days: 1));
    }
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await Store.open();
    now = DateTime(2026, 9, 1, 10);
    requests = 0;
  });

  test('never asks a new user, however many successes', () async {
    final p = prompter();
    await p.recordOpen();
    for (var i = 0; i < 6; i++) {
      expect(await p.recordWin(), isFalse);
    }
    expect(requests, 0);
  });

  test('reopening on the same day counts once', () async {
    final p = prompter();
    await p.recordOpen();
    await p.recordOpen();
    now = now.add(const Duration(hours: 5));
    await p.recordOpen();
    expect(p.daysUsed, 1);
  });

  test('asks after a few days of use and a second success, then resets', () async {
    final p = prompter();
    await openOnDays(p, ReviewPrompter.minDays);
    expect(await p.recordWin(), isFalse, reason: 'one success is not enough');
    expect(await p.recordWin(), isTrue);
    expect(requests, 1);
    expect(p.wins, 0);
    expect(p.asks, 1);
  });

  test('waits out the cooldown and stops after the last ask', () async {
    final p = prompter();
    await openOnDays(p, ReviewPrompter.minDays);
    await p.recordWin();
    await p.recordWin();
    expect(requests, 1);

    // Within the cooldown: successes are counted, nobody is asked.
    now = now.add(const Duration(days: 30));
    expect(await p.recordWin(), isFalse);
    expect(await p.recordWin(), isFalse);
    expect(requests, 1);

    for (var ask = 2; ask <= ReviewPrompter.maxAsks; ask++) {
      now = now.add(ReviewPrompter.cooldown);
      await p.recordWin();
      await p.recordWin();
      expect(requests, ask);
    }
    now = now.add(ReviewPrompter.cooldown * 2);
    for (var i = 0; i < 5; i++) {
      await p.recordWin();
    }
    expect(requests, ReviewPrompter.maxAsks, reason: 'never more than maxAsks');
  });

  test('a failing Play request is swallowed and still counts', () async {
    final p = prompter(fails: true);
    await openOnDays(p, ReviewPrompter.minDays);
    await p.recordWin();
    expect(await p.recordWin(), isTrue);
    expect(p.asks, 1);
  });

  test('review state stays on the device, out of exported backups', () async {
    final p = prompter();
    await p.recordOpen();
    await store.writeJson('settings.v1', {'country': 'RS'});
    final exported = Backup.encode(store);
    expect(exported, isNot(contains(ReviewPrompter.storeKey)));
    expect(exported, contains('settings.v1'));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/expense_entry.dart';
import 'package:salary_currency_pro/services/expense_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll on a fresh install returns an empty list, not null/crash',
      () async {
    final service = ExpenseService();
    expect(await service.loadAll(), isEmpty);
  });

  test('add() persists a transaction retrievable via loadAll', () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 42.5,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 7),
      note: 'Market',
    );
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.type, TransactionType.expense);
    expect(all.first.categoryId, ExpenseCategories.groceries);
    expect(all.first.amount, 42.5);
    expect(all.first.currencyCode, 'EUR');
    expect(all.first.note, 'Market');
  });

  test('loadAll returns newest-first regardless of insertion order',
      () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 10,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 20,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 10),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 30,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 5),
    );

    final all = await service.loadAll();
    expect(all.map((e) => e.amount).toList(), [20, 30, 10]);
  });

  test('loadForMonth filters to only that calendar month', () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.salary,
      amount: 1000,
      currencyCode: 'EUR',
      date: DateTime(2026, 7, 28),
    );
    await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.salary,
      amount: 2000,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );

    final august = await service.loadForMonth(DateTime(2026, 8, 15));
    expect(august, hasLength(1));
    expect(august.first.amount, 2000);
  });

  test(
      'summaryForMonth sums income and expenses separately per currency and '
      'computes balance as income minus expense', () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.salary,
      amount: 1000,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 150,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 3),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.transport,
      amount: 50,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 4),
    );

    final summaries = await service.summaryForMonth(DateTime(2026, 8, 15));
    expect(summaries, hasLength(1));
    expect(summaries.first.currencyCode, 'EUR');
    expect(summaries.first.totalIncome, 1000);
    expect(summaries.first.totalExpense, 200);
    expect(summaries.first.balance, 800);
  });

  test('summaryForMonth keeps mixed currencies separate rather than mixing them',
      () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.freelance,
      amount: 500,
      currencyCode: 'USD',
      date: DateTime(2026, 8, 2),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 100,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 3),
    );

    final summaries = await service.summaryForMonth(DateTime(2026, 8, 20));
    expect(summaries, hasLength(2));
    final byCurrency = {for (final s in summaries) s.currencyCode: s};
    expect(byCurrency['USD']!.totalIncome, 500);
    expect(byCurrency['USD']!.totalExpense, 0);
    expect(byCurrency['EUR']!.totalIncome, 0);
    expect(byCurrency['EUR']!.totalExpense, 100);
  });

  test('update() replaces fields in place, keeping the same id', () async {
    final service = ExpenseService();
    final original = await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 10,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
      note: 'typo',
    );

    await service.update(
      id: original.id,
      type: TransactionType.expense,
      categoryId: ExpenseCategories.transport,
      amount: 25,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
      note: 'fixed',
    );

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.id, original.id);
    expect(all.first.categoryId, ExpenseCategories.transport);
    expect(all.first.amount, 25);
    expect(all.first.note, 'fixed');
  });

  test('update() is a no-op for an id that no longer exists', () async {
    final service = ExpenseService();
    await service.update(
      id: 'does-not-exist',
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 10,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    expect(await service.loadAll(), isEmpty);
  });

  test('restore() re-inserts a deleted entry with its original id', () async {
    final service = ExpenseService();
    final entry = await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.salary,
      amount: 1000,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.delete(entry.id);
    expect(await service.loadAll(), isEmpty);

    await service.restore(entry);
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.id, entry.id);
    expect(all.first.amount, 1000);
  });

  test('restore() is a no-op if an entry with that id already exists', () async {
    final service = ExpenseService();
    final entry = await service.add(
      type: TransactionType.income,
      categoryId: ExpenseCategories.salary,
      amount: 1000,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.restore(entry);
    expect(await service.loadAll(), hasLength(1));
  });

  test('delete() removes only the targeted transaction', () async {
    final service = ExpenseService();
    final a = await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 10,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.transport,
      amount: 20,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 2),
    );

    await service.delete(a.id);
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.amount, 20);
  });

  test('clear() empties the ledger', () async {
    final service = ExpenseService();
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.groceries,
      amount: 10,
      currencyCode: 'EUR',
      date: DateTime(2026, 8, 1),
    );
    await service.clear();
    expect(await service.loadAll(), isEmpty);
  });

  test('corrupt locally-stored JSON degrades to an empty list rather than throwing',
      () async {
    SharedPreferences.setMockInitialValues({
      'expense_transactions_v1': '{not valid json',
    });
    final service = ExpenseService();
    expect(await service.loadAll(), isEmpty);
    expect(await service.summaryForMonth(DateTime.now()), isEmpty);
  });
}

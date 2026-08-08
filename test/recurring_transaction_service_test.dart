import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/expense_entry.dart';
import 'package:salary_currency_pro/models/recurring_transaction.dart';
import 'package:salary_currency_pro/services/expense_service.dart';
import 'package:salary_currency_pro/services/recurring_transaction_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('add() persists a template retrievable via loadAll', () async {
    final service = RecurringTransactionService();
    await service.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 500,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 1),
      autoPost: true,
    );

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.amount, 500);
  });

  test('checkDue auto-posts a due autoPost template as a real ExpenseEntry', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 500,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: true,
      note: 'Rent',
    );

    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);

    final posted = await expenses.loadAll();
    expect(posted, hasLength(1));
    expect(posted.first.amount, 500);
    expect(posted.first.note, 'Rent');

    final templates = await recurring.loadAll();
    expect(templates.first.lastResolvedDate, DateTime(2026, 3, 1));
  });

  test('checkDue is idempotent — calling it again does not double-post', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 500,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: true,
    );

    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);
    await recurring.checkDue(asOf: DateTime(2026, 3, 15), expenseService: expenses);
    await recurring.checkDue(asOf: DateTime(2026, 3, 20), expenseService: expenses);

    expect(await expenses.loadAll(), hasLength(1));
  });

  test('checkDue queues a review item for a non-autoPost template instead of posting', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.entertainment,
      amount: 15,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: false,
      note: 'Streaming subscription',
    );

    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);

    expect(await expenses.loadAll(), isEmpty);
    final queue = await recurring.loadReviewQueue();
    expect(queue, hasLength(1));
    expect(queue.first.amount, 15);
    expect(queue.first.note, 'Streaming subscription');
  });

  test('checkDue does not duplicate a review item already queued for the same occurrence', () async {
    final recurring = RecurringTransactionService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.entertainment,
      amount: 15,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: false,
    );

    await recurring.checkDue(asOf: DateTime(2026, 3, 1));
    await recurring.checkDue(asOf: DateTime(2026, 3, 15));
    await recurring.checkDue(asOf: DateTime(2026, 3, 20));

    expect(await recurring.loadReviewQueue(), hasLength(1));
  });

  test('confirmReview posts the queued item and removes it from the queue', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.entertainment,
      amount: 15,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: false,
    );
    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);
    final item = (await recurring.loadReviewQueue()).first;

    await recurring.confirmReview(item.id, expenseService: expenses);

    expect(await recurring.loadReviewQueue(), isEmpty);
    expect(await expenses.loadAll(), hasLength(1));
    final templates = await recurring.loadAll();
    expect(templates.first.lastResolvedDate, DateTime(2026, 3, 1));
  });

  test('skipReview removes the item without posting, and does not re-queue it', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.entertainment,
      amount: 15,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: false,
    );
    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);
    final item = (await recurring.loadReviewQueue()).first;

    await recurring.skipReview(item.id);

    expect(await recurring.loadReviewQueue(), isEmpty);
    expect(await expenses.loadAll(), isEmpty);

    // Re-running checkDue for the same month must not re-queue it.
    await recurring.checkDue(asOf: DateTime(2026, 3, 20), expenseService: expenses);
    expect(await recurring.loadReviewQueue(), isEmpty);
  });

  test('setActive(false) pauses a template so checkDue skips it', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    final template = await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 500,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: true,
    );

    await recurring.setActive(template.id, false);
    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);

    expect(await expenses.loadAll(), isEmpty);
  });

  test('delete() removes both the template and any of its queued review items', () async {
    final recurring = RecurringTransactionService();
    final template = await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.entertainment,
      amount: 15,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: false,
    );
    await recurring.checkDue(asOf: DateTime(2026, 3, 1));
    expect(await recurring.loadReviewQueue(), hasLength(1));

    await recurring.delete(template.id);

    expect(await recurring.loadAll(), isEmpty);
    expect(await recurring.loadReviewQueue(), isEmpty);
  });

  test('update() changes a template\'s fields without resetting lastResolvedDate', () async {
    final recurring = RecurringTransactionService();
    final expenses = ExpenseService();
    final template = await recurring.add(
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 500,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: true,
    );
    await recurring.checkDue(asOf: DateTime(2026, 3, 1), expenseService: expenses);

    await recurring.update(
      template.id,
      type: TransactionType.expense,
      categoryId: ExpenseCategories.housing,
      amount: 550,
      currencyCode: 'EUR',
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 3, 1),
      autoPost: true,
    );

    final all = await recurring.loadAll();
    expect(all.first.amount, 550);
    expect(all.first.lastResolvedDate, DateTime(2026, 3, 1));
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/expense_entry.dart';
import 'package:salary_currency_pro/models/recurring_transaction.dart';

/// PROMPT-003 Stage B item 5: pure date-math tests for
/// [RecurringTransaction.dueOccurrenceAsOf] — no SharedPreferences
/// involved, this is the logic every other recurring-transaction test
/// ultimately depends on being right.
void main() {
  RecurringTransaction template({
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    bool active = true,
    DateTime? lastResolvedDate,
  }) =>
      RecurringTransaction(
        id: 't1',
        type: TransactionType.expense,
        categoryId: ExpenseCategories.housing,
        amount: 100,
        currencyCode: 'EUR',
        frequency: frequency,
        startDate: startDate,
        autoPost: true,
        active: active,
        createdAt: startDate,
        lastResolvedDate: lastResolvedDate,
      );

  test('not due before the start date', () {
    final t = template(frequency: RecurrenceFrequency.monthly, startDate: DateTime(2026, 3, 1));
    expect(t.dueOccurrenceAsOf(DateTime(2026, 2, 28)), isNull);
  });

  test('due exactly on the start date', () {
    final t = template(frequency: RecurrenceFrequency.monthly, startDate: DateTime(2026, 3, 1));
    expect(t.dueOccurrenceAsOf(DateTime(2026, 3, 1)), DateTime(2026, 3, 1));
  });

  test('monthly: next occurrence one month after the last resolved date', () {
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 15),
      lastResolvedDate: DateTime(2026, 1, 15),
    );
    expect(t.dueOccurrenceAsOf(DateTime(2026, 2, 15)), DateTime(2026, 2, 15));
    expect(t.dueOccurrenceAsOf(DateTime(2026, 2, 14)), isNull);
  });

  test('monthly: day-of-month overflow clamps to the last real day of a short month', () {
    // 31 Jan -> 28 Feb 2026 (2026 is not a leap year).
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 31),
      lastResolvedDate: DateTime(2026, 1, 31),
    );
    expect(t.dueOccurrenceAsOf(DateTime(2026, 2, 28)), DateTime(2026, 2, 28));
  });

  test('monthly: December rolls over to January of the next year', () {
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 12, 5),
      lastResolvedDate: DateTime(2026, 12, 5),
    );
    expect(t.dueOccurrenceAsOf(DateTime(2027, 1, 5)), DateTime(2027, 1, 5));
  });

  test('weekly: next occurrence exactly 7 days later', () {
    final t = template(
      frequency: RecurrenceFrequency.weekly,
      startDate: DateTime(2026, 3, 2),
      lastResolvedDate: DateTime(2026, 3, 2),
    );
    expect(t.dueOccurrenceAsOf(DateTime(2026, 3, 9)), DateTime(2026, 3, 9));
    expect(t.dueOccurrenceAsOf(DateTime(2026, 3, 8)), isNull);
  });

  test('only the single most recent missed occurrence is surfaced, not every one', () {
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 1),
      lastResolvedDate: DateTime(2026, 1, 1),
    );
    // App unopened from Feb through June — five months missed.
    expect(t.dueOccurrenceAsOf(DateTime(2026, 6, 15)), DateTime(2026, 6, 1));
  });

  test('an inactive (paused) template is never due', () {
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 1),
      active: false,
    );
    expect(t.dueOccurrenceAsOf(DateTime(2026, 12, 31)), isNull);
  });

  test('once resolved for a given date, it is not due again until the next occurrence', () {
    final t = template(
      frequency: RecurrenceFrequency.monthly,
      startDate: DateTime(2026, 1, 1),
      lastResolvedDate: DateTime(2026, 3, 1),
    );
    expect(t.dueOccurrenceAsOf(DateTime(2026, 3, 15)), isNull);
    expect(t.dueOccurrenceAsOf(DateTime(2026, 4, 1)), DateTime(2026, 4, 1));
  });

  group('nextOccurrenceOnOrAfter (for radar "Next: {date}" display)', () {
    test('before anything is due, returns the upcoming occurrence, not null', () {
      final t = template(frequency: RecurrenceFrequency.monthly, startDate: DateTime(2026, 5, 1));
      expect(t.nextOccurrenceOnOrAfter(DateTime(2026, 4, 1)), DateTime(2026, 5, 1));
    });

    test('when overdue, skips forward past every missed occurrence to the next real one', () {
      final t = template(
        frequency: RecurrenceFrequency.monthly,
        startDate: DateTime(2026, 1, 1),
        lastResolvedDate: DateTime(2026, 1, 1),
      );
      // Unresolved since January; "now" is June — next real occurrence is July.
      expect(t.nextOccurrenceOnOrAfter(DateTime(2026, 6, 15)), DateTime(2026, 7, 1));
    });

    test('returns today itself when today is exactly the occurrence date', () {
      final t = template(frequency: RecurrenceFrequency.weekly, startDate: DateTime(2026, 3, 2));
      expect(t.nextOccurrenceOnOrAfter(DateTime(2026, 3, 2)), DateTime(2026, 3, 2));
    });
  });
}

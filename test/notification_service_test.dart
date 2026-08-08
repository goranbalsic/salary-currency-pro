import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/services/notification_scheduler.dart';
import 'package:salary_currency_pro/services/notification_service.dart';

class _ScheduledCall {
  final String kind;
  final int id;
  final String title;
  final String body;
  final DateTime? dateTime;
  final int? day;

  const _ScheduledCall(this.kind, this.id, this.title, this.body, {this.dateTime, this.day});
}

/// Records every call instead of touching a real platform channel — same
/// fake-injection pattern this app already uses for RateProviderApi/
/// ScenarioService in other tests.
class _FakeScheduler implements NotificationScheduler {
  final List<_ScheduledCall> calls = [];
  final List<int> cancelled = [];
  bool permissionGranted = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
  }) async {
    calls.add(_ScheduledCall('daily', id, title, body));
  }

  @override
  Future<void> scheduleMonthlyOnDay({
    required int id,
    required String title,
    required String body,
    required int day,
  }) async {
    calls.add(_ScheduledCall('monthly', id, title, body, day: day));
  }

  @override
  Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    calls.add(_ScheduledCall('oneTime', id, title, body, dateTime: dateTime));
  }

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    calls.add(_ScheduledCall('showNow', id, title, body));
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }
}

/// Simulates the real platform plugin failing (e.g. no platform channel
/// registered, as in a plain `flutter test` run with no real device) —
/// every method throws.
class _ThrowingScheduler implements NotificationScheduler {
  @override
  Future<void> initialize() async => throw StateError('not available');

  @override
  Future<bool> requestPermission() async => throw StateError('not available');

  @override
  Future<void> scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
  }) async =>
      throw StateError('not available');

  @override
  Future<void> scheduleMonthlyOnDay({
    required int id,
    required String title,
    required String body,
    required int day,
  }) async =>
      throw StateError('not available');

  @override
  Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async =>
      throw StateError('not available');

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async =>
      throw StateError('not available');

  @override
  Future<void> cancel(int id) async => throw StateError('not available');
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('preferences — all off by default', () {
    test('every reminder type defaults to disabled', () async {
      final service = NotificationService(scheduler: _FakeScheduler());
      expect(await service.isExpenseNudgeEnabled(), isFalse);
      expect(await service.isBudgetThresholdEnabled(), isFalse);
      expect(await service.isInvoiceDueEnabled(), isFalse);
      expect(await service.isPausalReminderEnabled(), isFalse);
    });
  });

  group('expense nudge', () {
    test('enabling requests permission and schedules a daily repeat', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);

      await service.setExpenseNudgeEnabled(true, title: 'Log today\'s spending?', body: 'body');

      expect(await service.isExpenseNudgeEnabled(), isTrue);
      expect(scheduler.calls, hasLength(1));
      expect(scheduler.calls.first.kind, 'daily');
      expect(scheduler.calls.first.id, NotificationService.expenseNudgeId);
    });

    test('disabling cancels the scheduled reminder', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setExpenseNudgeEnabled(true, title: 't', body: 'b');

      await service.setExpenseNudgeEnabled(false, title: 't', body: 'b');

      expect(await service.isExpenseNudgeEnabled(), isFalse);
      expect(scheduler.cancelled, contains(NotificationService.expenseNudgeId));
    });
  });

  group('paušal reminder', () {
    test('enabling schedules a monthly reminder on the 15th', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);

      await service.setPausalReminderEnabled(true, title: 't', body: 'b');

      expect(scheduler.calls.first.kind, 'monthly');
      expect(scheduler.calls.first.day, NotificationService.pausalReminderDay);
      expect(scheduler.calls.first.id, NotificationService.pausalReminderId);
    });

    test('disabling cancels the main reminder', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setPausalReminderEnabled(true, title: 't', body: 'b');

      await service.setPausalReminderEnabled(false, title: 't', body: 'b');

      expect(await service.isPausalReminderEnabled(), isFalse);
      expect(scheduler.cancelled, contains(NotificationService.pausalReminderId));
    });

    test('lead reminder is off by default and adds a second schedule on the 12th when enabled', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      expect(await service.isPausalLeadReminderEnabled(), isFalse);

      await service.setPausalReminderEnabled(
        true,
        title: 't',
        body: 'b',
        leadReminderEnabled: true,
        leadTitle: 'lead t',
        leadBody: 'lead b',
      );

      expect(await service.isPausalLeadReminderEnabled(), isTrue);
      // Both the main (15th) and lead (12th) reminders are scheduled — the
      // lead reminder is additive, not a replacement.
      expect(scheduler.calls, hasLength(2));
      final leadCall = scheduler.calls.firstWhere((c) => c.id == NotificationService.pausalLeadReminderId);
      expect(leadCall.day, NotificationService.pausalLeadReminderDay);
      expect(leadCall.title, 'lead t');
    });

    test('turning the lead reminder off while the main one stays on cancels only the lead id', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setPausalReminderEnabled(
        true,
        title: 't',
        body: 'b',
        leadReminderEnabled: true,
        leadTitle: 'lead t',
        leadBody: 'lead b',
      );

      await service.setPausalReminderEnabled(true, title: 't', body: 'b', leadReminderEnabled: false);

      expect(await service.isPausalReminderEnabled(), isTrue);
      expect(await service.isPausalLeadReminderEnabled(), isFalse);
      expect(scheduler.cancelled, contains(NotificationService.pausalLeadReminderId));
      expect(scheduler.cancelled, isNot(contains(NotificationService.pausalReminderId)));
    });

    test('disabling the main reminder cancels the lead reminder too, regardless of its own preference', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setPausalReminderEnabled(
        true,
        title: 't',
        body: 'b',
        leadReminderEnabled: true,
        leadTitle: 'lead t',
        leadBody: 'lead b',
      );

      await service.setPausalReminderEnabled(false, title: 't', body: 'b');

      expect(scheduler.cancelled, contains(NotificationService.pausalReminderId));
      expect(scheduler.cancelled, contains(NotificationService.pausalLeadReminderId));
    });
  });

  group('budget threshold — event-triggered, deduplicated per month', () {
    test('does nothing when the preference is off, even if over the limit', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);

      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 150,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );

      expect(scheduler.calls, isEmpty);
    });

    test('fires once when crossing 80%, and does not re-fire on a later smaller crossing', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setBudgetThresholdEnabled(true);

      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 85,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );
      expect(scheduler.calls, hasLength(1));
      expect(scheduler.calls.first.title, 'title 80');

      // Still under 100% and already notified at 80% this month.
      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );
      expect(scheduler.calls, hasLength(1));
    });

    test('crossing straight to 100% fires only the 100% notification, not both', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setBudgetThresholdEnabled(true);

      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 120,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );

      expect(scheduler.calls, hasLength(1));
      expect(scheduler.calls.first.title, 'title 100');
    });

    test('a new calendar month resets the dedup flag and can notify again', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setBudgetThresholdEnabled(true);

      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );
      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 4),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );

      expect(scheduler.calls, hasLength(2));
    });

    test('different categories are tracked independently', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setBudgetThresholdEnabled(true);

      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );
      await service.checkBudgetThreshold(
        categoryId: 'transport',
        month: DateTime(2026, 3),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 'title $p',
        bodyBuilder: (p) => 'body $p',
      );

      expect(scheduler.calls, hasLength(2));
    });
  });

  group('invoice reminder', () {
    test('schedules 1 day before the due date at 09:00', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setInvoiceDueEnabled(true);

      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-1',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );

      expect(scheduler.calls, hasLength(1));
      expect(scheduler.calls.first.dateTime, DateTime(2026, 6, 14, 9, 0));
    });

    test('does nothing when the preference is off', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);

      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-1',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );

      expect(scheduler.calls, isEmpty);
    });

    test('cancelInvoiceReminder cancels the same id scheduleInvoiceReminder used', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setInvoiceDueEnabled(true);
      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-1',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );
      final scheduledId = scheduler.calls.first.id;

      await service.cancelInvoiceReminder('inv-1');

      expect(scheduler.cancelled, contains(scheduledId));
    });

    test('two different invoices get two different stable ids', () async {
      final scheduler = _FakeScheduler();
      final service = NotificationService(scheduler: scheduler);
      await service.setInvoiceDueEnabled(true);

      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-1',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );
      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-2',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );

      expect(scheduler.calls[0].id, isNot(scheduler.calls[1].id));
    });
  });

  group('best-effort: a failing scheduler never crashes a core feature', () {
    // Regression test: cancelInvoiceReminder originally called the
    // scheduler unconditionally with no error handling. In a real app
    // this is harmless (the platform plugin is always available), but it
    // surfaced as a real widget-test crash (LateInitializationError from
    // the platform interface) because no platform channel is registered
    // in a plain `flutter test` run -- and the same class of failure
    // could happen on a real device in a genuinely broken environment.
    // Deleting an invoice or toggling a notification preference must
    // never throw just because the underlying plugin failed.
    test('cancelInvoiceReminder swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.cancelInvoiceReminder('inv-1'); // must not throw
    });

    test('setExpenseNudgeEnabled(true) swallows a scheduler failure and still persists the preference', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setExpenseNudgeEnabled(true, title: 't', body: 'b');
      expect(await service.isExpenseNudgeEnabled(), isTrue);
    });

    test('setExpenseNudgeEnabled(false) swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setExpenseNudgeEnabled(false, title: 't', body: 'b');
    });

    test('setPausalReminderEnabled swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setPausalReminderEnabled(true, title: 't', body: 'b');
      expect(await service.isPausalReminderEnabled(), isTrue);
    });

    test('setBudgetThresholdEnabled swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setBudgetThresholdEnabled(true);
      expect(await service.isBudgetThresholdEnabled(), isTrue);
    });

    test('setInvoiceDueEnabled swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setInvoiceDueEnabled(true);
      expect(await service.isInvoiceDueEnabled(), isTrue);
    });

    test('checkBudgetThreshold swallows a scheduler failure but still sets the dedup flag', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setBudgetThresholdEnabled(true);
      await service.checkBudgetThreshold(
        categoryId: 'groceries',
        month: DateTime(2026, 3),
        spent: 90,
        limit: 100,
        titleBuilder: (p) => 't $p',
        bodyBuilder: (p) => 'b $p',
      );
    });

    test('scheduleInvoiceReminder swallows a scheduler failure', () async {
      final service = NotificationService(scheduler: _ThrowingScheduler());
      await service.setInvoiceDueEnabled(true);
      await service.scheduleInvoiceReminder(
        invoiceId: 'inv-1',
        dueDate: DateTime(2026, 6, 15),
        title: 't',
        body: 'b',
      );
    });
  });
}

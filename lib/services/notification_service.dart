import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_scheduler.dart';

/// Local-only notification preferences and scheduling logic — PROMPT-003
/// Stage B item 7. All four reminder types are OFF by default and stay
/// off until the user explicitly enables each one in Settings; enabling
/// any of them requests OS permission at that point, never proactively at
/// app start. Every reminder's actual text is supplied by the caller
/// (which has `AppLocalizations` access) — this service never hardcodes
/// user-facing strings.
///
/// Every actual scheduler call is wrapped in [_safely] — a failure to
/// schedule/cancel/show a notification (e.g. the platform plugin isn't
/// available, as in a plain `flutter test` run with no real platform
/// channel) must never crash a core feature like deleting an invoice or
/// adding an expense. This mirrors this app's existing "best-effort,
/// never let a side feature break the primary one" pattern (see
/// `ExpenseService`'s own best-effort persistence).
class NotificationService {
  static const _prefsExpenseNudgeKey = 'notif_expense_nudge_enabled';
  static const _prefsBudgetThresholdKey = 'notif_budget_threshold_enabled';
  static const _prefsInvoiceDueKey = 'notif_invoice_due_enabled';
  static const _prefsPausalReminderKey = 'notif_pausal_reminder_enabled';
  static const _notifiedThresholdPrefix = 'notif_budget_threshold_notified_';

  static const expenseNudgeId = 1001;
  static const pausalReminderId = 1002;
  static const pausalReminderDay = 15;

  /// Bumped on every preference change so Settings can refresh live.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  final NotificationScheduler _scheduler;

  NotificationService({NotificationScheduler? scheduler})
      : _scheduler = scheduler ?? FlutterLocalNotificationScheduler();

  Future<bool> isExpenseNudgeEnabled() => _getBool(_prefsExpenseNudgeKey);
  Future<bool> isBudgetThresholdEnabled() => _getBool(_prefsBudgetThresholdKey);
  Future<bool> isInvoiceDueEnabled() => _getBool(_prefsInvoiceDueKey);
  Future<bool> isPausalReminderEnabled() => _getBool(_prefsPausalReminderKey);

  Future<void> setExpenseNudgeEnabled(
    bool enabled, {
    required String title,
    required String body,
  }) async {
    await _setBool(_prefsExpenseNudgeKey, enabled);
    if (enabled) {
      await _safely(() => _scheduler.requestPermission());
      await _safely(
        () => _scheduler.scheduleDailyRepeating(id: expenseNudgeId, title: title, body: body),
      );
    } else {
      await _safely(() => _scheduler.cancel(expenseNudgeId));
    }
    changes.value++;
  }

  Future<void> setPausalReminderEnabled(
    bool enabled, {
    required String title,
    required String body,
  }) async {
    await _setBool(_prefsPausalReminderKey, enabled);
    if (enabled) {
      await _safely(() => _scheduler.requestPermission());
      await _safely(() => _scheduler.scheduleMonthlyOnDay(
            id: pausalReminderId,
            title: title,
            body: body,
            day: pausalReminderDay,
          ));
    } else {
      await _safely(() => _scheduler.cancel(pausalReminderId));
    }
    changes.value++;
  }

  /// Budget-threshold alerts are event-triggered (see [checkBudgetThreshold])
  /// rather than scheduled ahead, so enabling just requests permission;
  /// disabling has nothing to cancel.
  Future<void> setBudgetThresholdEnabled(bool enabled) async {
    await _setBool(_prefsBudgetThresholdKey, enabled);
    if (enabled) await _safely(() => _scheduler.requestPermission());
    changes.value++;
  }

  /// Invoice reminders are per-invoice (see [scheduleInvoiceReminder],
  /// called from the Invoices screen on add/edit) rather than scheduled
  /// here for every existing invoice retroactively.
  Future<void> setInvoiceDueEnabled(bool enabled) async {
    await _setBool(_prefsInvoiceDueKey, enabled);
    if (enabled) await _safely(() => _scheduler.requestPermission());
    changes.value++;
  }

  /// Call after an expense is added/edited for [categoryId]. Notifies at
  /// most once per (category, calendar month, threshold) — a persisted
  /// flag prevents re-notifying on every subsequent expense in the same
  /// category once a threshold has already fired that month, and the
  /// flag's month component means it naturally resets itself next month
  /// without any cleanup code. If both 80% and 100% are newly crossed in
  /// the same call, only the higher one fires.
  Future<void> checkBudgetThreshold({
    required String categoryId,
    required DateTime month,
    required double spent,
    required double limit,
    required String Function(int percent) titleBuilder,
    required String Function(int percent) bodyBuilder,
  }) async {
    if (!await isBudgetThresholdEnabled()) return;
    if (limit <= 0) return;
    final fraction = spent / limit;
    final monthKey = '${month.year}-${month.month}';

    for (final threshold in [100, 80]) {
      if (fraction * 100 < threshold) continue;
      final flagKey = '$_notifiedThresholdPrefix${categoryId}_${monthKey}_$threshold';
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(flagKey) ?? false) continue;
      await prefs.setBool(flagKey, true);
      await _safely(() => _scheduler.showNow(
            id: _stableId('budget_$categoryId', 3000000),
            title: titleBuilder(threshold),
            body: bodyBuilder(threshold),
          ));
      return;
    }
  }

  /// Reminds 1 day before [dueDate] at 09:00 local time. A no-op if the
  /// preference is off, or if that reminder moment has already passed
  /// (see [NotificationScheduler.scheduleOneTime] — never fabricates a
  /// reminder for a moment already gone).
  Future<void> scheduleInvoiceReminder({
    required String invoiceId,
    required DateTime dueDate,
    required String title,
    required String body,
  }) async {
    if (!await isInvoiceDueEnabled()) return;
    await _safely(() => _scheduler.requestPermission());
    final reminderDate = DateTime(dueDate.year, dueDate.month, dueDate.day - 1, 9, 0);
    await _safely(() => _scheduler.scheduleOneTime(
          id: _stableId('invoice_$invoiceId', 4000000),
          title: title,
          body: body,
          dateTime: reminderDate,
        ));
  }

  /// Call when an invoice is marked paid or deleted — cancels its
  /// reminder regardless of whether one was ever actually scheduled (a
  /// cancel of a non-existent id is a harmless no-op on every platform
  /// this plugin supports), and regardless of the current preference
  /// state (a reminder scheduled while the preference was on must still
  /// be cancelled even if the user has since turned it off).
  Future<void> cancelInvoiceReminder(String invoiceId) async {
    await _safely(() => _scheduler.cancel(_stableId('invoice_$invoiceId', 4000000)));
  }

  int _stableId(String seed, int base) => base + (seed.hashCode & 0xFFFFF);

  Future<void> _safely(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Notification plumbing is best-effort — never let it crash a core
      // feature (adding an expense, deleting an invoice, ...).
    }
  }

  Future<bool> _getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

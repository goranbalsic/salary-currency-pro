import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense_entry.dart';
import '../models/recurring_transaction.dart';
import 'expense_service.dart';

/// Local, on-device-only store of recurring-transaction templates and the
/// review queue they feed — PROMPT-003 Stage B item 5. Same privacy model
/// as [ExpenseService]: never synced, degrades to an empty list on corrupt
/// data.
class RecurringTransactionService {
  static const _templatesKey = 'recurring_transactions_v1';
  static const _reviewQueueKey = 'recurring_review_queue_v1';

  /// Bumped on every successful add/update/delete/setActive/checkDue/
  /// confirmReview/skipReview so screens can refresh live — same pattern
  /// as [ExpenseService.changes].
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<RecurringTransaction>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_templatesKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => RecurringTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<RecurringReviewItem>> loadReviewQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_reviewQueueKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => RecurringReviewItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<RecurringTransaction> add({
    required TransactionType type,
    required String categoryId,
    required double amount,
    required String currencyCode,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    required bool autoPost,
    String note = '',
  }) async {
    final all = await loadAll();
    final template = RecurringTransaction(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      type: type,
      categoryId: categoryId,
      amount: amount,
      currencyCode: currencyCode,
      note: note,
      frequency: frequency,
      startDate: startDate,
      autoPost: autoPost,
      createdAt: DateTime.now(),
    );
    all.insert(0, template);
    await _saveTemplates(all);
    changes.value++;
    return template;
  }

  Future<void> update(
    String id, {
    required TransactionType type,
    required String categoryId,
    required double amount,
    required String currencyCode,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    required bool autoPost,
    String note = '',
  }) async {
    final all = await loadAll();
    final index = all.indexWhere((t) => t.id == id);
    if (index == -1) return;
    all[index] = all[index].copyWith(
      type: type,
      categoryId: categoryId,
      amount: amount,
      currencyCode: currencyCode,
      note: note,
      frequency: frequency,
      startDate: startDate,
      autoPost: autoPost,
    );
    await _saveTemplates(all);
    changes.value++;
  }

  Future<void> setActive(String id, bool active) async {
    final all = await loadAll();
    final index = all.indexWhere((t) => t.id == id);
    if (index == -1) return;
    all[index] = all[index].copyWith(active: active);
    await _saveTemplates(all);
    changes.value++;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((t) => t.id == id);
    await _saveTemplates(all);
    final queue = await loadReviewQueue();
    queue.removeWhere((r) => r.recurringId == id);
    await _saveQueue(queue);
    changes.value++;
  }

  /// Checks every active template for a due occurrence as of [asOf]
  /// (defaults to now). Auto-post templates get an [ExpenseEntry] created
  /// immediately via [expenseService] and their `lastResolvedDate`
  /// advanced; review-required templates get a [RecurringReviewItem]
  /// queued instead (skipped if one already exists for that occurrence —
  /// safe to call repeatedly, e.g. on every app start and every time the
  /// Expense Tracker screen opens).
  Future<void> checkDue({DateTime? asOf, ExpenseService? expenseService}) async {
    final now = asOf ?? DateTime.now();
    final expenses = expenseService ?? ExpenseService();
    final all = await loadAll();
    final queue = await loadReviewQueue();
    var templatesChanged = false;
    var queueChanged = false;

    for (var i = 0; i < all.length; i++) {
      final template = all[i];
      final due = template.dueOccurrenceAsOf(now);
      if (due == null) continue;

      if (template.autoPost) {
        await expenses.add(
          type: template.type,
          categoryId: template.categoryId,
          amount: template.amount,
          currencyCode: template.currencyCode,
          date: due,
          note: template.note,
        );
        all[i] = template.copyWith(lastResolvedDate: due);
        templatesChanged = true;
      } else {
        final alreadyQueued = queue.any(
          (r) => r.recurringId == template.id && r.occurrenceDate == due,
        );
        if (!alreadyQueued) {
          queue.add(RecurringReviewItem(
            id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
            recurringId: template.id,
            occurrenceDate: due,
            type: template.type,
            categoryId: template.categoryId,
            amount: template.amount,
            currencyCode: template.currencyCode,
            note: template.note,
          ));
          queueChanged = true;
        }
      }
    }

    if (templatesChanged) await _saveTemplates(all);
    if (queueChanged) await _saveQueue(queue);
    if (templatesChanged || queueChanged) changes.value++;
  }

  /// Posts a queued review item as a real [ExpenseEntry] and marks its
  /// template resolved through that occurrence, then removes it from the
  /// queue.
  Future<void> confirmReview(String reviewItemId, {ExpenseService? expenseService}) async {
    final queue = await loadReviewQueue();
    final index = queue.indexWhere((r) => r.id == reviewItemId);
    if (index == -1) return;
    final item = queue[index];

    final expenses = expenseService ?? ExpenseService();
    await expenses.add(
      type: item.type,
      categoryId: item.categoryId,
      amount: item.amount,
      currencyCode: item.currencyCode,
      date: item.occurrenceDate,
      note: item.note,
    );

    await _resolveReviewItem(item);
  }

  /// Discards a queued review item without creating an [ExpenseEntry] —
  /// still marks its template resolved through that occurrence, so it
  /// isn't re-queued next time [checkDue] runs.
  Future<void> skipReview(String reviewItemId) async {
    final queue = await loadReviewQueue();
    final index = queue.indexWhere((r) => r.id == reviewItemId);
    if (index == -1) return;
    await _resolveReviewItem(queue[index]);
  }

  Future<void> _resolveReviewItem(RecurringReviewItem item) async {
    final all = await loadAll();
    final templateIndex = all.indexWhere((t) => t.id == item.recurringId);
    if (templateIndex != -1) {
      all[templateIndex] = all[templateIndex].copyWith(lastResolvedDate: item.occurrenceDate);
      await _saveTemplates(all);
    }

    final queue = await loadReviewQueue();
    queue.removeWhere((r) => r.id == item.id);
    await _saveQueue(queue);
    changes.value++;
  }

  Future<void> _saveTemplates(List<RecurringTransaction> templates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(templates.map((t) => t.toJson()).toList());
      await prefs.setString(_templatesKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }

  Future<void> _saveQueue(List<RecurringReviewItem> queue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(queue.map((r) => r.toJson()).toList());
      await prefs.setString(_reviewQueueKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

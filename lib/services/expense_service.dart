import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense_entry.dart';

/// Local, on-device-only ledger of income/expense transactions. Same
/// privacy model as [HistoryService]/[ScenarioService]: never synced or
/// uploaded, degrades to an empty list on corrupt data rather than
/// crashing, capped so it can't grow unbounded on a device kept for years.
class ExpenseService {
  static const _prefsKey = 'expense_transactions_v1';
  static const maxEntries = 2000;

  /// Bumped on every successful add/delete/clear so Home and the tracker
  /// screen can refresh live — same pattern as [HistoryService.changes].
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<ExpenseEntry>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      final entries = decoded
          .map((e) => ExpenseEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      return entries;
    } catch (_) {
      return [];
    }
  }

  Future<List<ExpenseEntry>> loadForMonth(DateTime month) async {
    final all = await loadAll();
    return all
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .toList();
  }

  /// One [MonthlySummary] per currency present in [month], newest/most-
  /// significant currency arbitrarily ordered by first appearance — callers
  /// with a single-currency household will just get a single-element list.
  Future<List<MonthlySummary>> summaryForMonth(DateTime month) async {
    final entries = await loadForMonth(month);
    final byCurrency = <String, MonthlySummary>{};
    for (final e in entries) {
      final existing = byCurrency[e.currencyCode];
      final income = (existing?.totalIncome ?? 0) +
          (e.type == TransactionType.income ? e.amount : 0);
      final expense = (existing?.totalExpense ?? 0) +
          (e.type == TransactionType.expense ? e.amount : 0);
      byCurrency[e.currencyCode] = MonthlySummary(
        currencyCode: e.currencyCode,
        totalIncome: income,
        totalExpense: expense,
      );
    }
    return byCurrency.values.toList();
  }

  /// Per-currency totals for one [type], grouped by category — the shared
  /// basis for both the tracker's "Spending by category" card and category
  /// budget progress. Only currencies/categories actually present in
  /// [month] appear in the result.
  Future<Map<String, Map<String, double>>> categoryTotalsForMonth(
    DateTime month, {
    required TransactionType type,
  }) async {
    final entries = await loadForMonth(month);
    final result = <String, Map<String, double>>{};
    for (final e in entries.where((e) => e.type == type)) {
      final byCategory = result.putIfAbsent(e.currencyCode, () => {});
      byCategory[e.categoryId] = (byCategory[e.categoryId] ?? 0) + e.amount;
    }
    return result;
  }

  Future<ExpenseEntry> add({
    required TransactionType type,
    required String categoryId,
    required double amount,
    required String currencyCode,
    required DateTime date,
    String note = '',
  }) async {
    final all = await loadAll();
    final entry = ExpenseEntry(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      type: type,
      categoryId: categoryId,
      amount: amount,
      currencyCode: currencyCode,
      date: date,
      note: note,
    );
    all.insert(0, entry);
    await _save(all.take(maxEntries).toList());
    changes.value++;
    return entry;
  }

  /// Replaces the entry matching [id] in place — same position in the
  /// stored list, only the fields change. A no-op if [id] no longer exists
  /// (e.g. deleted from another screen while an edit sheet was open).
  Future<void> update({
    required String id,
    required TransactionType type,
    required String categoryId,
    required double amount,
    required String currencyCode,
    required DateTime date,
    String note = '',
  }) async {
    final all = await loadAll();
    final index = all.indexWhere((e) => e.id == id);
    if (index == -1) return;
    all[index] = ExpenseEntry(
      id: id,
      schemaVersion: all[index].schemaVersion,
      type: type,
      categoryId: categoryId,
      amount: amount,
      currencyCode: currencyCode,
      date: date,
      note: note,
    );
    await _save(all);
    changes.value++;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((e) => e.id == id);
    await _save(all);
    changes.value++;
  }

  /// Re-inserts a previously-deleted [entry] exactly as it was (same id,
  /// same fields) — the undo half of [delete]. A no-op if an entry with the
  /// same id already exists (e.g. undo tapped twice).
  Future<void> restore(ExpenseEntry entry) async {
    final all = await loadAll();
    if (all.any((e) => e.id == entry.id)) return;
    all.insert(0, entry);
    await _save(all);
    changes.value++;
  }

  Future<void> clear() async {
    await _save(const []);
    changes.value++;
  }

  Future<void> _save(List<ExpenseEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/budget.dart';

/// Local, on-device-only store of category budgets and savings goals. Same
/// privacy/persistence model as the other services in this app.
class BudgetService {
  static const _budgetsPrefsKey = 'category_budgets_v1';
  static const _goalsPrefsKey = 'savings_goals_v1';

  /// Bumped on every successful write so screens can refresh live — same
  /// pattern as [ExpenseService.changes].
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<CategoryBudget>> loadCategoryBudgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_budgetsPrefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => CategoryBudget.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Creates or replaces the budget for [categoryId] — one budget per
  /// category, so setting a new limit for an already-budgeted category
  /// overwrites the old one rather than adding a duplicate.
  Future<void> setCategoryBudget(CategoryBudget budget) async {
    final all = await loadCategoryBudgets();
    all.removeWhere((b) => b.categoryId == budget.categoryId);
    all.add(budget);
    await _saveBudgets(all);
    changes.value++;
  }

  Future<void> deleteCategoryBudget(String categoryId) async {
    final all = await loadCategoryBudgets();
    all.removeWhere((b) => b.categoryId == categoryId);
    await _saveBudgets(all);
    changes.value++;
  }

  Future<void> _saveBudgets(List<CategoryBudget> budgets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(budgets.map((b) => b.toJson()).toList());
      await prefs.setString(_budgetsPrefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }

  Future<List<SavingsGoal>> loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_goalsPrefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      final goals = decoded
          .map((e) => SavingsGoal.fromJson(e as Map<String, dynamic>))
          .toList();
      goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return goals;
    } catch (_) {
      return [];
    }
  }

  Future<SavingsGoal> addGoal({
    required String name,
    required double targetAmount,
    required String currencyCode,
    DateTime? targetDate,
  }) async {
    final all = await loadGoals();
    final goal = SavingsGoal(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      name: name,
      targetAmount: targetAmount,
      currencyCode: currencyCode,
      targetDate: targetDate,
      createdAt: DateTime.now(),
    );
    all.insert(0, goal);
    await _saveGoals(all);
    changes.value++;
    return goal;
  }

  /// Adds [amount] (positive or negative, e.g. to correct a mistaken entry)
  /// to the goal's recorded progress. Never lets [SavingsGoal.currentAmount]
  /// go negative.
  Future<void> addProgress(String goalId, double amount) async {
    final all = await loadGoals();
    final index = all.indexWhere((g) => g.id == goalId);
    if (index == -1) return;
    final g = all[index];
    all[index] = SavingsGoal(
      id: g.id,
      schemaVersion: g.schemaVersion,
      name: g.name,
      targetAmount: g.targetAmount,
      currentAmount: (g.currentAmount + amount).clamp(0, double.infinity),
      currencyCode: g.currencyCode,
      targetDate: g.targetDate,
      createdAt: g.createdAt,
    );
    await _saveGoals(all);
    changes.value++;
  }

  Future<void> deleteGoal(String goalId) async {
    final all = await loadGoals();
    all.removeWhere((g) => g.id == goalId);
    await _saveGoals(all);
    changes.value++;
  }

  /// Clears both category budgets and savings goals — used by Settings'
  /// "Delete all local data" action.
  Future<void> clearAll() async {
    await _saveBudgets(const []);
    await _saveGoals(const []);
    changes.value++;
  }

  Future<void> _saveGoals(List<SavingsGoal> goals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(goals.map((g) => g.toJson()).toList());
      await prefs.setString(_goalsPrefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

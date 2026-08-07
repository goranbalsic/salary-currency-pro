import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/budget.dart';
import 'package:salary_currency_pro/services/budget_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Category budgets', () {
    test('loadCategoryBudgets on a fresh install returns an empty list', () async {
      final service = BudgetService();
      expect(await service.loadCategoryBudgets(), isEmpty);
    });

    test('setCategoryBudget persists a budget retrievable via loadCategoryBudgets',
        () async {
      final service = BudgetService();
      await service.setCategoryBudget(const CategoryBudget(
        categoryId: 'groceries',
        monthlyLimit: 300,
        currencyCode: 'EUR',
      ));
      final all = await service.loadCategoryBudgets();
      expect(all, hasLength(1));
      expect(all.first.categoryId, 'groceries');
      expect(all.first.monthlyLimit, 300);
    });

    test('setCategoryBudget replaces an existing budget for the same category '
        'instead of adding a duplicate', () async {
      final service = BudgetService();
      await service.setCategoryBudget(const CategoryBudget(
        categoryId: 'groceries',
        monthlyLimit: 300,
        currencyCode: 'EUR',
      ));
      await service.setCategoryBudget(const CategoryBudget(
        categoryId: 'groceries',
        monthlyLimit: 400,
        currencyCode: 'EUR',
      ));
      final all = await service.loadCategoryBudgets();
      expect(all, hasLength(1));
      expect(all.first.monthlyLimit, 400);
    });

    test('deleteCategoryBudget removes only the targeted category budget',
        () async {
      final service = BudgetService();
      await service.setCategoryBudget(
          const CategoryBudget(categoryId: 'groceries', monthlyLimit: 300, currencyCode: 'EUR'));
      await service.setCategoryBudget(
          const CategoryBudget(categoryId: 'transport', monthlyLimit: 100, currencyCode: 'EUR'));
      await service.deleteCategoryBudget('groceries');
      final all = await service.loadCategoryBudgets();
      expect(all, hasLength(1));
      expect(all.first.categoryId, 'transport');
    });
  });

  group('Savings goals', () {
    test('loadGoals on a fresh install returns an empty list', () async {
      final service = BudgetService();
      expect(await service.loadGoals(), isEmpty);
    });

    test('addGoal persists a goal with zero starting progress', () async {
      final service = BudgetService();
      final goal = await service.addGoal(
        name: 'Emergency fund',
        targetAmount: 1000,
        currencyCode: 'EUR',
      );
      expect(goal.currentAmount, 0);
      expect(goal.progressFraction, 0);
      expect(goal.isComplete, isFalse);

      final all = await service.loadGoals();
      expect(all, hasLength(1));
      expect(all.first.name, 'Emergency fund');
    });

    test('addProgress accumulates and progressFraction reflects it', () async {
      final service = BudgetService();
      final goal = await service.addGoal(
        name: 'Emergency fund',
        targetAmount: 1000,
        currencyCode: 'EUR',
      );
      await service.addProgress(goal.id, 250);
      await service.addProgress(goal.id, 250);

      final all = await service.loadGoals();
      expect(all.first.currentAmount, 500);
      expect(all.first.progressFraction, 0.5);
      expect(all.first.isComplete, isFalse);
    });

    test('addProgress never lets currentAmount go negative', () async {
      final service = BudgetService();
      final goal = await service.addGoal(
        name: 'Emergency fund',
        targetAmount: 1000,
        currencyCode: 'EUR',
      );
      await service.addProgress(goal.id, 100);
      await service.addProgress(goal.id, -500);

      final all = await service.loadGoals();
      expect(all.first.currentAmount, 0);
    });

    test('isComplete and progressFraction cap at reaching the target', () async {
      final service = BudgetService();
      final goal = await service.addGoal(
        name: 'Emergency fund',
        targetAmount: 1000,
        currencyCode: 'EUR',
      );
      await service.addProgress(goal.id, 1500);

      final all = await service.loadGoals();
      expect(all.first.currentAmount, 1500);
      expect(all.first.isComplete, isTrue);
      expect(all.first.progressFraction, 1.0);
    });

    test('deleteGoal removes only the targeted goal', () async {
      final service = BudgetService();
      final a = await service.addGoal(name: 'A', targetAmount: 100, currencyCode: 'EUR');
      await service.addGoal(name: 'B', targetAmount: 200, currencyCode: 'EUR');

      await service.deleteGoal(a.id);
      final all = await service.loadGoals();
      expect(all, hasLength(1));
      expect(all.first.name, 'B');
    });

    test('corrupt locally-stored JSON degrades to an empty list rather than throwing',
        () async {
      SharedPreferences.setMockInitialValues({
        'category_budgets_v1': '{not valid json',
        'savings_goals_v1': '[also not valid',
      });
      final service = BudgetService();
      expect(await service.loadCategoryBudgets(), isEmpty);
      expect(await service.loadGoals(), isEmpty);
    });
  });
}

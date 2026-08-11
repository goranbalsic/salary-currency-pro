import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/budget.dart';
import '../../models/currency.dart';
import '../../models/expense_entry.dart';
import '../../services/budget_service.dart';
import '../../services/expense_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';

/// Monthly category spending limits (compared against real
/// [ExpenseService] data, never enforced — informational only) and savings
/// goals with manually-logged progress. No bank connection exists in this
/// app, so nothing here is inferred or automated.
class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final _budgetService = BudgetService();
  final _expenseService = ExpenseService();
  final _notificationService = NotificationService();
  List<CategoryBudget> _budgets = const [];
  List<SavingsGoal> _goals = const [];
  Map<String, Map<String, double>> _spentByCurrency = const {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    BudgetService.changes.addListener(_load);
    ExpenseService.changes.addListener(_load);
  }

  @override
  void dispose() {
    BudgetService.changes.removeListener(_load);
    ExpenseService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final budgets = await _budgetService.loadCategoryBudgets();
    final goals = await _budgetService.loadGoals();
    final spent = await _expenseService.categoryTotalsForMonth(
      DateTime.now(),
      type: TransactionType.expense,
    );
    if (!mounted) return;
    setState(() {
      _budgets = budgets;
      _goals = goals;
      _spentByCurrency = spent;
      _loaded = true;
    });
    unawaited(_checkBudgetThresholds(budgets, spent));
  }

  /// Same threshold check as `expense_tracker_screen.dart`'s, kept here
  /// too since this screen also reactively reloads on every
  /// ExpenseService/BudgetService change — see that screen's doc comment
  /// on `_checkBudgetThresholds` for the scope limit both share
  /// (foreground-only; no true background delivery for an auto-posted
  /// recurring transaction while neither screen is open).
  Future<void> _checkBudgetThresholds(
    List<CategoryBudget> budgets,
    Map<String, Map<String, double>> spentByCurrency,
  ) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    for (final budget in budgets) {
      final spent = spentByCurrency[budget.currencyCode]?[budget.categoryId] ?? 0;
      await _notificationService.checkBudgetThreshold(
        categoryId: budget.categoryId,
        month: now,
        spent: spent,
        limit: budget.monthlyLimit,
        titleBuilder: (percent) => l10n.notifBudgetThresholdNotifTitle(
          localizedCategoryLabel(l10n, budget.categoryId),
          percent,
        ),
        bodyBuilder: (percent) => l10n.notifBudgetThresholdNotifBody(
          localizedCategoryLabel(l10n, budget.categoryId),
          percent,
        ),
      );
    }
  }

  double _spentFor(CategoryBudget b) => _spentByCurrency[b.currencyCode]?[b.categoryId] ?? 0;

  Map<String, CategoryBudget> get _budgetsByCategory =>
      {for (final b in _budgets) b.categoryId: b};

  Future<void> _openSetLimitSheet(String categoryId) async {
    final existing = _budgets.where((b) => b.categoryId == categoryId);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SetBudgetSheet(
        categoryId: categoryId,
        existing: existing.isEmpty ? null : existing.first,
      ),
    );
  }

  Future<void> _confirmDeleteBudget(AppLocalizations l10n, CategoryBudget budget) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.budgetsDeleteLimitConfirmTitle),
        content: Text(l10n.budgetsDeleteLimitConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete,
                style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _budgetService.deleteCategoryBudget(budget.categoryId);
    }
  }

  Future<void> _confirmDeleteGoal(AppLocalizations l10n, SavingsGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.budgetsDeleteGoalConfirmTitle),
        content: Text(l10n.budgetsDeleteGoalConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete,
                style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _budgetService.deleteGoal(goal.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgetsScreenTitle)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.budgetsSectionGoals,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (_goals.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.savings_outlined,
                              size: 32,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.budgetsNoGoalsYet,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  for (final g in _goals)
                    _GoalCard(
                      goal: g,
                      l10n: l10n,
                      onAddProgress: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => _AddProgressSheet(goal: g),
                      ),
                      onDelete: () => _confirmDeleteGoal(l10n, g),
                    ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const _AddGoalSheet(),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.budgetsAddGoal),
                ),
                const SizedBox(height: 24),
                Text(l10n.budgetsSectionCategoryBudgets,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(l10n.budgetsNoBudgetsHint, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                for (final categoryId in ExpenseCategories.expenseIds)
                  _CategoryBudgetTile(
                    categoryId: categoryId,
                    budget: _budgetsByCategory[categoryId],
                    spent: _budgetsByCategory[categoryId] == null
                        ? 0
                        : _spentFor(_budgetsByCategory[categoryId]!),
                    l10n: l10n,
                    onSetLimit: () => _openSetLimitSheet(categoryId),
                    onDelete: (b) => _confirmDeleteBudget(l10n, b),
                  ),
              ],
            ),
    );
  }
}

class _CategoryBudgetTile extends StatelessWidget {
  final String categoryId;
  final CategoryBudget? budget;
  final double spent;
  final AppLocalizations l10n;
  final VoidCallback onSetLimit;
  final ValueChanged<CategoryBudget> onDelete;

  const _CategoryBudgetTile({
    required this.categoryId,
    required this.budget,
    required this.spent,
    required this.l10n,
    required this.onSetLimit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final b = budget;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);

    if (b == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(categoryIcon(categoryId)),
          title: Text(localizedCategoryLabel(l10n, categoryId)),
          subtitle: Text(l10n.budgetsNoLimitSet),
          trailing: TextButton(onPressed: onSetLimit, child: Text(l10n.budgetsSetLimit)),
        ),
      );
    }

    final fraction = b.monthlyLimit > 0 ? (spent / b.monthlyLimit).clamp(0.0, 1.0) : 0.0;
    final isOver = spent > b.monthlyLimit;
    final colorScheme = Theme.of(context).colorScheme;
    final color = isOver
        ? colorScheme.error
        : (fraction >= 0.8
            ? colorScheme.secondary
            : AppColors.positiveAction(colorScheme.brightness));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(categoryIcon(categoryId), size: 20, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(localizedCategoryLabel(l10n, categoryId),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onSetLimit,
                  tooltip: l10n.budgetsEditLimit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => onDelete(b),
                  tooltip: l10n.commonDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isOver
                  ? '${l10n.budgetsOverBudget} — ${fmt.format(spent)} / ${fmt.format(b.monthlyLimit)} ${b.currencyCode}'
                  : '${fmt.format(spent)} / ${fmt.format(b.monthlyLimit)} ${b.currencyCode}',
              style: TextStyle(
                fontSize: 12,
                color: isOver ? colorScheme.error : null,
                fontWeight: isOver ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final AppLocalizations l10n;
  final VoidCallback onAddProgress;
  final VoidCallback onDelete;

  const _GoalCard({
    required this.goal,
    required this.l10n,
    required this.onAddProgress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final brightness = Theme.of(context).colorScheme.brightness;
    final color = goal.isComplete
        ? AppColors.positiveAction(brightness)
        : AppColors.neutralAccent(brightness);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(goal.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  tooltip: l10n.commonDelete,
                ),
              ],
            ),
            if (goal.targetDate != null)
              Text(
                DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(goal.targetDate!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: goal.progressFraction,
                minHeight: 10,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${fmt.format(goal.currentAmount)} / ${fmt.format(goal.targetAmount)} ${goal.currencyCode}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (goal.isComplete)
                  Text(l10n.budgetsGoalComplete,
                      style: TextStyle(color: color, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAddProgress,
                icon: const Icon(Icons.add),
                label: Text(l10n.budgetsAddProgress),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetBudgetSheet extends StatefulWidget {
  final String categoryId;
  final CategoryBudget? existing;
  const _SetBudgetSheet({required this.categoryId, this.existing});

  @override
  State<_SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<_SetBudgetSheet> {
  late final _limitCtrl =
      TextEditingController(text: widget.existing == null ? '' : _plain(widget.existing!.monthlyLimit));
  late String _currencyCode = widget.existing?.currencyCode ?? 'EUR';
  final _service = BudgetService();
  AmountIssue? _issue;

  static String _plain(double v) => v == v.truncateToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _limitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final result = parseAmountInput(_limitCtrl.text, allowZero: false);
    if (!result.isValid) {
      setState(() => _issue = result.issue);
      return;
    }
    await _service.setCategoryBudget(CategoryBudget(
      categoryId: widget.categoryId,
      monthlyLimit: result.value!,
      currencyCode: _currencyCode,
    ));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _issueText(AppLocalizations l10n, AmountIssue issue) => switch (issue) {
        AmountIssue.empty => l10n.convertAmountIssueEmpty,
        AmountIssue.invalid => l10n.convertAmountIssueInvalid,
        AmountIssue.negative => l10n.convertAmountIssueNegative,
        AmountIssue.zeroNotAllowed => l10n.convertAmountIssueZero,
        AmountIssue.tooLarge => l10n.convertAmountIssueTooLarge,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localizedCategoryLabel(l10n, widget.categoryId),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  key: const Key('budget_limit_field'),
                  controller: _limitCtrl,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.budgetsMonthlyLimit,
                    errorText: _issue == null ? null : _issueText(l10n, _issue!),
                  ),
                  onChanged: (_) {
                    if (_issue != null) setState(() => _issue = null);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _currencyCode,
                  isExpanded: true,
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  items: [
                    for (final c in supportedCurrencies)
                      DropdownMenuItem(value: c.code, child: Text(c.code)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _currencyCode = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
    );
  }
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _service = BudgetService();
  String _currencyCode = 'EUR';
  DateTime? _targetDate;
  AmountIssue? _issue;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    final result = parseAmountInput(_targetCtrl.text, allowZero: false);
    if (!result.isValid) {
      setState(() => _issue = result.issue);
      return;
    }
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    await _service.addGoal(
      name: name,
      targetAmount: result.value!,
      currencyCode: _currencyCode,
      targetDate: _targetDate,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _issueText(AppLocalizations l10n, AmountIssue issue) => switch (issue) {
        AmountIssue.empty => l10n.convertAmountIssueEmpty,
        AmountIssue.invalid => l10n.convertAmountIssueInvalid,
        AmountIssue.negative => l10n.convertAmountIssueNegative,
        AmountIssue.zeroNotAllowed => l10n.convertAmountIssueZero,
        AmountIssue.tooLarge => l10n.convertAmountIssueTooLarge,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.budgetsAddGoal,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              key: const Key('goal_name_field'),
              controller: _nameCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.budgetsGoalName),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('goal_target_field'),
                    controller: _targetCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.budgetsTargetAmount,
                      errorText: _issue == null ? null : _issueText(l10n, _issue!),
                    ),
                    onChanged: (_) {
                      if (_issue != null) setState(() => _issue = null);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currencyCode,
                    isExpanded: true,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                    items: [
                      for (final c in supportedCurrencies)
                        DropdownMenuItem(value: c.code, child: Text(c.code)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _currencyCode = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(_targetDate == null ? l10n.budgetsNoTargetDate : dateFmt.format(_targetDate!)),
              subtitle: Text(l10n.budgetsTargetDateOptional),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _save, child: Text(l10n.commonSave)),
          ],
        ),
      ),
    );
  }
}

class _AddProgressSheet extends StatefulWidget {
  final SavingsGoal goal;
  const _AddProgressSheet({required this.goal});

  @override
  State<_AddProgressSheet> createState() => _AddProgressSheetState();
}

class _AddProgressSheetState extends State<_AddProgressSheet> {
  final _amountCtrl = TextEditingController();
  final _service = BudgetService();
  AmountIssue? _issue;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final result = parseAmountInput(_amountCtrl.text, allowZero: false);
    if (!result.isValid) {
      setState(() => _issue = result.issue);
      return;
    }
    await _service.addProgress(widget.goal.id, result.value!);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _issueText(AppLocalizations l10n, AmountIssue issue) => switch (issue) {
        AmountIssue.empty => l10n.convertAmountIssueEmpty,
        AmountIssue.invalid => l10n.convertAmountIssueInvalid,
        AmountIssue.negative => l10n.convertAmountIssueNegative,
        AmountIssue.zeroNotAllowed => l10n.convertAmountIssueZero,
        AmountIssue.tooLarge => l10n.convertAmountIssueTooLarge,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.goal.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(l10n.budgetsProgressExplanation, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          TextField(
            key: const Key('goal_progress_field'),
            controller: _amountCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.budgetsProgressAmountLabel,
              errorText: _issue == null ? null : _issueText(l10n, _issue!),
            ),
            onChanged: (_) {
              if (_issue != null) setState(() => _issue = null);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
    );
  }
}

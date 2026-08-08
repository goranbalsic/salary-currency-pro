import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/country.dart';
import '../../models/currency.dart';
import '../../models/expense_entry.dart';
import '../../models/recurring_transaction.dart';
import '../../services/budget_service.dart';
import '../../services/expense_service.dart';
import '../../services/notification_service.dart';
import '../../services/recurring_transaction_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';

/// A monthly income/expense ledger the user enters directly — the app's one
/// screen backed by ongoing, multi-entry data rather than a single
/// calculation. Reachable from Home's "This month" card and from the Tools
/// hub's Track & Plan category.
class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

enum _SortMode { dateDesc, amountDesc }

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  final _service = ExpenseService();
  final _recurringService = RecurringTransactionService();
  final _budgetService = BudgetService();
  final _notificationService = NotificationService();
  final _searchCtrl = TextEditingController();
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  List<ExpenseEntry> _entries = const [];
  List<MonthlySummary> _summaries = const [];
  List<RecurringReviewItem> _reviewQueue = const [];

  /// Previous calendar month's total expense in the primary (first) summary
  /// currency — Unknown (null) rather than 0 when there's no prior data, so
  /// the insights card can honestly say "not enough data" instead of
  /// claiming a 100% change from a month that was never tracked.
  double? _previousMonthExpense;
  bool _loaded = false;
  String _query = '';
  TransactionType? _typeFilter;
  _SortMode _sort = _SortMode.dateDesc;

  @override
  void initState() {
    super.initState();
    // Re-check on every screen open (not just app start, see app.dart) so
    // an occurrence that came due while the app was already running shows
    // up immediately rather than waiting for the next full restart.
    _recurringService.checkDue().then((_) => _loadReviewQueue());
    _load();
    ExpenseService.changes.addListener(_load);
    RecurringTransactionService.changes.addListener(_loadReviewQueue);
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    ExpenseService.changes.removeListener(_load);
    RecurringTransactionService.changes.removeListener(_loadReviewQueue);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadReviewQueue() async {
    final queue = await _recurringService.loadReviewQueue();
    if (!mounted) return;
    setState(() => _reviewQueue = queue);
  }

  /// Expense-only totals per category, grouped by currency — the basis for
  /// the "Spending by category" card. Computed from the already-loaded
  /// month's [_entries], same source of truth as [_summaries].
  Map<String, Map<String, double>> _categoryTotalsByCurrency() {
    final result = <String, Map<String, double>>{};
    for (final e in _entries.where((e) => e.type == TransactionType.expense)) {
      final byCategory = result.putIfAbsent(e.currencyCode, () => {});
      byCategory[e.categoryId] = (byCategory[e.categoryId] ?? 0) + e.amount;
    }
    return result;
  }

  /// Search/filter/sort are display-only over the already-loaded month —
  /// [_summaries] (and the totals they show) are always computed from the
  /// full month's data, never from this filtered view, so a filtered list
  /// can never be mistaken for a changed balance.
  List<ExpenseEntry> _visibleEntries(AppLocalizations l10n) {
    var result = _entries.where((e) {
      if (_typeFilter != null && e.type != _typeFilter) return false;
      if (_query.isEmpty) return true;
      final category = localizedCategoryLabel(l10n, e.categoryId).toLowerCase();
      return category.contains(_query) || e.note.toLowerCase().contains(_query);
    }).toList();

    result.sort(switch (_sort) {
      _SortMode.dateDesc => (a, b) => b.date.compareTo(a.date),
      _SortMode.amountDesc => (a, b) => b.amount.compareTo(a.amount),
    });
    return result;
  }

  Future<void> _load() async {
    final entries = await _service.loadForMonth(_month);
    final summaries = await _service.summaryForMonth(_month);

    double? previousExpense;
    if (summaries.isNotEmpty) {
      final previousMonth = DateTime(_month.year, _month.month - 1);
      final previousSummaries = await _service.summaryForMonth(previousMonth);
      final match = previousSummaries.where((s) => s.currencyCode == summaries.first.currencyCode);
      previousExpense = match.isEmpty ? null : match.first.totalExpense;
    }

    if (!mounted) return;
    setState(() {
      _entries = entries;
      _summaries = summaries;
      _previousMonthExpense = previousExpense;
      _loaded = true;
    });
    unawaited(_checkBudgetThresholds());
  }

  /// Fire-and-forget: checks every category budget against this month's
  /// real spend and notifies (at most once per category/month/threshold —
  /// see NotificationService.checkBudgetThreshold) if 80% or 100% was
  /// just crossed. Runs whenever this screen reloads, which covers a
  /// manually-added expense immediately; an expense auto-posted by a
  /// recurring transaction while the user is elsewhere in the app is
  /// caught the next time either this screen or Budgets & Goals reloads,
  /// not the instant it posts — a deliberate, disclosed scope limit (see
  /// DECISIONS.md) rather than the heavier background-execution machinery
  /// true instant delivery would need.
  Future<void> _checkBudgetThresholds() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final budgets = await _budgetService.loadCategoryBudgets();
    final spentByCurrency = await _service.categoryTotalsForMonth(
      _month,
      type: TransactionType.expense,
    );
    for (final budget in budgets) {
      final spent = spentByCurrency[budget.currencyCode]?[budget.categoryId] ?? 0;
      await _notificationService.checkBudgetThreshold(
        categoryId: budget.categoryId,
        month: _month,
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

  String _csvFor(AppLocalizations l10n) {
    final dateFmt = DateFormat('yyyy-MM-dd');
    final buffer = StringBuffer('Date,Type,Category,Amount,Currency,Note\n');
    for (final e in _entries) {
      final type = e.type == TransactionType.income ? 'Income' : 'Expense';
      final category = localizedCategoryLabel(l10n, e.categoryId);
      final note = e.note.replaceAll('"', '""');
      buffer.writeln(
        '${dateFmt.format(e.date)},$type,$category,${e.amount.toStringAsFixed(2)},${e.currencyCode},"$note"',
      );
    }
    return buffer.toString();
  }

  Future<void> _exportCsv(AppLocalizations l10n) async {
    if (_entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseExportEmpty)),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: _csvFor(l10n)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.expenseExportCopied)),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
    _load();
  }

  Future<void> _pickType() async {
    final l10n = AppLocalizations.of(context)!;
    final type = await showModalBottomSheet<TransactionType>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.moneyGreen,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: Text(l10n.expenseAddIncome),
              onTap: () => Navigator.of(sheetContext).pop(TransactionType.income),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.alertRed,
                child: Icon(Icons.remove, color: Colors.white),
              ),
              title: Text(l10n.expenseAddExpense),
              onTap: () => Navigator.of(sheetContext).pop(TransactionType.expense),
            ),
          ],
        ),
      ),
    );
    if (type == null || !mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddTransactionSheet(type: type),
    );
  }

  Future<void> _confirmDelete(ExpenseEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.expenseDeleteConfirmTitle),
        content: Text(l10n.expenseDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete, style: const TextStyle(color: AppColors.alertRed)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _service.delete(entry.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.expenseDeletedConfirmation),
        action: SnackBarAction(
          label: l10n.commonUndo,
          onPressed: () => _service.restore(entry),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final monthFmt =
        DateFormat.yMMMM(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expenseScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: l10n.expenseExportCsv,
            onPressed: () => _exportCsv(l10n),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickType,
        child: const Icon(Icons.add),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: l10n.expensePreviousMonth,
                      onPressed: () => _changeMonth(-1),
                    ),
                    Text(
                      _capitalize(monthFmt.format(_month)),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: l10n.expenseNextMonth,
                      onPressed: () => _changeMonth(1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_reviewQueue.isNotEmpty) ...[
                  _RecurringReviewBanner(
                    items: _reviewQueue,
                    recurringService: _recurringService,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 12),
                ],
                for (final s in _summaries) ...[
                  _SummaryCard(summary: s, l10n: l10n),
                  const SizedBox(height: 12),
                ],
                for (final entry in _categoryTotalsByCurrency().entries) ...[
                  _CategoryBreakdownCard(
                    currencyCode: entry.key,
                    totals: entry.value,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 12),
                ],
                if (_summaries.isNotEmpty) ...[
                  _InsightsCard(
                    summary: _summaries.first,
                    previousMonthExpense: _previousMonthExpense,
                    categoryTotals: _categoryTotalsByCurrency()[_summaries.first.currencyCode] ?? const {},
                    l10n: l10n,
                  ),
                  const SizedBox(height: 12),
                ],
                if (_entries.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 40,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.expenseEmptyState,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  TextField(
                    key: const Key('expense_search_field'),
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: l10n.expenseSearchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: l10n.commonClearSearch,
                              onPressed: () => _searchCtrl.clear(),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: Text(l10n.expenseFilterAll),
                              selected: _typeFilter == null,
                              onSelected: (_) => setState(() => _typeFilter = null),
                            ),
                            ChoiceChip(
                              label: Text(l10n.expenseIncome),
                              selected: _typeFilter == TransactionType.income,
                              onSelected: (_) =>
                                  setState(() => _typeFilter = TransactionType.income),
                            ),
                            ChoiceChip(
                              label: Text(l10n.expenseExpenses),
                              selected: _typeFilter == TransactionType.expense,
                              onSelected: (_) =>
                                  setState(() => _typeFilter = TransactionType.expense),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(_sort == _SortMode.dateDesc
                            ? Icons.calendar_today_outlined
                            : Icons.sort),
                        tooltip: _sort == _SortMode.dateDesc
                            ? l10n.expenseSortByAmount
                            : l10n.expenseSortByDate,
                        onPressed: () => setState(() {
                          _sort = _sort == _SortMode.dateDesc
                              ? _SortMode.amountDesc
                              : _SortMode.dateDesc;
                        }),
                      ),
                    ],
                  ),
                  Builder(builder: (context) {
                    final visible = _visibleEntries(l10n);
                    final isFiltered = _query.isNotEmpty || _typeFilter != null;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isFiltered)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              l10n.expenseResultCount(visible.length, _entries.length),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        else
                          const SizedBox(height: 8),
                        if (visible.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: Text(
                                l10n.expenseNoResults,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        else
                          for (final e in visible)
                            _TransactionTile(
                              entry: e,
                              l10n: l10n,
                              onDelete: () => _confirmDelete(e),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => _AddTransactionSheet(type: e.type, existing: e),
                              ),
                            ),
                      ],
                    );
                  }),
                ],
              ],
            ),
    );
  }
}

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Surfaces due occurrences of review-required (`autoPost: false`)
/// recurring transactions — PROMPT-003 Stage B item 5's "review-before-
/// post option". Auto-post templates never appear here; they're already
/// posted as real [ExpenseEntry] rows by the time this screen loads.
class _RecurringReviewBanner extends StatelessWidget {
  final List<RecurringReviewItem> items;
  final RecurringTransactionService recurringService;
  final AppLocalizations l10n;

  const _RecurringReviewBanner({
    required this.items,
    required this.recurringService,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return Card(
      color: AppColors.gold.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.repeat, size: 18, color: AppColors.navy),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.recurringReviewBannerTitle(items.length),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(categoryIcon(item.categoryId), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${localizedCategoryLabel(l10n, item.categoryId)} · '
                        '${fmt.format(item.amount)} ${item.currencyCode}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => recurringService.skipReview(item.id),
                      child: Text(l10n.recurringReviewSkip),
                    ),
                    FilledButton(
                      onPressed: () => recurringService.confirmReview(item.id),
                      child: Text(l10n.recurringReviewPost),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final MonthlySummary summary;
  final AppLocalizations l10n;
  const _SummaryCard({required this.summary, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '${summary.currencyCode} ', decimalDigits: 2);
    final balanceColor =
        summary.balance >= 0 ? AppColors.moneyGreen : AppColors.alertRed;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryColumn(context, l10n.expenseIncome, fmt.format(summary.totalIncome), AppColors.moneyGreen),
                _summaryColumn(context, l10n.expenseExpenses, fmt.format(summary.totalExpense), AppColors.alertRed),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.expenseBalance, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  fmt.format(summary.balance),
                  style: TextStyle(fontWeight: FontWeight.w800, color: balanceColor, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryColumn(BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

/// Proportional-bar breakdown of this month's expenses by category, for one
/// currency. Capped at the top 6 categories by amount — a long tail of
/// small categories would clutter the card without adding decision-useful
/// information, per the "clear insights over overwhelming dashboards"
/// product judgment call.
class _CategoryBreakdownCard extends StatelessWidget {
  final String currencyCode;
  final Map<String, double> totals;
  final AppLocalizations l10n;
  const _CategoryBreakdownCard({
    required this.currencyCode,
    required this.totals,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final grandTotal = totals.values.fold<double>(0, (a, b) => a + b);
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.expenseSpendingByCategory} · $currencyCode',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            for (final e in sorted.take(6))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(categoryIcon(e.key), size: 16, color: AppColors.alertRed),
                            const SizedBox(width: 6),
                            Text(localizedCategoryLabel(l10n, e.key)),
                          ],
                        ),
                        Text(
                          '${fmt.format(e.value)} $currencyCode'
                          ' (${grandTotal > 0 ? (e.value / grandTotal * 100).round() : 0}%)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: grandTotal > 0 ? e.value / grandTotal : 0,
                        minHeight: 8,
                        backgroundColor: AppColors.alertRed.withValues(alpha: 0.12),
                        valueColor: const AlwaysStoppedAnimation(AppColors.alertRed),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small, honest observations about the primary currency's data for this
/// month — never fabricated, never shown without enough real data to
/// support the specific claim, and every number is computed live from
/// [ExpenseEntry] records already loaded for the screen (no separate,
/// possibly-stale computation path).
class _Insight {
  final String headline;
  final String calculation;
  const _Insight({required this.headline, required this.calculation});
}

/// One plain-language observation at a time (PROMPT-003 Stage B item 9,
/// the "financial mirror"), always tappable to reveal the real numbers
/// behind it — never just an assertion the user has to take on faith,
/// matching this app's general sourced/traceable-numbers standard.
class _InsightsCard extends StatefulWidget {
  final MonthlySummary summary;
  final double? previousMonthExpense;
  final Map<String, double> categoryTotals;
  final AppLocalizations l10n;

  const _InsightsCard({
    required this.summary,
    required this.previousMonthExpense,
    required this.categoryTotals,
    required this.l10n,
  });

  @override
  State<_InsightsCard> createState() => _InsightsCardState();
}

class _InsightsCardState extends State<_InsightsCard> {
  int _index = 0;
  bool _expanded = false;

  List<_Insight> _buildInsights() {
    final l10n = widget.l10n;
    final fmt = NumberFormat.currency(symbol: '${widget.summary.currencyCode} ', decimalDigits: 0);
    final insights = <_Insight>[];

    final previous = widget.previousMonthExpense;
    if (previous != null && previous > 0) {
      final currentText = fmt.format(widget.summary.totalExpense);
      final previousText = fmt.format(previous);
      final change = ((widget.summary.totalExpense - previous) / previous * 100).round();
      final headline = change > 2
          ? l10n.expenseInsightHigherThanLastMonth(change, currentText, previousText)
          : change < -2
              ? l10n.expenseInsightLowerThanLastMonth(change.abs(), currentText, previousText)
              : l10n.expenseInsightSameAsLastMonth(currentText);
      insights.add(_Insight(
        headline: headline,
        calculation: l10n.expenseInsightMonthCalc(currentText, previousText, change),
      ));
    }

    if (widget.categoryTotals.isNotEmpty) {
      final sorted = widget.categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.first;
      final total = widget.categoryTotals.values.fold<double>(0, (a, b) => a + b);
      if (total > 0) {
        final percent = (top.value / total * 100).round();
        insights.add(_Insight(
          headline: l10n.expenseInsightTopCategory(
              localizedCategoryLabel(l10n, top.key), percent),
          calculation: l10n.expenseInsightCategoryCalc(
              fmt.format(top.value), fmt.format(total), percent),
        ));
      }
    }

    return insights;
  }

  void _goTo(int index) {
    setState(() {
      _index = index;
      _expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final insights = _buildInsights();
    if (insights.isEmpty) return const SizedBox.shrink();
    final index = _index.clamp(0, insights.length - 1);
    final insight = insights[index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights_outlined, size: 18, color: AppColors.navy),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l10n.expenseInsightsTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                if (insights.length > 1)
                  Text(
                    l10n.expenseInsightCounter(index + 1, insights.length),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(insight.headline, style: Theme.of(context).textTheme.bodyMedium),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: AppColors.moneyGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.expenseInsightHowCalculated,
                      style: const TextStyle(
                        color: AppColors.moneyGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  insight.calculation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ),
            if (insights.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // Distinct from this screen's own month-switcher chevrons
                // (Icons.chevron_left/right, above) so the two controls
                // stay visually and semantically separate.
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    onPressed: index == 0 ? null : () => _goTo(index - 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: index == insights.length - 1 ? null : () => _goTo(index + 1),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final ExpenseEntry entry;
  final AppLocalizations l10n;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const _TransactionTile({
    required this.entry,
    required this.l10n,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.type == TransactionType.income;
    final color = isIncome ? AppColors.moneyGreen : AppColors.alertRed;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final dateFmt = DateFormat.MMMd(Localizations.localeOf(context).languageCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(categoryIcon(entry.categoryId), color: color),
        ),
        title: Text(localizedCategoryLabel(l10n, entry.categoryId),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          entry.note.isEmpty
              ? dateFmt.format(entry.date)
              : '${entry.note} · ${dateFmt.format(entry.date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${fmt.format(entry.amount)} ${entry.currencyCode}',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Theme.of(context).colorScheme.outline,
              onPressed: onDelete,
              tooltip: l10n.commonDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTransactionSheet extends StatefulWidget {
  final TransactionType type;

  /// When non-null, the sheet edits this entry in place instead of creating
  /// a new one — same id, same list position, just changed fields.
  final ExpenseEntry? existing;

  const _AddTransactionSheet({required this.type, this.existing});

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  late final _amountCtrl = TextEditingController(
    text: widget.existing == null ? '' : _plainAmount(widget.existing!.amount),
  );
  late final _noteCtrl = TextEditingController(text: widget.existing?.note ?? '');
  final _service = ExpenseService();
  late String _categoryId =
      widget.existing?.categoryId ?? ExpenseCategories.defaultFor(widget.type);
  late String _currencyCode = widget.existing?.currencyCode ?? 'EUR';
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  AmountIssue? _issue;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  static String _plainAmount(double value) =>
      value == value.truncateToDouble() ? value.toInt().toString() : value.toString();

  @override
  void initState() {
    super.initState();
    // Editing an existing entry already has a real currency — no need to
    // guess a default and risk overwriting what the user actually chose.
    if (!_isEditing) _loadDefaultCurrency();
  }

  Future<void> _loadDefaultCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countryId = prefs.getString('salary_selected_country_id');
      if (countryId == null) return;
      final match = kCountries.where((c) => c.id == countryId);
      if (match.isEmpty || !mounted) return;
      setState(() => _currencyCode = match.first.currencyCode);
    } catch (_) {
      // Default 'EUR' stands if this can't be read.
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final result = parseAmountInput(_amountCtrl.text, allowZero: false);
    if (!result.isValid) {
      setState(() => _issue = result.issue);
      return;
    }
    setState(() => _saving = true);
    if (_isEditing) {
      await _service.update(
        id: widget.existing!.id,
        type: widget.type,
        categoryId: _categoryId,
        amount: result.value!,
        currencyCode: _currencyCode,
        date: _date,
        note: _noteCtrl.text.trim(),
      );
    } else {
      await _service.add(
        type: widget.type,
        categoryId: _categoryId,
        amount: result.value!,
        currencyCode: _currencyCode,
        date: _date,
        note: _noteCtrl.text.trim(),
      );
    }
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
    final categoryIds = widget.type == TransactionType.income
        ? ExpenseCategories.incomeIds
        : ExpenseCategories.expenseIds;
    final color =
        widget.type == TransactionType.income ? AppColors.moneyGreen : AppColors.alertRed;
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
            Text(
              _isEditing
                  ? l10n.expenseEditTransaction
                  : (widget.type == TransactionType.income
                      ? l10n.expenseAddIncome
                      : l10n.expenseAddExpense),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('expense_amount_field'),
                    controller: _amountCtrl,
                    autofocus: true,
                    cursorColor: color,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.expenseAmount,
                      floatingLabelStyle: _issue == null ? TextStyle(color: color) : null,
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
            Text(l10n.expenseCategory, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final id in categoryIds)
                  ChoiceChip(
                    avatar: Icon(categoryIcon(id), size: 18),
                    label: Text(localizedCategoryLabel(l10n, id)),
                    selected: _categoryId == id,
                    onSelected: (_) => setState(() => _categoryId = id),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(labelText: l10n.expenseNote),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l10n.expenseDate),
              trailing: Text(dateFmt.format(_date)),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}

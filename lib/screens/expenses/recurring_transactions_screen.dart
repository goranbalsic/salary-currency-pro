import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/currency.dart';
import '../../models/expense_entry.dart';
import '../../models/recurring_transaction.dart';
import '../../services/recurring_transaction_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_empty_state.dart';

/// Manage recurring-transaction templates — PROMPT-003 Stage B item 5
/// ("define-once, auto-post, review-before-post option"). Any due
/// occurrences awaiting review live in the Expense Tracker's review
/// banner, not here — this screen is purely template CRUD.
class RecurringTransactionsScreen extends StatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  State<RecurringTransactionsScreen> createState() => _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState extends State<RecurringTransactionsScreen> {
  final _service = RecurringTransactionService();
  List<RecurringTransaction> _templates = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    RecurringTransactionService.changes.addListener(_load);
  }

  @override
  void dispose() {
    RecurringTransactionService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final all = await _service.loadAll();
    if (!mounted) return;
    setState(() {
      _templates = all;
      _loaded = true;
    });
  }

  Future<void> _pickTypeThenAdd() async {
    final l10n = AppLocalizations.of(context)!;
    final type = await showModalBottomSheet<TransactionType>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.positiveAction(
                    Theme.of(sheetContext).brightness),
                child: const Icon(Icons.add, color: Colors.white),
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
      builder: (_) => _RecurringEditSheet(type: type),
    );
  }

  Future<void> _confirmDelete(RecurringTransaction template) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recurringDeleteConfirmTitle),
        content: Text(l10n.recurringDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete,
                style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _service.delete(template.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recurringScreenTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickTypeThenAdd,
        child: const Icon(Icons.add),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : _templates.isEmpty
              ? AppEmptyState(
                  icon: Icons.repeat,
                  message: l10n.recurringEmptyState,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final t = _templates[index];
                    final color = t.type == TransactionType.income
                        ? AppColors.positiveAction(Theme.of(context).brightness)
                        : Theme.of(context).colorScheme.error;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.12),
                          child: Icon(categoryIcon(t.categoryId), color: color),
                        ),
                        title: Text(localizedCategoryLabel(l10n, t.categoryId)),
                        subtitle: Text(
                          '${fmt.format(t.amount)} ${t.currencyCode} · '
                          '${t.frequency == RecurrenceFrequency.weekly ? l10n.recurringFrequencyWeekly : l10n.recurringFrequencyMonthly}'
                          '${t.active ? '' : ' · ${l10n.recurringPausedLabel}'}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (action) {
                            switch (action) {
                              case 'toggle':
                                _service.setActive(t.id, !t.active);
                                break;
                              case 'edit':
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => _RecurringEditSheet(type: t.type, existing: t),
                                );
                                break;
                              case 'delete':
                                _confirmDelete(t);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'toggle',
                              child: Text(t.active ? l10n.recurringPauseAction : l10n.recurringResumeAction),
                            ),
                            PopupMenuItem(value: 'edit', child: Text(l10n.expenseEditTransaction)),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(l10n.commonDelete, style: const TextStyle(color: AppColors.alertRed)),
                            ),
                          ],
                        ),
                        isThreeLine: false,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => _RecurringEditSheet(type: t.type, existing: t),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _RecurringEditSheet extends StatefulWidget {
  final TransactionType type;
  final RecurringTransaction? existing;

  const _RecurringEditSheet({required this.type, this.existing});

  @override
  State<_RecurringEditSheet> createState() => _RecurringEditSheetState();
}

class _RecurringEditSheetState extends State<_RecurringEditSheet> {
  late final _amountCtrl = TextEditingController(
    text: widget.existing == null ? '' : _plainAmount(widget.existing!.amount),
  );
  late final _noteCtrl = TextEditingController(text: widget.existing?.note ?? '');
  final _service = RecurringTransactionService();

  late String _categoryId =
      widget.existing?.categoryId ?? ExpenseCategories.defaultFor(widget.type);
  late String _currencyCode = widget.existing?.currencyCode ?? 'EUR';
  late RecurrenceFrequency _frequency = widget.existing?.frequency ?? RecurrenceFrequency.monthly;
  late DateTime _startDate = widget.existing?.startDate ?? DateTime.now();
  late bool _autoPost = widget.existing?.autoPost ?? false;
  AmountIssue? _issue;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  static String _plainAmount(double value) =>
      value == value.truncateToDouble() ? value.toInt().toString() : value.toString();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
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
        widget.existing!.id,
        type: widget.type,
        categoryId: _categoryId,
        amount: result.value!,
        currencyCode: _currencyCode,
        frequency: _frequency,
        startDate: _startDate,
        autoPost: _autoPost,
        note: _noteCtrl.text.trim(),
      );
    } else {
      await _service.add(
        type: widget.type,
        categoryId: _categoryId,
        amount: result.value!,
        currencyCode: _currencyCode,
        frequency: _frequency,
        startDate: _startDate,
        autoPost: _autoPost,
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
    final color = widget.type == TransactionType.income
        ? AppColors.positiveAction(Theme.of(context).brightness)
        : Theme.of(context).colorScheme.error;
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
              _isEditing ? l10n.recurringEditTitle : l10n.recurringAddTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
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
            Text(l10n.recurringFrequencyLabel, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            SegmentedButton<RecurrenceFrequency>(
              segments: [
                ButtonSegment(
                  value: RecurrenceFrequency.weekly,
                  label: Text(l10n.recurringFrequencyWeekly),
                ),
                ButtonSegment(
                  value: RecurrenceFrequency.monthly,
                  label: Text(l10n.recurringFrequencyMonthly),
                ),
              ],
              selected: {_frequency},
              onSelectionChanged: (s) => setState(() => _frequency = s.first),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l10n.recurringStartDateLabel),
              trailing: Text(dateFmt.format(_startDate)),
              onTap: _pickStartDate,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _autoPost,
              onChanged: (v) => setState(() => _autoPost = v),
              title: Text(l10n.recurringAutoPostLabel),
              subtitle: Text(l10n.recurringAutoPostSubtitle),
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

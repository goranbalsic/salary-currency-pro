import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/country.dart';
import '../../models/currency.dart';
import '../../models/expense_entry.dart';
import '../../models/fiscal_receipt_scan.dart';
import '../../services/expense_service.dart';
import '../../services/fiscal_receipt_scan_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';

/// PROMPT-003H checkpoint 3: reviews the local scan queue built by
/// [FiscalReceiptScanService] and lets the user turn an
/// [ScanQueueStatus.awaitingFetch] scan into a manual expense via the
/// existing [ExpenseService] — the only forward action available on a
/// queued item at this stage. Never performs network I/O and never shows a
/// status implying fiscal verification or automatic retrieval.
class FiscalReceiptQueueScreen extends StatefulWidget {
  const FiscalReceiptQueueScreen({super.key});

  @override
  State<FiscalReceiptQueueScreen> createState() => _FiscalReceiptQueueScreenState();
}

class _FiscalReceiptQueueScreenState extends State<FiscalReceiptQueueScreen> {
  final _service = FiscalReceiptScanService();
  List<FiscalReceiptScan> _scans = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    FiscalReceiptScanService.changes.addListener(_load);
  }

  @override
  void dispose() {
    FiscalReceiptScanService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final scans = await _service.loadAll();
    if (!mounted) return;
    setState(() {
      _scans = scans;
      _loaded = true;
    });
  }

  Future<void> _confirmDelete(FiscalReceiptScan scan) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.receiptQueueDeleteConfirmTitle),
        content: Text(l10n.receiptQueueDeleteConfirmBody),
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
    await _service.delete(scan.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.receiptQueueDeletedConfirmation),
        action: SnackBarAction(
          label: l10n.commonUndo,
          onPressed: () => _service.restore(scan),
        ),
      ),
    );
  }

  /// The manual expense handoff is the only forward action on a queued
  /// item, and only while it's still awaiting a manual expense — a scan
  /// already linked to an expense has no further action here, so it isn't
  /// tappable at all (see DECISIONS.md D-032 checkpoint 3).
  Future<void> _openHandoff(FiscalReceiptScan scan) async {
    if (scan.status != ScanQueueStatus.awaitingFetch) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ScanExpenseHandoffSheet(scan: scan),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptQueueScreenTitle)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : _scans.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 40,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.receiptQueueEmptyState,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: _scans.length,
                  itemBuilder: (context, index) => _QueueTile(
                    scan: _scans[index],
                    l10n: l10n,
                    onTap: () => _openHandoff(_scans[index]),
                    onDelete: () => _confirmDelete(_scans[index]),
                  ),
                ),
    );
  }
}

class _QueueTile extends StatelessWidget {
  final FiscalReceiptScan scan;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _QueueTile({
    required this.scan,
    required this.l10n,
    required this.onTap,
    required this.onDelete,
  });

  String get _statusLabel {
    if (scan.status == ScanQueueStatus.expenseCreated) {
      return l10n.receiptQueueStatusLinked;
    }
    if (scan.outcome == ReceiptScanOutcome.unknownFormat) {
      return l10n.receiptQueueUnrecognizedFormat;
    }
    return l10n.receiptScanStatusAwaitingFetch;
  }

  String get _truncatedPayload {
    const max = 48;
    return scan.rawPayload.length <= max
        ? scan.rawPayload
        : '${scan.rawPayload.substring(0, max)}…';
  }

  bool get _isLinked => scan.status == ScanQueueStatus.expenseCreated;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
        .add_Hm();
    final brightness = Theme.of(context).brightness;
    final statusColor = _isLinked
        ? AppColors.positiveAction(brightness)
        : AppColors.neutralAccent(brightness);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: _isLinked ? null : onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.12),
          child: Icon(
            _isLinked ? Icons.check_circle_outline : Icons.qr_code_2,
            color: statusColor,
          ),
        ),
        title: Text(_statusLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${l10n.receiptQueueScannedAt(dateFmt.format(scan.scannedAt))} · $_truncatedPayload',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          color: Theme.of(context).colorScheme.outline,
          onPressed: onDelete,
          tooltip: l10n.commonDelete,
        ),
      ),
    );
  }
}

/// Creates an [ExpenseEntry] from [scan] through the existing
/// [ExpenseService] — no parallel expense model — then links it back to the
/// scan via [FiscalReceiptScanService.linkExpense]. Only the scan's
/// timestamp is pre-filled (the only field the local classification already
/// deterministically provides); the amount is always typed by the user,
/// never inferred or fetched. Cancel/back leaves the scan record untouched
/// since nothing is written until [_save] runs.
class _ScanExpenseHandoffSheet extends StatefulWidget {
  final FiscalReceiptScan scan;

  const _ScanExpenseHandoffSheet({required this.scan});

  @override
  State<_ScanExpenseHandoffSheet> createState() => _ScanExpenseHandoffSheetState();
}

class _ScanExpenseHandoffSheetState extends State<_ScanExpenseHandoffSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _expenseService = ExpenseService();
  final _scanService = FiscalReceiptScanService();
  String _categoryId = ExpenseCategories.defaultFor(TransactionType.expense);
  String _currencyCode = 'EUR';
  late DateTime _date = widget.scan.scannedAt;
  AmountIssue? _issue;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultCurrency();
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
    final entry = await _expenseService.add(
      type: TransactionType.expense,
      categoryId: _categoryId,
      amount: result.value!,
      currencyCode: _currencyCode,
      date: _date,
      note: _noteCtrl.text.trim(),
    );
    await _scanService.linkExpense(id: widget.scan.id, expenseId: entry.id);
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
            Text(
              l10n.receiptHandoffTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.alertRed, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.receiptHandoffFromScanNote(dateFmt.format(widget.scan.scannedAt)),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('receipt_handoff_amount_field'),
                    controller: _amountCtrl,
                    autofocus: true,
                    cursorColor: AppColors.alertRed,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.expenseAmount,
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
                for (final id in ExpenseCategories.expenseIds)
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/currency.dart';
import '../../models/invoice.dart';
import '../../services/invoice_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';

/// A minimal, offline invoice ledger for freelancers/small businesses:
/// track what clients owe, mark invoices paid, and see totals at a glance.
/// No client accounts, no sending, no payment processing — a record you
/// keep yourself, same privacy model as every other local-only feature in
/// this app.
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

enum _InvoiceFilter { all, unpaid, overdue, paid }

class _InvoicesScreenState extends State<InvoicesScreen> {
  final _service = InvoiceService();
  final _notificationService = NotificationService();
  List<Invoice> _invoices = const [];
  bool _loaded = false;
  _InvoiceFilter _filter = _InvoiceFilter.all;

  @override
  void initState() {
    super.initState();
    _load();
    InvoiceService.changes.addListener(_load);
  }

  @override
  void dispose() {
    InvoiceService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final invoices = await _service.loadAll();
    if (!mounted) return;
    setState(() {
      _invoices = invoices;
      _loaded = true;
    });
  }

  List<Invoice> get _filtered {
    final now = DateTime.now();
    return switch (_filter) {
      _InvoiceFilter.all => _invoices,
      _InvoiceFilter.unpaid => _invoices.where((i) => !i.isPaid).toList(),
      _InvoiceFilter.overdue => _invoices.where((i) => i.isOverdueAsOf(now)).toList(),
      _InvoiceFilter.paid => _invoices.where((i) => i.isPaid).toList(),
    };
  }

  /// Outstanding (unpaid) totals per currency — the headline numbers a
  /// business owner actually needs: how much is owed, and how much of that
  /// is overdue.
  Map<String, ({double outstanding, double overdue})> get _totalsByCurrency {
    final now = DateTime.now();
    final result = <String, ({double outstanding, double overdue})>{};
    for (final i in _invoices.where((i) => !i.isPaid)) {
      final existing = result[i.currencyCode];
      final outstanding = (existing?.outstanding ?? 0) + i.amount;
      final overdue = (existing?.overdue ?? 0) + (i.isOverdueAsOf(now) ? i.amount : 0);
      result[i.currencyCode] = (outstanding: outstanding, overdue: overdue);
    }
    return result;
  }

  Future<void> _confirmDelete(Invoice invoice) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.invoiceDeleteConfirmTitle),
        content: Text(l10n.invoiceDeleteConfirmBody),
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
    if (confirmed == true) {
      await _service.delete(invoice.id);
      await _notificationService.cancelInvoiceReminder(invoice.id);
    }
  }

  Future<void> _togglePaid(AppLocalizations l10n, Invoice invoice) async {
    final nowPaid = !invoice.isPaid;
    await _service.markPaid(invoice.id, paid: nowPaid);
    if (nowPaid) {
      await _notificationService.cancelInvoiceReminder(invoice.id);
    } else {
      // Marked unpaid again — re-schedule if the due date still allows it;
      // scheduleInvoiceReminder itself no-ops for a moment already past.
      await _notificationService.scheduleInvoiceReminder(
        invoiceId: invoice.id,
        dueDate: invoice.dueDate,
        title: l10n.notifInvoiceDueNotifTitle,
        body: l10n.notifInvoiceDueNotifBody(
          invoice.clientName,
          NumberFormat.currency(symbol: '', decimalDigits: 2).format(invoice.amount),
          invoice.currencyCode,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.invoicesScreenTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _InvoiceFormSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                for (final entry in _totalsByCurrency.entries) ...[
                  _TotalsCard(currencyCode: entry.key, totals: entry.value, l10n: l10n),
                  const SizedBox(height: 12),
                ],
                if (_invoices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 40,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.invoicesEmptyState,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.invoiceFilterAll),
                        selected: _filter == _InvoiceFilter.all,
                        onSelected: (_) => setState(() => _filter = _InvoiceFilter.all),
                      ),
                      ChoiceChip(
                        label: Text(l10n.invoiceFilterUnpaid),
                        selected: _filter == _InvoiceFilter.unpaid,
                        onSelected: (_) => setState(() => _filter = _InvoiceFilter.unpaid),
                      ),
                      ChoiceChip(
                        label: Text(l10n.invoiceFilterOverdue),
                        selected: _filter == _InvoiceFilter.overdue,
                        onSelected: (_) => setState(() => _filter = _InvoiceFilter.overdue),
                      ),
                      ChoiceChip(
                        label: Text(l10n.invoiceFilterPaid),
                        selected: _filter == _InvoiceFilter.paid,
                        onSelected: (_) => setState(() => _filter = _InvoiceFilter.paid),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(child: Text(l10n.toolsSearchNoResults)),
                    )
                  else
                    for (final invoice in _filtered)
                      _InvoiceTile(
                        invoice: invoice,
                        l10n: l10n,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => _InvoiceFormSheet(existing: invoice),
                        ),
                        onTogglePaid: () => _togglePaid(l10n, invoice),
                        onDelete: () => _confirmDelete(invoice),
                      ),
                ],
              ],
            ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final String currencyCode;
  final ({double outstanding, double overdue}) totals;
  final AppLocalizations l10n;
  const _TotalsCard({required this.currencyCode, required this.totals, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '$currencyCode ', decimalDigits: 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.invoiceOutstanding, style: Theme.of(context).textTheme.bodySmall),
                Text(fmt.format(totals.outstanding),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              ],
            ),
            if (totals.overdue > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(l10n.invoiceOverdue,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.alertRed)),
                  Text(fmt.format(totals.overdue),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.alertRed)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback onTogglePaid;
  final VoidCallback onDelete;

  const _InvoiceTile({
    required this.invoice,
    required this.l10n,
    required this.onTap,
    required this.onTogglePaid,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = invoice.isOverdueAsOf(DateTime.now());
    final color = invoice.isPaid
        ? AppColors.moneyGreen
        : (overdue ? AppColors.alertRed : AppColors.gold);
    final statusLabel = invoice.isPaid
        ? l10n.invoiceStatusPaid
        : (overdue ? l10n.invoiceStatusOverdue : l10n.invoiceStatusUnpaid);
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(invoice.isPaid ? Icons.check : Icons.receipt_long, color: color),
        ),
        title: Text(invoice.clientName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${l10n.invoiceDueLabel} ${dateFmt.format(invoice.dueDate)} · $statusLabel',
          style: TextStyle(color: overdue && !invoice.isPaid ? AppColors.alertRed : null),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${fmt.format(invoice.amount)} ${invoice.currencyCode}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            IconButton(
              icon: Icon(invoice.isPaid ? Icons.undo : Icons.check_circle_outline, size: 20),
              tooltip: invoice.isPaid ? l10n.invoiceMarkUnpaid : l10n.invoiceMarkPaid,
              onPressed: onTogglePaid,
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

class _InvoiceFormSheet extends StatefulWidget {
  final Invoice? existing;
  const _InvoiceFormSheet({this.existing});

  @override
  State<_InvoiceFormSheet> createState() => _InvoiceFormSheetState();
}

class _InvoiceFormSheetState extends State<_InvoiceFormSheet> {
  late final _clientCtrl = TextEditingController(text: widget.existing?.clientName ?? '');
  late final _descriptionCtrl = TextEditingController(text: widget.existing?.description ?? '');
  late final _amountCtrl =
      TextEditingController(text: widget.existing == null ? '' : _plain(widget.existing!.amount));
  final _service = InvoiceService();
  final _notificationService = NotificationService();
  String _currencyCode = 'EUR';
  late DateTime _issueDate = widget.existing?.issueDate ?? DateTime.now();
  late DateTime _dueDate =
      widget.existing?.dueDate ?? DateTime.now().add(const Duration(days: 14));
  AmountIssue? _issue;

  bool get _isEditing => widget.existing != null;

  static String _plain(double v) => v == v.truncateToDouble() ? v.toInt().toString() : v.toString();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) _currencyCode = widget.existing!.currencyCode;
  }

  @override
  void dispose() {
    _clientCtrl.dispose();
    _descriptionCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDueDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _dueDate : _issueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    setState(() {
      if (isDueDate) {
        _dueDate = picked;
      } else {
        _issueDate = picked;
      }
    });
  }

  Future<void> _save() async {
    final result = parseAmountInput(_amountCtrl.text, allowZero: false);
    if (!result.isValid) {
      setState(() => _issue = result.issue);
      return;
    }
    final client = _clientCtrl.text.trim();
    if (client.isEmpty) return;

    String invoiceId;
    bool isPaid;
    if (_isEditing) {
      invoiceId = widget.existing!.id;
      isPaid = widget.existing!.isPaid;
      await _service.update(Invoice(
        id: invoiceId,
        schemaVersion: widget.existing!.schemaVersion,
        clientName: client,
        description: _descriptionCtrl.text.trim(),
        amount: result.value!,
        currencyCode: _currencyCode,
        issueDate: _issueDate,
        dueDate: _dueDate,
        isPaid: isPaid,
        paidDate: widget.existing!.paidDate,
      ));
    } else {
      isPaid = false;
      final created = await _service.add(
        clientName: client,
        description: _descriptionCtrl.text.trim(),
        amount: result.value!,
        currencyCode: _currencyCode,
        issueDate: _issueDate,
        dueDate: _dueDate,
      );
      invoiceId = created.id;
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (isPaid) {
      await _notificationService.cancelInvoiceReminder(invoiceId);
    } else {
      await _notificationService.scheduleInvoiceReminder(
        invoiceId: invoiceId,
        dueDate: _dueDate,
        title: l10n.notifInvoiceDueNotifTitle,
        body: l10n.notifInvoiceDueNotifBody(
          client,
          NumberFormat.currency(symbol: '', decimalDigits: 2).format(result.value!),
          _currencyCode,
        ),
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
              _isEditing ? l10n.invoiceEditTitle : l10n.invoiceAddTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('invoice_client_field'),
              controller: _clientCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.invoiceClientName),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionCtrl,
              decoration: InputDecoration(labelText: l10n.invoiceDescription),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('invoice_amount_field'),
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.invoiceAmount,
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
              leading: const Icon(Icons.event_available_outlined),
              title: Text(l10n.invoiceIssueDate),
              trailing: Text(dateFmt.format(_issueDate)),
              onTap: () => _pickDate(isDueDate: false),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.invoiceDueDate),
              trailing: Text(dateFmt.format(_dueDate)),
              onTap: () => _pickDate(isDueDate: true),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _save, child: Text(l10n.commonSave)),
          ],
        ),
      ),
    );
  }
}

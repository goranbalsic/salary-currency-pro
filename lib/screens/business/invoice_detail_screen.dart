import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/nbs_ips_eligibility.dart';
import '../../models/business_profile.dart';
import '../../models/invoice.dart';
import '../../pdf/invoice_pdf_content.dart';
import '../../services/business_profile_service.dart';
import '../../services/invoice_pdf_service.dart';
import '../../services/invoice_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import 'invoices_screen.dart' show InvoiceFormSheet;

/// The invoice detail journey (PROMPT-003 Stage C item 12.1-12.3): a
/// scannable identity/status header, an NBS IPS QR eligibility
/// explanation for Serbian RSD invoices, then a clear, limited action
/// hierarchy — Generate/Share PDF first (the document action this whole
/// feature is for), then edit and mark paid/unpaid, then delete last and
/// visually separated as the one destructive action.
class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final _service = InvoiceService();
  final _notificationService = NotificationService();
  final _businessProfileService = BusinessProfileService();
  final _pdfService = InvoicePdfService();
  Invoice? _invoice;
  BusinessProfile _profile = const BusinessProfile();
  bool _loaded = false;
  bool _pdfInFlight = false;

  @override
  void initState() {
    super.initState();
    _load();
    InvoiceService.changes.addListener(_load);
    BusinessProfileService.changes.addListener(_loadProfile);
  }

  @override
  void dispose() {
    InvoiceService.changes.removeListener(_load);
    BusinessProfileService.changes.removeListener(_loadProfile);
    super.dispose();
  }

  Future<void> _load() async {
    final all = await _service.loadAll();
    if (!mounted) return;
    final matches = all.where((i) => i.id == widget.invoiceId);
    if (matches.isEmpty) {
      // Deleted (from this screen or elsewhere) — nothing left to show.
      Navigator.of(context).maybePop();
      return;
    }
    final profile = await _businessProfileService.load();
    if (!mounted) return;
    setState(() {
      _invoice = matches.first;
      _profile = profile;
      _loaded = true;
    });
  }

  Future<void> _loadProfile() async {
    final profile = await _businessProfileService.load();
    if (!mounted) return;
    setState(() => _profile = profile);
  }

  Future<void> _togglePaid(AppLocalizations l10n) async {
    final invoice = _invoice;
    if (invoice == null) return;
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

  Future<void> _confirmDelete(AppLocalizations l10n) async {
    final invoice = _invoice;
    if (invoice == null) return;
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
    if (confirmed != true || !mounted) return;

    await _service.delete(invoice.id);
    await _notificationService.cancelInvoiceReminder(invoice.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _generatePdf(AppLocalizations l10n) async {
    final invoice = _invoice;
    // Guards against a rapid second tap starting a competing export while
    // one is already in flight — never mutates the stored invoice either
    // way, so a failed or repeated attempt can't corrupt/duplicate data.
    if (_pdfInFlight || invoice == null) return;
    setState(() => _pdfInFlight = true);

    try {
      final profile = await _businessProfileService.load();
      if (!mounted) return;
      final eligibility = NbsIpsEligibility.evaluate(invoice, profile);
      final content = buildInvoicePdfContent(
        invoice: invoice,
        profile: profile,
        localeCode: Localizations.localeOf(context).languageCode,
        statusLabels: InvoicePdfStatusLabels(
          paid: l10n.invoiceStatusPaid,
          unpaid: l10n.invoiceStatusUnpaid,
          overdue: l10n.invoiceStatusOverdue,
        ),
        tableLabels: InvoicePdfTableLabels(
          description: l10n.invoiceItemDescription,
          quantity: l10n.invoiceItemQuantity,
          unitPrice: l10n.invoiceItemUnitPrice,
          subtotal: l10n.invoiceItemSubtotal,
        ),
        // Only an eligible Serbian RSD invoice with fully valid payment
        // data gets a payload — every other invoice still gets a full,
        // professional PDF, just without a QR code.
        qrPayload: eligibility.isEligible ? eligibility.payload : null,
      );
      final bytes = await _pdfService.generate(content);
      if (!mounted) return;
      final filename = invoice.invoiceNumber.isNotEmpty
          ? '${invoice.invoiceNumber}.pdf'
          : 'invoice-${invoice.id}.pdf';
      await _pdfService.shareOrPrint(bytes, filename: filename);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.invoicePdfError)));
    } finally {
      if (mounted) setState(() => _pdfInFlight = false);
    }
  }

  void _openEditSheet() {
    final invoice = _invoice;
    if (invoice == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => InvoiceFormSheet(existing: invoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final invoice = _invoice;

    if (!_loaded || invoice == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final overdue = invoice.isOverdueAsOf(DateTime.now());
    final statusColor = invoice.isPaid
        ? AppColors.moneyGreen
        : (overdue ? AppColors.alertRed : AppColors.gold);
    final statusLabel = invoice.isPaid
        ? l10n.invoiceStatusPaid
        : (overdue ? l10n.invoiceStatusOverdue : l10n.invoiceStatusUnpaid);
    final amountFmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    final eligibility = NbsIpsEligibility.evaluate(invoice, _profile);

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.clientName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.invoiceEditTitle,
            onPressed: _openEditSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          invoice.clientName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text(
                            statusLabel,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (invoice.invoiceNumber.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      invoice.invoiceNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    '${amountFmt.format(invoice.amount)} ${invoice.currencyCode}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.event_available_outlined,
                    label: l10n.invoiceIssueDate,
                    value: dateFmt.format(invoice.issueDate),
                  ),
                  _DetailRow(
                    icon: Icons.event_outlined,
                    label: l10n.invoiceDueDate,
                    value: dateFmt.format(invoice.dueDate),
                    valueColor: overdue && !invoice.isPaid ? AppColors.alertRed : null,
                  ),
                  if (invoice.items.isNotEmpty) ...[
                    const Divider(height: 24),
                    for (final item in invoice.items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(item.description)),
                            Text(
                              '${_plainQuantity(item.quantity)} × '
                              '${amountFmt.format(item.unitPrice)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                  ] else if (invoice.description.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(invoice.description),
                  ],
                ],
              ),
            ),
          ),
          if (eligibility.reason != NbsIpsEligibilityReason.notRsd) ...[
            const SizedBox(height: 12),
            _QrEligibilityBanner(eligible: eligibility.isEligible, l10n: l10n),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pdfInFlight ? null : () => _generatePdf(l10n),
            icon: _pdfInFlight
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
            label: Text(l10n.invoiceGeneratePdf),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _togglePaid(l10n),
            icon: Icon(invoice.isPaid ? Icons.undo : Icons.check_circle_outline),
            label: Text(invoice.isPaid ? l10n.invoiceMarkUnpaid : l10n.invoiceMarkPaid),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () => _confirmDelete(l10n),
              icon: const Icon(Icons.delete_outline, color: AppColors.alertRed),
              label: Text(l10n.commonDelete, style: const TextStyle(color: AppColors.alertRed)),
            ),
          ),
        ],
      ),
    );
  }

  static String _plainQuantity(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
}

/// Eligibility transparency for the NBS IPS QR code (item 12.1's own
/// requirement): never a disabled/mysterious control, always plain text
/// explaining availability — and never shown at all for non-RSD invoices,
/// so non-Serbian users see nothing suggesting their invoice is deficient.
class _QrEligibilityBanner extends StatelessWidget {
  final bool eligible;
  final AppLocalizations l10n;

  const _QrEligibilityBanner({required this.eligible, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final color = eligible ? AppColors.moneyGreen : Theme.of(context).colorScheme.outline;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              eligible ? Icons.qr_code_2 : Icons.info_outline,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                eligible ? l10n.invoiceQrEligibleBody : l10n.invoiceQrIneligibleBody,
                style: TextStyle(fontSize: 12.5, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

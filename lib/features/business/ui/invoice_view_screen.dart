import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/ledger.dart';
import '../../../core/widgets/qr_view.dart';
import '../../../l10n/l10n.dart';
import '../../fx/data/rates_controller.dart';
import '../../reports/pdf_reports.dart';
import '../../settings/settings_controller.dart';
import '../data/business_store.dart';
import '../domain/invoice.dart';
import '../domain/invoice_qr.dart';
import '../domain/ips_qr.dart';
import '../domain/payment_details.dart';
import 'invoice_common.dart';
import 'invoice_editor_screen.dart';

enum _Menu { edit, duplicate, markUnpaid, cancel, delete }

class InvoiceViewScreen extends StatefulWidget {
  const InvoiceViewScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  State<InvoiceViewScreen> createState() => _InvoiceViewScreenState();
}

class _InvoiceViewScreenState extends State<InvoiceViewScreen> {
  bool _busy = false;
  bool _fetchingRate = false;

  BusinessStore get _store => context.read<BusinessStore>();

  Future<void> _edit(Invoice inv) async {
    await Navigator.of(context).push<Invoice>(MaterialPageRoute(builder: (_) => InvoiceEditorScreen(invoiceId: inv.id)));
  }

  Future<void> _duplicate(Invoice inv) async {
    if (!await ensureInvoiceQuota(context) || !mounted) return;
    final created = await Navigator.of(context).push<Invoice>(MaterialPageRoute(builder: (_) => InvoiceEditorScreen(duplicateOf: inv)));
    if (created == null || !mounted) return;
    await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => InvoiceViewScreen(invoiceId: created.id)));
  }

  Future<void> _setStatus(Invoice inv, InvoiceStatus status) async {
    final l = context.l10n;
    final before = inv;
    final today = DateTime.now();
    final updated = status == InvoiceStatus.paid
        ? inv.copyWith(status: status, paidDate: DateTime(today.year, today.month, today.day))
        : inv.copyWith(status: status, clearPaidDate: true);
    await _store.upsertInvoice(updated);
    if (!mounted) return;
    final message = switch (status) {
      InvoiceStatus.paid => l.invMarkedPaid,
      InvoiceStatus.issued => before.status == InvoiceStatus.draft ? l.invIssued : l.invMarkedUnpaid,
      InvoiceStatus.cancelled => l.invCancelled,
      InvoiceStatus.draft => l.snackSaved,
    };
    final store = _store;
    showSnack(
      context,
      message,
      action: SnackBarAction(label: l.actionUndo, onPressed: () => store.upsertInvoice(before)),
    );
  }

  Future<void> _issue(Invoice inv) async {
    if (!invoiceReadyToIssue(inv)) {
      showSnack(context, context.l10n.invCompleteFirst);
      await _edit(inv);
      return;
    }
    await _setStatus(inv, InvoiceStatus.issued);
  }

  Future<void> _cancel(Invoice inv) async {
    final l = context.l10n;
    final ok = await confirmDestructive(context, title: l.invCancelConfirm(inv.number), body: l.invCancelBody, action: l.invCancelInvoice);
    if (ok && mounted) await _setStatus(inv, InvoiceStatus.cancelled);
  }

  Future<void> _delete(Invoice inv) async {
    final l = context.l10n;
    final ok = await confirmDestructive(context, title: l.invDeleteConfirm(inv.number), action: l.actionDelete);
    if (!ok || !mounted) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await _store.deleteInvoice(inv.id);
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l.snackDeleted), duration: const Duration(seconds: 3)));
  }

  Future<void> _share(Invoice inv) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await shareInvoicePdf(context, inv);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _fetchRate(Invoice inv) async {
    final l = context.l10n;
    setState(() => _fetchingRate = true);
    try {
      final point = await context.read<RatesController>().nbsRateOn(inv.currency, inv.issueDate);
      if (!mounted) return;
      if (point == null) {
        showSnack(context, l.invRateUnavailable);
      } else {
        final current = _store.invoiceById(inv.id) ?? inv;
        await _store.upsertInvoice(current.copyWith(rsdRate: point.value, rsdRateDate: point.date));
      }
    } catch (_) {
      if (mounted) showSnack(context, l.invRateOffline);
    } finally {
      if (mounted) setState(() => _fetchingRate = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final business = context.watch<BusinessStore>();
    final serbian = context.select<SettingsController, bool>((s) => s.country.code == 'RS');
    final inv = business.invoiceById(widget.invoiceId);
    if (inv == null) return Scaffold(appBar: AppBar());
    final today = DateTime.now();
    final status = inv.status;

    final menu = <_Menu>[
      if (status != InvoiceStatus.cancelled) _Menu.edit,
      _Menu.duplicate,
      if (status == InvoiceStatus.paid) _Menu.markUnpaid,
      if (status == InvoiceStatus.issued || status == InvoiceStatus.paid) _Menu.cancel,
      _Menu.delete,
    ];

    final shareButton = OutlinedButton.icon(
      onPressed: _busy ? null : () => _share(inv),
      icon: _busy
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.picture_as_pdf_outlined, size: 20),
      label: ButtonLabel(l.invShare),
    );
    final actions = switch (status) {
      InvoiceStatus.draft => [
        OutlinedButton(onPressed: () => _edit(inv), child: ButtonLabel(l.actionEdit)),
        FilledButton(
          onPressed: () => _issue(inv),
          child: ButtonLabel(l.invIssue),
        ),
      ],
      InvoiceStatus.issued => [
        shareButton,
        FilledButton(
          onPressed: () => _setStatus(inv, InvoiceStatus.paid),
          child: ButtonLabel(l.invMarkPaid),
        ),
      ],
      InvoiceStatus.paid => [shareButton],
      InvoiceStatus.cancelled => [
        OutlinedButton(onPressed: () => _delete(inv), child: ButtonLabel(l.invDelete)),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(inv.number.isEmpty ? l.invDocTitle : inv.number),
        actions: [
          PopupMenuButton<_Menu>(
            tooltip: l.commonMore,
            onSelected: (m) => switch (m) {
              _Menu.edit => _edit(inv),
              _Menu.duplicate => _duplicate(inv),
              _Menu.markUnpaid => _setStatus(inv, InvoiceStatus.issued),
              _Menu.cancel => _cancel(inv),
              _Menu.delete => _delete(inv),
            },
            itemBuilder: (context) => [
              for (final m in menu)
                PopupMenuItem(
                  value: m,
                  child: Text(switch (m) {
                    _Menu.edit => l.actionEdit,
                    _Menu.duplicate => l.invDuplicate,
                    _Menu.markUnpaid => l.invMarkUnpaid,
                    _Menu.cancel => l.invCancelInvoice,
                    _Menu.delete => l.invDelete,
                  }),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActions(children: actions),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 32),
        children: [
          Row(
            children: [
              InvoiceStatusChip(invoice: inv, today: today),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  switch (status) {
                    InvoiceStatus.paid when inv.paidDate != null => l.invPaidOn(f.date(inv.paidDate!)),
                    InvoiceStatus.issued || InvoiceStatus.draft => l.invDueOn(f.date(inv.dueDate)),
                    _ => '',
                  },
                  style: t.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              f.money(inv.total, inv.currency),
              style: t.displayLarge!.copyWith(
                fontSize: 40,
                decoration: status == InvoiceStatus.cancelled ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(inv.client.name.isEmpty ? '—' : inv.client.name, style: t.titleMedium!.copyWith(color: c.ink2)),
          if (serbian && inv.currency != 'RSD') ...[
            const SizedBox(height: 10),
            if (inv.totalRsd != null)
              Text(
                '≈ ${f.money(inv.totalRsd!, 'RSD')} · ${l.invRateLine(f.rate(inv.rsdRate!), f.date(inv.rsdRateDate ?? inv.issueDate))}',
                style: t.bodySmall,
              )
            else
              InfoNote(l.invRateMissingNote, warning: true),
            if (inv.totalRsd == null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _fetchingRate ? null : () => _fetchRate(inv),
                  icon: _fetchingRate
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.refresh, size: 18),
                  label: Text(l.invRateRetry),
                ),
              ),
          ],
          const SizedBox(height: 20),
          InvoiceDocument(invoice: inv, profile: business.profile, serbian: serbian),
        ],
      ),
    );
  }
}

/// On-screen rendition of the invoice, mirroring the PDF's content.
class InvoiceDocument extends StatelessWidget {
  const InvoiceDocument({super.key, required this.invoice, required this.profile, required this.serbian});

  final Invoice invoice;
  final BusinessProfile profile;
  final bool serbian;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final inv = invoice;
    final cur = inv.currency;
    final seller = profile.party;
    final payment = PaymentDetails.of(profile, inv);
    final showQr = serbian && (inv.status == InvoiceStatus.issued || inv.status == InvoiceStatus.draft);
    final qr = showQr ? invoiceIpsQr(inv, profile, purposeLabel: l.invDocTitle) : null;

    Widget party(String title, InvoiceParty p, {bool seller = false}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Overline(title, padding: const EdgeInsets.only(bottom: 4)),
        Text(p.name.isEmpty ? '—' : p.name, style: t.titleMedium),
        for (final line in [p.address, p.city, if (!seller) p.country])
          if (line.trim().isNotEmpty) Text(line, style: t.bodySmall!.copyWith(color: c.ink2)),
        if (p.taxId.isNotEmpty) Text('${serbian ? l.invPib : l.profTaxIdGeneric}: ${p.taxId}', style: t.bodySmall!.copyWith(color: c.ink2)),
        if (p.registrationNo.isNotEmpty) Text('${serbian ? l.invMb : l.profRegNoGeneric}: ${p.registrationNo}', style: t.bodySmall!.copyWith(color: c.ink2)),
        if (p.email.isNotEmpty) Text(p.email, style: t.bodySmall!.copyWith(color: c.ink2)),
      ],
    );

    return Panel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: party(l.invSeller, seller, seller: true)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(l.invDocTitle.toUpperCase(), style: t.labelSmall!.copyWith(letterSpacing: 1.4)),
                  Text(inv.number, style: t.titleLarge),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: c.line),
          const SizedBox(height: 14),
          party(l.invBuyer, inv.client),
          const SizedBox(height: 14),
          _MetaGrid(
            rows: [
              (l.invIssueDate, f.date(inv.issueDate)),
              (l.invServiceDate, f.date(inv.serviceDate)),
              (l.invDueDate, f.date(inv.dueDate)),
              if (inv.place.isNotEmpty) (l.invPlaceLabel, inv.place),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1.2, color: c.ink),
          for (final item in inv.lines)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.line)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.description.isEmpty ? '—' : item.description, style: t.bodyMedium),
                        const SizedBox(height: 2),
                        Text(
                          '${f.number(item.quantity, decimals: _qtyDecimals(item.quantity))}${item.unit.isEmpty ? '' : ' ${item.unit}'} × ${f.money(item.unitPrice, cur)}'
                          '${inv.vatRegistered ? ' · ${l.invVat} ${f.percentValue(item.vatPercent, decimals: item.vatPercent == item.vatPercent.roundToDouble() ? 0 : 1)}' : ''}',
                          style: t.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(f.money(item.net, cur), style: t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular)),
                ],
              ),
            ),
          if (inv.vatRegistered) ...[
            LedgerRow(label: l.invSubtotal, value: f.money(inv.netTotal, cur)),
            LedgerRow(label: l.invVat, value: f.money(inv.vatTotal, cur), divider: false),
          ],
          LedgerTotal(label: l.invTotalDue, value: f.money(inv.total, cur)),
          if (serbian && cur != 'RSD' && inv.totalRsd != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${l.invTotalRsd}: ${f.money(inv.totalRsd!, 'RSD')} · ${l.invRateLine(f.rate(inv.rsdRate!), f.date(inv.rsdRateDate ?? inv.issueDate))}',
                style: t.bodySmall,
              ),
            ),
          if (!payment.isEmpty) ...[
            const SizedBox(height: 6),
            _MetaGrid(
              rows: [
                if (payment.account != null) (l.invAccount, payment.account!),
                if (payment.iban != null) (l.invIban, payment.iban!),
                if (payment.swift != null) (l.invSwift, payment.swift!),
                if (payment.bank != null) (l.invBank, payment.bank!),
                if (payment.reference != null) (l.invReferenceLabel, payment.reference!),
              ],
            ),
          ],
          if (qr != null) ...[
            const SizedBox(height: 16),
            if (qr.payload != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrView(data: qr.payload!, size: 132, semanticLabel: l.invQrCaption),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.invQrCaption, style: t.titleSmall),
                        const SizedBox(height: 4),
                        Text(l.invQrHint, style: t.bodySmall),
                      ],
                    ),
                  ),
                ],
              )
            else
              InfoNote(l.invQrMissing(qr.errors.contains(IpsQrError.account) ? l.invQrReasonAccount : l.invQrReasonOther)),
          ],
          if (inv.note.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(inv.note, style: t.bodySmall!.copyWith(color: c.ink)),
          ],
          const SizedBox(height: 16),
          if (!inv.vatRegistered) Text(l.invNotInVat, style: t.bodySmall),
          Text(l.invValidWithoutStamp, style: t.bodySmall),
        ],
      ),
    );
  }

  static int _qtyDecimals(double q) {
    if (q == q.roundToDouble()) return 0;
    final s = q.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '');
    return s.length - s.indexOf('.') - 1;
  }
}

class _MetaGrid extends StatelessWidget {
  const _MetaGrid({required this.rows});
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    return Column(
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 118,
                  child: Text(label, style: t.bodySmall!.copyWith(color: c.ink2)),
                ),
                Expanded(child: SelectableText(value, style: t.bodyMedium)),
              ],
            ),
          ),
      ],
    );
  }
}

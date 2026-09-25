import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_config.dart';
import '../../../core/design/tokens.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../data/business_store.dart';
import '../domain/invoice.dart';

String invoiceStatusLabel(AppLocalizations l, Invoice inv, DateTime today) {
  if (inv.isOverdue(today)) return l.statusOverdue;
  return switch (inv.status) {
    InvoiceStatus.draft => l.statusDraft,
    InvoiceStatus.issued => l.statusIssued,
    InvoiceStatus.paid => l.statusPaid,
    InvoiceStatus.cancelled => l.statusCancelled,
  };
}

/// True when another invoice may be created: always with Pro, otherwise
/// while the free quota lasts (the paywall is offered when it runs out).
Future<bool> ensureInvoiceQuota(BuildContext context) async {
  final business = context.read<BusinessStore>();
  final pro = context.read<ProController>();
  if (pro.can(ProFeature.unlimitedInvoices) || business.createdCount < AppConfig.freeInvoiceLimit) return true;
  return requirePro(context, ProFeature.unlimitedInvoices);
}

/// Whether a draft has what an issued invoice needs.
bool invoiceReadyToIssue(Invoice inv) =>
    inv.client.name.trim().isNotEmpty &&
    inv.number.trim().isNotEmpty &&
    inv.items.any((i) => i.description.trim().isNotEmpty && i.unitPrice > 0 && i.quantity > 0);

class InvoiceStatusChip extends StatelessWidget {
  const InvoiceStatusChip({super.key, required this.invoice, required this.today});

  final Invoice invoice;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final overdue = invoice.isOverdue(today);
    final (bg, fg) = switch (invoice.status) {
      InvoiceStatus.paid => (c.greenTint, c.positive),
      InvoiceStatus.issued when overdue => (c.warningTint, c.brick),
      InvoiceStatus.issued => (c.brassTint, c.brassText),
      InvoiceStatus.draft => (c.sunken, c.ink2),
      InvoiceStatus.cancelled => (c.sunken, c.ink2),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Text(invoiceStatusLabel(context.l10n, invoice, today), style: t.labelSmall!.copyWith(color: fg, letterSpacing: 0.2)),
    );
  }
}

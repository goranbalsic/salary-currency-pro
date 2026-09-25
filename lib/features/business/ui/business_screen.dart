import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_config.dart';
import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../home/catalog.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../settings/settings_controller.dart';
import '../data/business_store.dart';
import '../domain/invoice.dart';
import '../domain/pausal.dart';
import 'invoice_editor_screen.dart';
import 'invoice_view_screen.dart';
import 'invoices_list_screen.dart';
import 'pausal_screen.dart';
import 'profile_screen.dart';

String invoiceStatusLabel(AppLocalizations l, Invoice inv, DateTime today) {
  if (inv.isOverdue(today)) return l.statusOverdue;
  return switch (inv.status) {
    InvoiceStatus.draft => l.statusDraft,
    InvoiceStatus.issued => l.statusIssued,
    InvoiceStatus.paid => l.statusPaid,
    InvoiceStatus.cancelled => l.statusCancelled,
  };
}

/// Starts a new invoice, enforcing the free quota and the profile setup.
Future<void> startNewInvoice(BuildContext context) async {
  final business = context.read<BusinessStore>();
  final pro = context.read<ProController>();
  if (!pro.can(ProFeature.unlimitedInvoices) && business.createdCount >= AppConfig.freeInvoiceLimit) {
    final ok = await requirePro(context, ProFeature.unlimitedInvoices);
    if (!ok || !context.mounted) return;
  }
  if (business.profile.isEmpty) {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const ProfileScreen(firstRun: true)));
    if (saved != true || !context.mounted) return;
  }
  final created = await Navigator.of(context).push<Invoice>(MaterialPageRoute(builder: (_) => const InvoiceEditorScreen()));
  if (created != null && context.mounted) {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => InvoiceViewScreen(invoiceId: created.id)));
  }
}

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final business = context.watch<BusinessStore>();
    final pro = context.watch<ProController>();
    final country = context.select<SettingsController, String>((s) => s.country.code);
    final today = DateTime.now();
    final invoices = business.invoices;
    final freeLeft = AppConfig.freeInvoiceLimit - business.createdCount;
    final tools = [Tool.vat, Tool.margin, Tool.breakEven, Tool.investment];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageBody(
          padding: const EdgeInsets.fromLTRB(Gap.page, 16, Gap.page, 40),
          children: [
            ScreenHeader(
              title: l.bizTitle,
              trailing: IconButton.outlined(
                tooltip: l.bizProfile,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen())),
                style: IconButton.styleFrom(
                  backgroundColor: c.surface,
                  side: BorderSide(color: c.line),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
                ),
                icon: const Icon(Icons.storefront_outlined),
              ),
            ),
            if (country == 'RS') ...[const SizedBox(height: 18), _PausalCard(locked: !pro.can(ProFeature.pausalTracker))],
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.ink))),
              child: Row(
                children: [
                  Expanded(child: Text(l.bizInvoices, style: t.titleLarge)),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 40), padding: const EdgeInsets.symmetric(horizontal: 14), shape: const StadiumBorder()),
                    onPressed: () => startNewInvoice(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l.bizNewInvoice),
                  ),
                ],
              ),
            ),
            if (!pro.can(ProFeature.unlimitedInvoices) && freeLeft > 0)
              Padding(padding: const EdgeInsets.only(top: 8), child: Text(l.bizFreeLeft(freeLeft), style: t.bodySmall)),
            if (invoices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(l.bizInvoicesEmpty, style: t.bodyMedium!.copyWith(color: c.ink2)),
              )
            else ...[
              for (final inv in invoices.take(5)) InvoiceRow(invoice: inv, today: today),
              if (invoices.length > 5)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const InvoicesListScreen())),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(l.bizShowAll(invoices.length)),
                  ),
                ),
            ],
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.ink))),
              child: Overline(l.bizTools),
            ),
            for (final tool in tools)
              InkWell(
                onTap: () => openTool(context, tool),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 60),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.title(l), style: t.titleMedium),
                              const SizedBox(height: 2),
                              Text(tool.description(l, country), style: t.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      if (tool.pro != null && !pro.can(tool.pro!)) const ProBadge(),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 20, color: c.ink3),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(f.date(today), style: t.bodySmall!.copyWith(color: Colors.transparent)),
          ],
        ),
      ),
    );
  }
}

class InvoiceRow extends StatelessWidget {
  const InvoiceRow({super.key, required this.invoice, required this.today});
  final Invoice invoice;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final overdue = invoice.isOverdue(today);
    final (bg, fg) = switch (invoice.status) {
      InvoiceStatus.paid => (c.greenTint, c.positive),
      InvoiceStatus.issued when overdue => (c.warningTint, c.brick),
      InvoiceStatus.issued => (c.brassTint, c.brassText),
      InvoiceStatus.draft => (c.sunken, c.ink2),
      InvoiceStatus.cancelled => (c.sunken, c.ink2),
    };
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => InvoiceViewScreen(invoiceId: invoice.id))),
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invoice.client.name.isEmpty ? '—' : invoice.client.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('${invoice.number} · ${f.shortDate(invoice.issueDate)}', style: t.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  f.money(invoice.total, invoice.currency),
                  style: t.titleLarge!.copyWith(
                    fontSize: 17,
                    decoration: invoice.status == InvoiceStatus.cancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
                  child: Text(invoiceStatusLabel(l, invoice, today), style: t.labelSmall!.copyWith(color: fg, letterSpacing: 0.2)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PausalCard extends StatelessWidget {
  const _PausalCard({required this.locked});
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final business = context.watch<BusinessStore>();
    final revenue = business.revenue();
    final status = PausalTracker.compute(revenue.entries, DateTime.now());
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.xl),
      onTap: () async {
        if (!await requirePro(context, ProFeature.pausalTracker) || !context.mounted) return;
        await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PausalScreen()));
      },
      child: Panel(
        radius: Radii.xl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.bizPausalCard(status.year), style: t.titleLarge!.copyWith(fontSize: 20))),
                if (locked) const ProBadge() else Icon(Icons.chevron_right, color: c.ink3),
              ],
            ),
            const SizedBox(height: 14),
            PausalMeter(
              label: l.pausalAnnual,
              value: status.yearToDate,
              limit: PausalLimits.annualLimitRsd,
              color: c.chart1,
              blurred: locked,
            ),
            const SizedBox(height: 14),
            PausalMeter(
              label: l.pausalVat,
              value: status.last12Months,
              limit: PausalLimits.vatLimitRsd,
              color: c.chart3,
              blurred: locked,
            ),
            if (!locked && status.projectedYearEnd != null) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: c.line),
              const SizedBox(height: 10),
              Text(
                status.projectedOverAnnual
                    ? l.pausalProjectionOver(f.money(status.projectedYearEnd!, 'RSD', decimals: 0))
                    : l.pausalProjection(f.money(status.projectedYearEnd!, 'RSD', decimals: 0)),
                style: t.bodySmall!.copyWith(color: status.projectedOverAnnual ? c.brick : c.ink2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PausalMeter extends StatelessWidget {
  const PausalMeter({super.key, required this.label, required this.value, required this.limit, required this.color, this.blurred = false});

  final String label;
  final double value;
  final double limit;
  final Color color;
  final bool blurred;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final share = limit <= 0 ? 0.0 : (value / limit);
    final fill = blurred ? 0.0 : share.clamp(0.0, 1.0);
    final over = share >= 1;
    final warn = share >= PausalLimits.warnShare;
    return Semantics(
      label: '$label: ${f.money(value, 'RSD', decimals: 0)} ${l.pausalOf(f.money(limit, 'RSD', decimals: 0))}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: t.bodyMedium)),
              if (!blurred) Text(f.percent(share), style: t.bodySmall!.copyWith(color: over ? c.brick : c.ink2, fontFeatures: Fonts.tabular)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Container(height: 10, color: c.sunken),
                FractionallySizedBox(
                  widthFactor: fill,
                  child: Container(height: 10, decoration: BoxDecoration(color: over ? c.brick : color, borderRadius: BorderRadius.circular(5))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  blurred ? '•••' : f.money(value, 'RSD', decimals: 0),
                  style: t.titleSmall!.copyWith(fontFamily: Fonts.serif, fontFeatures: Fonts.tabular, fontSize: 16),
                ),
              ),
              Text(l.pausalOf(f.number(limit, decimals: 0)), style: t.bodySmall),
            ],
          ),
          if (!blurred && (over || warn)) ...[
            const SizedBox(height: 6),
            Text(over ? l.pausalOver : l.pausalWarn, style: t.bodySmall!.copyWith(color: over ? c.brick : c.warning)),
          ],
        ],
      ),
    );
  }
}

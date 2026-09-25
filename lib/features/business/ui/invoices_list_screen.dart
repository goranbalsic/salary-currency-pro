import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../data/business_store.dart';
import '../domain/invoice.dart';
import 'business_screen.dart';

enum _Filter { all, unpaid, overdue, paid, drafts }

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  _Filter _filter = _Filter.all;
  String _query = '';

  bool _matches(Invoice inv, DateTime today) {
    final ok = switch (_filter) {
      _Filter.all => true,
      _Filter.unpaid => inv.status == InvoiceStatus.issued,
      _Filter.overdue => inv.isOverdue(today),
      _Filter.paid => inv.status == InvoiceStatus.paid,
      _Filter.drafts => inv.status == InvoiceStatus.draft,
    };
    if (!ok) return false;
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return inv.client.name.toLowerCase().contains(q) || inv.number.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final business = context.watch<BusinessStore>();
    final today = DateTime.now();
    final all = business.invoices;
    final shown = all.where((i) => _matches(i, today)).toList();

    // Outstanding (issued, unpaid) totals per currency.
    final outstanding = <String, List<double>>{};
    for (final inv in all.where((i) => i.status == InvoiceStatus.issued)) {
      outstanding.putIfAbsent(inv.currency, () => []).add(inv.total);
    }
    final outstandingText = [
      for (final e in outstanding.entries) f.money(Money.sum(e.value), e.key),
    ].join(' · ');

    String label(_Filter x) => switch (x) {
          _Filter.all => l.invsFilterAll,
          _Filter.unpaid => l.statusIssued,
          _Filter.overdue => l.statusOverdue,
          _Filter.paid => l.statusPaid,
          _Filter.drafts => l.invsFilterDrafts,
        };

    return Scaffold(
      appBar: AppBar(
        title: Text(l.bizInvoices),
        actions: [
          IconButton(tooltip: l.invNew, onPressed: () => startNewInvoice(context), icon: const Icon(Icons.add)),
        ],
      ),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 4, Gap.page, 32),
        children: [
          if (outstandingText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Panel(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.invsOutstanding, style: t.bodySmall),
                    const SizedBox(height: 4),
                    Text(outstandingText, style: t.titleLarge!.copyWith(fontSize: 19)),
                  ],
                ),
              ),
            ),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l.invsSearchHint,
              prefixIcon: Icon(Icons.search, color: c.ink2),
              filled: true,
              fillColor: c.sunken,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final x in _Filter.values) ...[
                  PillChip(label: label(x), selected: _filter == x, onTap: () => setState(() => _filter = x)),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(all.isEmpty ? l.bizInvoicesEmpty : l.invsNoMatch, textAlign: TextAlign.center, style: t.bodyMedium!.copyWith(color: c.ink2)),
            )
          else
            for (final inv in shown) InvoiceRow(invoice: inv, today: today),
        ],
      ),
    );
  }
}

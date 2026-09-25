import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../data/business_store.dart';
import '../domain/pausal.dart';
import 'business_screen.dart';

const _roman = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'];

class PausalScreen extends StatelessWidget {
  const PausalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final business = context.watch<BusinessStore>();
    final now = DateTime.now();
    final revenue = business.revenue();
    final status = PausalTracker.compute(revenue.entries, now);
    String rsd(double v) => f.money(v, 'RSD', decimals: 0);

    // Monthly split for the current year: invoices vs. revenue added by hand.
    final fromInvoices = List<List<double>>.generate(12, (_) => []);
    final fromManual = List<List<double>>.generate(12, (_) => []);
    for (final inv in business.invoices) {
      final v = inv.totalRsd;
      if (!inv.countsAsRevenue || v == null || inv.serviceDate.year != now.year) continue;
      fromInvoices[inv.serviceDate.month - 1].add(v);
    }
    for (final m in business.manualRevenue) {
      if (m.date.year != now.year) continue;
      fromManual[m.date.month - 1].add(m.amountRsd);
    }
    final columns = [
      for (var i = 0; i < 12; i++) StackedColumn(label: _roman[i], bottom: Money.sum(fromInvoices[i]), top: Money.sum(fromManual[i])),
    ];
    final hasMonthly = columns.any((col) => col.bottom + col.top > 0);
    final monthsLeft = 12 - now.month + 1;
    final monthlyRoom = status.annualRemaining > 0 ? status.annualRemaining / monthsLeft : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(l.pausalTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          FinePrint(l.pausalIntro),
          const SizedBox(height: 18),
          Panel(
            radius: Radii.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PausalMeter(label: l.pausalAnnual, value: status.yearToDate, limit: PausalLimits.annualLimitRsd, color: c.chart1),
                const SizedBox(height: 6),
                Text(l.pausalLeft(rsd(status.annualRemaining)), style: t.bodySmall!.copyWith(color: c.ink2)),
                const SizedBox(height: 18),
                PausalMeter(label: l.pausalVat, value: status.last12Months, limit: PausalLimits.vatLimitRsd, color: c.chart3),
                const SizedBox(height: 6),
                Text(l.pausalLeft(rsd(status.vatRemaining)), style: t.bodySmall!.copyWith(color: c.ink2)),
              ],
            ),
          ),
          if (status.projectedYearEnd != null || monthlyRoom > 0) ...[
            const SizedBox(height: 14),
            if (status.projectedYearEnd != null)
              InfoNote(
                status.projectedOverAnnual ? l.pausalProjectionOver(rsd(status.projectedYearEnd!)) : l.pausalProjection(rsd(status.projectedYearEnd!)),
                icon: Icons.trending_up,
                warning: status.projectedOverAnnual,
              ),
            if (monthlyRoom > 0 && now.month < 12) ...[
              const SizedBox(height: 8),
              InfoNote(l.pausalMonthlyRoom(rsd(monthlyRoom)), icon: Icons.calendar_month_outlined),
            ],
          ],
          if (revenue.missingRate > 0) ...[
            const SizedBox(height: 8),
            InfoNote(l.pausalMissingRate(revenue.missingRate), warning: true),
          ],
          if (hasMonthly) ...[
            const SizedBox(height: 26),
            SectionTitle(l.pausalByMonth(now.year)),
            StackedColumns(
              columns: columns,
              bottomColor: c.chart1,
              topColor: c.chart4,
              bottomLabel: l.pausalFromInvoices,
              topLabel: l.pausalManual,
              format: rsd,
              height: 150,
            ),
          ],
          const SizedBox(height: 26),
          SectionTitle(
            l.pausalManual,
            trailing: TextButton.icon(
              onPressed: () => _addRevenue(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.pausalManualAdd),
            ),
          ),
          if (business.manualRevenue.isEmpty)
            Text(l.pausalManualEmpty, style: t.bodyMedium!.copyWith(color: c.ink2))
          else
            for (final m in business.manualRevenue)
              LedgerRow(
                label: f.date(m.date),
                note: m.note.isEmpty ? null : m.note,
                value: rsd(m.amountRsd),
                onTap: () => _confirmRemove(context, m),
              ),
          const SizedBox(height: 18),
          FinePrint(l.pausalSourceInvoices),
          const SizedBox(height: 6),
          FinePrint(l.pausalDisclaimer),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, ManualRevenue m) async {
    final l = context.l10n;
    final f = context.fmt;
    final store = context.read<BusinessStore>();
    final ok = await confirmDestructive(
      context,
      title: l.pausalRemoveTitle,
      body: '${f.date(m.date)} · ${f.money(m.amountRsd, 'RSD', decimals: 0)}${m.note.isEmpty ? '' : ' · ${m.note}'}',
      action: l.actionRemove,
    );
    if (!ok) return;
    await store.removeManual(m.id);
    if (context.mounted) {
      showSnack(
        context,
        l.snackDeleted,
        action: SnackBarAction(label: l.actionUndo, onPressed: () => store.addManual(m.date, m.amountRsd, m.note)),
      );
    }
  }

  Future<void> _addRevenue(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddRevenueSheet(),
    );
  }
}

class _AddRevenueSheet extends StatefulWidget {
  const _AddRevenueSheet();

  @override
  State<_AddRevenueSheet> createState() => _AddRevenueSheetState();
}

class _AddRevenueSheetState extends State<_AddRevenueSheet> {
  late DateTime _date;
  double? _amount;
  final _note = TextEditingController();
  bool _tried = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _tried = true);
    final amount = _amount;
    if (amount == null || amount <= 0) return;
    await context.read<BusinessStore>().addManual(_date, Money.round(amount), _note.text.trim());
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final today = DateTime.now();
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.pausalManualAdd, style: t.titleLarge),
            const SizedBox(height: 16),
            DateBox(
              label: l.pausalManualDate,
              value: _date,
              firstDate: DateTime(today.year - 2),
              lastDate: DateTime(today.year, today.month, today.day),
              onChanged: (d) => setState(() => _date = d),
            ),
            const SizedBox(height: 12),
            NumberBox(
              label: l.pausalManualAmount,
              value: _amount,
              formats: f,
              suffixText: 'RSD',
              errorText: _tried && (_amount ?? 0) <= 0 ? l.pausalManualAmountError : null,
              onChanged: (v) => setState(() => _amount = v),
            ),
            const SizedBox(height: 12),
            TextBox(
              controller: _note,
              label: l.pausalManualNote,
              maxLength: 80,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: _save, child: Text(l.actionSave)),
          ],
        ),
      ),
    );
  }
}

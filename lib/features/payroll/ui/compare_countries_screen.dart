import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../fx/data/rates_controller.dart';
import '../../fx/domain/rates.dart';
import '../../fx/ui/currency_sheet.dart';
import '../../settings/settings_controller.dart';
import '../domain/payroll_engine.dart';
import '../domain/payroll_models.dart';

/// One system's outcome, converted to the comparison currency.
class CountryComparison {
  const CountryComparison({required this.system, required this.gross, required this.net, required this.totalCost, required this.wedge});

  final PayrollSystem system;
  final double gross;
  final double net;
  final double totalCost;
  final double wedge;
}

/// Runs [amount] (in [currency], as [mode]) through every payroll system
/// with default options. Systems whose currency has no rate are skipped.
List<CountryComparison> compareCountries(RateBook book, PayrollInputMode mode, double amount, String currency) {
  const engine = PayrollEngine();
  final out = <CountryComparison>[];
  for (final s in PayrollSystem.values) {
    final toLocal = book.rate(currency, s.currency);
    final back = book.rate(s.currency, currency);
    if (toLocal == null || back == null) continue;
    final local = amount * toLocal.rate;
    if (!local.isFinite || local <= 0 || local > PayrollEngine.maxAmount) continue;
    try {
      final r = engine.compute(s, mode, local);
      out.add(CountryComparison(
        system: s,
        gross: r.gross * back.rate,
        net: r.net * back.rate,
        totalCost: r.totalCost * back.rate,
        wedge: r.taxWedge,
      ));
    } on PayrollSolveException {
      continue;
    }
  }
  // Rank by what the mode holds constant: most net for the same gross or
  // budget; lowest employer cost for the same net.
  out.sort((a, b) => mode == PayrollInputMode.net ? a.totalCost.compareTo(b.totalCost) : b.net.compareTo(a.net));
  return out;
}

class CompareCountriesScreen extends StatefulWidget {
  const CompareCountriesScreen({super.key});

  @override
  State<CompareCountriesScreen> createState() => _CompareCountriesScreenState();
}

class _CompareCountriesScreenState extends State<CompareCountriesScreen> {
  static const _key = 'payroll.compare.v1';
  static const _currencies = ['EUR', 'RSD', 'BAM', 'MKD', 'RON', 'USD', 'CHF', 'GBP'];

  PayrollInputMode _mode = PayrollInputMode.gross;
  double? _amount = 2000;
  String _currency = 'EUR';
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final raw = context.read<AppServices>().store.readJson(_key);
    if (raw is Map) {
      _mode = PayrollInputMode.values.where((m) => m.name == raw['mode']).firstOrNull ?? _mode;
      final a = raw['amount'];
      _amount = a is num && a.isFinite && a > 0 ? a.toDouble() : null;
      if (raw['currency'] is String && _currencies.contains(raw['currency'])) _currency = raw['currency'] as String;
    }
    // Rates may be stale or missing when this opens straight from Home.
    // Deferred: the controller notifies listeners, not allowed mid-build.
    final rates = context.read<RatesController>();
    scheduleMicrotask(() => unawaited(rates.refresh()));
  }

  void _save() {
    unawaited(context.read<AppServices>().store.writeJson(_key, {'mode': _mode.name, 'amount': _amount, 'currency': _currency}));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final rates = context.watch<RatesController>();
    final home = context.select<SettingsController, String>((s) => s.country.code);
    final amount = _amount;
    final results = amount == null || amount <= 0 ? const <CountryComparison>[] : compareCountries(rates.book, _mode, amount, _currency);
    // Whole units: after currency conversion, cents would be false precision.
    String money(double v) => f.money(v, _currency, decimals: 0);
    final label = switch (_mode) {
      PayrollInputMode.gross => l.payInputGross,
      PayrollInputMode.net => l.payInputNet,
      PayrollInputMode.totalCost => l.payInputCost,
    };
    final maxCost = results.fold<double>(0, (m, r) => r.totalCost > m ? r.totalCost : m);
    final rateDate = rates.book.ecb?.date ?? rates.book.nbs?.date;

    return Scaffold(
      appBar: AppBar(title: Text(l.toolCompare)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          Segmented<PayrollInputMode>(
            values: PayrollInputMode.values,
            selected: _mode,
            semanticLabel: l.payModeSemantic,
            labelOf: (m) => switch (m) {
              PayrollInputMode.gross => l.payModeGross,
              PayrollInputMode.net => l.payModeNet,
              PayrollInputMode.totalCost => l.payModeCost,
            },
            onChanged: (m) {
              setState(() => _mode = m);
              _save();
            },
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AmountField(
                  label: label,
                  value: _amount,
                  formats: f,
                  decimals: Formats.currencyDecimals(_currency),
                  onChanged: (v) {
                    setState(() => _amount = v);
                    _save();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final picked = await showCurrencySheet(context, current: _currency, available: _currencies, pinned: _currencies.take(4).toList());
                    if (picked == null) return;
                    setState(() => _currency = picked);
                    _save();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(children: [CodeTile(_currency, width: 42), Icon(Icons.expand_more, size: 18, color: c.ink2)]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (rates.book.isEmpty)
            InfoNote(l.cmpNeedsRates, warning: true)
          else if (results.isEmpty)
            FinePrint(l.payEmpty)
          else ...[
            Row(
              children: [
                Expanded(child: Overline(_mode == PayrollInputMode.net ? l.cmpRankedByCost : l.cmpRankedByNet)),
                Text(_mode == PayrollInputMode.net ? l.payTotalCost : l.payNetTotal, style: t.labelSmall),
              ],
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < results.length; i++)
              _CompareRow(
                rank: i + 1,
                item: results[i],
                home: results[i].system.countryCode == home,
                primary: money(_mode == PayrollInputMode.net ? results[i].totalCost : results[i].net),
                secondary: _mode == PayrollInputMode.gross
                    ? l.cmpCostLine(money(results[i].totalCost), f.percent(results[i].wedge))
                    : l.cmpGrossLine(money(results[i].gross), f.percent(results[i].wedge)),
                netShare: maxCost <= 0 ? 0 : results[i].net / maxCost,
                costShare: maxCost <= 0 ? 0 : results[i].totalCost / maxCost,
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                _Key(color: c.chart1, label: l.segNet),
                const SizedBox(width: 16),
                _Key(color: c.sunken, label: l.cmpTaxesKey, border: c.line),
              ],
            ),
            const SizedBox(height: 16),
            FinePrint(l.cmpNote(rateDate == null ? '—' : f.date(rateDate))),
          ],
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.rank,
    required this.item,
    required this.home,
    required this.primary,
    required this.secondary,
    required this.netShare,
    required this.costShare,
  });

  final int rank;
  final CountryComparison item;
  final bool home;
  final String primary;
  final String secondary;
  final double netShare;
  final double costShare;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                child: Text('$rank', style: t.bodySmall!.copyWith(fontFamily: Fonts.serif, fontFeatures: Fonts.tabular)),
              ),
              CodeTile(item.system.countryCode, accent: home),
              const SizedBox(width: 10),
              Expanded(child: Text(l.systemName(item.system), style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              Text(primary, style: t.titleLarge!.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bar: total cost as the track, net pay as the fill.
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    return SizedBox(
                      height: 8,
                      child: Stack(
                        children: [
                          Container(
                            width: w * costShare.clamp(0.0, 1.0),
                            decoration: BoxDecoration(color: c.sunken, borderRadius: BorderRadius.circular(4), border: Border.all(color: c.line)),
                          ),
                          Container(
                            width: w * netShare.clamp(0.0, 1.0),
                            decoration: BoxDecoration(color: c.chart1, borderRadius: BorderRadius.circular(4)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(secondary, style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.color, required this.label, this.border});
  final Color color;
  final String label;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3), border: border == null ? null : Border.all(color: border!)),
        ),
        const SizedBox(width: 6),
        Text(label, style: t.bodySmall),
      ],
    );
  }
}

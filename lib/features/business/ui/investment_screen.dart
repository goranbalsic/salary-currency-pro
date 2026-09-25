import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../history/calc_state.dart';
import '../../history/history_store.dart';
import '../../history/save_dialog.dart';
import '../../settings/settings_controller.dart';
import '../domain/business_math.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({super.key, this.initial});

  final Map<String, Object?>? initial;

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> with CalcState<InvestmentScreen> {
  @override
  ToolId get toolId => ToolId.investment;
  @override
  String get storeKey => 'calc.investment.v1';

  static const maxYears = 30;

  double? _initial;
  double? _rate = 8;
  List<double?> _flows = [null, null, null, null, null];

  late String _currency;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _currency = context.read<SettingsController>().homeCurrency;
    final init = initialInputs(widget.initial);
    if (init != null) {
      _initial = readDouble(init, 'initial');
      _rate = readDouble(init, 'rate');
      final flows = init['flows'];
      if (flows is List && flows.isNotEmpty) {
        _flows = [for (final v in flows.take(maxYears)) v is num && v.isFinite ? v.toDouble() : null];
      }
      if (init['currency'] is String) _currency = init['currency'] as String;
    }
  }

  Map<String, Object?> get _json => {'initial': _initial, 'rate': _rate, 'flows': _flows, 'currency': _currency};

  bool get _ready => (_initial ?? 0) > 0 && _rate != null && _flows.any((v) => v != null && v != 0);

  void _changed() {
    setState(() {});
    persistInputs(_json, complete: _ready);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final cur = _currency;
    final symbol = f.currencySymbol(cur);
    final decimals = Formats.currencyDecimals(cur);
    final flows = [for (final v in _flows) v ?? 0.0];
    final result = _ready ? Investment.analyze(initial: _initial!, discountRatePercent: _rate!, flows: flows) : null;
    final rateText = _rate == null ? '' : f.percentValue(_rate!, decimals: _rate! == _rate!.roundToDouble() ? 0 : 1);
    String years(double? y) => y == null ? l.invsNever : l.invsYears(f.number(y, decimals: 1));

    final cumulative = <LinePoint>[];
    if (result != null) {
      var running = -_initial!;
      cumulative.add(LinePoint(0, running, l.invsYear(0)));
      for (var i = 0; i < flows.length; i++) {
        running = Money.round(running + flows[i]);
        cumulative.add(LinePoint(i + 1.0, running, l.invsYear(i + 1)));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.invsTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          Panel(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                NumberInputRow(
                  label: l.invsInitial,
                  value: _initial,
                  formats: f,
                  decimals: decimals,
                  suffix: symbol,
                  onChanged: (v) {
                    _initial = v;
                    _changed();
                  },
                ),
                NumberInputRow(
                  label: l.invsRate,
                  value: _rate,
                  formats: f,
                  suffix: l.commonPercentPa,
                  maxIntegerDigits: 2,
                  divider: false,
                  onChanged: (v) {
                    _rate = v;
                    _changed();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionTitle(l.invsFlows),
          FinePrint(l.invsFlowsHint),
          const SizedBox(height: 6),
          Panel(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                for (var i = 0; i < _flows.length; i++)
                  NumberInputRow(
                    key: ValueKey('year$i'),
                    label: l.invsYear(i + 1),
                    value: _flows[i],
                    formats: f,
                    decimals: decimals,
                    suffix: symbol,
                    signed: true,
                    divider: i < _flows.length - 1,
                    onChanged: (v) {
                      _flows = [..._flows]..[i] = v;
                      _changed();
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              if (_flows.length < maxYears)
                TextButton.icon(
                  onPressed: () {
                    _flows = [..._flows, null];
                    _changed();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.invsAddYear),
                ),
              if (_flows.length > 1)
                TextButton.icon(
                  onPressed: () {
                    _flows = _flows.sublist(0, _flows.length - 1);
                    _changed();
                  },
                  icon: const Icon(Icons.remove, size: 18),
                  label: Text(l.invsRemoveYear),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (result == null)
            FinePrint(l.invsEmpty)
          else ...[
            Overline(l.invsNpv),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(f.money(result.npv, cur), style: t.displayLarge!.copyWith(color: result.npv < 0 ? c.brick : c.positive)),
            ),
            const SizedBox(height: 4),
            Text(result.npv >= 0 ? l.invsGood(rateText) : l.invsBad(rateText), style: t.bodyMedium!.copyWith(color: c.ink2)),
            const SizedBox(height: 16),
            Panel(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LedgerRow(label: l.invsIrr, value: result.irr == null ? l.invsNoIrr : f.percent(result.irr!, decimals: 2)),
                  LedgerRow(label: l.invsPayback, value: years(result.paybackYears)),
                  LedgerRow(label: l.invsDiscountedPayback, value: years(result.discountedPaybackYears)),
                  LedgerRow(
                    label: l.invsPi,
                    value: result.profitabilityIndex == null ? '—' : f.number(result.profitabilityIndex!, decimals: 2),
                    divider: false,
                  ),
                ],
              ),
            ),
            if (cumulative.length > 2) ...[
              const SizedBox(height: 22),
              SectionTitle(l.invsCumulative),
              LineChart(
                points: cumulative,
                color: c.chart4,
                formatY: (v) => f.money(v, cur),
                baseline: 0,
                semanticLabel: l.invsCumulative,
              ),
            ],
            const SizedBox(height: 18),
            SaveShareRow(
              saveLabel: l.actionSave,
              shareLabel: l.actionShare,
              onSave: () => saveCalculation(context, ToolId.investment, _json, suggestedName: l.invsTitle),
              onShare: () async {
                final ok = await shareText(
                  shareBody(
                    l.invsTitle,
                    [
                      (l.invsInitial, f.money(_initial!, cur)),
                      (l.invsRate, rateText),
                      for (var i = 0; i < flows.length; i++) (l.invsYear(i + 1), f.money(flows[i], cur)),
                      (l.invsNpv, f.money(result.npv, cur)),
                      (l.invsIrr, result.irr == null ? l.invsNoIrr : f.percent(result.irr!, decimals: 2)),
                      (l.invsPayback, years(result.paybackYears)),
                    ],
                    l.shareFooter,
                  ),
                  subject: l.invsTitle,
                );
                if (!ok && context.mounted) showSnack(context, l.errorShare);
              },
            ),
          ],
        ],
      ),
    );
  }
}

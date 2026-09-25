import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../history/calc_state.dart';
import '../../history/history_store.dart';
import '../../history/save_dialog.dart';
import '../../settings/settings_controller.dart';
import '../domain/business_math.dart';

class BreakEvenScreen extends StatefulWidget {
  const BreakEvenScreen({super.key, this.initial});

  final Map<String, Object?>? initial;

  @override
  State<BreakEvenScreen> createState() => _BreakEvenScreenState();
}

class _BreakEvenScreenState extends State<BreakEvenScreen> with CalcState<BreakEvenScreen> {
  @override
  ToolId get toolId => ToolId.breakEven;
  @override
  String get storeKey => 'calc.breakEven.v1';

  double? _fixed;
  double? _price;
  double? _variable;
  double? _target;
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
      _fixed = readDouble(init, 'fixed');
      _price = readDouble(init, 'price');
      _variable = readDouble(init, 'variable');
      _target = readDouble(init, 'target');
      if (init['currency'] is String) _currency = init['currency'] as String;
    }
  }

  Map<String, Object?> get _json => {'fixed': _fixed, 'price': _price, 'variable': _variable, 'target': _target, 'currency': _currency};

  bool get _ready => (_price ?? 0) > 0 && _fixed != null;

  void _changed() {
    setState(() {});
    final r = _result;
    persistInputs(_json, complete: r != null);
  }

  BreakEvenResult? get _result =>
      !_ready ? null : BreakEven.compute(fixedCosts: _fixed ?? 0, unitPrice: _price!, unitVariableCost: _variable ?? 0, targetProfit: _target ?? 0);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final cur = _currency;
    final symbol = f.currencySymbol(cur);
    final decimals = Formats.currencyDecimals(cur);
    final result = _result;
    final impossible = _ready && result == null;

    Widget input(String label, double? value, ValueChanged<double?> onChanged, {String? hint, bool divider = true}) => NumberInputRow(
      label: label,
      hint: hint,
      value: value,
      formats: f,
      decimals: decimals,
      suffix: symbol,
      divider: divider,
      onChanged: (v) {
        onChanged(v);
        _changed();
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.beTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          Panel(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                input(l.beFixed, _fixed, (v) => _fixed = v, hint: l.beFixedHint),
                input(l.bePrice, _price, (v) => _price = v),
                input(l.beVariable, _variable, (v) => _variable = v, hint: l.beVariableHint),
                input(l.beTarget, _target, (v) => _target = v, hint: l.commonOptional, divider: false),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (impossible)
            InfoNote(l.beImpossible, warning: true)
          else if (result == null)
            FinePrint(l.beEmpty)
          else ...[
            Overline(l.beUnits),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(l.beUnitsValue(result.units, f.number(result.units.toDouble(), decimals: 0)), style: t.displayLarge),
            ),
            const SizedBox(height: 14),
            Panel(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LedgerRow(label: l.beRevenue, value: f.money(result.revenue, cur)),
                  LedgerRow(label: l.beContribution, value: f.percentValue(result.contributionMarginPercent, decimals: 1)),
                  LedgerRow(
                    label: l.beContributionUnit,
                    value: f.money((_price ?? 0) - (_variable ?? 0), cur),
                    divider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FinePrint(l.beExplain),
            const SizedBox(height: 18),
            SaveShareRow(
              saveLabel: l.actionSave,
              shareLabel: l.actionShare,
              onSave: () => saveCalculation(context, ToolId.breakEven, _json, suggestedName: l.beTitle),
              onShare: () async {
                final ok = await shareText(
                  shareBody(
                    l.beTitle,
                    [
                      (l.beFixed, f.money(_fixed ?? 0, cur)),
                      (l.bePrice, f.money(_price!, cur)),
                      (l.beVariable, f.money(_variable ?? 0, cur)),
                      if ((_target ?? 0) > 0) (l.beTarget, f.money(_target!, cur)),
                      (l.beUnits, l.beUnitsValue(result.units, f.number(result.units.toDouble(), decimals: 0))),
                      (l.beRevenue, f.money(result.revenue, cur)),
                    ],
                    l.shareFooter,
                  ),
                  subject: l.beTitle,
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

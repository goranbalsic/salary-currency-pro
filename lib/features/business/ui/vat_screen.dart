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

/// Formats a VAT rate without needless decimals: 20 → "20%", 9.5 → "9,5%".
String vatRateLabel(Formats f, double rate) => f.percentValue(rate, decimals: rate == rate.roundToDouble() ? 0 : 1);

class VatScreen extends StatefulWidget {
  const VatScreen({super.key, this.initial});

  /// Inputs of a saved calculation to restore.
  final Map<String, Object?>? initial;

  @override
  State<VatScreen> createState() => _VatScreenState();
}

class _VatScreenState extends State<VatScreen> with CalcState<VatScreen> {
  @override
  ToolId get toolId => ToolId.vat;
  @override
  String get storeKey => 'calc.vat.v1';

  bool _extract = false;
  double? _amount;
  double _rate = 20;
  bool _custom = false;
  late String _currency;
  late List<double> _rates;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final settings = context.read<SettingsController>();
    _rates = vatRatesByCountry[settings.country.code] ?? const [20];
    _currency = settings.homeCurrency;
    _rate = _rates.first;
    final init = initialInputs(widget.initial);
    if (init != null) {
      _extract = init['mode'] == 'extract';
      final a = readDouble(init, 'amount');
      _amount = a != null && a > 0 ? a : null;
      final r = readDouble(init, 'rate');
      if (r != null && r >= 0 && r < 100) _rate = r;
      if (init['currency'] is String) _currency = init['currency'] as String;
    }
    _custom = !_rates.contains(_rate);
  }

  Map<String, Object?> get _json => {'mode': _extract ? 'extract' : 'add', 'amount': _amount, 'rate': _rate, 'currency': _currency};

  void _changed() {
    setState(() {});
    persistInputs(_json, complete: (_amount ?? 0) > 0);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final amount = _amount;
    final result = amount == null || amount <= 0 ? null : (_extract ? Vat.extract(amount, _rate) : Vat.add(amount, _rate));
    final cur = _currency;
    final rateText = vatRateLabel(f, _rate);

    return Scaffold(
      appBar: AppBar(title: Text(l.vatTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          Segmented<bool>(
            values: const [false, true],
            selected: _extract,
            labelOf: (v) => v ? l.vatExtract : l.vatAdd,
            onChanged: (v) {
              _extract = v;
              _changed();
            },
          ),
          const SizedBox(height: 22),
          AmountField(
            label: _extract ? l.vatAmountGross : l.vatAmountNet,
            value: _amount,
            formats: f,
            decimals: Formats.currencyDecimals(cur),
            suffix: f.currencySymbol(cur),
            onChanged: (v) {
              _amount = v;
              _changed();
            },
          ),
          const SizedBox(height: 20),
          Overline(l.vatRate, padding: const EdgeInsets.only(bottom: 8)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final r in _rates)
                PillChip(
                  label: vatRateLabel(f, r),
                  selected: !_custom && _rate == r,
                  onTap: () {
                    _custom = false;
                    _rate = r;
                    _changed();
                  },
                ),
              PillChip(
                label: l.vatOther,
                selected: _custom,
                onTap: () {
                  _custom = true;
                  _changed();
                },
              ),
            ],
          ),
          if (_custom)
            NumberInputRow(
              label: l.vatRate,
              value: _rate,
              formats: f,
              suffix: '%',
              maxIntegerDigits: 2,
              onChanged: (v) {
                if (v != null && v >= 0 && v < 100) _rate = v;
                if (v == null) _rate = 0;
                _changed();
              },
            ),
          const SizedBox(height: 24),
          if (result == null)
            FinePrint(l.vatEmpty)
          else ...[
            Panel(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LedgerRow(label: l.vatNet, value: f.money(result.net, cur)),
                  LedgerRow(label: l.vatVat, hint: rateText, value: f.money(result.vat, cur), divider: false),
                  LedgerTotal(label: l.vatGross, value: f.money(result.gross, cur)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SaveShareRow(
              saveLabel: l.actionSave,
              shareLabel: l.actionShare,
              onSave: () => saveCalculation(context, ToolId.vat, _json, suggestedName: '${l.toolVat} · ${f.money(amount!, cur)}'),
              onShare: () async {
                final ok = await shareText(
                  shareBody(
                    l.vatTitle,
                    [
                      (l.vatNet, f.money(result.net, cur)),
                      ('${l.vatVat} $rateText', f.money(result.vat, cur)),
                      (l.vatGross, f.money(result.gross, cur)),
                    ],
                    l.shareFooter,
                  ),
                  subject: l.vatTitle,
                );
                if (!ok && context.mounted) showSnack(context, l.errorShare);
              },
            ),
          ],
          const SizedBox(height: 18),
          Text(l.vatRatesNote(l.countryName(context.read<SettingsController>().country.code)), style: t.bodySmall),
        ],
      ),
    );
  }
}

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
import 'vat_screen.dart';

enum MarginMode { price, markup, margin }

class MarginScreen extends StatefulWidget {
  const MarginScreen({super.key, this.initial});

  final Map<String, Object?>? initial;

  @override
  State<MarginScreen> createState() => _MarginScreenState();
}

class _MarginScreenState extends State<MarginScreen> with CalcState<MarginScreen> {
  @override
  ToolId get toolId => ToolId.margin;
  @override
  String get storeKey => 'calc.margin.v1';

  MarginMode _mode = MarginMode.price;
  double? _cost;
  double? _price;
  double? _markup;
  double? _margin;
  double? _discount;
  double _vat = 0;
  late List<double> _rates;
  late String _currency;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final settings = context.read<SettingsController>();
    _rates = vatRatesByCountry[settings.country.code] ?? const [20];
    _currency = settings.homeCurrency;
    _vat = _rates.first;
    final init = initialInputs(widget.initial);
    if (init != null) {
      _mode = MarginMode.values.where((m) => m.name == init['mode']).firstOrNull ?? MarginMode.price;
      _cost = _positive(readDouble(init, 'cost'));
      _price = _positive(readDouble(init, 'price'));
      _markup = readDouble(init, 'markup');
      _margin = readDouble(init, 'margin');
      _discount = readDouble(init, 'discount');
      final v = readDouble(init, 'vat');
      if (v != null && v >= 0 && v < 100) _vat = v;
      if (init['currency'] is String) _currency = init['currency'] as String;
    }
  }

  static double? _positive(double? v) => v != null && v > 0 ? v : null;

  Map<String, Object?> get _json => {
        'mode': _mode.name,
        'cost': _cost,
        'price': _price,
        'markup': _markup,
        'margin': _margin,
        'discount': _discount,
        'vat': _vat,
        'currency': _currency,
      };

  /// Selling price before discount, from whichever inputs the mode uses.
  double? get _listPrice {
    final cost = _cost;
    switch (_mode) {
      case MarginMode.price:
        return _price;
      case MarginMode.markup:
        final m = _markup;
        return cost == null || m == null ? null : PriceBreakdown.priceFromMarkup(cost, m);
      case MarginMode.margin:
        final m = _margin;
        return cost == null || m == null ? null : PriceBreakdown.priceFromMargin(cost, m);
    }
  }

  bool get _complete => _cost != null && _listPrice != null && _listPrice! > 0;

  void _changed() {
    setState(() {});
    persistInputs(_json, complete: _complete);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final c = context.colors;
    final cur = _currency;
    final symbol = f.currencySymbol(cur);
    final decimals = Formats.currencyDecimals(cur);
    final impossible = _mode == MarginMode.margin && (_margin ?? 0) >= 100;
    final price = _listPrice;
    final breakdown = _cost == null || price == null || price <= 0 || impossible
        ? null
        : PriceBreakdown(cost: _cost!, price: price, discountPercent: (_discount ?? 0).clamp(0, 100).toDouble(), vatPercent: _vat);
    String pct(double? v) => v == null ? '—' : f.percentValue(v, decimals: 1);

    return Scaffold(
      appBar: AppBar(title: Text(l.mrgTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          Segmented<MarginMode>(
            values: MarginMode.values,
            selected: _mode,
            labelOf: (m) => switch (m) {
              MarginMode.price => l.mrgFromPrice,
              MarginMode.markup => l.mrgFromMarkup,
              MarginMode.margin => l.mrgFromMargin,
            },
            onChanged: (m) {
              // Carry the current result over so switching modes keeps the numbers.
              final current = _listPrice;
              final cost = _cost;
              if (current != null && cost != null && cost > 0 && current > 0) {
                _price = current;
                // The percentage fields take positive values only.
                final profitable = current > cost;
                _markup = profitable ? double.parse(((current - cost) / cost * 100).toStringAsFixed(2)) : null;
                _margin = profitable ? double.parse(((current - cost) / current * 100).toStringAsFixed(2)) : null;
              }
              _mode = m;
              _changed();
            },
          ),
          const SizedBox(height: 16),
          Panel(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                NumberInputRow(
                  label: l.mrgCost,
                  value: _cost,
                  formats: f,
                  decimals: decimals,
                  suffix: symbol,
                  onChanged: (v) {
                    _cost = _positive(v);
                    _changed();
                  },
                ),
                switch (_mode) {
                  MarginMode.price => NumberInputRow(
                      key: const ValueKey('price'),
                      label: l.mrgPrice,
                      value: _price,
                      formats: f,
                      decimals: decimals,
                      suffix: symbol,
                      onChanged: (v) {
                        _price = _positive(v);
                        _changed();
                      },
                    ),
                  MarginMode.markup => NumberInputRow(
                      key: const ValueKey('markup'),
                      label: l.mrgMarkup,
                      value: _markup,
                      formats: f,
                      suffix: '%',
                      maxIntegerDigits: 5,
                      onChanged: (v) {
                        _markup = v;
                        _changed();
                      },
                    ),
                  MarginMode.margin => NumberInputRow(
                      key: const ValueKey('margin'),
                      label: l.mrgMargin,
                      value: _margin,
                      formats: f,
                      suffix: '%',
                      maxIntegerDigits: 3,
                      error: impossible,
                      onChanged: (v) {
                        _margin = v;
                        _changed();
                      },
                    ),
                },
                NumberInputRow(
                  label: l.mrgDiscount,
                  hint: l.commonOptional,
                  value: _discount,
                  formats: f,
                  suffix: '%',
                  maxIntegerDigits: 2,
                  divider: false,
                  onChanged: (v) {
                    _discount = v;
                    _changed();
                  },
                ),
              ],
            ),
          ),
          if (impossible) ...[const SizedBox(height: 10), InfoNote(l.mrgImpossible, warning: true)],
          const SizedBox(height: 18),
          Overline(l.mrgVat, padding: const EdgeInsets.only(bottom: 8)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final r in {..._rates, 0.0})
                PillChip(
                  label: vatRateLabel(f, r),
                  selected: _vat == r,
                  onTap: () {
                    _vat = r;
                    _changed();
                  },
                ),
            ],
          ),
          const SizedBox(height: 22),
          if (breakdown == null)
            FinePrint(l.mrgEmpty)
          else ...[
            Panel(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_mode != MarginMode.price) LedgerRow(label: l.mrgPrice, value: f.money(breakdown.price, cur)),
                  if ((_discount ?? 0) > 0) LedgerRow(label: l.mrgPriceAfterDiscount, value: f.money(breakdown.discountedPrice, cur)),
                  LedgerRow(
                    label: l.mrgProfit,
                    value: f.money(breakdown.profit, cur),
                    valueColor: breakdown.profit < 0 ? c.brick : null,
                  ),
                  LedgerRow(label: l.mrgMargin, value: pct(breakdown.marginPercent), valueColor: breakdown.profit < 0 ? c.brick : null),
                  LedgerRow(label: l.mrgMarkup, value: pct(breakdown.markupPercent), valueColor: breakdown.profit < 0 ? c.brick : null),
                  LedgerRow(label: l.mrgVat, hint: vatRateLabel(f, _vat), value: f.money(breakdown.vat, cur), divider: false),
                  LedgerTotal(label: l.mrgPriceWithVat, value: f.money(breakdown.priceWithVat, cur)),
                ],
              ),
            ),
            if (breakdown.profit < 0) ...[const SizedBox(height: 10), InfoNote(l.mrgLoss, warning: true)],
            const SizedBox(height: 18),
            SaveShareRow(
              saveLabel: l.actionSave,
              shareLabel: l.actionShare,
              onSave: () => saveCalculation(context, ToolId.margin, _json, suggestedName: l.mrgTitle),
              onShare: () async {
                final ok = await shareText(
                  shareBody(
                    l.mrgTitle,
                    [
                      (l.mrgCost, f.money(_cost!, cur)),
                      (l.mrgPrice, f.money(breakdown.price, cur)),
                      if ((_discount ?? 0) > 0) (l.mrgPriceAfterDiscount, f.money(breakdown.discountedPrice, cur)),
                      (l.mrgProfit, f.money(breakdown.profit, cur)),
                      (l.mrgMargin, pct(breakdown.marginPercent)),
                      (l.mrgMarkup, pct(breakdown.markupPercent)),
                      (l.mrgPriceWithVat, f.money(breakdown.priceWithVat, cur)),
                    ],
                    l.shareFooter,
                  ),
                  subject: l.mrgTitle,
                );
                if (!ok && context.mounted) showSnack(context, l.errorShare);
              },
            ),
          ],
          const SizedBox(height: 18),
          FinePrint(l.mrgMarginHint),
        ],
      ),
    );
  }
}

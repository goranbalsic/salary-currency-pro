import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../settings/settings_controller.dart';
import '../../shell/root_shell.dart';
import '../data/rates_controller.dart';
import '../domain/rates.dart';
import 'currency_sheet.dart';

const _fxKey = 'fx.converter.v1';

class FxScreen extends StatefulWidget {
  const FxScreen({super.key});

  @override
  State<FxScreen> createState() => _FxScreenState();
}

class _FxScreenState extends State<FxScreen> {
  int _section = 0;
  ShellController? _shell;
  String? _from;
  String? _to;
  double? _amount = 1000;
  RateKind _kind = RateKind.middle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_from == null) {
      final home = context.read<SettingsController>().homeCurrency;
      final raw = context.read<AppServices>().store.readJson(_fxKey);
      _from = home == 'EUR' ? 'USD' : 'EUR';
      _to = home;
      if (raw is Map) {
        if (raw['from'] is String) _from = raw['from'] as String;
        if (raw['to'] is String) _to = raw['to'] as String;
        final a = raw['amount'];
        if (a is num && a.isFinite && a > 0) _amount = a.toDouble();
        _kind = RateKind.values.where((k) => k.name == raw['kind']).firstOrNull ?? RateKind.middle;
      }
    }
    final shell = ShellScope.of(context);
    if (shell != _shell) {
      _shell?.removeListener(_onShell);
      _shell = shell;
      _shell?.addListener(_onShell);
      _onShell();
    }
  }

  void _onShell() {
    final s = _shell?.takeSection(AppTab.fx);
    if (s != null && mounted) setState(() => _section = s.clamp(0, 1));
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShell);
    super.dispose();
  }

  void _persist() {
    unawaited(context.read<AppServices>().store.writeJson(_fxKey, {'from': _from, 'to': _to, 'amount': _amount, 'kind': _kind.name}));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rates = context.watch<RatesController>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => rates.refresh(force: true),
          child: PageBody(
            padding: const EdgeInsets.fromLTRB(Gap.page, 16, Gap.page, 40),
            children: [
              ScreenHeader(
                title: l.fxTitle,
                trailing: _StatusPill(rates: rates),
              ),
              const SizedBox(height: 18),
              Segmented<int>(
                values: const [0, 1],
                selected: _section,
                labelOf: (i) => [l.fxTabConverter, l.fxTabList][i],
                onChanged: (i) => setState(() => _section = i),
              ),
              const SizedBox(height: 20),
              if (!rates.hasData)
                _NoRates(loading: rates.status == RatesStatus.loading, onRetry: () => rates.refresh(force: true))
              else if (_section == 0)
                ..._converter(context, rates.book)
              else
                _RateList(book: rates.book),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _converter(BuildContext context, RateBook book) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);
    final from = _from!;
    final to = _to!;
    final conv = _amount == null ? null : book.convert(_amount!, from, to, _kind);
    final rate = book.rate(from, to, _kind);
    final nbsPair = rate?.source == RateSource.nbs && (from == 'RSD' || to == 'RSD');
    final currencies = book.currencies;
    final pinned = {home, 'EUR', 'USD', 'CHF', 'GBP', 'RSD', 'BAM', 'MKD', 'RON'}.toList();

    Future<void> pick(bool isFrom) async {
      final picked = await showCurrencySheet(context, current: isFrom ? from : to, available: currencies, pinned: pinned);
      if (picked == null || !mounted) return;
      setState(() {
        if (isFrom) {
          if (picked == _to) _to = _from;
          _from = picked;
        } else {
          if (picked == _from) _from = _to;
          _to = picked;
        }
      });
      _persist();
    }

    String sourceLabel() {
      if (rate?.source == RateSource.ecb) return l.fxSourceEcb;
      final base = switch (_kind) {
        RateKind.middle => l.fxSourceNbsMiddle,
        RateKind.buy => l.fxSourceNbsBuy,
        RateKind.sell => l.fxSourceNbsSell,
      };
      return (from != 'RSD' && to != 'RSD') ? '$base, ${l.fxSourceCross}' : base;
    }

    return [
      Panel(
        radius: Radii.xl,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CurrencyButton(code: from, label: l.fxPickFrom, onTap: () => pick(true)),
                  const SizedBox(height: 6),
                  AmountField(
                    key: ValueKey('fx-amount-$from'),
                    label: l.fxAmount(from),
                    value: _amount,
                    formats: f,
                    fontSize: 34,
                    onChanged: (v) {
                      setState(() => _amount = v);
                      _persist();
                    },
                  ),
                ],
              ),
            ),
            // The swap button sits on the divider. The row is as tall as the
            // button so the whole button receives taps (a child painted
            // outside its parent's box is not hit-testable).
            SizedBox(
              height: 44,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Positioned.fill(
                    child: Center(child: Container(height: 1, color: c.line)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Tooltip(
                      message: l.fxSwap,
                      child: Material(
                        color: c.paper,
                        shape: CircleBorder(side: BorderSide(color: c.ink)),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            setState(() {
                              final tmp = _from;
                              _from = _to;
                              _to = tmp;
                              if (conv != null) _amount = double.parse(conv.result.toStringAsFixed(2));
                            });
                            _persist();
                          },
                          child: const SizedBox(width: 44, height: 44, child: Icon(Icons.swap_vert, size: 22)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CurrencyButton(code: to, label: l.fxPickTo, accent: true, onTap: () => pick(false)),
                  const SizedBox(height: 10),
                  Semantics(
                    liveRegion: true,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(conv == null ? '—' : f.number(conv.result, decimals: 2), style: t.displayMedium!.copyWith(fontSize: 34, color: c.green)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.line)),
              ),
              child: Text(
                rate == null
                    ? l.fxUnsupported
                    : '${l.fxRateLine(from, f.rate(rate.rate, decimals: rate.rate < 0.1 ? 6 : 4), to)} · ${sourceLabel()}${rate.date == null ? '' : ', ${f.date(rate.date!)}'}',
                style: t.bodySmall!.copyWith(color: c.ink2),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (kind, label) in [(RateKind.middle, l.fxKindMiddle), (RateKind.buy, l.fxKindBuy), (RateKind.sell, l.fxKindSell)])
            PillChip(
              label: label,
              selected: _kind == kind,
              onTap: () {
                setState(() => _kind = kind);
                _persist();
              },
            ),
        ],
      ),
      if (!nbsPair && _kind != RateKind.middle) ...[const SizedBox(height: 6), FinePrint(l.fxKindHint)],
      const SizedBox(height: 26),
      if (rate != null && rate.source != null) _HistorySection(from: from, to: to, source: rate.source!),
      const SizedBox(height: 26),
      _QuickList(book: book, home: home),
      const SizedBox(height: 20),
      FinePrint(l.fxSourcesNote),
    ];
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.rates});
  final RatesController rates;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final fetched = rates.lastFetched;
    final loading = rates.status == RatesStatus.loading;
    final offline = rates.status == RatesStatus.offline;
    final text = loading
        ? l.fxLoading
        : fetched == null
        ? ''
        : (offline ? l.fxOffline(f.shortDate(fetched)) : l.fxUpdated(f.shortDate(fetched)));
    if (text.isEmpty) return const SizedBox.shrink();
    return Semantics(
      button: true,
      label: '$text. ${l.fxRefresh}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: loading ? null : () => rates.refresh(force: true),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.6, color: c.ink2))
              else
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: offline ? c.warning : c.positive),
                ),
              const SizedBox(width: 6),
              Flexible(child: Text(text, style: t.bodySmall!.copyWith(color: c.ink2), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoRates extends StatelessWidget {
  const _NoRates({required this.loading, required this.onRetry});
  final bool loading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoNote(l.fxNoRates, icon: Icons.wifi_off),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: loading ? null : onRetry,
          child: loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l.actionRetry),
        ),
      ],
    );
  }
}

class _CurrencyButton extends StatelessWidget {
  const _CurrencyButton({required this.code, required this.label, required this.onTap, this.accent = false});
  final String code;
  final String label;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final c = context.colors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: '$label: ${l.currencyName(code) ?? code}',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeTile(code, filled: !accent, accent: accent, width: 42),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(l.currencyName(code) ?? code, style: t.titleMedium, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.expand_more, size: 18, color: c.ink2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatefulWidget {
  const _HistorySection({required this.from, required this.to, required this.source});
  final String from;
  final String to;
  final RateSource source;

  @override
  State<_HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<_HistorySection> {
  int _days = 30;
  Future<List<RatePoint>>? _future;
  String? _key;

  /// History is drawn for the pair's non-base currency against the base of
  /// the source (e.g. EUR in RSD for NBS). Pairs where both sides differ
  /// from the base are drawn as a ratio of the two series.
  Future<List<RatePoint>> _load(RatesController rates) async {
    final base = widget.source == RateSource.nbs ? 'RSD' : 'EUR';
    Future<List<RatePoint>?> series(String code) async => code == base ? null : rates.history(widget.source, code, _days);
    final a = await series(widget.from);
    final b = await series(widget.to);
    if (a != null && b == null) return a;
    if (a == null && b != null) return [for (final p in b) RatePoint(p.date, 1 / p.value)];
    if (a == null || b == null) return const [];
    final byDate = {for (final p in b) p.date: p.value};
    return [
      for (final p in a)
        if (byDate[p.date] != null) RatePoint(p.date, p.value / byDate[p.date]!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final pro = context.watch<ProController>();
    final rates = context.read<RatesController>();
    final unlocked = pro.can(ProFeature.fxHistory);
    final key = '${widget.from}-${widget.to}-$_days-${widget.source.name}';
    if (unlocked && key != _key) {
      _key = key;
      _future = _load(rates);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.fxHistoryTitle(widget.from, widget.to, _days), trailing: unlocked ? null : const ProBadge()),
        Wrap(
          spacing: 8,
          children: [
            for (final d in const [30, 90, 365])
              PillChip(
                label: l.fxHistoryDays(d),
                selected: _days == d,
                onTap: () async {
                  if (!unlocked && !await requirePro(context, ProFeature.fxHistory)) return;
                  if (mounted) setState(() => _days = d);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (!unlocked)
          InkWell(
            onTap: () => requirePro(context, ProFeature.fxHistory),
            borderRadius: BorderRadius.circular(Radii.md),
            child: Container(
              height: 120,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: c.sunken, borderRadius: BorderRadius.circular(Radii.md)),
              child: Text(
                l.fxHistoryPro,
                textAlign: TextAlign.center,
                style: t.bodyMedium!.copyWith(color: c.ink2),
              ),
            ),
          )
        else
          FutureBuilder<List<RatePoint>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(height: 172, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
              }
              final points = snap.data ?? const [];
              if (snap.hasError || points.length < 2) {
                return SizedBox(
                  height: 60,
                  child: Center(child: Text(l.fxHistoryError, style: t.bodySmall)),
                );
              }
              var min = points.first.value;
              var max = points.first.value;
              for (final p in points) {
                if (p.value < min) min = p.value;
                if (p.value > max) max = p.value;
              }
              final dec = max < 0.1 ? 6 : 4;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LineChart(
                    points: [for (var i = 0; i < points.length; i++) LinePoint(i.toDouble(), points[i].value, f.date(points[i].date))],
                    color: c.chart1,
                    formatY: (v) => f.rate(v, decimals: dec),
                    semanticLabel:
                        '${l.fxHistoryTitle(widget.from, widget.to, _days)}: ${l.fxHistoryMinMax(f.rate(min, decimals: dec), f.rate(max, decimals: dec))}',
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      Text('${f.shortDate(points.first.date)} · ${f.rate(points.first.value, decimals: dec)}', style: t.bodySmall),
                      Text(
                        l.fxHistoryMinMax(f.rate(min, decimals: dec), f.rate(max, decimals: dec)),
                        style: t.bodySmall,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _QuickList extends StatelessWidget {
  const _QuickList({required this.book, required this.home});
  final RateBook book;
  final String home;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final euroHome = home == 'EUR';
    final codes = euroHome
        ? const ['USD', 'GBP', 'CHF', 'RSD', 'BAM', 'RON', 'HUF', 'MKD']
        : [
            for (final code in const ['EUR', 'USD', 'CHF', 'GBP', 'BAM', 'MKD', 'RON', 'RSD', 'HUF'])
              if (code != home) code,
          ];
    final rows = <Widget>[];
    for (final code in codes) {
      final r = euroHome ? book.rate('EUR', code) : book.rate(code, home);
      if (r == null) continue;
      rows.add(
        Container(
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          child: Row(
            children: [
              CodeTile(code, width: 40),
              const SizedBox(width: 12),
              Expanded(child: Text(l.currencyName(code) ?? code, style: t.bodyMedium)),
              Text(f.rate(r.rate, decimals: r.rate < 0.1 ? 6 : 4), style: t.titleLarge!.copyWith(fontSize: 17)),
            ],
          ),
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.ink)),
          ),
          child: Overline(euroHome ? l.fxListEcb : '${l.fxPerUnit} · $home'),
        ),
        ...rows,
      ],
    );
  }
}

class _RateList extends StatelessWidget {
  const _RateList({required this.book});
  final RateBook book;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);
    final useNbs = home == 'RSD' || book.ecb == null;
    final table = useNbs ? book.nbs : book.ecb;
    if (table == null) return InfoNote(l.fxNoRates);
    const order = ['EUR', 'USD', 'CHF', 'GBP', 'BAM', 'MKD', 'RON', 'HUF', 'CZK', 'PLN', 'SEK', 'NOK', 'DKK', 'JPY', 'CNY', 'CAD', 'AUD', 'TRY', 'RUB'];
    final codes = table.quotes.keys.toList()
      ..sort((a, b) {
        final ia = order.indexOf(a);
        final ib = order.indexOf(b);
        if (ia >= 0 && ib >= 0) return ia.compareTo(ib);
        if (ia >= 0) return -1;
        if (ib >= 0) return 1;
        return a.compareTo(b);
      });
    final cell = t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular, fontSize: 13.5);
    Widget row(String code, List<String> v, {bool header = false}) => Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: header ? c.ink : c.line)),
      ),
      child: Row(
        children: [
          SizedBox(width: 52, child: header ? Text(code, style: t.labelSmall) : CodeTile(code, width: 42)),
          for (final s in v)
            Expanded(
              child: Text(s, textAlign: TextAlign.right, style: header ? t.labelSmall : cell),
            ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(useNbs ? l.fxListNbs : l.fxListEcb, style: t.titleLarge),
        const SizedBox(height: 4),
        Text(f.date(table.date), style: t.bodySmall),
        const SizedBox(height: 10),
        if (useNbs)
          row('', [l.fxColBuy.toUpperCase(), l.fxColMiddle.toUpperCase(), l.fxColSell.toUpperCase()], header: true)
        else
          row('', [l.fxColRate.toUpperCase()], header: true),
        for (final code in codes)
          if (useNbs)
            row(code, [
              f.rate(table.quotes[code]!.buy ?? table.quotes[code]!.middle),
              f.rate(table.quotes[code]!.middle),
              f.rate(table.quotes[code]!.sell ?? table.quotes[code]!.middle),
            ])
          else
            row(code, [f.rate(table.quotes[code]!.middle)]),
        const SizedBox(height: 16),
        FinePrint(l.fxSourcesNote),
      ],
    );
  }
}

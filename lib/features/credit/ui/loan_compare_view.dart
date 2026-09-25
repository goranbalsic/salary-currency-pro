import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../settings/settings_controller.dart';
import '../domain/credit_inputs.dart';
import '../domain/loan_engine.dart';
import 'credit_widgets.dart';

const _compareKey = 'credit.compare.v1';

class LoanCompareView extends StatefulWidget {
  const LoanCompareView({super.key});

  @override
  State<LoanCompareView> createState() => _LoanCompareViewState();
}

class _LoanCompareViewState extends State<LoanCompareView> {
  double? _principal;
  String? _currency;
  List<LoanOffer> _offers = const [LoanOffer(), LoanOffer()];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currency != null) return;
    final home = context.read<SettingsController>().homeCurrency;
    final raw = context.read<AppServices>().store.readJson(_compareKey);
    _currency = home;
    if (raw is Map) {
      final p = raw['principal'];
      _principal = p is num && p.isFinite && p > 0 ? p.toDouble() : null;
      if (raw['currency'] is String) _currency = raw['currency'] as String;
      final offers = raw['offers'];
      if (offers is List && offers.isNotEmpty) _offers = [for (final o in offers.take(3)) LoanOffer.fromJson(o)];
      if (_offers.length < 2) _offers = [..._offers, const LoanOffer()];
    }
  }

  void _save() {
    unawaited(
      context.read<AppServices>().store.writeJson(_compareKey, {
        'principal': _principal,
        'currency': _currency,
        'offers': [for (final o in _offers) o.toJson()],
      }),
    );
  }

  void _setOffer(int i, LoanOffer o) {
    setState(() => _offers = [..._offers]..[i] = o);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final pro = context.watch<ProController>();
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);
    if (!pro.can(ProFeature.compareLoans)) {
      return PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 18, Gap.page, 40),
        children: [
          Panel(
            color: c.brassTint,
            borderColor: c.brass.withValues(alpha: 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.toolLoanCompare, style: t.titleLarge)),
                    const ProBadge(strong: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(l.toolLoanCompareDesc, style: t.bodyMedium),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => requirePro(context, ProFeature.compareLoans),
                  child: Text(l.proFeatureTitle(l.toolLoanCompare)),
                ),
              ],
            ),
          ),
        ],
      );
    }
    final cur = _currency!;
    final results = <LoanResult?>[];
    for (final o in _offers) {
      final p = _principal;
      final r = o.rate;
      if (p == null || r == null) {
        results.add(null);
        continue;
      }
      final input = LoanInput(principal: p, annualRatePercent: r, months: o.months, upfrontFeePercent: o.feePercent ?? 0, monthlyFee: o.monthlyFee ?? 0);
      results.add(input.validate() == null ? const LoanEngine().compute(input) : null);
    }
    final valid = [
      for (var i = 0; i < results.length; i++)
        if (results[i] != null) i,
    ];
    int? best;
    double? worstCost;
    for (final i in valid) {
      if (best == null || results[i]!.totalCost < results[best]!.totalCost) best = i;
      if (worstCost == null || results[i]!.totalCost > worstCost) worstCost = results[i]!.totalCost;
    }

    return PageBody(
      padding: const EdgeInsets.fromLTRB(Gap.page, 18, Gap.page, 40),
      children: [
        FinePrint(l.cmpLoanIntro),
        const SizedBox(height: 12),
        Panel(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: CurrencyAmountRow(
            label: l.loanAmount,
            value: _principal,
            currency: cur,
            currencies: creditCurrencies(home),
            onChanged: (v) {
              setState(() => _principal = v);
              _save();
            },
            onCurrency: (code) {
              setState(() => _currency = code);
              _save();
            },
          ),
        ),
        for (var i = 0; i < _offers.length; i++) ...[
          const SizedBox(height: 14),
          Panel(
            borderColor: best == i && valid.length > 1 ? c.green : null,
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.cmpLoanOffer(i + 1), style: t.titleLarge!.copyWith(fontSize: 19))),
                    if (best == i && valid.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: c.greenTint, borderRadius: BorderRadius.circular(6)),
                        child: Text(l.cmpLoanBest, style: t.labelSmall!.copyWith(color: c.positive, letterSpacing: 0.2)),
                      ),
                    if (_offers.length > 2)
                      IconButton(
                        tooltip: l.cmpLoanRemove,
                        onPressed: () {
                          setState(() => _offers = [..._offers]..removeAt(i));
                          _save();
                        },
                        icon: const Icon(Icons.close, size: 20),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      NumberInputRow(
                        label: l.loanRate,
                        value: _offers[i].rate,
                        formats: f,
                        suffix: l.commonPercentPa,
                        maxIntegerDigits: 3,
                        onChanged: (v) => _setOffer(i, _offers[i].copyWith(rate: v, clearRate: v == null)),
                      ),
                      TermField(
                        label: l.loanTerm,
                        months: _offers[i].months,
                        onChanged: (m) => _setOffer(i, _offers[i].copyWith(months: m)),
                      ),
                      NumberInputRow(
                        label: l.loanFee,
                        value: _offers[i].feePercent,
                        formats: f,
                        suffix: '%',
                        maxIntegerDigits: 2,
                        onChanged: (v) => _setOffer(i, _offers[i].copyWith(feePercent: v, clearFee: v == null)),
                      ),
                      NumberInputRow(
                        label: l.loanMonthlyFee,
                        value: _offers[i].monthlyFee,
                        formats: f,
                        suffix: f.currencySymbol(cur),
                        divider: results[i] != null,
                        onChanged: (v) => _setOffer(i, _offers[i].copyWith(monthlyFee: v, clearMonthlyFee: v == null)),
                      ),
                      if (results[i] != null) ...[
                        LedgerRow(label: l.loanInstallment, value: f.money(results[i]!.firstInstallment, cur)),
                        LedgerRow(label: l.loanEir, value: results[i]!.eirAnnual == null ? '—' : f.percent(results[i]!.eirAnnual!, decimals: 2)),
                        LedgerRow(label: l.loanTotalInterest, value: f.money(results[i]!.totalInterest, cur)),
                        LedgerRow(label: l.loanTotal, value: f.money(results[i]!.totalCost, cur), emphasis: true, divider: false),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_offers.length < 3) ...[
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => _offers = [..._offers, const LoanOffer()]);
              _save();
            },
            icon: const Icon(Icons.add),
            label: Text(l.cmpLoanAdd),
          ),
        ],
        if (best != null && valid.length > 1 && worstCost != null && worstCost > results[best]!.totalCost) ...[
          const SizedBox(height: 16),
          InfoNote(
            '${l.cmpLoanOffer(best + 1)}: ${l.cmpLoanSavesVs(f.money(Money.sub(worstCost, results[best]!.totalCost), cur))}',
            icon: Icons.check_circle_outline,
          ),
        ],
      ],
    );
  }
}

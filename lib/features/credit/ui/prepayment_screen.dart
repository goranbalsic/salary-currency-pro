import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../settings/settings_controller.dart';
import '../domain/credit_inputs.dart';
import '../domain/loan_engine.dart';
import 'credit_widgets.dart';
import 'loan_view.dart' show loanInputsKey;

/// Early-repayment simulator for the loan currently set up in the Loans tab.
class PrepaymentScreen extends StatefulWidget {
  const PrepaymentScreen({super.key});

  @override
  State<PrepaymentScreen> createState() => _PrepaymentScreenState();
}

class _PrepaymentScreenState extends State<PrepaymentScreen> {
  LoanInputs? _loan;
  double? _amount;
  int _after = 12;
  PrepaymentMode _mode = PrepaymentMode.shortenTerm;
  double? _fee;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final home = context.read<SettingsController>().homeCurrency;
    _loan = LoanInputs.fromJson(context.read<AppServices>().store.readJson(loanInputsKey), fallbackCurrency: home);
    final input = _loan?.toInput();
    if (input != null && input.validate() == null) {
      _after = math.max(1, input.months ~/ 3);
      _amount = (input.principal * 0.15).roundToDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final input = _loan?.toInput();
    final valid = input != null && input.validate() == null;
    return Scaffold(
      appBar: AppBar(title: Text(l.prepayTitle)),
      body: !valid
          ? Padding(padding: const EdgeInsets.all(Gap.page), child: InfoNote(l.prepayNoLoan))
          : Builder(
              builder: (context) {
                final cur = _loan!.currency;
                final after = _after.clamp(1, input.months - 1);
                final result = const LoanEngine().prepay(
                  input,
                  afterMonth: after,
                  amount: _amount ?? 0,
                  mode: _mode,
                  feePercent: _fee ?? 0,
                );
                final hasAmount = (_amount ?? 0) > 0;
                return PageBody(
                  children: [
                    Text(
                      l.prepayIntro(f.money(input.principal, cur), f.percentValue(input.annualRatePercent), l.commonMonthsCount(input.months)),
                      style: t.bodyMedium!.copyWith(color: c.ink2),
                    ),
                    const SizedBox(height: 16),
                    Panel(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          NumberInputRow(
                            label: l.prepayAmount,
                            value: _amount,
                            formats: f,
                            suffix: f.currencySymbol(cur),
                            onChanged: (v) => setState(() => _amount = v),
                          ),
                          StepperRow(
                            label: l.prepayAfter,
                            value: after,
                            min: 1,
                            max: input.months - 1,
                            onChanged: (v) => setState(() => _after = v),
                          ),
                          NumberInputRow(
                            label: l.prepayFee,
                            value: _fee,
                            formats: f,
                            suffix: '%',
                            maxIntegerDigits: 2,
                            onChanged: (v) => setState(() => _fee = v),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.prepayMode, style: t.bodyMedium!.copyWith(color: c.ink2)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    PillChip(
                                      label: l.prepayShorten,
                                      selected: _mode == PrepaymentMode.shortenTerm,
                                      onTap: () => setState(() => _mode = PrepaymentMode.shortenTerm),
                                    ),
                                    PillChip(
                                      label: l.prepayLower,
                                      selected: _mode == PrepaymentMode.lowerPayment,
                                      onTap: () => setState(() => _mode = PrepaymentMode.lowerPayment),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (hasAmount) ...[
                      InkResultCard(
                        label: l.prepaySaved,
                        figure: f.money(result.interestSaved, cur),
                        stats: [
                          if (result.paidOff || _mode == PrepaymentMode.shortenTerm)
                            (l.prepayNewTerm, l.commonMonthsCount(result.after.months), false)
                          else
                            (l.prepayNewInstallment, f.money(result.newInstallment, cur), false),
                          (l.prepayNetSaving, f.money(result.netSaving, cur), true),
                        ],
                      ),
                      if (result.paidOff) ...[const SizedBox(height: 10), InfoNote(l.prepayPaidOff)],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(flex: 4, child: SizedBox.shrink()),
                          Expanded(
                            flex: 3,
                            child: Text(l.prepayBefore.toUpperCase(), textAlign: TextAlign.right, style: t.labelSmall),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(l.prepayAfterLabel.toUpperCase(), textAlign: TextAlign.right, style: t.labelSmall),
                          ),
                        ],
                      ),
                      _Compare(label: l.loanTotalInterest, before: f.number(result.original.totalInterest), after: f.number(result.after.totalInterest)),
                      _Compare(label: l.loanTerm, before: l.commonMonthsCount(result.original.months), after: l.commonMonthsCount(result.after.months)),
                      _Compare(label: l.loanTotal, before: f.number(result.original.totalCost), after: f.number(result.after.totalCost)),
                      if (result.monthsSaved > 0) ...[
                        const SizedBox(height: 10),
                        Text(l.prepayMonthsSaved(l.commonMonthsCount(result.monthsSaved)), style: t.titleSmall!.copyWith(color: c.positive)),
                      ],
                    ],
                  ],
                );
              },
            ),
    );
  }
}

class _Compare extends StatelessWidget {
  const _Compare({required this.label, required this.before, required this.after});
  final String label;
  final String before;
  final String after;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final style = t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label, style: style)),
          Expanded(
            flex: 3,
            child: Text(
              before,
              textAlign: TextAlign.right,
              style: style.copyWith(color: c.ink2),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              after,
              textAlign: TextAlign.right,
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

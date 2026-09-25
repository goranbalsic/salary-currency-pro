import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../history/history_store.dart';
import '../../history/save_dialog.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../reports/pdf_reports.dart';
import '../../settings/settings_controller.dart';
import '../../shell/root_shell.dart';
import '../domain/credit_inputs.dart';
import '../domain/loan_engine.dart';
import 'credit_widgets.dart';
import 'loan_schedule_screen.dart';
import 'prepayment_screen.dart';

const loanInputsKey = 'credit.loan.v1';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  static const _engine = LoanEngine();
  LoanInputs? _inputs;
  bool _more = false;
  Timer? _recordTimer;
  ShellController? _shell;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inputs == null) {
      final home = context.read<SettingsController>().homeCurrency;
      final store = context.read<AppServices>().store;
      _inputs = LoanInputs.fromJson(store.readJson(loanInputsKey), fallbackCurrency: home) ?? LoanInputs.defaults(home);
      _more = (_inputs!.monthlyFee ?? 0) > 0;
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
    final calc = _shell?.takeRestore(ToolId.loan);
    if (calc == null || !mounted) return;
    final restored = LoanInputs.fromJson(calc.inputs, fallbackCurrency: _inputs!.currency);
    if (restored != null) _update(restored, record: false);
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShell);
    _recordTimer?.cancel();
    super.dispose();
  }

  void _update(LoanInputs next, {bool record = true}) {
    setState(() => _inputs = next);
    unawaited(context.read<AppServices>().store.writeJson(loanInputsKey, next.toJson()));
    _recordTimer?.cancel();
    if (record && next.toInput()?.validate() == null && next.toInput() != null) {
      _recordTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) unawaited(context.read<HistoryStore>().recordRecent(ToolId.loan, next.toJson()));
      });
    }
  }

  String? _errorText(AppLocalizations l, LoanInputError? e) => switch (e) {
        LoanInputError.principal => l.loanErrorPrincipal,
        LoanInputError.rate => l.loanErrorRate,
        LoanInputError.term => l.loanErrorTerm,
        LoanInputError.fee => l.loanErrorFee,
        null => null,
      };

  @override
  Widget build(BuildContext context) {
    final inputs = _inputs!;
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final pro = context.watch<ProController>();
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);
    final cur = inputs.currency;
    String money(double v) => f.money(v, cur);

    final input = inputs.toInput();
    final validation = input?.validate();
    LoanResult? result;
    if (input != null && validation == null) result = _engine.compute(input);
    final showError = (inputs.principal != null || inputs.rate != null) && (input == null || validation != null);
    final error = showError ? _errorText(l, input == null ? (inputs.principal == null ? LoanInputError.principal : LoanInputError.rate) : validation) : null;

    return PageBody(
      padding: const EdgeInsets.fromLTRB(Gap.page, 18, Gap.page, 40),
      children: [
        Panel(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CurrencyAmountRow(
                label: l.loanAmount,
                value: inputs.principal,
                currency: cur,
                currencies: creditCurrencies(home),
                error: validation == LoanInputError.principal,
                onChanged: (v) => _update(inputs.copyWith(principal: v, clearPrincipal: v == null)),
                onCurrency: (code) => _update(inputs.copyWith(currency: code)),
              ),
              NumberInputRow(
                label: l.loanRate,
                value: inputs.rate,
                formats: f,
                suffix: l.commonPercentPa,
                decimals: 2,
                maxIntegerDigits: 3,
                error: validation == LoanInputError.rate,
                onChanged: (v) => _update(inputs.copyWith(rate: v, clearRate: v == null)),
              ),
              TermField(label: l.loanTerm, months: inputs.months, onChanged: (m) => _update(inputs.copyWith(months: m))),
              NumberInputRow(
                label: l.loanFee,
                value: inputs.feePercent,
                formats: f,
                suffix: '%',
                decimals: 2,
                maxIntegerDigits: 2,
                error: validation == LoanInputError.fee,
                onChanged: (v) => _update(inputs.copyWith(feePercent: v, clearFee: v == null)),
              ),
              if (_more)
                NumberInputRow(
                  label: l.loanMonthlyFee,
                  hint: l.loanMonthlyFeeHint,
                  value: inputs.monthlyFee,
                  formats: f,
                  suffix: f.currencySymbol(cur),
                  decimals: 2,
                  onChanged: (v) => _update(inputs.copyWith(monthlyFee: v, clearMonthlyFee: v == null)),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Text(l.loanRepayment, style: t.bodyMedium!.copyWith(color: c.ink2))),
                    Flexible(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          PillChip(label: l.loanAnnuity, selected: inputs.type == RepaymentType.annuity, onTap: () => _update(inputs.copyWith(type: RepaymentType.annuity))),
                          PillChip(label: l.loanLinear, selected: inputs.type == RepaymentType.linear, onTap: () => _update(inputs.copyWith(type: RepaymentType.linear))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _more = !_more),
                  icon: Icon(_more ? Icons.expand_less : Icons.expand_more),
                  label: Text(_more ? l.loanLess : l.loanMore),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (error != null) InfoNote(error, warning: true),
        if (result != null) ...[
          InkResultCard(
            label: inputs.type == RepaymentType.annuity ? l.loanInstallment : l.loanFirstInstallment,
            figure: money(result.firstInstallment),
            stats: [
              (l.loanEir, result.eirAnnual == null ? '—' : f.percent(result.eirAnnual!, decimals: 2), true),
              (l.loanTotalInterest, f.number(result.totalInterest, decimals: 2), false),
              (l.loanTotal, f.number(result.totalCost, decimals: 2), false),
            ],
            footnote: result.totalFees > 0 ? l.loanTotalIncludes(money(result.totalFees)) : null,
          ),
          const SizedBox(height: 8),
          FinePrint(l.loanEirNote),
          const SizedBox(height: 24),
          SectionTitle(l.loanByYear),
          StackedColumns(
            columns: [
              for (var i = 0; i < result.byYear.length; i++)
                StackedColumn(label: l.loanYearShort(i + 1), bottom: result.byYear[i].principal, top: result.byYear[i].interest),
            ],
            bottomColor: c.chart1,
            topColor: c.chart2,
            bottomLabel: l.loanPrincipal,
            topLabel: l.loanInterest,
            format: (v) => f.number(v, decimals: 2),
          ),
          const SizedBox(height: 26),
          SectionTitle(l.loanSchedule),
          _SchedulePreview(result: result),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => LoanScheduleScreen(result: result!, currency: cur),
            )),
            child: Text(l.loanScheduleAll(result.months)),
          ),
          if (result.months >= 6) ...[
            const SizedBox(height: 22),
            _PrepayTeaser(input: input!, currency: cur, locked: !pro.can(ProFeature.earlyRepayment)),
          ],
          const SizedBox(height: 22),
          ResultActions(
            saveLabel: l.actionSave,
            shareLabel: l.actionShare,
            pdfLabel: l.actionDownloadPdf,
            pdfLocked: !pro.can(ProFeature.pdfExport),
            onSave: () => saveCalculation(context, ToolId.loan, inputs.toJson()),
            onShare: () async {
              final ok = await shareText(loanShareText(l, f, result!, cur), subject: l.toolLoan);
              if (!ok && context.mounted) showSnack(context, l.errorShare);
            },
            onPdf: () async {
              if (!await requirePro(context, ProFeature.pdfExport) || !context.mounted) return;
              await shareLoanPdf(context, result!, cur);
            },
          ),
        ],
      ],
    );
  }
}

String loanShareText(AppLocalizations l, Formats f, LoanResult r, String currency) {
  String money(double v) => f.money(v, currency);
  final i = r.input;
  final b = StringBuffer()
    ..writeln('${l.toolLoan}: ${money(i.principal)}, ${l.commonMonthsCount(i.months)}')
    ..writeln('${l.loanInstallment}: ${money(r.firstInstallment)}')
    ..writeln('${l.loanEir}: ${r.eirAnnual == null ? '—' : f.percent(r.eirAnnual!, decimals: 2)}')
    ..writeln('${l.loanTotalInterest}: ${money(r.totalInterest)}')
    ..writeln('${l.loanTotal}: ${money(r.totalCost)}')
    ..write('— ${l.shareFooter}');
  return b.toString();
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview({required this.result});
  final LoanResult result;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final rows = result.rows;
    final shown = rows.length <= 5 ? rows : [...rows.take(3), rows.last];
    TextStyle cell = t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular, fontSize: 13.5);
    TextStyle head = t.labelSmall!;
    Widget r(List<String> v, {bool header = false, bool divider = true}) => Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: header ? c.ink : c.line, width: header ? 1 : (divider ? 1 : 0)))),
          child: Row(
            children: [
              SizedBox(width: 34, child: Text(v[0], style: header ? head : cell)),
              for (var i = 1; i < v.length; i++) Expanded(child: Text(v[i], textAlign: TextAlign.right, style: header ? head : cell)),
            ],
          ),
        );
    return Column(
      children: [
        r([l.loanColNo, l.loanColInterest.toUpperCase(), l.loanColPrincipal.toUpperCase(), l.loanColBalance.toUpperCase()], header: true),
        for (var i = 0; i < shown.length; i++) ...[
          if (rows.length > 5 && i == 3)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
              child: Text('· · ·', textAlign: TextAlign.center, style: t.bodySmall),
            ),
          r(
            ['${shown[i].index}', f.number(shown[i].interest), f.number(shown[i].principal), f.number(shown[i].balance)],
            divider: i < shown.length - 1,
          ),
        ],
      ],
    );
  }
}

class _PrepayTeaser extends StatelessWidget {
  const _PrepayTeaser({required this.input, required this.currency, required this.locked});

  final LoanInput input;
  final String currency;
  final bool locked;

  static double niceAmount(double principal) {
    final raw = principal * 0.15;
    if (raw <= 0) return 0;
    final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    return (raw / magnitude).round() * magnitude;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final after = math.max(1, input.months ~/ 3);
    final amount = niceAmount(input.principal);
    final scenario = const LoanEngine().prepay(input, afterMonth: after, amount: amount);
    final monthsText = l.commonMonthsCount(scenario.monthsSaved);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.brassTint,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: c.brass.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.loanPrepayTitle, style: t.titleLarge!.copyWith(fontSize: 19))),
              if (locked) const ProBadge(strong: true),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.loanPrepayTeaser(f.money(scenario.amount, currency), after, monthsText, f.money(Money.round(scenario.interestSaved), currency)),
            style: t.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              if (!await requirePro(context, ProFeature.earlyRepayment) || !context.mounted) return;
              await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PrepaymentScreen()));
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: c.brassText),
            child: Text('${l.loanPrepayCta} →'),
          ),
        ],
      ),
    );
  }
}

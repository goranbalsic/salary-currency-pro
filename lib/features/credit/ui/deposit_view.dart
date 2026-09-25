import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
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
import '../domain/deposit_engine.dart';
import 'credit_widgets.dart';

const depositInputsKey = 'credit.deposit.v1';

/// Default withholding tax on deposit interest where the app knows it:
/// Serbia taxes interest on foreign-currency savings at 15 % and exempts
/// dinar savings. Elsewhere the person enters their own rate.
double defaultDepositTax(String homeCountry, String currency) {
  if (homeCountry == 'RS') return currency == 'RSD' ? 0 : 15;
  return 0;
}

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  static const _engine = DepositEngine();
  DepositInputs? _inputs;
  Timer? _recordTimer;
  ShellController? _shell;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inputs == null) {
      final settings = context.read<SettingsController>();
      final store = context.read<AppServices>().store;
      _inputs =
          DepositInputs.fromJson(store.readJson(depositInputsKey), fallbackCurrency: settings.homeCurrency) ??
          DepositInputs(
            currency: settings.homeCurrency,
            taxPercent: defaultDepositTax(settings.country.code, settings.homeCurrency),
          );
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
    final calc = _shell?.takeRestore(ToolId.deposit);
    if (calc == null || !mounted) return;
    final restored = DepositInputs.fromJson(calc.inputs, fallbackCurrency: _inputs!.currency);
    if (restored != null) _update(restored, record: false);
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShell);
    _recordTimer?.cancel();
    super.dispose();
  }

  void _update(DepositInputs next, {bool record = true}) {
    setState(() => _inputs = next);
    unawaited(context.read<AppServices>().store.writeJson(depositInputsKey, next.toJson()));
    _recordTimer?.cancel();
    final input = next.toInput();
    if (record && input != null && input.validate() == null) {
      _recordTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) unawaited(context.read<HistoryStore>().recordRecent(ToolId.deposit, next.toJson()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputs = _inputs!;
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final settings = context.watch<SettingsController>();
    final pro = context.watch<ProController>();
    final cur = inputs.currency;
    String money(double v) => f.money(v, cur);

    final input = inputs.toInput();
    final validation = input?.validate();
    final result = (input != null && validation == null) ? _engine.compute(input) : null;
    String? error;
    if ((inputs.principal != null || inputs.rate != null) && result == null) {
      error = switch (validation) {
        DepositInputError.rate => l.depErrorRate,
        null when input == null => l.depErrorRate,
        _ => l.depErrorAmount,
      };
    }

    return PageBody(
      padding: const EdgeInsets.fromLTRB(Gap.page, 18, Gap.page, 40),
      children: [
        Panel(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CurrencyAmountRow(
                label: l.depAmount,
                value: inputs.principal,
                currency: cur,
                currencies: creditCurrencies(settings.homeCurrency),
                onChanged: (v) => _update(inputs.copyWith(principal: v, clearPrincipal: v == null)),
                onCurrency: (code) => _update(
                  inputs.copyWith(
                    currency: code,
                    taxPercent: defaultDepositTax(settings.country.code, code),
                  ),
                ),
              ),
              NumberInputRow(
                label: l.depRate,
                value: inputs.rate,
                formats: f,
                suffix: l.commonPercentPa,
                maxIntegerDigits: 3,
                error: validation == DepositInputError.rate,
                onChanged: (v) => _update(inputs.copyWith(rate: v, clearRate: v == null)),
              ),
              TermField(
                label: l.depTerm,
                months: inputs.months,
                presets: const [3, 6, 12, 24, 36, 60],
                onChanged: (m) => _update(inputs.copyWith(months: m)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.depPayout, style: t.bodyMedium!.copyWith(color: c.ink2)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final (mode, label) in [
                          (Compounding.atMaturity, l.depAtMaturity),
                          (Compounding.monthly, l.depMonthly),
                          (Compounding.annually, l.depAnnually),
                        ])
                          PillChip(
                            label: label,
                            selected: inputs.compounding == mode,
                            onTap: () => _update(inputs.copyWith(compounding: mode)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: c.line),
              NumberInputRow(
                label: l.depTax,
                value: inputs.taxPercent,
                formats: f,
                suffix: '%',
                maxIntegerDigits: 3,
                onChanged: (v) => _update(inputs.copyWith(taxPercent: v, clearTax: v == null)),
              ),
              NumberInputRow(
                label: l.depContribution,
                hint: l.commonOptional,
                value: inputs.contribution,
                formats: f,
                suffix: f.currencySymbol(cur),
                divider: false,
                onChanged: (v) => _update(inputs.copyWith(contribution: v, clearContribution: v == null)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FinePrint(settings.country.code == 'RS' ? l.depTaxHintRs : l.depTaxHint),
        const SizedBox(height: 20),
        if (error != null) InfoNote(error, warning: true),
        if (result != null) ...[
          InkResultCard(
            label: l.depFinal,
            figure: money(result.finalBalance),
            stats: [
              (l.depNetInterest, f.number(result.netInterest), true),
              (l.depTaxAmount, f.number(result.tax), false),
              (l.depPaidIn, f.number(result.totalContributed), false),
            ],
            footnote: result.effectiveAnnualYield == null ? null : l.depYield(f.percent(result.effectiveAnnualYield!, decimals: 2)),
          ),
          const SizedBox(height: 24),
          SectionTitle(l.depByYear),
          _YearTable(result: result),
          const SizedBox(height: 22),
          ResultActions(
            saveLabel: l.actionSave,
            shareLabel: l.actionShare,
            pdfLabel: l.actionDownloadPdf,
            pdfLocked: !pro.can(ProFeature.pdfExport),
            onSave: () => saveCalculation(context, ToolId.deposit, inputs.toJson()),
            onShare: () async {
              final text = [
                '${l.toolDeposit}: ${money(input!.principal)} · ${f.percentValue(input.annualRatePercent)} · ${l.commonMonthsCount(input.months)}',
                '${l.depGrossInterest}: ${money(result.grossInterest)}',
                '${l.depTaxAmount}: ${money(result.tax)}',
                '${l.depFinal}: ${money(result.finalBalance)}',
                '— ${l.shareFooter}',
              ].join('\n');
              final ok = await shareText(text, subject: l.toolDeposit);
              if (!ok && context.mounted) showSnack(context, l.errorShare);
            },
            onPdf: () async {
              if (!await requirePro(context, ProFeature.pdfExport) || !context.mounted) return;
              await shareDepositPdf(context, result, cur);
            },
          ),
        ],
      ],
    );
  }
}

class _YearTable extends StatelessWidget {
  const _YearTable({required this.result});
  final DepositResult result;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final cell = t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular);
    Widget row(List<String> v, {bool header = false}) => Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: header ? c.ink : c.line)),
      ),
      child: Row(
        children: [
          SizedBox(width: 56, child: Text(v[0], style: header ? t.labelSmall : cell)),
          Expanded(
            child: Text(v[1], textAlign: TextAlign.right, style: header ? t.labelSmall : cell),
          ),
          Expanded(
            child: Text(v[2], textAlign: TextAlign.right, style: header ? t.labelSmall : cell),
          ),
        ],
      ),
    );
    return Column(
      children: [
        row([l.depColYear.toUpperCase(), l.depColInterest.toUpperCase(), l.depColBalance.toUpperCase()], header: true),
        for (final y in result.years) row(['${y.year}', f.number(y.grossInterest - y.tax), f.number(y.balance)]),
      ],
    );
  }
}

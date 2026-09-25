import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/storage/store.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../fx/data/rates_controller.dart';
import '../../history/history_store.dart';
import '../../history/save_dialog.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../reports/pdf_reports.dart';
import '../../settings/settings_controller.dart';
import '../../shell/root_shell.dart';
import '../domain/payroll_engine.dart';
import '../domain/payroll_inputs.dart';
import '../domain/payroll_models.dart';
import '../domain/payroll_rules.dart';
import 'payroll_breakdown.dart';
import 'payroll_labels.dart';
import 'payroll_sheets.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  static const _lastKey = 'payroll.last.v1';
  static const _engine = PayrollEngine();

  PayrollInputs? _inputs;
  Timer? _recordTimer;
  ShellController? _shell;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inputs == null) {
      final services = context.read<SettingsController>();
      final saved = PayrollInputs.fromJson(_storeOf(context).readJson(_lastKey));
      _inputs = saved ?? PayrollInputs(system: services.payrollSystem);
    }
    final shell = ShellScope.of(context);
    if (shell != _shell) {
      _shell?.removeListener(_onShell);
      _shell = shell;
      _shell?.addListener(_onShell);
      _onShell();
    }
  }

  Store _storeOf(BuildContext context) => context.read<AppServices>().store;

  void _onShell() {
    final calc = _shell?.takeRestore(ToolId.payroll);
    if (calc == null) return;
    final restored = PayrollInputs.fromJson(calc.inputs);
    if (restored != null && mounted) _update(restored, record: false);
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShell);
    _recordTimer?.cancel();
    super.dispose();
  }

  void _update(PayrollInputs next, {bool record = true}) {
    setState(() => _inputs = next);
    unawaited(_storeOf(context).writeJson(_lastKey, next.toJson()));
    _recordTimer?.cancel();
    if (record && (next.amount ?? 0) > 0) {
      _recordTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) unawaited(context.read<HistoryStore>().recordRecent(ToolId.payroll, next.toJson()));
      });
    }
  }

  Future<void> _pickSystem(PayrollInputs inputs) async {
    final settings = context.read<SettingsController>();
    final pro = context.read<ProController>();
    final picked = await showPayrollSystemSheet(
      context,
      current: inputs.system,
      homeCountry: settings.country.code,
      lockedOthers: !pro.can(ProFeature.allCountries),
    );
    if (picked == null || !mounted) return;
    if (picked.countryCode != settings.country.code && !pro.can(ProFeature.allCountries)) {
      final ok = await requirePro(context, ProFeature.allCountries);
      if (!ok || !mounted) return;
    }
    if (picked.countryCode == settings.country.code) unawaited(settings.setPayrollSystem(picked));
    _update(inputs.copyWith(system: picked, clearAmount: picked.currency != inputs.system.currency));
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
    final system = inputs.system;
    final locked = system.countryCode != settings.country.code && !pro.can(ProFeature.allCountries);

    PayrollResult? result;
    String? error;
    final amount = inputs.amount;
    if (amount != null && amount > 0 && !locked) {
      try {
        result = _engine.compute(system, inputs.mode, amount, inputs.options);
      } on PayrollSolveException {
        error = l.payErrorTooLarge;
      }
    }
    final rulesDate = f.date(PayrollRules.effectiveFrom(system));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageBody(
          padding: const EdgeInsets.fromLTRB(Gap.page, 16, Gap.page, 40),
          children: [
            ScreenHeader(
              title: l.payTitle,
              trailing: _SystemButton(system: system, onTap: () => _pickSystem(inputs)),
            ),
            const SizedBox(height: 18),
            Segmented<PayrollInputMode>(
              values: PayrollInputMode.values,
              selected: inputs.mode,
              semanticLabel: l.payModeSemantic,
              labelOf: (m) => switch (m) {
                PayrollInputMode.gross => l.payModeGross,
                PayrollInputMode.net => l.payModeNet,
                PayrollInputMode.totalCost => l.payModeCost,
              },
              onChanged: (m) {
                // Carry the current figure over: switching to "net" starts
                // from the net just computed, and so on.
                double? carry;
                if (result != null) {
                  carry = switch (m) {
                    PayrollInputMode.gross => result.gross,
                    PayrollInputMode.net => result.net > 0 ? result.net : null,
                    PayrollInputMode.totalCost => result.totalCost,
                  };
                }
                _update(inputs.copyWith(mode: m, amount: carry, clearAmount: carry == null));
              },
            ),
            if (payrollHasOptions(system)) ...[
              const SizedBox(height: 10),
              _OptionsRow(
                system: system,
                options: inputs.options,
                onTap: () async {
                  final next = await showPayrollOptionsSheet(context, system: system, options: inputs.options);
                  if (next != null && mounted) _update(inputs.copyWith(options: next));
                },
              ),
            ],
            const SizedBox(height: 20),
            AmountField(
              key: ValueKey('pay-${system.name}-${inputs.mode.name}'),
              label: switch (inputs.mode) {
                PayrollInputMode.gross => l.payInputGross,
                PayrollInputMode.net => l.payInputNet,
                PayrollInputMode.totalCost => l.payInputCost,
              },
              value: inputs.amount,
              formats: f,
              decimals: system.decimals,
              suffix: f.currencySymbol(system.currency),
              helper: _helper(l, f, inputs),
              onChanged: (v) => _update(inputs.copyWith(amount: v, clearAmount: v == null)),
            ),
            const SizedBox(height: 22),
            if (locked)
              _LockedCard(system: system)
            else if (error != null)
              InfoNote(error, warning: true)
            else if (result == null)
              InfoNote(l.payEmpty)
            else ...[
              _ResultHero(result: result, mode: inputs.mode),
              const SizedBox(height: 26),
              SectionTitle(
                l.payBreakdown,
                trailing: PillChip(
                  label: l.payAnnualToggle,
                  selected: settings.annualView,
                  onTap: () => settings.setAnnualView(!settings.annualView),
                ),
              ),
              PayrollBreakdown(result: result, annual: settings.annualView),
              ..._notes(l, f, result),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text(l.payWedge(f.percent(result.taxWedge)), style: t.bodySmall)),
                  Text(l.payRulesFrom(rulesDate), style: t.bodySmall),
                ],
              ),
              if (settings.annualView) ...[const SizedBox(height: 6), FinePrint(l.payAnnualNote)],
              const SizedBox(height: 22),
              ResultActions(
                saveLabel: l.actionSave,
                shareLabel: l.actionShare,
                pdfLabel: l.actionDownloadPdf,
                pdfLocked: !pro.can(ProFeature.pdfExport),
                onSave: () => saveCalculation(context, ToolId.payroll, inputs.toJson()),
                onShare: () async {
                  final ok = await shareText(payrollShareText(l, f, result!, rulesDate), subject: l.payTitle);
                  if (!ok && context.mounted) showSnack(context, l.errorShare);
                },
                onPdf: () async {
                  if (!await requirePro(context, ProFeature.pdfExport) || !context.mounted) return;
                  await sharePayrollPdf(context, result!, annual: settings.annualView);
                },
              ),
              const SizedBox(height: 16),
              FinePrint(l.payDisclaimer(rulesDate)),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => _showSources(context, system),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(l.paySources),
                ),
              ),
            ],
            if (result == null && !locked) ...[
              const SizedBox(height: 16),
              FinePrint(l.payDisclaimer(rulesDate)),
            ],
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ExcludeSemantics(child: SizedBox(height: 1, child: ColoredBox(color: c.paper))),
          ],
        ),
      ),
    );
  }

  String? _helper(AppLocalizations l, Formats f, PayrollInputs inputs) {
    if (inputs.mode == PayrollInputMode.net) return l.payHelperNet;
    if (inputs.mode == PayrollInputMode.totalCost) return l.payHelperCost;
    if (inputs.system == PayrollSystem.serbia) {
      return l.payHelperRsMinBase(f.money(PayrollRules.rsMinBase, 'RSD', decimals: 0));
    }
    return null;
  }

  List<Widget> _notes(AppLocalizations l, Formats fm, PayrollResult r) {
    String m(double v) => fm.money(v, r.system.currency, decimals: r.system.decimals);
    final out = <Widget>[];
    void add(String text, {bool warning = false}) {
      out.add(Padding(padding: const EdgeInsets.only(top: 8), child: InfoNote(text, warning: warning)));
    }

    if (r.notes.contains(PayrollNote.nonPositiveNet)) add(l.payNoteNonPositive, warning: true);
    if (r.notes.contains(PayrollNote.minimumBaseApplied)) {
      final min = switch (r.system) {
        PayrollSystem.serbia => PayrollRules.rsMinBase,
        PayrollSystem.northMacedonia => PayrollRules.mkMinBase,
        _ => null,
      };
      if (min != null) add(l.payNoteMinBase(m(min)));
    }
    if (r.notes.contains(PayrollNote.maximumBaseApplied)) {
      final max = switch (r.system) {
        PayrollSystem.serbia => PayrollRules.rsMaxBase,
        PayrollSystem.northMacedonia => PayrollRules.mkMaxBase,
        PayrollSystem.bulgaria => PayrollRules.bgMaxBase,
        PayrollSystem.croatia => PayrollRules.hrMaxPensionBase,
        PayrollSystem.montenegro => PayrollRules.meMaxBase,
        _ => null,
      };
      if (max != null) add(l.payNoteMaxBase(m(max)));
    }
    if (r.notes.contains(PayrollNote.pensionReliefApplied)) {
      add(l.payNoteRelief(m(PayrollEngine.croatiaPensionBase(r.gross))));
    }
    return out;
  }

  void _showSources(BuildContext context, PayrollSystem system) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    unawaited(showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 24),
        children: [
          Text(l.sourcesTitle, style: t.titleLarge),
          const SizedBox(height: 12),
          for (final s in PayrollRules.sources(system))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text('•  '), Expanded(child: Text(s, style: t.bodyMedium))],
              ),
            ),
          const SizedBox(height: 4),
          FinePrint(l.payDisclaimer(context.fmt.date(PayrollRules.effectiveFrom(system)))),
        ],
      ),
    ));
  }
}

class _SystemButton extends StatelessWidget {
  const _SystemButton({required this.system, required this.onTap});

  final PayrollSystem system;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final name = system == PayrollSystem.fbih ? 'FBiH' : (system == PayrollSystem.republikaSrpska ? 'RS BiH' : l.countryName(system.countryCode));
    return Semantics(
      button: true,
      label: '${l.paySystemTitle}: ${l.systemName(system)}',
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md), side: BorderSide(color: c.line)),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, maxWidth: 170),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeTile(system.countryCode, filled: true, width: 30),
                  const SizedBox(width: 8),
                  Flexible(child: Text(name, style: t.labelMedium, overflow: TextOverflow.ellipsis)),
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

class _OptionsRow extends StatelessWidget {
  const _OptionsRow({required this.system, required this.options, required this.onTap});

  final PayrollSystem system;
  final PayrollOptions options;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final summary = switch (system) {
      PayrollSystem.croatia => l.payOptionsHrSummary(
          f.percentValue(options.croatiaLowerRate * 100, decimals: _dec(options.croatiaLowerRate)),
          f.percentValue(options.croatiaHigherRate * 100, decimals: _dec(options.croatiaHigherRate)),
          options.children,
        ),
      PayrollSystem.montenegro =>
        l.payOptionsMeSummary(f.percentValue(options.montenegroSurtaxRate * 100, decimals: _dec(options.montenegroSurtaxRate))),
      PayrollSystem.romania => [
          l.payOptionsRoSummary(options.dependents),
          if (options.romaniaMinimumWageFacility) l.payOptionsRoMinWage,
        ].join(' · '),
      PayrollSystem.fbih => l.payOptionsFbihSummary(options.fbihDisabilityFund ? l.payOn : l.payOff),
      _ => '',
    };
    return SelectRow(label: l.payOptions, value: summary, onTap: onTap, divider: false);
  }

  static int _dec(double rate) {
    final p = rate * 100;
    return (p - p.roundToDouble()).abs() < 1e-9 ? 0 : 2;
  }
}

class _ResultHero extends StatelessWidget {
  const _ResultHero({required this.result, required this.mode});

  final PayrollResult result;
  final PayrollInputMode mode;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final r = result;
    final cur = r.system.currency;
    final d = r.system.decimals;
    final rates = context.watch<RatesController>();
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);

    final (label, figure) = switch (mode) {
      PayrollInputMode.gross => (l.payResultNet, r.net),
      PayrollInputMode.net => (l.payResultGross, r.gross),
      PayrollInputMode.totalCost => (l.payResultGrossBudget, r.gross),
    };
    final lines = <String>[];
    // Convert to the home currency (or to EUR when the pay already is in
    // the home currency but not in euros) for context.
    final target = cur != home ? home : (cur != 'EUR' ? 'EUR' : null);
    if (target != null) {
      final conv = rates.book.convert(figure, cur, target);
      if (conv != null) lines.add(l.payApprox(f.money(conv.result, target)));
    }
    switch (mode) {
      case PayrollInputMode.gross:
        lines.add(l.payShareOfGross(f.percent(r.netToGross)));
      case PayrollInputMode.net:
      case PayrollInputMode.totalCost:
        lines.add(l.payNetLine(f.money(r.net, cur, decimals: d)));
    }
    final shares = percentShares([r.net, r.totalTax, r.employeeTotal, r.employerTotal]);
    final segs = [
      ChartSegment(label: l.segNet, value: r.net > 0 ? r.net : 0, color: c.chart1, valueLabel: f.percentValue(shares[0], decimals: 1)),
      ChartSegment(label: l.segTax, value: r.totalTax, color: c.chart2, valueLabel: f.percentValue(shares[1], decimals: 1)),
      ChartSegment(label: l.segEmployee, value: r.employeeTotal, color: c.chart3, valueLabel: f.percentValue(shares[2], decimals: 1)),
      if (r.employerTotal > 0)
        ChartSegment(label: l.segEmployer, value: r.employerTotal, color: c.chart4, valueLabel: f.percentValue(shares[3], decimals: 1)),
    ];
    return Panel(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      radius: Radii.xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Overline(label),
          const SizedBox(height: 4),
          Semantics(
            label: '$label ${f.money(figure, cur, decimals: d)}',
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(f.number(figure, decimals: d), style: t.displayLarge!.copyWith(color: c.green)),
                  const SizedBox(width: 8),
                  Text(f.currencySymbol(cur), style: t.titleMedium!.copyWith(color: c.ink2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(lines.join(' · '), style: t.bodyMedium!.copyWith(color: c.ink2)),
          if (mode != PayrollInputMode.totalCost && r.employerLines.isNotEmpty)
            Text(l.payTotalCostLine(f.money(r.totalCost, cur, decimals: d)), style: t.bodyMedium!.copyWith(color: c.ink2)),
          const SizedBox(height: 18),
          Text(l.payComposition, style: t.labelMedium!.copyWith(color: c.ink2)),
          const SizedBox(height: 10),
          CompositionBar(segments: segs),
        ],
      ),
    );
  }
}

class _LockedCard extends StatelessWidget {
  const _LockedCard({required this.system});
  final PayrollSystem system;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    return Panel(
      color: c.brassTint,
      borderColor: c.brass.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: Text(l.systemName(system), style: t.titleLarge)), const ProBadge(strong: true)]),
          const SizedBox(height: 8),
          Text(l.paySystemProHint, style: t.bodyMedium),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => requirePro(context, ProFeature.allCountries),
            child: Text(l.proFeatureTitle(l.systemName(system))),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../reports/pdf_reports.dart';
import '../../settings/settings_controller.dart';
import '../data/team_store.dart';
import '../domain/payroll_engine.dart';
import '../domain/payroll_models.dart';
import 'payroll_breakdown.dart';
import 'payroll_labels.dart';
import 'payroll_sheets.dart';

/// Totals for one currency across the team.
class TeamTotals {
  TeamTotals(this.currency, this.decimals);

  final String currency;
  final int decimals;
  final _gross = <double>[];
  final _net = <double>[];
  final _tax = <double>[];
  final _employee = <double>[];
  final _employer = <double>[];
  final _cost = <double>[];
  int count = 0;

  void add(PayrollResult r) {
    count++;
    _gross.add(r.gross);
    _net.add(r.net > 0 ? r.net : 0);
    _tax.add(r.totalTax);
    _employee.add(r.employeeTotal);
    _employer.add(r.employerTotal);
    _cost.add(r.totalCost);
  }

  double get gross => Money.sum(_gross, decimals);
  double get net => Money.sum(_net, decimals);
  double get tax => Money.sum(_tax, decimals);
  double get employee => Money.sum(_employee, decimals);
  double get employer => Money.sum(_employer, decimals);
  double get cost => Money.sum(_cost, decimals);

  /// Groups team members' results by currency, in first-seen order.
  static List<TeamTotals> of(Iterable<TeamMember> members) {
    final byCurrency = <String, TeamTotals>{};
    for (final m in members) {
      final t = byCurrency.putIfAbsent(m.system.currency, () => TeamTotals(m.system.currency, m.system.decimals));
      t.add(m.compute());
    }
    return byCurrency.values.toList();
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool _annual = false;
  bool _busy = false;

  Future<void> _edit([TeamMember? member]) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => TeamMemberScreen(member: member)));
  }

  Future<void> _pdf() async {
    if (_busy) return;
    if (!await requirePro(context, ProFeature.pdfExport) || !mounted) return;
    setState(() => _busy = true);
    try {
      await shareTeamPdf(context, context.read<TeamStore>().members, annual: _annual);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share(List<TeamMember> members, List<TeamTotals> totals) async {
    final l = context.l10n;
    final f = context.fmt;
    final mult = _annual ? 12 : 1;
    final b = StringBuffer('${l.teamTitle} · ${_annual ? l.commonAnnual : l.commonMonthly}\n\n');
    for (final m in members) {
      final r = m.compute();
      String money(double v) => f.money(v * mult, m.system.currency, decimals: m.system.decimals);
      b.writeln('${m.name.isEmpty ? l.teamUnnamed : m.name}${m.role.isEmpty ? '' : ' (${m.role})'} · ${l.systemName(m.system)}');
      b.writeln('  ${l.payGross}: ${money(r.gross)} · ${l.payNetTotal}: ${money(r.net)} · ${l.payTotalCost}: ${money(r.totalCost)}');
    }
    for (final t in totals) {
      String money(double v) => f.money(v * mult, t.currency, decimals: t.decimals);
      b
        ..writeln()
        ..writeln('${l.teamTotal} (${t.currency}): ${l.payTotalCost} ${money(t.cost)} · ${l.payGross} ${money(t.gross)} · ${l.payNetTotal} ${money(t.net)}');
    }
    b
      ..writeln()
      ..write('— ${l.shareFooter}');
    final ok = await shareText(b.toString(), subject: l.teamTitle);
    if (!ok && mounted) showSnack(context, l.errorShare);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final team = context.watch<TeamStore>();
    final pro = context.watch<ProController>();
    final members = team.members;
    final totals = TeamTotals.of(members);
    final mult = _annual ? 12 : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.teamTitle),
        actions: [IconButton(tooltip: l.teamAdd, onPressed: _edit, icon: const Icon(Icons.person_add_alt_1_outlined))],
      ),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          if (members.isEmpty) ...[
            const SizedBox(height: 12),
            Text(l.teamEmptyTitle, style: t.headlineSmall),
            const SizedBox(height: 8),
            Text(l.teamEmpty, style: t.bodyMedium!.copyWith(color: c.ink2)),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: _edit, icon: const Icon(Icons.person_add_alt_1_outlined), label: Text(l.teamAdd)),
          ] else ...[
            Segmented<bool>(
              values: const [false, true],
              selected: _annual,
              labelOf: (v) => v ? l.commonAnnual : l.commonMonthly,
              onChanged: (v) => setState(() => _annual = v),
            ),
            const SizedBox(height: 16),
            for (final total in totals) ...[
              _TotalsCard(totals: total, multiplier: mult),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 8),
            SectionTitle(l.teamMembers(members.length)),
            for (final m in members) _MemberRow(member: m, multiplier: mult, onTap: () => _edit(m)),
            const SizedBox(height: 14),
            OutlinedButton.icon(onPressed: _edit, icon: const Icon(Icons.add), label: Text(l.teamAdd)),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => _share(members, totals),
              icon: const Icon(Icons.ios_share, size: 20),
              label: Text(l.actionShare),
            ),
            const SizedBox(height: 10),
            PdfButton(label: l.actionDownloadPdf, locked: !pro.can(ProFeature.pdfExport), busy: _busy, onPressed: _pdf),
            const SizedBox(height: 16),
            FinePrint(l.teamNote),
            if (totals.length > 1) ...[const SizedBox(height: 6), FinePrint(l.teamCurrenciesNote)],
          ],
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.totals, required this.multiplier});

  final TeamTotals totals;
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    String money(double v) => f.money(v * multiplier, totals.currency, decimals: totals.decimals);
    final shares = percentShares([totals.net, totals.tax, totals.employee, totals.employer]);
    return Panel(
      radius: Radii.xl,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Overline(l.payTotalCost),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(money(totals.cost), style: t.displayLarge!.copyWith(fontSize: 38)),
          ),
          const SizedBox(height: 14),
          CompositionBar(
            segments: [
              ChartSegment(label: l.segNet, value: totals.net, color: c.chart1, valueLabel: f.percentValue(shares[0], decimals: 1)),
              ChartSegment(label: l.segTax, value: totals.tax, color: c.chart2, valueLabel: f.percentValue(shares[1], decimals: 1)),
              ChartSegment(label: l.segEmployee, value: totals.employee, color: c.chart3, valueLabel: f.percentValue(shares[2], decimals: 1)),
              if (totals.employer > 0)
                ChartSegment(label: l.segEmployer, value: totals.employer, color: c.chart4, valueLabel: f.percentValue(shares[3], decimals: 1)),
            ],
          ),
          const SizedBox(height: 12),
          LedgerRow(label: l.payGross, value: money(totals.gross)),
          LedgerRow(label: l.payNetTotal, value: money(totals.net)),
          LedgerRow(label: l.segTax, value: money(totals.tax)),
          LedgerRow(label: l.segEmployee, value: money(totals.employee)),
          LedgerRow(label: l.segEmployer, value: money(totals.employer), divider: false),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.multiplier, required this.onTap});

  final TeamMember member;
  final int multiplier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final r = member.compute();
    String money(double v) => f.money(v * multiplier, member.system.currency, decimals: member.system.decimals);
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
        child: Row(
          children: [
            CodeTile(member.system.countryCode),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name.isEmpty ? l.teamUnnamed : member.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    [if (member.role.isNotEmpty) member.role, '${l.payNetTotal} ${money(r.net)}'].join(' · '),
                    style: t.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(money(r.totalCost), style: t.titleMedium!.copyWith(fontFeatures: Fonts.tabular)),
                Text(l.teamCostShort, style: t.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Adds or edits one team member.
class TeamMemberScreen extends StatefulWidget {
  const TeamMemberScreen({super.key, this.member});

  final TeamMember? member;

  @override
  State<TeamMemberScreen> createState() => _TeamMemberScreenState();
}

class _TeamMemberScreenState extends State<TeamMemberScreen> {
  final _name = TextEditingController();
  final _role = TextEditingController();
  late PayrollSystem _system;
  PayrollInputMode _mode = PayrollInputMode.gross;
  double? _amount;
  PayrollOptions _options = const PayrollOptions();
  bool _loaded = false;
  bool _tried = false;
  String _initial = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final m = widget.member;
    _system = m?.system ?? context.read<SettingsController>().payrollSystem;
    if (m != null) {
      _name.text = m.name;
      _role.text = m.role;
      _mode = m.mode;
      _amount = m.amount;
      _options = m.options;
    }
    _initial = _snapshot();
  }

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    super.dispose();
  }

  String _snapshot() => jsonEncode({
        'n': _name.text.trim(),
        'r': _role.text.trim(),
        's': _system.name,
        'm': _mode.name,
        'a': _amount,
        'o': _options.toJson(),
      });

  bool get _dirty => _snapshot() != _initial;

  Future<void> _pickSystem() async {
    final settings = context.read<SettingsController>();
    final pro = context.read<ProController>();
    final picked = await showPayrollSystemSheet(
      context,
      current: _system,
      homeCountry: settings.country.code,
      lockedOthers: !pro.can(ProFeature.allCountries),
    );
    if (picked == null || !mounted) return;
    if (picked.countryCode != settings.country.code && !await requirePro(context, ProFeature.allCountries)) return;
    setState(() {
      if (picked.currency != _system.currency) _amount = null;
      _system = picked;
      _options = const PayrollOptions();
    });
  }

  Future<void> _pickOptions() async {
    final picked = await showPayrollOptionsSheet(context, system: _system, options: _options);
    if (picked != null) setState(() => _options = picked);
  }

  Future<void> _save() async {
    setState(() => _tried = true);
    final amount = _amount;
    if (amount == null || amount <= 0) return;
    final team = context.read<TeamStore>();
    final member = TeamMember(
      id: widget.member?.id ?? team.newId(),
      name: _name.text.trim(),
      role: _role.text.trim(),
      system: _system,
      mode: _mode,
      amount: amount,
      options: _options,
    );
    await team.upsert(member);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final m = widget.member;
    if (m == null) return;
    final ok = await confirmDestructive(context, title: l.teamRemoveTitle(m.name.isEmpty ? l.teamUnnamed : m.name), action: l.actionRemove);
    if (!ok || !mounted) return;
    final team = context.read<TeamStore>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await team.remove(m.id);
    navigator.pop();
    messenger.showSnackBar(SnackBar(
      content: Text(l.snackDeleted),
      action: SnackBarAction(label: l.actionUndo, onPressed: () => team.upsert(m)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final amount = _amount;
    PayrollResult? result;
    var tooLarge = false;
    if (amount != null && amount > 0) {
      try {
        result = const PayrollEngine().compute(_system, _mode, amount, _options);
      } on PayrollSolveException {
        tooLarge = true;
      }
    }
    String money(double v) => f.money(v, _system.currency, decimals: _system.decimals);
    final label = switch (_mode) {
      PayrollInputMode.gross => l.payInputGross,
      PayrollInputMode.net => l.payInputNet,
      PayrollInputMode.totalCost => l.payInputCost,
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!_dirty || await confirmDiscard(context)) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.member == null ? l.teamAdd : l.teamEdit),
          actions: [
            if (widget.member != null) IconButton(tooltip: l.actionRemove, onPressed: _delete, icon: const Icon(Icons.delete_outline)),
          ],
        ),
        bottomNavigationBar: BottomActions(children: [FilledButton(onPressed: _save, child: Text(l.actionSave))]),
        body: PageBody(
          padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 32),
          children: [
            TextBox(controller: _name, label: l.teamName, textCapitalization: TextCapitalization.words, maxLength: 60),
            const SizedBox(height: 12),
            TextBox(controller: _role, label: l.teamRole, hint: l.teamRoleHint, textCapitalization: TextCapitalization.sentences, maxLength: 60),
            const SizedBox(height: 12),
            PickerBox(
              label: l.paySystemTitle,
              value: l.systemName(_system),
              leading: CodeTile(_system.countryCode),
              onTap: _pickSystem,
            ),
            if (payrollHasOptions(_system)) ...[
              const SizedBox(height: 12),
              PickerBox(label: l.payOptions, value: payrollOptionsSummary(l, f, _system, _options), onTap: _pickOptions),
            ],
            const SizedBox(height: 20),
            Segmented<PayrollInputMode>(
              values: PayrollInputMode.values,
              selected: _mode,
              semanticLabel: l.payModeSemantic,
              labelOf: (m) => switch (m) {
                PayrollInputMode.gross => l.payModeGross,
                PayrollInputMode.net => l.payModeNet,
                PayrollInputMode.totalCost => l.payModeCost,
              },
              onChanged: (m) => setState(() {
                // Keep the equivalent amount so switching modes changes nothing.
                final r = result;
                if (r != null) {
                  _amount = switch (m) {
                    PayrollInputMode.gross => r.gross,
                    PayrollInputMode.net => r.net > 0 ? r.net : null,
                    PayrollInputMode.totalCost => r.totalCost,
                  };
                }
                _mode = m;
              }),
            ),
            const SizedBox(height: 20),
            AmountField(
              label: label,
              value: _amount,
              formats: f,
              decimals: _system.decimals,
              suffix: f.currencySymbol(_system.currency),
              onChanged: (v) => setState(() => _amount = v),
            ),
            if (_tried && (amount == null || amount <= 0)) ...[
              const SizedBox(height: 8),
              Text(l.teamAmountError, style: t.bodySmall!.copyWith(color: context.colors.brick)),
            ],
            if (tooLarge) ...[const SizedBox(height: 8), InfoNote(l.payErrorTooLarge, warning: true)],
            if (result != null) ...[
              const SizedBox(height: 18),
              Panel(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  children: [
                    LedgerRow(label: l.payGross, value: money(result.gross)),
                    LedgerRow(label: l.payNetTotal, value: money(result.net)),
                    LedgerRow(label: l.payTotalCost, value: money(result.totalCost), emphasis: true, divider: false),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../domain/payroll_models.dart';
import '../domain/payroll_rules.dart';

/// Picks a payroll system. Systems outside the home country show a Pro tag
/// when [lockedOthers] is true (the caller decides what happens on tap).
Future<PayrollSystem?> showPayrollSystemSheet(
  BuildContext context, {
  required PayrollSystem current,
  required String homeCountry,
  required bool lockedOthers,
}) {
  return showModalBottomSheet<PayrollSystem>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final c = context.colors;
      final t = Theme.of(context).textTheme;
      final l = context.l10n;
      final ordered = [
        ...PayrollSystem.values.where((s) => s.countryCode == homeCountry),
        ...PayrollSystem.values.where((s) => s.countryCode != homeCountry),
      ];
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 24),
          children: [
            Text(l.paySystemTitle, style: t.titleLarge),
            if (lockedOthers) ...[const SizedBox(height: 6), Text(l.paySystemProHint, style: t.bodySmall)],
            const SizedBox(height: 12),
            Container(height: 1, color: c.ink),
            for (final s in ordered)
              InkWell(
                onTap: () => Navigator.of(context).pop(s),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 60),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
                  child: Row(
                    children: [
                      CodeTile(s.countryCode, filled: s == current),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l.systemName(s), style: t.titleMedium),
                            if (s == PayrollSystem.fbih || s == PayrollSystem.republikaSrpska)
                              Text(l.countryBA, style: t.bodySmall),
                          ],
                        ),
                      ),
                      Text(s.currency, style: t.bodySmall!.copyWith(color: c.ink2)),
                      const SizedBox(width: 10),
                      if (lockedOthers && s.countryCode != homeCountry)
                        const ProBadge()
                      else
                        SizedBox(width: 30, child: s == current ? Icon(Icons.check, color: c.green) : null),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

/// Country-specific options (Croatian rates and children, Montenegrin
/// surtax, Romanian dependants, FBiH disability fund).
Future<PayrollOptions?> showPayrollOptionsSheet(
  BuildContext context, {
  required PayrollSystem system,
  required PayrollOptions options,
}) {
  return showModalBottomSheet<PayrollOptions>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _OptionsSheet(system: system, initial: options),
  );
}

class _OptionsSheet extends StatefulWidget {
  const _OptionsSheet({required this.system, required this.initial});

  final PayrollSystem system;
  final PayrollOptions initial;

  @override
  State<_OptionsSheet> createState() => _OptionsSheetState();
}

class _OptionsSheetState extends State<_OptionsSheet> {
  late PayrollOptions _o = widget.initial;
  late double? _lower = widget.initial.croatiaLowerRate * 100;
  late double? _higher = widget.initial.croatiaHigherRate * 100;
  late double? _surtax = widget.initial.montenegroSurtaxRate * 100;

  bool get _hrValid {
    final lo = _lower;
    final hi = _higher;
    if (lo == null || hi == null) return false;
    final (lMin, lMax) = PayrollRules.hrLowerRateRange;
    final (hMin, hMax) = PayrollRules.hrHigherRateRange;
    return lo >= lMin * 100 && lo <= lMax * 100 && hi >= hMin * 100 && hi <= hMax * 100;
  }

  bool get _meValid => _surtax != null && _surtax! >= 0 && _surtax! <= 50;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final valid = switch (widget.system) {
      PayrollSystem.croatia => _hrValid,
      PayrollSystem.montenegro => _meValid,
      _ => true,
    };
    final children = <Widget>[];
    switch (widget.system) {
      case PayrollSystem.croatia:
        final (lMin, lMax) = PayrollRules.hrLowerRateRange;
        final (hMin, hMax) = PayrollRules.hrHigherRateRange;
        children.addAll([
          Overline(l.payHrRates, padding: const EdgeInsets.only(bottom: 4)),
          NumberInputRow(
            label: l.payHrLower,
            value: _lower,
            formats: f,
            suffix: '%',
            decimals: 2,
            maxIntegerDigits: 2,
            error: !_hrValid,
            onChanged: (v) => setState(() => _lower = v),
          ),
          NumberInputRow(
            label: l.payHrHigher,
            value: _higher,
            formats: f,
            suffix: '%',
            decimals: 2,
            maxIntegerDigits: 2,
            error: !_hrValid,
            onChanged: (v) => setState(() => _higher = v),
          ),
          const SizedBox(height: 8),
          FinePrint(_hrValid
              ? l.payHrRatesHint
              : l.payHrRateError(
                  '${f.number(lMin * 100, decimals: 0)}–${f.number(lMax * 100, decimals: 0)}${f.percentSign}',
                  '${f.number(hMin * 100, decimals: 0)}–${f.number(hMax * 100, decimals: 0)}${f.percentSign}',
                )),
          const SizedBox(height: 16),
          StepperRow(
            label: l.payChildren,
            value: _o.children,
            max: PayrollRules.hrChildFactors.length,
            onChanged: (v) => setState(() => _o = _o.copyWith(children: v)),
          ),
          StepperRow(
            label: l.payDependents,
            value: _o.dependents,
            max: 10,
            divider: false,
            onChanged: (v) => setState(() => _o = _o.copyWith(dependents: v)),
          ),
        ]);
      case PayrollSystem.montenegro:
        children.addAll([
          NumberInputRow(
            label: l.payMeSurtax,
            value: _surtax,
            formats: f,
            suffix: '%',
            decimals: 2,
            maxIntegerDigits: 2,
            error: !_meValid,
            divider: false,
            onChanged: (v) => setState(() => _surtax = v),
          ),
          const SizedBox(height: 8),
          FinePrint(l.payMeSurtaxHint),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in const [10.0, 13.0, 15.0])
                PillChip(
                  label: f.percentValue(preset, decimals: 0),
                  selected: _surtax == preset,
                  onTap: () => setState(() => _surtax = preset),
                ),
            ],
          ),
        ]);
      case PayrollSystem.romania:
        children.addAll([
          StepperRow(
            label: l.payRoDependents,
            value: _o.dependents.clamp(0, 4),
            max: 4,
            suffix: _o.dependents >= 4 ? '+' : null,
            onChanged: (v) => setState(() => _o = _o.copyWith(dependents: v)),
          ),
          SwitchRow(
            label: l.payRoMinWage,
            hint: l.payRoMinWageHint,
            value: _o.romaniaMinimumWageFacility,
            divider: false,
            onChanged: (v) => setState(() => _o = _o.copyWith(romaniaMinimumWageFacility: v)),
          ),
        ]);
      case PayrollSystem.fbih:
        children.add(SwitchRow(
          label: l.payFbihDisability,
          hint: l.payFbihDisabilityHint,
          value: _o.fbihDisabilityFund,
          divider: false,
          onChanged: (v) => setState(() => _o = _o.copyWith(fbihDisabilityFund: v)),
        ));
      default:
        break;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${l.payOptions} · ${l.systemName(widget.system)}', style: t.titleLarge),
            const SizedBox(height: 12),
            ...children,
            const SizedBox(height: 20),
            FilledButton(
              onPressed: valid
                  ? () {
                      var out = _o;
                      if (widget.system == PayrollSystem.croatia) {
                        out = out.copyWith(croatiaLowerRate: _lower! / 100, croatiaHigherRate: _higher! / 100);
                      }
                      if (widget.system == PayrollSystem.montenegro) out = out.copyWith(montenegroSurtaxRate: _surtax! / 100);
                      Navigator.of(context).pop(out);
                    }
                  : null,
              child: Text(l.actionDone),
            ),
          ],
        ),
      ),
    );
  }
}

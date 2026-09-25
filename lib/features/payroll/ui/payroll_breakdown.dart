import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../domain/payroll_models.dart';
import 'payroll_labels.dart';

/// The statement-style breakdown of a payroll result: employee section
/// closed by net pay, employer section closed by total cost.
class PayrollBreakdown extends StatelessWidget {
  const PayrollBreakdown({super.key, required this.result, this.annual = false});

  final PayrollResult result;
  final bool annual;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final c = context.colors;
    final r = result;
    final d = r.system.decimals;
    final k = annual ? 12.0 : 1.0;
    String m(double v) => f.number(Money.round(v * k, d), decimals: d);
    String neg(double v) => v == 0 ? m(0) : '−${m(v)}';
    String pct(double? rate) => rate == null ? '' : f.percentValue(rate * 100, decimals: _rateDecimals(rate));

    final rows = <Widget>[
      Overline(l.payEmployee, padding: const EdgeInsets.only(top: 6, bottom: 2)),
      LedgerRow(label: l.payGross, value: m(r.gross)),
      for (final line in r.employeeLines)
        LedgerRow(
          label: payrollItemLabel(l, line.item),
          hint: line.rate == null ? null : pct(line.rate),
          note: line.base != null ? l.payOnBase(m(line.base!)) : (line.rate == null ? l.payFixedMonthly : null),
          value: neg(line.amount),
        ),
    ];
    final allowanceLabel = payrollAllowanceLabel(l, r.system);
    if (allowanceLabel != null && r.allowance > 0) {
      rows.add(LedgerRow(label: allowanceLabel, value: m(r.allowance), valueColor: c.ink2));
    }
    if (r.system != PayrollSystem.montenegro) {
      rows.add(LedgerRow(label: l.payTaxBase, value: m(r.taxableBase)));
    }
    if (r.taxBands.length <= 1) {
      final band = r.taxBands.firstOrNull;
      rows.add(
        LedgerRow(
          label: l.payIncomeTax,
          hint: band == null ? null : pct(band.rate),
          value: neg(r.incomeTax),
          divider: r.surtax > 0,
        ),
      );
    } else {
      for (var i = 0; i < r.taxBands.length; i++) {
        final b = r.taxBands[i];
        rows.add(
          LedgerRow(
            label: i == 0 ? l.payIncomeTax : '',
            note: l.payTaxOn(pct(b.rate), m(b.taxable)),
            value: neg(b.tax),
            divider: i == r.taxBands.length - 1 && r.surtax > 0,
          ),
        );
      }
    }
    if (r.surtax > 0) {
      rows.add(
        LedgerRow(
          label: l.paySurtax,
          hint: pct(r.options.montenegroSurtaxRate),
          value: neg(r.surtax),
          divider: false,
        ),
      );
    }
    rows.add(LedgerTotal(label: l.payNetTotal, value: m(r.net)));

    if (r.employerLines.isNotEmpty) {
      rows.add(Overline(l.payEmployer, padding: const EdgeInsets.only(top: 14, bottom: 2)));
      for (var i = 0; i < r.employerLines.length; i++) {
        final line = r.employerLines[i];
        rows.add(
          LedgerRow(
            label: payrollItemLabel(l, line.item),
            hint: line.rate == null ? null : pct(line.rate),
            note: line.base != null ? l.payOnBase(m(line.base!)) : null,
            value: m(line.amount),
            divider: i < r.employerLines.length - 1,
          ),
        );
      }
      rows.add(LedgerTotal(label: l.payTotalCost, value: m(r.totalCost)));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }

  static int _rateDecimals(double rate) {
    final p = rate * 100;
    if ((p - p.roundToDouble()).abs() < 1e-9) return 0;
    if ((p * 10 - (p * 10).roundToDouble()).abs() < 1e-9) return 1;
    return 2;
  }
}

/// Largest-remainder rounding so displayed percentages sum to exactly 100.
List<double> percentShares(List<double> values, {int decimals = 1}) {
  final total = values.fold<double>(0, (a, v) => a + (v > 0 ? v : 0));
  if (total <= 0) return List.filled(values.length, 0);
  final scale = decimals == 0 ? 1 : (decimals == 1 ? 10 : 100);
  final target = 100 * scale;
  final raw = [for (final v in values) (v > 0 ? v : 0) / total * target];
  final floors = [for (final r in raw) r.floor()];
  var remaining = target - floors.fold<int>(0, (a, v) => a + v);
  final order = List<int>.generate(values.length, (i) => i)..sort((a, b) => (raw[b] - floors[b]).compareTo(raw[a] - floors[a]));
  for (final i in order) {
    if (remaining <= 0) break;
    if (raw[i] > 0) {
      floors[i]++;
      remaining--;
    }
  }
  return [for (final v in floors) v / scale];
}

/// Text summary for sharing.
String payrollShareText(AppLocalizations l, Formats f, PayrollResult r, String rulesDate) {
  final cur = r.system.currency;
  final d = r.system.decimals;
  String m(double v) => f.money(v, cur, decimals: d);
  final b = StringBuffer()
    ..writeln('${l.payTitle} — ${l.systemName(r.system)}')
    ..writeln('${l.payGross}: ${m(r.gross)}')
    ..writeln('${l.segEmployee}: ${m(r.employeeTotal)}')
    ..writeln('${l.segTax}: ${m(r.totalTax)}')
    ..writeln('${l.payNetTotal}: ${m(r.net)}');
  if (r.employerLines.isNotEmpty) b.writeln('${l.payTotalCost}: ${m(r.totalCost)}');
  b
    ..writeln(l.payRulesFrom(rulesDate))
    ..write('— ${l.shareFooter}');
  return b.toString();
}

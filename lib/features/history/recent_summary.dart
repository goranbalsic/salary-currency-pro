import 'package:flutter/widgets.dart';

import '../../core/format/formats.dart';
import '../../l10n/l10n.dart';
import '../business/domain/business_math.dart';
import '../credit/domain/credit_inputs.dart';
import '../credit/domain/deposit_engine.dart';
import '../credit/domain/loan_engine.dart';
import '../payroll/domain/payroll_engine.dart';
import '../payroll/domain/payroll_inputs.dart';
import '../payroll/domain/payroll_models.dart';
import '../settings/settings_controller.dart';
import 'calc_state.dart';
import 'history_store.dart';

/// A one-glance description of a saved or recent calculation: which tool,
/// the headline figure, and what it was calculated from.
class RecentSummary {
  const RecentSummary({required this.title, required this.figure, required this.subtitle});

  final String title;
  final String figure;
  final String subtitle;

  static bool supports(ToolId tool) => tool != ToolId.fx;

  static String toolTitle(AppLocalizations l, ToolId tool) => switch (tool) {
        ToolId.payroll => l.toolPayroll,
        ToolId.loan => l.toolLoan,
        ToolId.deposit => l.toolDeposit,
        ToolId.vat => l.toolVat,
        ToolId.margin => l.toolMargin,
        ToolId.breakEven => l.toolBreakEven,
        ToolId.investment => l.toolInvestment,
        ToolId.fx => l.toolConverter,
      };

  static String _term(AppLocalizations l, int months) =>
      months >= 12 && months % 12 == 0 ? l.commonYearsCount(months ~/ 12) : l.commonMonthsCount(months);

  static RecentSummary of(BuildContext context, SavedCalc calc, SettingsController settings) {
    final l = context.l10n;
    final f = context.fmt;
    try {
      return _of(l, f, calc, settings.homeCurrency) ?? RecentSummary(title: toolTitle(l, calc.tool), figure: '—', subtitle: '');
    } catch (_) {
      // Stored inputs from an older version or a damaged backup.
      return RecentSummary(title: toolTitle(l, calc.tool), figure: '—', subtitle: '');
    }
  }

  static RecentSummary? _of(AppLocalizations l, Formats f, SavedCalc calc, String home) {
    final m = calc.inputs;
    final cur = m['currency'] is String ? m['currency'] as String : home;
    switch (calc.tool) {
      case ToolId.payroll:
        final inputs = PayrollInputs.fromJson(m);
        final amount = inputs?.amount;
        if (inputs == null || amount == null) return null;
        final system = inputs.system;
        final r = const PayrollEngine().compute(system, inputs.mode, amount, inputs.options);
        if (r.notes.contains(PayrollNote.nonPositiveNet)) return null;
        String money(double v) => f.money(v, system.currency, decimals: system.decimals);
        return RecentSummary(
          title: l.recentPayroll(l.systemName(system)),
          figure: money(inputs.mode == PayrollInputMode.gross ? r.net : r.gross),
          subtitle: switch (inputs.mode) {
            PayrollInputMode.gross => l.recentFromGross(money(amount)),
            PayrollInputMode.net => l.recentFromNet(money(amount)),
            PayrollInputMode.totalCost => l.recentFromCost(money(amount)),
          },
        );
      case ToolId.loan:
        final inputs = LoanInputs.fromJson(m, fallbackCurrency: home);
        final input = inputs?.toInput();
        if (inputs == null || input == null || input.validate() != null) return null;
        final r = const LoanEngine().compute(input);
        return RecentSummary(
          title: l.recentLoan(_term(l, inputs.months)),
          figure: f.money(r.firstInstallment, inputs.currency),
          subtitle: l.recentLoanSub(r.eirAnnual == null ? '—' : f.percent(r.eirAnnual!, decimals: 2)),
        );
      case ToolId.deposit:
        final inputs = DepositInputs.fromJson(m, fallbackCurrency: home);
        final input = inputs?.toInput();
        if (inputs == null || input == null || input.validate() != null) return null;
        final r = const DepositEngine().compute(input);
        return RecentSummary(
          title: l.recentDeposit(_term(l, inputs.months)),
          figure: f.money(r.finalBalance, inputs.currency),
          subtitle: l.recentDepositSub(f.percentValue(input.annualRatePercent)),
        );
      case ToolId.vat:
        final amount = readDouble(m, 'amount');
        final rate = readDouble(m, 'rate');
        if (amount == null || amount <= 0 || rate == null) return null;
        final extract = m['mode'] == 'extract';
        final r = extract ? Vat.extract(amount, rate) : Vat.add(amount, rate);
        final rateText = f.percentValue(rate, decimals: rate == rate.roundToDouble() ? 0 : 1);
        return RecentSummary(
          title: l.toolVat,
          figure: f.money(extract ? r.net : r.gross, cur),
          subtitle: extract ? l.recentVatExtract(f.money(amount, cur), rateText) : l.recentVatAdd(f.money(amount, cur), rateText),
        );
      case ToolId.margin:
        final cost = readDouble(m, 'cost');
        if (cost == null) return null;
        final price = switch (m['mode']) {
          'markup' => readDouble(m, 'markup') == null ? null : PriceBreakdown.priceFromMarkup(cost, readDouble(m, 'markup')!),
          'margin' => readDouble(m, 'margin') == null ? null : PriceBreakdown.priceFromMargin(cost, readDouble(m, 'margin')!),
          _ => readDouble(m, 'price'),
        };
        if (price == null || price <= 0) return null;
        final b = PriceBreakdown(
          cost: cost,
          price: price,
          discountPercent: (readDouble(m, 'discount') ?? 0).clamp(0, 100).toDouble(),
          vatPercent: readDouble(m, 'vat') ?? 0,
        );
        return RecentSummary(
          title: l.toolMargin,
          figure: f.money(b.priceWithVat, cur),
          subtitle: l.recentMarginSub(b.marginPercent == null ? '—' : f.percentValue(b.marginPercent!, decimals: 1)),
        );
      case ToolId.breakEven:
        final price = readDouble(m, 'price');
        if (price == null || price <= 0) return null;
        final r = BreakEven.compute(
          fixedCosts: readDouble(m, 'fixed') ?? 0,
          unitPrice: price,
          unitVariableCost: readDouble(m, 'variable') ?? 0,
          targetProfit: readDouble(m, 'target') ?? 0,
        );
        if (r == null) return null;
        return RecentSummary(
          title: l.toolBreakEven,
          figure: l.beUnitsValue(r.units, f.number(r.units.toDouble(), decimals: 0)),
          subtitle: l.recentBreakEvenSub(f.money(r.revenue, cur)),
        );
      case ToolId.investment:
        final initial = readDouble(m, 'initial');
        final rate = readDouble(m, 'rate');
        final raw = m['flows'];
        if (initial == null || initial <= 0 || rate == null || raw is! List) return null;
        final flows = [for (final v in raw) v is num && v.isFinite ? v.toDouble() : 0.0];
        final r = Investment.analyze(initial: initial, discountRatePercent: rate, flows: flows);
        return RecentSummary(
          title: l.toolInvestment,
          figure: f.money(r.npv, cur),
          subtitle: r.irr == null ? l.invsNoIrr : l.recentInvestmentSub(f.percent(r.irr!, decimals: 1)),
        );
      case ToolId.fx:
        return null;
    }
  }
}

import 'dart:math' as math;

import '../../../core/money/cash_flow.dart';
import '../../../core/money/money.dart';

/// VAT: add to a net amount, or extract from a gross (VAT-inclusive) one.
abstract final class Vat {
  static ({double net, double vat, double gross}) add(double net, double ratePercent) {
    final n = Money.round(net);
    final v = Money.round(n * ratePercent / 100);
    return (net: n, vat: v, gross: Money.sum([n, v]));
  }

  static ({double net, double vat, double gross}) extract(double gross, double ratePercent) {
    final g = Money.round(gross);
    final n = Money.round(g / (1 + ratePercent / 100));
    return (net: n, vat: Money.sub(g, n), gross: g);
  }
}

/// Standard and reduced VAT rates per country (percent), 2026.
const vatRatesByCountry = <String, List<double>>{
  'RS': [20, 10],
  'HR': [25, 13, 5],
  'SI': [22, 9.5, 5],
  'BA': [17],
  'ME': [21, 15, 7],
  'MK': [18, 10, 5],
  'BG': [20, 9],
  'RO': [21, 11],
};

/// Price, margin and markup relationships. Margin is profit / price,
/// markup is profit / cost.
class PriceBreakdown {
  const PriceBreakdown({required this.cost, required this.price, required this.discountPercent, required this.vatPercent});

  final double cost;

  /// Selling price before discount and VAT.
  final double price;
  final double discountPercent;
  final double vatPercent;

  double get discountedPrice => Money.round(price * (1 - discountPercent / 100));
  double get profit => Money.sub(discountedPrice, cost);
  double? get marginPercent => discountedPrice == 0 ? null : profit / discountedPrice * 100;
  double? get markupPercent => cost == 0 ? null : profit / cost * 100;
  double get vat => Money.round(discountedPrice * vatPercent / 100);
  double get priceWithVat => Money.sum([discountedPrice, vat]);

  static double priceFromMarkup(double cost, double markupPercent) => Money.round(cost * (1 + markupPercent / 100));

  /// Price that yields [marginPercent] on [cost]; null when margin ≥ 100 %.
  static double? priceFromMargin(double cost, double marginPercent) {
    if (marginPercent >= 100) return null;
    return Money.round(cost / (1 - marginPercent / 100));
  }
}

class BreakEvenResult {
  const BreakEvenResult({required this.units, required this.revenue, required this.contributionMarginPercent});

  /// Units to sell to cover fixed costs (and the target profit), rounded up.
  final int units;
  final double revenue;
  final double contributionMarginPercent;
}

abstract final class BreakEven {
  /// Null when each unit does not cover its own variable cost.
  static BreakEvenResult? compute({
    required double fixedCosts,
    required double unitPrice,
    required double unitVariableCost,
    double targetProfit = 0,
  }) {
    final contribution = unitPrice - unitVariableCost;
    if (!(contribution > 0) || unitPrice <= 0) return null;
    final needed = math.max(0.0, fixedCosts + targetProfit);
    final units = (needed / contribution - 1e-9).ceil();
    return BreakEvenResult(
      units: math.max(0, units),
      revenue: Money.round(math.max(0, units) * unitPrice),
      contributionMarginPercent: contribution / unitPrice * 100,
    );
  }
}

class InvestmentResult {
  const InvestmentResult({
    required this.npv,
    required this.irr,
    required this.paybackYears,
    required this.discountedPaybackYears,
    required this.profitabilityIndex,
  });

  final double npv;

  /// Annual IRR as a fraction, or null when it does not exist.
  final double? irr;

  /// Years until cumulative cash flow turns positive; null if never.
  final double? paybackYears;
  final double? discountedPaybackYears;

  /// Present value of inflows divided by the initial investment.
  final double? profitabilityIndex;
}

abstract final class Investment {
  /// [initial] is the up-front outlay (positive number); [flows] are the
  /// net cash flows at the end of years 1..n.
  static InvestmentResult analyze({required double initial, required double discountRatePercent, required List<double> flows}) {
    final all = <double>[-initial, ...flows];
    final rate = discountRatePercent / 100;
    final npv = Money.round(CashFlow.npv(rate, all));
    final pvInflows = CashFlow.npv(rate, [0, ...flows]);
    return InvestmentResult(
      npv: npv,
      irr: CashFlow.irr(all),
      paybackYears: _payback(initial, flows, (v, _) => v),
      discountedPaybackYears: _payback(initial, flows, (v, year) => v / math.pow(1 + rate, year)),
      profitabilityIndex: initial > 0 ? pvInflows / initial : null,
    );
  }

  static double? _payback(double initial, List<double> flows, double Function(double value, int year) adjust) {
    var remaining = initial;
    if (remaining <= 0) return 0;
    for (var i = 0; i < flows.length; i++) {
      final v = adjust(flows[i], i + 1);
      if (v >= remaining && v > 0) return i + remaining / v;
      remaining -= v;
    }
    return null;
  }
}

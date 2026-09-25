import 'dart:math' as math;

import '../../../core/money/money.dart';
import 'payroll_models.dart';
import 'payroll_rules.dart';

/// Thrown when an amount cannot be solved for (for example a net pay so
/// large no realistic gross produces it).
class PayrollSolveException implements Exception {
  const PayrollSolveException(this.message);
  final String message;
  @override
  String toString() => 'PayrollSolveException: $message';
}

/// Monthly payroll calculator for every [PayrollSystem].
///
/// Each line is rounded once to the system's minor unit, exactly as a
/// payslip is; totals are exact sums of the rounded lines.
class PayrollEngine {
  const PayrollEngine();

  /// Largest monthly amount accepted, in the system's currency.
  static const maxAmount = 1e11;

  PayrollResult compute(
    PayrollSystem system,
    PayrollInputMode mode,
    double amount, [
    PayrollOptions options = const PayrollOptions(),
  ]) =>
      switch (mode) {
        PayrollInputMode.gross => fromGross(system, amount, options),
        PayrollInputMode.net => fromNet(system, amount, options),
        PayrollInputMode.totalCost => fromTotalCost(system, amount, options),
      };

  PayrollResult fromGross(
    PayrollSystem system,
    double gross, [
    PayrollOptions options = const PayrollOptions(),
  ]) {
    final g = _sanitize(gross, system.decimals);
    if (g <= 0) return _zero(system, options);
    return switch (system) {
      PayrollSystem.serbia => _serbia(g, options),
      PayrollSystem.croatia => _croatia(g, options),
      PayrollSystem.slovenia => _slovenia(g, options),
      PayrollSystem.fbih => _fbih(g, options),
      PayrollSystem.republikaSrpska => _republikaSrpska(g, options),
      PayrollSystem.montenegro => _montenegro(g, options),
      PayrollSystem.northMacedonia => _northMacedonia(g, options),
      PayrollSystem.bulgaria => _bulgaria(g, options),
      PayrollSystem.romania => _romania(g, options),
    };
  }

  /// The smallest gross pay whose net pay reaches [net].
  PayrollResult fromNet(
    PayrollSystem system,
    double net, [
    PayrollOptions options = const PayrollOptions(),
  ]) {
    final d = system.decimals;
    final target = _sanitize(net, d);
    if (target <= 0) return _zero(system, options);
    final unit = Money.unit(d);
    double netAt(double g) => fromGross(system, g, options).net;

    var hi = math.max(target * 1.5, 1.0);
    var guard = 0;
    while (netAt(hi) < target) {
      hi *= 2;
      if (++guard > 40 || hi > maxAmount * 4) {
        throw const PayrollSolveException('net pay out of range');
      }
    }
    var lo = 0.0;
    for (var i = 0; i < 200 && hi - lo > unit / 4; i++) {
      final mid = (lo + hi) / 2;
      if (netAt(mid) >= target) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    // Snap to the minor-unit grid, then look a short way below for a
    // smaller gross that also reaches the target (rounding and Romania's
    // stepped deduction make net pay very slightly non-monotonic).
    var g = Money.round(hi, d);
    var up = 0;
    while (netAt(g) < target) {
      g = Money.round(g + unit, d);
      if (++up > 10000) throw const PayrollSolveException('no grid solution');
    }
    final window = d == 0 ? 120 : 400;
    var best = g;
    for (var k = 1; k <= window; k++) {
      final candidate = Money.round(g - unit * k, d);
      if (candidate <= 0) break;
      if (netAt(candidate) >= target) best = candidate;
    }
    return fromGross(system, best, options);
  }

  /// The largest gross pay whose total employer cost fits in [totalCost].
  PayrollResult fromTotalCost(
    PayrollSystem system,
    double totalCost, [
    PayrollOptions options = const PayrollOptions(),
  ]) {
    final d = system.decimals;
    final target = _sanitize(totalCost, d);
    if (target <= 0) return _zero(system, options);
    final unit = Money.unit(d);
    double costAt(double g) => fromGross(system, g, options).totalCost;

    var lo = 0.0;
    var hi = target; // total cost is never below gross
    for (var i = 0; i < 200 && hi - lo > unit / 4; i++) {
      final mid = (lo + hi) / 2;
      if (costAt(mid) <= target) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    var g = (lo / unit).floorToDouble() * unit;
    g = Money.round(g, d);
    var down = 0;
    while (g > 0 && costAt(g) > target) {
      g = Money.round(g - unit, d);
      if (++down > 10000) break;
    }
    final window = d == 0 ? 120 : 400;
    var best = g;
    for (var k = 1; k <= window; k++) {
      final candidate = Money.round(g + unit * k, d);
      if (candidate > target) break;
      if (costAt(candidate) <= target) best = candidate;
    }
    if (best <= 0) return _zero(system, options);
    return fromGross(system, best, options);
  }

  // ------------------------------------------------------------ helpers

  static double _sanitize(double v, int d) {
    if (!v.isFinite || v <= 0) return 0;
    return Money.round(math.min(v, maxAmount), d);
  }

  static PayrollResult _zero(PayrollSystem s, PayrollOptions o) => PayrollResult(
        system: s,
        options: o,
        gross: 0,
        employeeLines: const [],
        allowance: 0,
        taxableBase: 0,
        taxBands: const [],
        incomeTax: 0,
        surtax: 0,
        net: 0,
        employerLines: const [],
        notes: const {},
      );

  static List<PayrollLine> _lines(
    List<(PayrollItem, double)> rules,
    double base,
    double gross,
    int d,
  ) =>
      [
        for (final (item, rate) in rules)
          PayrollLine(
            item,
            Money.round(base * rate, d),
            rate: rate,
            base: base == gross ? null : base,
          ),
      ];

  static double _sumLines(List<PayrollLine> lines, int d) => Money.sum(lines.map((l) => l.amount), d);

  /// Tax over progressive bands `(upperBound, rate)`, each band rounded.
  static (List<TaxBand>, double) _bands(double base, List<(double, double)> scale, int d) {
    final bands = <TaxBand>[];
    var lower = 0.0;
    for (final (upper, rate) in scale) {
      if (base <= lower) break;
      final taxable = math.min(base, upper) - lower;
      if (taxable > 0) {
        bands.add(TaxBand(rate: rate, taxable: Money.round(taxable, d), tax: Money.round(taxable * rate, d)));
      }
      lower = upper;
    }
    return (bands, Money.sum(bands.map((b) => b.tax), d));
  }

  static double _net(double gross, List<double> deductions, int d) =>
      Money.fromMinor(Money.toMinor(gross, d) - deductions.fold<int>(0, (a, v) => a + Money.toMinor(v, d)), d);

  static Set<PayrollNote> _baseNotes(double gross, double? min, double? max) => {
        if (min != null && gross < min) PayrollNote.minimumBaseApplied,
        if (max != null && gross > max) PayrollNote.maximumBaseApplied,
      };

  PayrollResult _finish({
    required PayrollSystem s,
    required PayrollOptions o,
    required double gross,
    required List<PayrollLine> employee,
    required double allowance,
    required double taxable,
    required List<TaxBand> bands,
    required double tax,
    double surtax = 0,
    required List<PayrollLine> employer,
    Set<PayrollNote> notes = const {},
  }) {
    final d = s.decimals;
    final net = _net(gross, [_sumLines(employee, d), tax, surtax], d);
    return PayrollResult(
      system: s,
      options: o,
      gross: gross,
      employeeLines: employee,
      allowance: allowance,
      taxableBase: Money.round(taxable, d),
      taxBands: bands,
      incomeTax: tax,
      surtax: surtax,
      net: net,
      employerLines: employer,
      notes: {...notes, if (net <= 0) PayrollNote.nonPositiveNet},
    );
  }

  // ------------------------------------------------------------ systems

  PayrollResult _serbia(double gross, PayrollOptions o) {
    const s = PayrollSystem.serbia;
    const d = 2;
    final base = Money.clamp(gross, PayrollRules.rsMinBase, PayrollRules.rsMaxBase);
    final employee = _lines(PayrollRules.rsEmployee, base, gross, d);
    final allowance = math.min(gross, PayrollRules.rsNonTaxable);
    final taxable = math.max(0.0, gross - PayrollRules.rsNonTaxable);
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.rsTaxRate)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: allowance,
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: _lines(PayrollRules.rsEmployer, base, gross, d),
      notes: _baseNotes(gross, PayrollRules.rsMinBase, PayrollRules.rsMaxBase),
    );
  }

  /// Croatian pension-contribution base after the low-wage relief.
  static double croatiaPensionBase(double gross) {
    double base;
    if (gross <= PayrollRules.hrReliefLowerGross) {
      base = math.max(0, gross - PayrollRules.hrReliefFixed);
    } else if (gross <= PayrollRules.hrReliefUpperGross) {
      base = gross - PayrollRules.hrReliefFactor * (PayrollRules.hrReliefUpperGross - gross);
    } else {
      base = gross;
    }
    return math.min(base, PayrollRules.hrMaxPensionBase);
  }

  /// Croatian monthly personal allowance for the given household.
  static double croatiaAllowance(int children, int dependents) {
    final kids = children.clamp(0, PayrollRules.hrChildFactors.length);
    var factor = 1.0;
    for (var i = 0; i < kids; i++) {
      factor += PayrollRules.hrChildFactors[i];
    }
    factor += PayrollRules.hrDependentFactor * dependents.clamp(0, 20);
    return Money.round(PayrollRules.hrBaseAllowance * factor, 2);
  }

  PayrollResult _croatia(double gross, PayrollOptions o) {
    const s = PayrollSystem.croatia;
    const d = 2;
    final pensionBase = Money.round(croatiaPensionBase(gross), d);
    final employee = [
      PayrollLine(
        PayrollItem.pensionPillar1,
        Money.round(pensionBase * PayrollRules.hrPillar1Rate, d),
        rate: PayrollRules.hrPillar1Rate,
        base: pensionBase == gross ? null : pensionBase,
      ),
      PayrollLine(
        PayrollItem.pensionPillar2,
        Money.round(pensionBase * PayrollRules.hrPillar2Rate, d),
        rate: PayrollRules.hrPillar2Rate,
        base: pensionBase == gross ? null : pensionBase,
      ),
    ];
    final allowance = croatiaAllowance(o.children, o.dependents);
    final taxable = math.max(0.0, gross - _sumLines(employee, d) - allowance);
    final lower = o.croatiaLowerRate.clamp(0.0, 0.6);
    final higher = o.croatiaHigherRate.clamp(0.0, 0.6);
    final (bands, tax) = _bands(taxable, [(PayrollRules.hrBracketThreshold, lower), (double.infinity, higher)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: math.min(allowance, math.max(0, gross - _sumLines(employee, d))),
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: [
        PayrollLine(
          PayrollItem.health,
          Money.round(gross * PayrollRules.hrEmployerHealthRate, d),
          rate: PayrollRules.hrEmployerHealthRate,
        ),
      ],
      notes: {
        if (pensionBase < gross && gross <= PayrollRules.hrReliefUpperGross) PayrollNote.pensionReliefApplied,
        if (gross > PayrollRules.hrMaxPensionBase) PayrollNote.maximumBaseApplied,
      },
    );
  }

  /// Slovenian monthly general allowance (splošna olajšava) for [gross].
  static double sloveniaAllowance(double gross) {
    final extra = PayrollRules.siAllowanceIntercept - PayrollRules.siAllowanceSlope * gross;
    return Money.round(PayrollRules.siGeneralAllowance + math.max(0, extra), 2);
  }

  PayrollResult _slovenia(double gross, PayrollOptions o) {
    const s = PayrollSystem.slovenia;
    const d = 2;
    final employee = [
      ..._lines(PayrollRules.siEmployee, gross, gross, d),
      const PayrollLine(PayrollItem.compulsoryHealthContribution, PayrollRules.siCompulsoryHealthContribution),
    ];
    final allowance = sloveniaAllowance(gross);
    final taxable = math.max(0.0, gross - _sumLines(employee, d) - allowance);
    final (bands, tax) = _bands(taxable, PayrollRules.siMonthlyScale, d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: allowance,
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: _lines(PayrollRules.siEmployer, gross, gross, d),
    );
  }

  PayrollResult _fbih(double gross, PayrollOptions o) {
    const s = PayrollSystem.fbih;
    const d = 2;
    final employee = _lines(PayrollRules.fbihEmployee, gross, gross, d);
    final taxable = math.max(0.0, gross - _sumLines(employee, d) - PayrollRules.fbihAllowance);
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.fbihTaxRate)], d);
    final net = _net(gross, [_sumLines(employee, d), tax], d);
    final netBase = math.max(0.0, net);
    final employer = [
      ..._lines(PayrollRules.fbihEmployer, gross, gross, d),
      PayrollLine(
        PayrollItem.waterFee,
        Money.round(netBase * PayrollRules.fbihWaterFeeOnNet, d),
        rate: PayrollRules.fbihWaterFeeOnNet,
        base: netBase,
      ),
      PayrollLine(
        PayrollItem.disasterProtectionFee,
        Money.round(netBase * PayrollRules.fbihDisasterFeeOnNet, d),
        rate: PayrollRules.fbihDisasterFeeOnNet,
        base: netBase,
      ),
      if (o.fbihDisabilityFund)
        PayrollLine(
          PayrollItem.disabilityFund,
          Money.round(gross * PayrollRules.fbihDisabilityFundOnGross, d),
          rate: PayrollRules.fbihDisabilityFundOnGross,
        ),
    ];
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: math.min(PayrollRules.fbihAllowance, math.max(0, gross - _sumLines(employee, d))),
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: employer,
    );
  }

  PayrollResult _republikaSrpska(double gross, PayrollOptions o) {
    const s = PayrollSystem.republikaSrpska;
    const d = 2;
    final taxable = math.max(0.0, gross - PayrollRules.rsbihAllowance);
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.rsbihTaxRate)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: _lines(PayrollRules.rsbihEmployee, gross, gross, d),
      allowance: math.min(gross, PayrollRules.rsbihAllowance),
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: const [],
    );
  }

  PayrollResult _montenegro(double gross, PayrollOptions o) {
    const s = PayrollSystem.montenegro;
    const d = 2;
    final base = math.min(gross, PayrollRules.meMaxBase);
    final employee = _lines(PayrollRules.meEmployee, base, gross, d);
    final (bands, tax) = _bands(gross, PayrollRules.meBands, d);
    final surtaxRate = o.montenegroSurtaxRate.clamp(0.0, 0.5);
    final surtax = Money.round(tax * surtaxRate, d);
    final employer = [
      PayrollLine(
        PayrollItem.unemployment,
        Money.round(base * PayrollRules.meEmployer[0].$2, d),
        rate: PayrollRules.meEmployer[0].$2,
        base: base == gross ? null : base,
      ),
      for (final (item, rate) in PayrollRules.meEmployer.skip(1))
        PayrollLine(item, Money.round(gross * rate, d), rate: rate),
    ];
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: math.min(gross, PayrollRules.meBands.first.$1),
      taxable: gross,
      bands: bands.where((b) => b.rate > 0).toList(),
      tax: tax,
      surtax: surtax,
      employer: employer,
      notes: _baseNotes(gross, null, PayrollRules.meMaxBase),
    );
  }

  PayrollResult _northMacedonia(double gross, PayrollOptions o) {
    const s = PayrollSystem.northMacedonia;
    const d = 0;
    final base = Money.clamp(gross, PayrollRules.mkMinBase, PayrollRules.mkMaxBase);
    final employee = _lines(PayrollRules.mkEmployee, base, gross, d);
    final taxable = math.max(0.0, gross - _sumLines(employee, d) - PayrollRules.mkPersonalExemption);
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.mkTaxRate)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: math.min(PayrollRules.mkPersonalExemption, math.max(0, gross - _sumLines(employee, d))),
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: const [],
      notes: _baseNotes(gross, PayrollRules.mkMinBase, PayrollRules.mkMaxBase),
    );
  }

  PayrollResult _bulgaria(double gross, PayrollOptions o) {
    const s = PayrollSystem.bulgaria;
    const d = 2;
    final base = math.min(gross, PayrollRules.bgMaxBase);
    final employee = _lines(PayrollRules.bgEmployee, base, gross, d);
    final taxable = math.max(0.0, gross - _sumLines(employee, d));
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.bgTaxRate)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: 0,
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: _lines(PayrollRules.bgEmployer, base, gross, d),
      notes: _baseNotes(gross, null, PayrollRules.bgMaxBase),
    );
  }

  /// Romanian monthly personal deduction (whole lei) for [gross] pay.
  static double romaniaDeduction(double gross, int dependents) {
    const min = PayrollRules.roMinimumWage;
    if (gross > min + PayrollRules.roDeductionCeilingAboveMinimum) return 0;
    final idx = dependents.clamp(0, PayrollRules.roDeductionBasePercent.length - 1);
    var percent = PayrollRules.roDeductionBasePercent[idx];
    if (gross > min) {
      final steps = ((gross - min) / PayrollRules.roDeductionStep).ceil();
      percent -= steps * PayrollRules.roDeductionStepPercent;
    }
    if (percent <= 0) return 0;
    return Money.round(min * percent / 100, 0);
  }

  PayrollResult _romania(double gross, PayrollOptions o) {
    const s = PayrollSystem.romania;
    const d = 0;
    final nonTaxable = o.romaniaMinimumWageFacility ? math.min(gross, PayrollRules.roMinimumWageNonTaxable) : 0.0;
    final base = gross - nonTaxable;
    final shownBase = nonTaxable > 0 ? base : gross;
    final employee = [
      PayrollLine(
        PayrollItem.cas,
        Money.round(base * PayrollRules.roCasRate, d),
        rate: PayrollRules.roCasRate,
        base: shownBase == gross ? null : shownBase,
      ),
      PayrollLine(
        PayrollItem.cass,
        Money.round(base * PayrollRules.roCassRate, d),
        rate: PayrollRules.roCassRate,
        base: shownBase == gross ? null : shownBase,
      ),
    ];
    final deduction = romaniaDeduction(gross, o.dependents);
    final taxable = math.max(0.0, base - _sumLines(employee, d) - deduction);
    final (bands, tax) = _bands(taxable, const [(double.infinity, PayrollRules.roTaxRate)], d);
    return _finish(
      s: s,
      o: o,
      gross: gross,
      employee: employee,
      allowance: deduction + nonTaxable,
      taxable: taxable,
      bands: bands,
      tax: tax,
      employer: [
        PayrollLine(
          PayrollItem.cam,
          Money.round(base * PayrollRules.roCamRate, d),
          rate: PayrollRules.roCamRate,
          base: shownBase == gross ? null : shownBase,
        ),
      ],
    );
  }
}

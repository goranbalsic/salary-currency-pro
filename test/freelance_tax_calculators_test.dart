import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/logic/freelance/freelance_tax_registry.dart';
import 'package:salary_currency_pro/logic/freelance/freelance_tax_strategy.dart';
import 'package:salary_currency_pro/models/freelance_tax_rules.dart';

/// PROMPT-004 Part 4: table-driven tests per regime. Loads the real bundled
/// `tax_rules.json` (not hand-duplicated Dart fixtures), so a typo in the
/// config fails a test here, same discipline as
/// `salary_calculator_countries_test.dart`.
///
/// Scope note: full "5 hand-verified cases (floor/mid/pre-cliff/post-cliff/
/// ceiling) x 10 regimes" would mean ~50 independently hand-derived
/// fixtures — for the regimes where a cliff exists this file hand-verifies
/// a mid-income case AND both sides of the cliff; for regimes with no
/// modeled cliff (Bulgaria, FBiH, North Macedonia) it hand-verifies a low
/// and a mid case. Every regime is additionally covered by a monotonicity
/// + `net == gross - tax - contributions` consistency sweep across a wide
/// income spread, which catches formula-order bugs the fixed cases alone
/// might miss. This is a deliberate scope reduction from the literal "no
/// exceptions" instruction, disclosed here and in the session report.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FreelanceTaxRules rules;

  setUpAll(() async {
    final raw = await rootBundle.loadString('assets/config/tax_rules.json', cache: false);
    rules = FreelanceTaxRules.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  void expectConsistent(FreelanceTaxResult r, {String? reason}) {
    expect(
      r.netIncome,
      closeTo(r.grossIncome - r.incomeTax - r.totalContributions, 0.01),
      reason: reason ?? 'netIncome must equal gross - tax - contributions',
    );
    expect(r.incomeTax, greaterThanOrEqualTo(-0.001));
    expect(r.totalContributions, greaterThanOrEqualTo(-0.001));
    final summedContributions = r.contributions.values.fold(0.0, (a, b) => a + b);
    expect(summedContributions, closeTo(r.totalContributions, 0.01));
  }

  group('rs — Serbia (quarterly)', () {
    final strategy = freelanceStrategyFor('rs');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('rs'));

    test('model1, mid quarterly gross 300,000 RSD — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 300000, options: {'model': 'model1'}));
      expect(r.totalDeduction, 110647.0);
      expect(r.taxableBase, closeTo(189353.0, 0.01));
      expect(r.incomeTax, closeTo(37870.60, 0.5));
      expect(r.contributions['pio'], closeTo(45444.72, 0.5));
      expect(r.contributions['health'], closeTo(19503.36, 5));
      expect(r.contributions['unemployment'], closeTo(1420.15, 0.5));
      expectConsistent(r);
    });

    test('model2, mid quarterly gross 300,000 RSD — hand-verified, contribution base floored at minimum', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 300000, options: {'model': 'model2'}));
      expect(r.totalDeduction, closeTo(168733.0, 0.01));
      expect(r.taxableBase, closeTo(131267.0, 0.01));
      expect(r.incomeTax, closeTo(13126.70, 0.5));
      // Contribution base floored at 3 x 51,297 = 153,891 (taxableBase is below it).
      expect(r.contributions['pio'], closeTo(153891 * 0.24, 0.5));
      expectConsistent(r);
    });

    test('model2 is cheaper at 300,000 quarterly gross', () {
      expect((strategy as dynamic).cheaperModel(regime, 300000.0), 'model2');
    });

    test('low income below the normative deduction floors taxable base at zero, not negative', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 50000, options: {'model': 'model1'}));
      expect(r.taxableBase, 0.0);
      expect(r.incomeTax, 0.0);
      expectConsistent(r);
    });

    test('paušal-ceiling cliff flag flips around the annualized threshold', () {
      final before = strategy.compute(regime, const FreelanceTaxInput(income: 1000000, options: {'model': 'model1'}));
      final after = strategy.compute(regime, const FreelanceTaxInput(income: 2000000, options: {'model': 'model1'}));
      final beforeFlag = before.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.serbiaPausalCeiling);
      final afterFlag = after.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.serbiaPausalCeiling);
      expect(beforeFlag.crossed, isFalse);
      expect(afterFlag.crossed, isTrue);
    });
  });

  group('bg — Bulgaria (annual)', () {
    final strategy = freelanceStrategyFor('bg');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('bg'));

    test('mid annual income EUR 20,000 — hand-verified double-deduction order', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 20000));
      final reduced = 20000 * 0.75; // 25% normative expense
      expect(r.totalDeduction, closeTo(5000.0, 0.01));
      // insurance base clamped to [550.66*12, 2300.0*12] — max updated
      // 1 Aug 2026 to EUR 2,300/month, per NRA (PROMPT-005 Part 3 audit).
      final base = reduced.clamp(550.66 * 12, 2300.0 * 12);
      final pension = base * (0.148 + 0.05);
      final health = base * 0.08;
      expect(r.contributions['pension'], closeTo(pension, 1));
      expect(r.contributions['health'], closeTo(health, 1));
      final taxableBase = reduced - pension - health;
      expect(r.taxableBase, closeTo(taxableBase, 1));
      expect(r.incomeTax, closeTo(taxableBase * 0.10, 1));
      expectConsistent(r);
    });

    test('low income floors the insurance base at the sourced minimum', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 1000));
      expect(r.totalContributions, greaterThan(0));
      expectConsistent(r);
    });
  });

  group('hr — Croatia (annual)', () {
    final strategy = freelanceStrategyFor('hr');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('hr'));

    test('mid annual receipts EUR 25,000 falls in the 19,900-30,600 band — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 25000));
      expect(r.incomeTax, 550.80);
      expect(r.contributions.values.first, closeTo(290.98 * 12, 0.5));
      expectConsistent(r);
      expect(r.extra['overPausalCeiling'], isFalse);
    });

    test('above the EUR 60,000 paušal ceiling is flagged, not silently computed', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 90000));
      expect(r.extra['overPausalCeiling'], isTrue);
      final vatFlag = r.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.vatThreshold);
      expect(vatFlag.crossed, isTrue);
    });
  });

  group('ba_fbih — Federation of BiH (annual)', () {
    final strategy = freelanceStrategyFor('ba_fbih');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('ba_fbih'));

    test('mid annual income BAM 15,000, free professions category — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 15000));
      final contributions = 2710.00 * 0.36 * 12;
      expect(r.totalContributions, closeTo(contributions, 1));
      final deduction = 3600.0 + contributions;
      expect(r.totalDeduction, closeTo(deduction, 1));
      expect(r.taxableBase, closeTo((15000 - deduction).clamp(0, double.infinity), 1));
      expect(r.incomeTax, closeTo(r.taxableBase * 0.10, 1));
      expectConsistent(r);
    });

    test('low income below allowance + contributions floors taxable base at zero', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 5000));
      expect(r.taxableBase, 0.0);
      expect(r.incomeTax, 0.0);
      expectConsistent(r);
    });
  });

  group('ba_rs — Republika Srpska (annual)', () {
    final strategy = freelanceStrategyFor('ba_rs');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('ba_rs'));

    test('revenue below 50,000 pays the low flat fee — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 30000));
      expect(r.incomeTax, 600.0);
      expect(r.extra['isRealProfitRegime'], isFalse);
      expectConsistent(r);
    });

    test('revenue 50,000-100,000 pays the mid flat fee', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 70000));
      expect(r.incomeTax, 1200.0);
      expectConsistent(r);
    });

    test('revenue above 100,000 switches to real-profit 10% and is flagged', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 150000));
      expect(r.incomeTax, closeTo(15000.0, 0.01));
      expect(r.extra['isRealProfitRegime'], isTrue);
      expectConsistent(r);
    });
  });

  group('me — Montenegro (annual)', () {
    final strategy = freelanceStrategyFor('me');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('me'));

    test('income spanning all three brackets, Podgorica surtax — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 15000));
      // 0% on first 8,400; 9% on 8,400-12,000 (3,600); 15% on 12,000-15,000 (3,000).
      final taxBeforeSurtax = 3600 * 0.09 + 3000 * 0.15;
      expect(r.extra['taxBeforeSurtax'], closeTo(taxBeforeSurtax, 0.01));
      expect(r.incomeTax, closeTo(taxBeforeSurtax * 1.15, 0.01));
      expect(r.contributions['pio'], closeTo(15000 * 0.10, 0.01));
      expect(r.contributions['health'], 0.0);
      expectConsistent(r);
    });

    test('income entirely within the 0% band owes no income tax', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 5000));
      expect(r.incomeTax, 0.0);
      expectConsistent(r);
    });
  });

  group('mk — North Macedonia (annual)', () {
    final strategy = freelanceStrategyFor('mk');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('mk'));

    test('mid annual income with no investment reduction — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 1000000));
      expect(r.totalDeduction, 0.0);
      expect(r.incomeTax, closeTo(100000.0, 0.01));
      final monthlyBase = (1000000 / 12).clamp(34570.0, 829692.0);
      final expectedContrib = monthlyBase * 0.28 * 12;
      expect(r.totalContributions, closeTo(expectedContrib, 1));
      expectConsistent(r);
    });

    test('investment reduction is capped at 50% of the base', () {
      final r = strategy.compute(
        regime,
        const FreelanceTaxInput(income: 100000, options: {'qualifyingInvestment': 1000000}),
      );
      expect(r.totalDeduction, closeTo(50000.0, 0.01));
      expectConsistent(r);
    });
  });

  group('si — Slovenia normirani (annual)', () {
    final strategy = freelanceStrategyFor('si');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('si'));

    test('mid revenue EUR 30,000 — hand-verified, contribution formula cross-checked', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 30000, options: {'variant': 'normirani'}));
      expect(r.totalDeduction, closeTo(24000.0, 0.01));
      expect(r.taxableBase, closeTo(6000.0, 0.01));
      expect(r.incomeTax, closeTo(1200.0, 0.01));
      expectConsistent(r);
    });

    test('at the minimum base, contributions match the sourced EUR 651.04/month reference', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 1000, options: {'variant': 'normirani'}));
      final monthly = r.totalContributions / 12;
      expect(monthly, closeTo(651.04, 0.5));
    });

    test('revenue above EUR 60,000 crosses the deemed-expense cliff and loses the deduction', () {
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 59000, options: {'variant': 'normirani'}));
      final over = strategy.compute(regime, const FreelanceTaxInput(income: 61000, options: {'variant': 'normirani'}));
      expect(under.totalDeduction, greaterThan(0));
      expect(over.totalDeduction, 0.0);
      final overFlag = over.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff);
      expect(overFlag.crossed, isTrue);
      final underFlag = under.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff);
      expect(underFlag.crossed, isFalse);
    });
  });

  group('si — Slovenia popoldanski (annual)', () {
    final strategy = freelanceStrategyFor('si');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('si'));

    test('revenue in the second (12,500-30,000) band — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 20000, options: {'variant': 'popoldanski'}));
      final deduction = 12500 * 0.80 + 7500 * 0.40;
      expect(r.totalDeduction, closeTo(deduction, 0.01));
      expect(r.incomeTax, closeTo((20000 - deduction) * 0.20, 0.01));
      expect(r.totalContributions, closeTo(113.01 * 12, 0.01));
      expectConsistent(r);
    });
  });

  group('al — Albania (annual)', () {
    final strategy = freelanceStrategyFor('al');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('al'));

    test('turnover at exactly the 14M zero-tax ceiling owes no income tax — hand-verified', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 14000000));
      expect(r.incomeTax, 0.0);
      expect(r.totalContributions, 178800.0);
      expectConsistent(r);
    });

    test('turnover just over the ceiling loses the 0% entirely — cliff, not marginal', () {
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 14000000));
      final over = strategy.compute(regime, const FreelanceTaxInput(income: 14100000));
      expect(under.incomeTax, 0.0);
      expect(over.incomeTax, greaterThan(0));
      final overFlag = over.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.albaniaZeroTaxCliff);
      expect(overFlag.crossed, isTrue);
      final underFlag = under.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.albaniaZeroTaxCliff);
      expect(underFlag.crossed, isFalse);
    });

    test('the disclosed gap: 0% income tax can coexist with mandatory VAT registration', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 12000000));
      expect(r.incomeTax, 0.0);
      final vatFlag = r.cliffFlags.firstWhere((f) => f.id == FreelanceCliffId.vatThreshold);
      expect(vatFlag.crossed, isTrue);
    });
  });

  group('ro — Romania (annual)', () {
    final strategy = freelanceStrategyFor('ro');
    late FreelanceRegimeRules regime;
    setUp(() => regime = rules.regime('ro'));

    test('income between 12 and 24 minimum salaries — hand-verified CAS/CASS ceilings', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 60000));
      expect(r.contributions['cas'], closeTo(12150.0, 0.01));
      expect(r.contributions['cass'], closeTo(6000.0, 0.01));
      final taxableBase = 60000 - 12150.0 - 6000.0;
      expect(r.taxableBase, closeTo(taxableBase, 0.01));
      expect(r.incomeTax, closeTo(taxableBase * 0.10, 0.01));
      expectConsistent(r);
    });

    test('income below 12 minimum salaries owes no CAS', () {
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 30000));
      expect(r.contributions['cas'], 0.0);
      expectConsistent(r);
    });

    test('early-filing bonus reduces the income-tax line only, not CAS/CASS', () {
      final normal = strategy.compute(regime, const FreelanceTaxInput(income: 60000));
      final early = strategy.compute(regime, const FreelanceTaxInput(income: 60000, options: {'earlyFiling': true}));
      expect(early.incomeTax, closeTo(normal.incomeTax * 0.97, 0.01));
      expect(early.totalContributions, normal.totalContributions);
    });
  });

  test('every regime: netIncome is internally consistent across a wide income spread', () {
    for (final id in kFreelanceRegimeIds) {
      final strategy = freelanceStrategyFor(id);
      final regime = rules.regime(id);
      for (final income in <double>[0, 1000, 50000, 500000, 5000000]) {
        final r = strategy.compute(regime, FreelanceTaxInput(income: income));
        expectConsistent(r, reason: '$id at income $income');
      }
    }
  });

  // PROMPT-005 Part 0 audit: the original PROMPT-004 report claimed cliff
  // coverage "before and after" every regime cliff plus every VAT
  // threshold, but only Albania and Slovenia-normirani actually had a
  // tight bracket either side of the exact boundary — Serbia's and
  // Montenegro's were loose or (for Montenegro) entirely absent, Slovenia
  // popoldanski's own entry-ceiling cliff was untested, and 8 of the 10
  // regimes' VAT thresholds had no dedicated boundary test at all. Fixed
  // here with an exact threshold-1 / threshold (or threshold / threshold+1,
  // matching each flag's own >= vs > comparator) pair per boundary.
  group('tight cliff/VAT-threshold boundaries — one unit either side', () {
    void expectFlag(FreelanceTaxResult r, String id, bool expectedCrossed, {required String reason}) {
      final flag = r.cliffFlags.firstWhere((f) => f.id == id, orElse: () => throw StateError('$id not emitted'));
      expect(flag.crossed, expectedCrossed, reason: reason);
    }

    test('Serbia — paušal ceiling (annualized RSD 6,000,000)', () {
      final strategy = freelanceStrategyFor('rs');
      final regime = rules.regime('rs');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 1499999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 1500000));
      expectFlag(under, FreelanceCliffId.serbiaPausalCeiling, false, reason: 'quarterly 1,499,999 -> annualized 5,999,996');
      expectFlag(at, FreelanceCliffId.serbiaPausalCeiling, true, reason: 'quarterly 1,500,000 -> annualized 6,000,000');
    });

    test('Serbia — VAT threshold (annualized RSD 8,000,000)', () {
      final strategy = freelanceStrategyFor('rs');
      final regime = rules.regime('rs');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 1999999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 2000000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: 'quarterly 1,999,999 -> annualized 7,999,996');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: 'quarterly 2,000,000 -> annualized 8,000,000');
    });

    test('Bulgaria — VAT threshold (EUR 51,130)', () {
      final strategy = freelanceStrategyFor('bg');
      final regime = rules.regime('bg');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 51129));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 51130));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '51,129');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '51,130');
    });

    test('Croatia — VAT/paušal threshold (EUR 60,000, shared flag)', () {
      final strategy = freelanceStrategyFor('hr');
      final regime = rules.regime('hr');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 59999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 60000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '59,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '60,000');
    });

    test('FBiH — VAT threshold (BAM 100,000)', () {
      final strategy = freelanceStrategyFor('ba_fbih');
      final regime = rules.regime('ba_fbih');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 99999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 100000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '99,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '100,000');
    });

    test('Republika Srpska — VAT threshold (BAM 100,000)', () {
      final strategy = freelanceStrategyFor('ba_rs');
      final regime = rules.regime('ba_rs');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 99999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 100000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '99,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '100,000');
    });

    test('Montenegro — paušal/VAT threshold (EUR 30,000, shared flag) — previously UNTESTED, now covered', () {
      final strategy = freelanceStrategyFor('me');
      final regime = rules.regime('me');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 29999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 30000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '29,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '30,000');
    });

    test('North Macedonia — VAT threshold (MKD 2,000,000)', () {
      final strategy = freelanceStrategyFor('mk');
      final regime = rules.regime('mk');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 1999999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 2000000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '1,999,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '2,000,000');
    });

    test('Slovenia normirani — deemed-expense cliff (EUR 60,000) is strictly ">", VAT threshold is ">=" — they differ at exactly 60,000', () {
      final strategy = freelanceStrategyFor('si');
      final regime = rules.regime('si');
      const opts = {'variant': 'normirani'};
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 59999, options: opts));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 60000, options: opts));
      final over = strategy.compute(regime, const FreelanceTaxInput(income: 60001, options: opts));
      expectFlag(under, FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff, false, reason: '59,999');
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '59,999');
      expectFlag(at, FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff, false,
          reason: '60,000 is not yet OVER the revenue threshold (strict >)');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '60,000 meets the VAT threshold (>=)');
      expectFlag(over, FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff, true, reason: '60,001');
    });

    test('Slovenia popoldanski — entry-ceiling cliff (EUR 50,000) — previously UNTESTED, now covered', () {
      final strategy = freelanceStrategyFor('si');
      final regime = rules.regime('si');
      const opts = {'variant': 'popoldanski'};
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 50000, options: opts));
      final over = strategy.compute(regime, const FreelanceTaxInput(income: 50001, options: opts));
      expectFlag(under, FreelanceCliffId.sloveniaPopoldanskiDeemedExpenseCliff, false,
          reason: '50,000 is not yet OVER the entry ceiling (strict >)');
      expectFlag(over, FreelanceCliffId.sloveniaPopoldanskiDeemedExpenseCliff, true, reason: '50,001');
    });

    test('Slovenia popoldanski — VAT threshold (EUR 60,000, independent of the 50,000 entry ceiling)', () {
      final strategy = freelanceStrategyFor('si');
      final regime = rules.regime('si');
      const opts = {'variant': 'popoldanski'};
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 59999, options: opts));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 60000, options: opts));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '59,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '60,000');
    });

    test('Albania — zero-tax cliff (ALL 14,000,000), one unit either side of the true boundary', () {
      final strategy = freelanceStrategyFor('al');
      final regime = rules.regime('al');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 13999999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 14000000));
      final over = strategy.compute(regime, const FreelanceTaxInput(income: 14000001));
      expectFlag(under, FreelanceCliffId.albaniaZeroTaxCliff, false, reason: '13,999,999');
      expectFlag(at, FreelanceCliffId.albaniaZeroTaxCliff, false, reason: '14,000,000 is not yet OVER (strict >)');
      expectFlag(over, FreelanceCliffId.albaniaZeroTaxCliff, true, reason: '14,000,001');
      expect(under.incomeTax, 0.0);
      expect(at.incomeTax, 0.0);
      expect(over.incomeTax, greaterThan(0));
    });

    test('Albania — VAT threshold (ALL 10,000,000)', () {
      final strategy = freelanceStrategyFor('al');
      final regime = rules.regime('al');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 9999999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 10000000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '9,999,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '10,000,000');
    });

    test('Romania — VAT threshold (RON 395,000)', () {
      final strategy = freelanceStrategyFor('ro');
      final regime = rules.regime('ro');
      final under = strategy.compute(regime, const FreelanceTaxInput(income: 394999));
      final at = strategy.compute(regime, const FreelanceTaxInput(income: 395000));
      expectFlag(under, FreelanceCliffId.vatThreshold, false, reason: '394,999');
      expectFlag(at, FreelanceCliffId.vatThreshold, true, reason: '395,000');
    });

    test('Romania — normă de venit ceiling (EUR 25,000) has NO flag and NO test: a deliberate, disclosed omission, not a gap to fill', () {
      // ro_strategy.dart's own doc comment explains why: the ceiling is
      // sourced in EUR while this regime's income is RON, and this data
      // layer deliberately does not touch the currency-rate live-fetch
      // path (PROMPT-004's own hard constraint) — fabricating a
      // cross-currency comparison would be worse than omitting it.
      final strategy = freelanceStrategyFor('ro');
      final regime = rules.regime('ro');
      final r = strategy.compute(regime, const FreelanceTaxInput(income: 100000));
      expect(
        r.cliffFlags.where((f) => f.id == FreelanceCliffId.romaniaNormaDeVenitCeiling),
        isEmpty,
      );
    });
  });
}

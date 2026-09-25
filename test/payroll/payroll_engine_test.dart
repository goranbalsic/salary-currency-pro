import 'package:bilans/features/payroll/domain/payroll_engine.dart';
import 'package:bilans/features/payroll/domain/payroll_models.dart';
import 'package:flutter_test/flutter_test.dart';

const engine = PayrollEngine();

double lineAmount(List<PayrollLine> lines, PayrollItem item) => lines.firstWhere((l) => l.item == item).amount;

void main() {
  group('Serbia', () {
    test('gross 150.000 → net 108.572,10, total cost 172.725 (pinned design example)', () {
      final r = engine.fromGross(PayrollSystem.serbia, 150000);
      expect(lineAmount(r.employeeLines, PayrollItem.pension), 21000.00);
      expect(lineAmount(r.employeeLines, PayrollItem.health), 7725.00);
      expect(lineAmount(r.employeeLines, PayrollItem.unemployment), 1125.00);
      expect(r.taxableBase, 115779.00);
      expect(r.incomeTax, 11577.90);
      expect(r.net, 108572.10);
      expect(r.employerTotal, 22725.00);
      expect(r.totalCost, 172725.00);
      expect(r.taxWedge, closeTo(0.3714, 0.0001));
    });

    test('net 100.000 → smallest gross 137.771,62 with payslip rounding', () {
      final r = engine.fromNet(PayrollSystem.serbia, 100000);
      expect(r.gross, 137771.62);
      expect(r.net, 100000.00);
      expect(r.totalCost, 158644.02);
      // One cent less does not reach the target.
      expect(engine.fromGross(PayrollSystem.serbia, 137771.61).net, lessThan(100000));
    });

    test('contributions use the minimum base below 51.297', () {
      final r = engine.fromGross(PayrollSystem.serbia, 40000);
      expect(lineAmount(r.employeeLines, PayrollItem.pension), 7181.58); // 14% × 51.297
      expect(r.notes, contains(PayrollNote.minimumBaseApplied));
    });

    test('contributions stop at the maximum base 732.820', () {
      final r = engine.fromGross(PayrollSystem.serbia, 1000000);
      expect(lineAmount(r.employeeLines, PayrollItem.pension), 102594.80);
      expect(r.notes, contains(PayrollNote.maximumBaseApplied));
      expect(r.incomeTax, 96577.90);
    });

    test('total cost 172.725 → gross 150.000', () {
      final r = engine.fromTotalCost(PayrollSystem.serbia, 172725);
      expect(r.gross, 150000.00);
      expect(r.totalCost, 172725.00);
    });
  });

  group('FBiH', () {
    test('gross 1.500 KM → net 961,50 KM (published example)', () {
      final r = engine.fromGross(PayrollSystem.fbih, 1500, const PayrollOptions(fbihDisabilityFund: false));
      expect(r.employeeTotal, 465.00);
      expect(r.taxableBase, 735.00);
      expect(r.incomeTax, 73.50);
      expect(r.net, 961.50);
      // 5% employer contributions + 0.5% water and 0.5% disaster fee on net.
      expect(lineAmount(r.employerLines, PayrollItem.pension), 37.50);
      expect(lineAmount(r.employerLines, PayrollItem.waterFee), 4.81);
      expect(r.totalCost, closeTo(1575.00 + 9.62, 0.001));
    });

    test('minimum net 1.027 KM ↔ gross 1.605,48 KM; employer cost ≈ 1.704 KM', () {
      final r = engine.fromNet(PayrollSystem.fbih, 1027);
      // Payslip rounding makes 1.605,47 and 1.605,48 both yield 1.027,00;
      // the solver returns the smaller gross.
      expect(r.gross, closeTo(1605.48, 0.011));
      expect(r.net, 1027.00);
      expect(r.totalCost, closeTo(1704.05, 0.02));
    });
  });

  group('Republika Srpska', () {
    test('gross 2.700 KM → net 1.727 KM; tax base ignores contributions', () {
      final r = engine.fromGross(PayrollSystem.republikaSrpska, 2700);
      expect(r.employeeTotal, 837.00);
      expect(r.taxableBase, 1700.00);
      expect(r.incomeTax, 136.00);
      expect(r.net, 1727.00);
      expect(r.employerTotal, 0);
    });
  });

  group('North Macedonia', () {
    test('gross 75.000 MKD → net 49.693 MKD (whole denars)', () {
      final r = engine.fromGross(PayrollSystem.northMacedonia, 75000);
      expect(r.employeeTotal, 21000);
      expect(r.taxableBase, 43068);
      expect(r.incomeTax, 4307);
      expect(r.net, 49693);
    });
  });

  group('Montenegro', () {
    test('gross 1.200 EUR: bands on gross, 13% surtax', () {
      final r = engine.fromGross(PayrollSystem.montenegro, 1200);
      expect(r.employeeTotal, 126.00);
      expect(r.incomeTax, 57.00);
      expect(r.surtax, 7.41);
      expect(r.net, 1009.59);
      expect(r.employerTotal, 11.64);
    });

    test('Podgorica surtax 15%', () {
      final r = engine.fromGross(PayrollSystem.montenegro, 1200, const PayrollOptions(montenegroSurtaxRate: 0.15));
      expect(r.surtax, 8.55);
    });

    test('no tax up to 700', () {
      final r = engine.fromGross(PayrollSystem.montenegro, 700);
      expect(r.incomeTax, 0);
      expect(r.net, 626.50);
    });
  });

  group('Slovenia', () {
    test('gross 2.000 EUR: 23,1 % contributions, OZP 39,36, monthly scale', () {
      final r = engine.fromGross(PayrollSystem.slovenia, 2000);
      expect(r.employeeTotal, 462.00 + 39.36);
      expect(r.allowance, 462.66);
      expect(r.taxableBase, 1035.98);
      expect(r.incomeTax, 188.34);
      expect(r.net, 1310.30);
      expect(r.employerTotal, 342.00);
      expect(r.totalCost, 2342.00);
    });

    test('increased general allowance below 1.480,51', () {
      expect(PayrollEngine.sloveniaAllowance(1480.51), closeTo(462.66, 0.01));
      expect(PayrollEngine.sloveniaAllowance(1200), closeTo(462.66 + 1736.03 - 1.17259 * 1200, 0.01));
    });
  });

  group('Croatia', () {
    test('gross 2.000 EUR, default 20/30 rates', () {
      final r = engine.fromGross(PayrollSystem.croatia, 2000);
      expect(lineAmount(r.employeeLines, PayrollItem.pensionPillar1), 300.00);
      expect(lineAmount(r.employeeLines, PayrollItem.pensionPillar2), 100.00);
      expect(r.taxableBase, 1000.00);
      expect(r.incomeTax, 200.00);
      expect(r.net, 1400.00);
      expect(r.totalCost, 2330.00);
    });

    test('low-wage relief: gross 1.000 → pension base 850', () {
      expect(PayrollEngine.croatiaPensionBase(1000), 850);
      expect(PayrollEngine.croatiaPensionBase(600), 300);
      expect(PayrollEngine.croatiaPensionBase(1300), 1300);
      final r = engine.fromGross(PayrollSystem.croatia, 1000);
      expect(r.employeeTotal, 170.00);
      expect(r.notes, contains(PayrollNote.pensionReliefApplied));
    });

    test('allowance with children: 1 → 900, 3 → 1.920', () {
      expect(PayrollEngine.croatiaAllowance(1, 0), 900);
      expect(PayrollEngine.croatiaAllowance(3, 0), 1920);
      expect(PayrollEngine.croatiaAllowance(0, 2), 1200);
    });

    test('higher band above 5.000 tax base; Zagreb 23/33', () {
      final r = engine.fromGross(
        PayrollSystem.croatia,
        8000,
        const PayrollOptions(croatiaLowerRate: 0.23, croatiaHigherRate: 0.33),
      );
      // base 8000 - 1600 - 600 = 5800 → 5000×23% + 800×33%
      expect(r.taxableBase, 5800);
      expect(r.incomeTax, 1150 + 264);
    });
  });

  group('Bulgaria', () {
    test('gross 1.500 EUR: 13,78% contributions, 10% tax', () {
      final r = engine.fromGross(PayrollSystem.bulgaria, 1500);
      expect(r.employeeTotal, closeTo(206.70, 0.02));
      expect(r.incomeTax, closeTo(129.33, 0.01));
      expect(r.net, closeTo(1163.97, 0.02));
    });

    test('contributions capped at 2.300 EUR', () {
      final r = engine.fromGross(PayrollSystem.bulgaria, 5000);
      expect(r.employeeTotal, closeTo(316.94, 0.02));
      expect(r.notes, contains(PayrollNote.maximumBaseApplied));
    });
  });

  group('Romania', () {
    test('minimum wage 4.325 with the 200 lei facility → net 2.699 (official)', () {
      final r = engine.fromGross(
        PayrollSystem.romania,
        4325,
        const PayrollOptions(romaniaMinimumWageFacility: true),
      );
      expect(lineAmount(r.employeeLines, PayrollItem.cas), 1031);
      expect(lineAmount(r.employeeLines, PayrollItem.cass), 413);
      expect(r.incomeTax, 182);
      expect(r.net, 2699);
    });

    test('personal deduction is a % of the minimum wage, stepping down', () {
      expect(PayrollEngine.romaniaDeduction(4325, 0), 865);
      expect(PayrollEngine.romaniaDeduction(4325, 4), 1946);
      expect(PayrollEngine.romaniaDeduction(4376, 0), 822); // 19% × 4325 = 821.75
      expect(PayrollEngine.romaniaDeduction(6325, 0), 0);
      expect(PayrollEngine.romaniaDeduction(6326, 4), 0);
    });

    test('net → gross works across the stepped deduction', () {
      for (final target in [2700.0, 3000.0, 3300.0, 3700.0]) {
        final r = engine.fromNet(PayrollSystem.romania, target);
        expect(r.net, greaterThanOrEqualTo(target));
        // No smaller whole-lei gross reaches the target.
        final lower = engine.fromGross(PayrollSystem.romania, r.gross - 1);
        expect(lower.net, lessThan(target), reason: 'target $target');
      }
    });
  });

  group('solvers across every system', () {
    for (final system in PayrollSystem.values) {
      test('${system.name}: gross → net → gross round-trips', () {
        for (final gross in [900.0, 2500.0, 7000.0, 150000.0]) {
          final forward = engine.fromGross(system, gross);
          if (forward.net <= 0) continue;
          final back = engine.fromNet(system, forward.net);
          expect(back.net, greaterThanOrEqualTo(forward.net));
          expect(back.gross, lessThanOrEqualTo(gross));
        }
      });

      test('${system.name}: total cost → gross never exceeds the budget', () {
        for (final budget in [1200.0, 5000.0, 90000.0]) {
          final r = engine.fromTotalCost(system, budget);
          expect(r.totalCost, lessThanOrEqualTo(budget));
          final unit = system.decimals == 0 ? 1.0 : 0.01;
          expect(engine.fromGross(system, r.gross + unit).totalCost, greaterThan(budget));
        }
      });

      test('${system.name}: zero, negative and non-finite input are safe', () {
        for (final v in [0.0, -5.0, double.nan, double.infinity]) {
          final r = engine.fromGross(system, v);
          expect(r.gross, 0);
          expect(r.net, 0);
          expect(engine.fromNet(system, v).gross, 0);
          expect(engine.fromTotalCost(system, v).gross, 0);
        }
      });

      test('${system.name}: net rises with gross in the normal range', () {
        var previous = -double.infinity;
        for (var g = 1000.0; g <= 20000; g += 250) {
          final n = engine.fromGross(system, g).net;
          expect(n, greaterThan(previous - 3), reason: 'gross $g');
          previous = n;
        }
      });
    }
  });
}

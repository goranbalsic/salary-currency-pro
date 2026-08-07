import 'package:flutter_test/flutter_test.dart';
import 'package:salary_currency_pro/logic/salary_calculator.dart';
import 'package:salary_currency_pro/models/country.dart';
import 'package:salary_currency_pro/models/tax_config.dart';
import 'package:salary_currency_pro/services/tax_config_service.dart';

/// One hand-verified reference calculation per non-Serbia country (Serbia's
/// own reference cases live in salary_calculator_test.dart). These load the
/// *actual* bundled JSON configs — not hand-duplicated Dart fixtures — so a
/// typo in a config file fails a test here, not just at runtime. Every
/// expected number below was computed by hand from the config's own rates
/// before being pasted in (see comments), the same discipline as the
/// existing Serbia tests.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final service = TaxConfigService();

  Future<CountryTaxConfig> load(String id, String asset) =>
      service.load(id, asset);

  void expectMonotonicAndInvertible(SalaryCalculator calc, String label) {
    double? prevNeto;
    for (final bruto in <double>[0, 1000, 10000, 100000, 1000000]) {
      final neto = calc.fromBruto(bruto).neto;
      if (prevNeto != null) {
        expect(neto, greaterThanOrEqualTo(prevNeto),
            reason: '$label: neto must be non-decreasing in gross');
      }
      prevNeto = neto;
    }
    // Round-trip a representative mid-range salary.
    final forward = calc.fromBruto(50000);
    if (forward.neto > 0) {
      final inverse = calc.fromNeto(forward.neto);
      expect(inverse.bruto1, closeTo(50000, 0.1),
          reason: '$label: fromNeto should invert fromBruto');
    }
  }

  test('Croatia — gross €2,000/mo', () async {
    final cfg = await load('hr', 'assets/config/tax/hr.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(2000);

    // Pension: 2000 * 20% = 400 (employee only, uncapped at this level)
    expect(r.employeeContributionsTotal, closeTo(400.0, 0.001));
    // Health: 2000 * 16.5% = 330 (employer only)
    expect(r.employerContributionsTotal, closeTo(330.0, 0.001));
    // Tax base = 2000 - 400 (contrib) - 600 (allowance) = 1000
    expect(r.taxBase, closeTo(1000.0, 0.001));
    // All of it falls in the 20% bracket (< 5000 monthly threshold)
    expect(r.tax, closeTo(200.0, 0.001));
    // No surtax by default
    expect(r.localSurtaxAmount, closeTo(0.0, 0.001));
    // Neto = 2000 - 400 - 200 = 1400
    expect(r.neto, closeTo(1400.0, 0.001));
    expect(r.bruto2, closeTo(2330.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Croatia');
  });

  test('Slovenia — gross €2,000/mo', () async {
    final cfg = await load('si', 'assets/config/tax/si.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(2000);

    // Social contributions: 2000 * 22.1% = 442 (employee), 2000*16.1%=322 (employer)
    expect(r.employeeContributionsTotal, closeTo(442.0, 0.001));
    expect(r.employerContributionsTotal, closeTo(322.0, 0.001));
    // Annual gross 24,000 >= 16,000 threshold -> lower allowance (5000/yr = 416.667/mo)
    expect(r.allowanceAmount, closeTo(416.6667, 0.01));
    // Tax base = 2000 - 442 - 416.6667 = 1141.3333
    expect(r.taxBase, closeTo(1141.3333, 0.01));
    // Bracket tax: 767.50*16% + (1141.3333-767.50)*26% = 122.80 + 97.1967 = 219.9967
    expect(r.tax, closeTo(219.9967, 0.01));
    expect(r.neto, closeTo(1338.0033, 0.01));
    expect(r.bruto2, closeTo(2322.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Slovenia');
  });

  test('Bosnia — Federation of BiH, gross BAM 1,500/mo', () async {
    final cfg = await load('ba_fbih', 'assets/config/tax/ba_fbih.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(1500);

    // Employee contributions: 1500 * (17+12.5+1.5)% = 1500*31% = 465
    expect(r.employeeContributionsTotal, closeTo(465.0, 0.001));
    // Employer contributions: 1500 * (2.5+2+0.5)% = 1500*5% = 75
    expect(r.employerContributionsTotal, closeTo(75.0, 0.001));
    // Tax base = 1500 - 465 - 300 (allowance) = 735
    expect(r.taxBase, closeTo(735.0, 0.001));
    expect(r.tax, closeTo(73.5, 0.001));
    expect(r.neto, closeTo(961.5, 0.001));
    expect(r.bruto2, closeTo(1575.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Bosnia (FBiH)');
  });

  test('Bosnia — Republika Srpska, gross BAM 1,500/mo', () async {
    final cfg = await load('ba_rs', 'assets/config/tax/ba_rs.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(1500);

    // Employee contributions: 1500 * (18.5+12+0.6+1.7)% = 1500*32.8% = 492
    expect(r.employeeContributionsTotal, closeTo(492.0, 0.001));
    // No employer-side contributions in RS
    expect(r.employerContributionsTotal, closeTo(0.0, 0.001));
    // Tax base = 1500 - 492 - 1000 (allowance) = 8
    expect(r.taxBase, closeTo(8.0, 0.001));
    expect(r.tax, closeTo(0.64, 0.001));
    expect(r.neto, closeTo(1007.36, 0.001));
    expect(r.bruto2, closeTo(1500.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Bosnia (RS)');
  });

  test('Montenegro — gross €1,500/mo', () async {
    final cfg = await load('me', 'assets/config/tax/me.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(1500);

    // Employee contributions: 1500 * (10+0.5)% = 157.5; no employer side
    expect(r.employeeContributionsTotal, closeTo(157.5, 0.001));
    expect(r.employerContributionsTotal, closeTo(0.0, 0.001));
    // Tax base = 1500 - 157.5 = 1342.5
    expect(r.taxBase, closeTo(1342.5, 0.001));
    // Bracket tax: 700*0% + 300*9% + 342.5*15% = 0 + 27 + 51.375 = 78.375
    expect(r.tax, closeTo(78.375, 0.001));
    expect(r.neto, closeTo(1264.125, 0.001));
    expect(r.bruto2, closeTo(1500.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Montenegro');
  });

  test('North Macedonia — gross MKD 60,000/mo', () async {
    final cfg = await load('mk', 'assets/config/tax/mk.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(60000);

    // Employee contributions: 60000 * 28% = 16800; no employer side
    expect(r.employeeContributionsTotal, closeTo(16800.0, 0.001));
    expect(r.employerContributionsTotal, closeTo(0.0, 0.001));
    // Tax base = 60000 - 16800 - 10270 (allowance) = 32930
    expect(r.taxBase, closeTo(32930.0, 0.001));
    expect(r.tax, closeTo(3293.0, 0.001));
    expect(r.neto, closeTo(39907.0, 0.001));

    expectMonotonicAndInvertible(calc, 'North Macedonia');
  });

  test('Bulgaria — gross EUR 2,000/mo (below the EUR 2,300 contribution cap)', () async {
    // Bulgaria adopted the euro 1 Jan 2026 (DECISIONS.md D-020); this
    // config's contribution base is EUR-denominated, cap EUR 2,300/month
    // effective 1 Aug 2026. 2,000 is below the cap, so it isn't clamped.
    final cfg = await load('bg', 'assets/config/tax/bg.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(2000);

    // Employee: 2000 * (10.58+3.2)% = 2000*13.78% = 275.6
    expect(r.employeeContributionsTotal, closeTo(275.6, 0.001));
    // Employer: 2000 * (14.12+4.8)% = 2000*18.92% = 378.4
    expect(r.employerContributionsTotal, closeTo(378.4, 0.001));
    // Tax base = 2000 - 275.6 = 1724.4
    expect(r.taxBase, closeTo(1724.4, 0.001));
    expect(r.tax, closeTo(172.44, 0.001));
    expect(r.neto, closeTo(1551.96, 0.001));
    expect(r.bruto2, closeTo(2378.4, 0.001));

    expectMonotonicAndInvertible(calc, 'Bulgaria');
  });

  test('Bulgaria — gross EUR 3,000/mo is clamped at the EUR 2,300 contribution cap', () async {
    final cfg = await load('bg', 'assets/config/tax/bg.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(3000);

    // Contribution base clamps at 2,300, not the full 3,000 gross.
    expect(r.employeeContributionsTotal, closeTo(2300 * 0.1378, 0.001));
    expect(r.employerContributionsTotal, closeTo(2300 * 0.1892, 0.001));
  });

  test('Albania — gross ALL 100,000/mo', () async {
    final cfg = await load('al', 'assets/config/tax/al.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(100000);

    // Employee: 100000 * (9.5+1.7)% = 100000*11.2% = 11200
    expect(r.employeeContributionsTotal, closeTo(11200.0, 0.001));
    // Employer: 100000 * (15+1.7)% = 100000*16.7% = 16700
    expect(r.employerContributionsTotal, closeTo(16700.0, 0.001));
    // Tax base = 100000 - 11200 = 88800, all within the 13% bracket (<170,000)
    expect(r.taxBase, closeTo(88800.0, 0.001));
    expect(r.tax, closeTo(11544.0, 0.001));
    expect(r.neto, closeTo(77256.0, 0.001));
    expect(r.bruto2, closeTo(116700.0, 0.001));

    expectMonotonicAndInvertible(calc, 'Albania');
  });

  test('Romania — gross RON 5,000/mo', () async {
    final cfg = await load('ro', 'assets/config/tax/ro.json');
    final calc = SalaryCalculator(cfg);
    final r = calc.fromBruto(5000);

    // CAS + CASS: 5000 * (25+10)% = 1750; CAM (employer only): 5000*2.25%=112.5
    expect(r.employeeContributionsTotal, closeTo(1750.0, 0.001));
    expect(r.employerContributionsTotal, closeTo(112.5, 0.001));
    // Personal deduction: delta=675, steps=13.5, rate=20-6.75=13.25% -> 662.5
    expect(r.allowanceAmount, closeTo(662.5, 0.001));
    // Tax base = 5000 - 1750 - 662.5 = 2587.5
    expect(r.taxBase, closeTo(2587.5, 0.001));
    expect(r.tax, closeTo(258.75, 0.001));
    expect(r.neto, closeTo(2991.25, 0.001));
    expect(r.bruto2, closeTo(5112.5, 0.001));

    expectMonotonicAndInvertible(calc, 'Romania');
  });

  test('every registered country/entity config loads and parses', () async {
    for (final country in kCountries) {
      if (country.hasEntities) {
        for (final entity in country.entities!) {
          final cfg = await load(entity.id, entity.taxConfigAsset);
          expect(cfg.contributions, isNotEmpty,
              reason: '${country.id}/${entity.id} has no contributions');
          expect(cfg.brackets, isNotEmpty,
              reason: '${country.id}/${entity.id} has no brackets');
        }
      } else {
        final cfg = await load(country.id, country.taxConfigAsset!);
        expect(cfg.contributions, isNotEmpty,
            reason: '${country.id} has no contributions');
        expect(cfg.brackets, isNotEmpty, reason: '${country.id} has no brackets');
      }
    }
  });
}

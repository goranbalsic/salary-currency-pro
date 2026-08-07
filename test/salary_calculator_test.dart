import 'package:flutter_test/flutter_test.dart';
import 'package:salary_currency_pro/logic/salary_calculator.dart';
import 'package:salary_currency_pro/models/tax_config.dart';

/// Mirrors assets/config/tax/rs.json (2026 parameters), pinned here so
/// these tests stay meaningful even if the config file is edited. This is
/// also the reference case the generic multi-country engine is built
/// against — every number below is unchanged from the Serbia-only
/// implementation this engine replaced.
final _config2026 = CountryTaxConfig(
  countryId: 'rs',
  year: 2026,
  effectiveFrom: DateTime(2026, 1, 1),
  taxBaseDeductsContributions: false,
  allowanceType: AllowanceType.flat,
  flatAllowanceAmount: 34221.0,
  allowanceParams: null,
  brackets: const [TaxBracket(upTo: null, rate: 0.10)],
  contributions: const [
    ContributionRate(
      id: 'pio',
      label: 'PIO',
      employeeRate: 0.14,
      employerRate: 0.10,
      minBase: 51297.0,
      maxBase: 732820.0,
    ),
    ContributionRate(
      id: 'health',
      label: 'Health',
      employeeRate: 0.0515,
      employerRate: 0.0515,
      minBase: 51297.0,
      maxBase: 732820.0,
    ),
    ContributionRate(
      id: 'unemployment',
      label: 'Unemployment',
      employeeRate: 0.0075,
      employerRate: 0.0,
      minBase: 51297.0,
      maxBase: 732820.0,
    ),
  ],
  localSurtax: null,
  sources: const [],
  lastUpdated: DateTime(2026, 8, 6),
);

void main() {
  final calc = SalaryCalculator(_config2026);

  group('fromBruto — hand-verified against manual calculation', () {
    test('bruto1 = 100,000 RSD (mid-range, no clamping)', () {
      final r = calc.fromBruto(100000);

      // Employee contributions = 100,000 * 19.9% = 19,900.00
      expect(r.employeeContributionsTotal, closeTo(19900.0, 0.001));
      // Tax base = 100,000 - 34,221 = 65,779.00
      expect(r.taxBase, closeTo(65779.0, 0.001));
      // Tax = 65,779 * 10% = 6,577.90
      expect(r.tax, closeTo(6577.90, 0.001));
      // Neto = 100,000 - 19,900 - 6,577.90 = 73,522.10
      expect(r.neto, closeTo(73522.10, 0.001));

      // Employer contributions = 100,000 * 15.15% = 15,150.00
      expect(r.employerContributionsTotal, closeTo(15150.0, 0.001));
      // Bruto2 (total employer cost) = 115,150.00
      expect(r.bruto2, closeTo(115150.0, 0.001));
    });

    test('bruto1 exactly at the non-taxable threshold: zero tax', () {
      final r = calc.fromBruto(34221);
      expect(r.taxBase, closeTo(0, 0.001));
      expect(r.tax, closeTo(0, 0.001));
      // Below the minimum contribution base (51,297), so contributions are
      // still charged on the minimum base, not on the actual 34,221.
      expect(r.highestContributionBase, closeTo(51297.0, 0.001));
      expect(r.employeeContributionsTotal, closeTo(51297.0 * 0.199, 0.001));
      expect(r.neto, closeTo(34221 - 51297.0 * 0.199, 0.001));
    });

    test('bruto1 below the minimum contribution base still pays '
        'contributions on the minimum base', () {
      final r = calc.fromBruto(40000);
      expect(r.highestContributionBase, closeTo(51297.0, 0.001));
      expect(r.employeeContributionsTotal, closeTo(51297.0 * 0.199, 0.001));
      // Tax itself is still based on actual bruto1, not the clamped base.
      expect(r.taxBase, closeTo(40000 - 34221, 0.001));
      expect(r.neto, closeTo(40000 - 51297.0 * 0.199 - 5779 * 0.10, 0.01));
    });

    test('bruto1 above the maximum contribution base caps contributions',
        () {
      final r = calc.fromBruto(1000000);
      expect(r.highestContributionBase, closeTo(732820.0, 0.001));
      expect(
        r.employeeContributionsTotal,
        closeTo(732820.0 * 0.199, 0.001),
      );
      expect(r.taxBase, closeTo(1000000 - 34221, 0.001));
      expect(r.tax, closeTo((1000000 - 34221) * 0.10, 0.001));
      expect(
        r.neto,
        closeTo(1000000 - 732820.0 * 0.199 - (1000000 - 34221) * 0.10, 0.01),
      );
    });

    test('bruto1 = 0 does not crash and produces a non-positive neto', () {
      final r = calc.fromBruto(0);
      expect(r.neto, lessThanOrEqualTo(0));
    });
  });

  group('fromNeto — inverse of fromBruto across every breakpoint segment',
      () {
    void expectRoundTrip(double bruto1) {
      final forward = calc.fromBruto(bruto1);
      final inverse = calc.fromNeto(forward.neto);
      expect(
        inverse.bruto1,
        closeTo(bruto1, 0.05),
        reason: 'round trip failed for bruto1=$bruto1',
      );
      expect(inverse.neto, closeTo(forward.neto, 0.05));
    }

    test('round-trips in the unclamped mid-range', () => expectRoundTrip(100000));
    test('round-trips below the min contribution base', () => expectRoundTrip(40000));
    test('round-trips right at the non-taxable threshold', () => expectRoundTrip(34221));
    test('round-trips above the max contribution base', () => expectRoundTrip(1000000));
    test(
      'round-trips for a low salary that still nets a positive take-home',
      () => expectRoundTrip(20000),
    );
  });

  test(
    'below ~10,208 RSD gross, the minimum contribution base floor means '
    'mandatory employee contributions alone exceed the salary — neto goes '
    'non-positive. This is a real consequence of the legal minimum '
    'contribution base (registering a salary this low is impractical), not '
    'a calculator bug — the UI must surface this rather than show a '
    'negative "neto" as if it were normal',
    () {
      final r = calc.fromBruto(5000);
      expect(r.highestContributionBase, closeTo(51297.0, 0.001));
      expect(r.neto, lessThan(0));
    },
  );

  test('neto is monotonically non-decreasing as bruto1 increases', () {
    double? prevNeto;
    for (final bruto1 in <double>[
      0.0, 10000, 34221, 40000, 51297, 100000, 500000, 732820, 1000000,
    ]) {
      final neto = calc.fromBruto(bruto1).neto;
      if (prevNeto != null) {
        expect(neto, greaterThanOrEqualTo(prevNeto));
      }
      prevNeto = neto;
    }
  });
}

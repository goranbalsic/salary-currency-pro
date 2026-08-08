import 'package:flutter_test/flutter_test.dart';
import 'package:salary_currency_pro/logic/salary_calculator.dart';
import 'package:salary_currency_pro/models/cross_border_comparison.dart';

void main() {
  final testAsOf = DateTime(2026, 8, 8);

  SalaryBreakdown breakdown() => const SalaryBreakdown(
        bruto1: 1000,
        allowanceAmount: 100,
        taxBase: 700,
        tax: 70,
        localSurtaxAmount: 7,
        contributions: [
          ContributionLine(id: 'pio', label: 'PIO', base: 1000, employeeAmount: 200, employerAmount: 100),
        ],
        employeeContributionsTotal: 200,
        employerContributionsTotal: 100,
        neto: 723,
        bruto2: 1100,
      );

  group('scaleBreakdownForPeriod', () {
    test('monthly period returns the exact same instance, no scaling', () {
      final b = breakdown();
      expect(identical(scaleBreakdownForPeriod(b, CrossBorderPayPeriod.monthly), b), isTrue);
    });

    test('annual period multiplies every money figure by 12', () {
      final b = breakdown();
      final annual = scaleBreakdownForPeriod(b, CrossBorderPayPeriod.annual);

      expect(annual.bruto1, closeTo(12000, 0.01));
      expect(annual.allowanceAmount, closeTo(1200, 0.01));
      expect(annual.taxBase, closeTo(8400, 0.01));
      expect(annual.tax, closeTo(840, 0.01));
      expect(annual.localSurtaxAmount, closeTo(84, 0.01));
      expect(annual.employeeContributionsTotal, closeTo(2400, 0.01));
      expect(annual.employerContributionsTotal, closeTo(1200, 0.01));
      expect(annual.neto, closeTo(8676, 0.01));
      expect(annual.bruto2, closeTo(13200, 0.01));
      expect(annual.contributions.single.base, closeTo(12000, 0.01));
      expect(annual.contributions.single.employeeAmount, closeTo(2400, 0.01));
      expect(annual.contributions.single.employerAmount, closeTo(1200, 0.01));
      expect(annual.contributions.single.id, 'pio');
      expect(annual.contributions.single.label, 'PIO');
    });

    test('annual scaling never leaves a floating-point rounding artifact', () {
      // A figure known to produce binary floating-point noise when scaled
      // naively (see money.dart's own doc comment for the same class of bug).
      const b = SalaryBreakdown(
        bruto1: 85.43,
        allowanceAmount: 0,
        taxBase: 85.43,
        tax: 0,
        localSurtaxAmount: 0,
        contributions: [],
        employeeContributionsTotal: 0,
        employerContributionsTotal: 0,
        neto: 85.43,
        bruto2: 85.43,
      );
      final annual = scaleBreakdownForPeriod(b, CrossBorderPayPeriod.annual);
      // 85.43 * 12 = 1025.16 exactly at the cent level.
      expect(annual.neto, 1025.16);
    });
  });

  group('CrossBorderRegimeResult', () {
    test('converts to the comparison currency using rateInfo.rate (EUR -> local)', () {
      final result = CrossBorderRegimeResult(
        countryId: 'rs',
        currencyCode: 'RSD',
        grossLocal: 100000,
        breakdown: breakdown(),
        rateInfo: CrossBorderRateInfo(rate: 117.0, source: 'Test', asOf: testAsOf),
      );
      // neto=723 local / 117 EUR-per-local-unit... see rate direction below.
      expect(result.netInComparisonCurrency, closeTo(723 / 117.0, 0.01));
      expect(result.employerCostInComparisonCurrency, closeTo(1100 / 117.0, 0.01));
    });

    test('comparison-currency conversion rounds to the nearest cent through money.dart, '
        'never leaving a repeating-decimal or float artifact on screen', () {
      // 100 / 3 = 33.333... — a classic repeating decimal that must land on
      // a clean two-decimal figure, not 33.333333333333336 or similar.
      const roundingBreakdown = SalaryBreakdown(
        bruto1: 100,
        allowanceAmount: 0,
        taxBase: 100,
        tax: 0,
        localSurtaxAmount: 0,
        contributions: [],
        employeeContributionsTotal: 0,
        employerContributionsTotal: 0,
        neto: 100,
        bruto2: 100,
      );
      final result = CrossBorderRegimeResult(
        countryId: 'ba',
        entityId: 'fbih',
        currencyCode: 'BAM',
        grossLocal: 100,
        breakdown: roundingBreakdown,
        rateInfo: CrossBorderRateInfo(rate: 3.0, source: 'Test', asOf: testAsOf),
      );
      expect(result.netInComparisonCurrency, 33.33);
      expect(result.employerCostInComparisonCurrency, 33.33);
    });

    test('rowId is just the country id when there is no entity, else country_entity', () {
      final noEntity = CrossBorderRegimeResult(
        countryId: 'hr',
        currencyCode: 'EUR',
        grossLocal: 1000,
        breakdown: breakdown(),
        rateInfo: CrossBorderRateInfo(rate: 1.0, source: 'Same currency', asOf: testAsOf, isSameCurrency: true),
      );
      expect(noEntity.rowId, 'hr');

      final withEntity = CrossBorderRegimeResult(
        countryId: 'ba',
        entityId: 'fbih',
        currencyCode: 'BAM',
        grossLocal: 1000,
        breakdown: breakdown(),
        rateInfo: CrossBorderRateInfo(rate: 1.96, source: 'Test', asOf: testAsOf),
      );
      expect(withEntity.rowId, 'ba_fbih');
    });
  });

  group('CrossBorderRegimeError', () {
    test('rowId mirrors CrossBorderRegimeResult\'s scheme', () {
      const noEntity = CrossBorderRegimeError(
        countryId: 'al',
        currencyCode: 'ALL',
        reason: CrossBorderUnavailableReason.noCachedRate,
        message: 'No cached exchange rate for ALL.',
      );
      expect(noEntity.rowId, 'al');

      const withEntity = CrossBorderRegimeError(
        countryId: 'ba',
        entityId: 'republika_srpska',
        currencyCode: 'BAM',
        reason: CrossBorderUnavailableReason.noCachedRate,
        message: 'No cached exchange rate for BAM.',
      );
      expect(withEntity.rowId, 'ba_republika_srpska');
    });
  });
}

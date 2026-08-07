import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/logic/budget_planner.dart';
import 'package:salary_currency_pro/logic/freelancer_payout_calculator.dart';
import 'package:salary_currency_pro/logic/loan_calculator.dart';
import 'package:salary_currency_pro/logic/savings_calculator.dart';
import 'package:salary_currency_pro/logic/vat_calculator.dart';
import 'package:salary_currency_pro/models/rate_snapshot.dart';
import 'package:salary_currency_pro/services/exchange_rate_service.dart';
import 'package:salary_currency_pro/services/rate_providers.dart';

class _FakeProvider implements RateProviderApi {
  @override
  final String id;
  final RateSnapshot Function(String base) onFetch;
  _FakeProvider(this.id, this.onFetch);

  @override
  Future<RateSnapshot> fetchLatest(String base) async => onFetch(base);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LoanCalculator.paymentFor', () {
    test('standard annuity: 10,000 at 12%/yr over 12 months ~ 888.49/mo', () {
      final r = LoanCalculator.paymentFor(
        principal: 10000,
        annualRatePercent: 12,
        months: 12,
      );
      expect(r.monthlyPayment, closeTo(888.49, 0.5));
      expect(r.schedule.length, 12);
      expect(r.schedule.last.remainingBalance, closeTo(0, 0.01));
      expect(r.totalPaid, closeTo(r.monthlyPayment * 12, 1));
    });

    test('zero interest splits principal evenly', () {
      final r = LoanCalculator.paymentFor(
        principal: 1200,
        annualRatePercent: 0,
        months: 12,
      );
      expect(r.monthlyPayment, closeTo(100, 0.001));
      expect(r.totalInterest, closeTo(0, 0.001));
    });
  });

  group('LoanCalculator.payoffFor', () {
    test('zero interest: 1000 at 100/mo pays off in exactly 10 months', () {
      final r = LoanCalculator.payoffFor(
        principal: 1000,
        annualRatePercent: 0,
        monthlyPayment: 100,
      );
      expect(r.months, 10);
      expect(r.totalInterest, closeTo(0, 0.001));
      expect(r.totalPaid, closeTo(1000, 0.001));
    });

    test('a payment that does not cover monthly interest throws instead of '
        'looping forever or lying about a payoff date', () {
      expect(
        () => LoanCalculator.payoffFor(
          principal: 1000,
          annualRatePercent: 24, // 2%/mo -> 20/mo interest on full balance
          monthlyPayment: 15,
        ),
        throwsA(isA<PaymentTooLowException>()),
      );
    });
  });

  group('SavingsCalculator.project', () {
    test('zero rate: future value is just principal + contributions', () {
      final r = SavingsCalculator.project(
        principal: 1000,
        monthlyContribution: 100,
        annualRatePercent: 0,
        years: 1,
      );
      expect(r.futureValue, closeTo(2200, 0.001));
      expect(r.totalInterestEarned, closeTo(0, 0.001));
    });

    test('6%/yr compounded monthly on 1000 + 100/mo over 1 year ~ 2295.24', () {
      final r = SavingsCalculator.project(
        principal: 1000,
        monthlyContribution: 100,
        annualRatePercent: 6,
        years: 1,
      );
      expect(r.futureValue, closeTo(2295.24, 1));
      expect(r.totalContributed, closeTo(2200, 0.001));
    });
  });

  group('VatCalculator', () {
    test('addVat(100, 20%) -> 20 VAT, 120 gross', () {
      final r = VatCalculator.addVat(100, 20);
      expect(r.vatAmount, closeTo(20, 0.001));
      expect(r.gross, closeTo(120, 0.001));
    });

    test('removeVat(120, 20%) -> 100 net, 20 VAT (inverse of addVat)', () {
      final r = VatCalculator.removeVat(120, 20);
      expect(r.net, closeTo(100, 0.001));
      expect(r.vatAmount, closeTo(20, 0.001));
    });
  });

  group('BudgetPlanner', () {
    test('classic 50/30/20 split on 3000', () {
      final r = BudgetPlanner.allocate(3000, kBudgetPresets[0]);
      expect(r.needs, closeTo(1500, 0.001));
      expect(r.wants, closeTo(900, 0.001));
      expect(r.savings, closeTo(600, 0.001));
    });
  });

  group('FreelancerPayoutCalculator', () {
    test('applies platform fee, then bank fee, then converts at the live rate',
        () async {
      final service = ExchangeRateService(
        frankfurter: _FakeProvider(
          'frankfurter',
          (base) => RateSnapshot(
            base: 'USD',
            rates: {'EUR': 0.9},
            asOf: DateTime(2026, 1, 1),
            fetchedAt: DateTime(2026, 1, 1),
            source: 'Fake',
          ),
        ),
      );
      final calc = FreelancerPayoutCalculator(rateService: service);

      final r = await calc.compute(
        grossForeign: 1000,
        foreignCurrency: 'USD',
        platformFeePercent: 10, // -> 900 left
        bankFeeFlat: 20,
        bankFeePercent: 2, // 2% of 900 = 18, + 20 flat = 38
        localCurrency: 'EUR',
      );

      expect(r.platformFeeAmount, closeTo(100, 0.001));
      expect(r.bankFeeAmount, closeTo(38, 0.001));
      // net foreign = 900 - 38 = 862; local = 862 * 0.9 = 775.8
      expect(r.netForeign, closeTo(862, 0.001));
      expect(r.localAmount, closeTo(775.8, 0.001));
    });
  });
}

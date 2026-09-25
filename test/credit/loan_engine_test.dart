import 'package:bilans/core/money/cash_flow.dart';
import 'package:bilans/core/money/money.dart';
import 'package:bilans/features/credit/domain/credit_inputs.dart';
import 'package:bilans/features/credit/domain/deposit_engine.dart';
import 'package:bilans/features/credit/domain/loan_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = LoanEngine();

  group('annuity schedule (bank rounding)', () {
    test('10,000 at 6% over 12 months', () {
      final r = engine.compute(const LoanInput(principal: 10000, annualRatePercent: 6, months: 12));
      expect(r.firstInstallment, 860.66);
      expect(r.lastInstallment, 860.70, reason: 'the last installment absorbs rounding');
      expect(r.totalInterest, 327.96);
      expect(r.rows.length, 12);
      expect(r.rows.last.balance, 0);
      expect(Money.sum(r.rows.map((e) => e.principal)), 10000);
    });

    test('100,000 at 5% over 30 years', () {
      final r = engine.compute(const LoanInput(principal: 100000, annualRatePercent: 5, months: 360));
      expect(r.firstInstallment, 536.82);
      expect(r.totalInterest, 93256.52);
      expect(r.eirAnnual, closeTo(0.0511619, 1e-6), reason: 'no fees: EIR = (1 + r/12)^12 − 1');
    });

    test('the processing fee raises the APR', () {
      final base = engine.compute(const LoanInput(principal: 1200000, annualRatePercent: 7.49, months: 84));
      final withFee = engine.compute(const LoanInput(principal: 1200000, annualRatePercent: 7.49, months: 84, upfrontFeePercent: 1));
      expect(base.eirAnnual, closeTo(0.0775255, 1e-6));
      expect(withFee.eirAnnual, closeTo(0.0808815, 1e-6));
      expect(withFee.totalFees, 12000);
      expect(withFee.totalCost, Money.sum([1200000, withFee.totalInterest, 12000]));
    });

    test('monthly fees are part of the APR and total cost', () {
      final r = engine.compute(const LoanInput(principal: 10000, annualRatePercent: 6, months: 12, monthlyFee: 5));
      expect(r.totalMonthlyFees, 60);
      expect(r.eirAnnual!, greaterThan(0.0617));
    });

    test('zero interest splits the principal evenly', () {
      final r = engine.compute(const LoanInput(principal: 1000, annualRatePercent: 0, months: 3));
      expect(r.rows.map((e) => e.installment), [333.33, 333.33, 333.34]);
      expect(r.totalInterest, 0);
      expect(r.eirAnnual, closeTo(0, 1e-9));
    });

    test('by-year totals add up to the whole loan', () {
      final r = engine.compute(const LoanInput(principal: 50000, annualRatePercent: 4.2, months: 30));
      final years = r.byYear;
      expect(years.length, 3);
      expect(Money.sum(years.map((y) => y.principal)), 50000);
      expect(Money.sum(years.map((y) => y.interest)), r.totalInterest);
    });
  });

  group('equal-principal schedule', () {
    test('12,000 at 6% over 12 months', () {
      final r = engine.compute(const LoanInput(principal: 12000, annualRatePercent: 6, months: 12, type: RepaymentType.linear));
      expect(r.firstInstallment, 1060);
      expect(r.lastInstallment, 1005);
      expect(r.totalInterest, 390);
      expect(r.rows.every((e) => e.principal == 1000), isTrue);
    });
  });

  group('validation', () {
    test('rejects impossible inputs', () {
      expect(const LoanInput(principal: 0, annualRatePercent: 5, months: 12).validate(), LoanInputError.principal);
      expect(const LoanInput(principal: 100, annualRatePercent: -1, months: 12).validate(), LoanInputError.rate);
      expect(const LoanInput(principal: 100, annualRatePercent: 5, months: 0).validate(), LoanInputError.term);
      expect(const LoanInput(principal: 100, annualRatePercent: 5, months: 601).validate(), LoanInputError.term);
      expect(const LoanInput(principal: 100, annualRatePercent: 5, months: 12, upfrontFeePercent: 100).validate(), LoanInputError.fee);
      expect(() => engine.compute(const LoanInput(principal: 0, annualRatePercent: 5, months: 12)), throwsArgumentError);
    });
  });

  group('early repayment', () {
    const input = LoanInput(principal: 100000, annualRatePercent: 6, months: 120);

    test('shorter term keeps the installment and saves interest', () {
      final p = engine.prepay(input, afterMonth: 24, amount: 20000);
      expect(p.amount, 20000);
      expect(p.monthsSaved, greaterThan(0));
      expect(p.interestSaved, greaterThan(0));
      expect(p.after.rows.last.balance, 0);
      expect(p.after.rows[30].installment, closeTo(p.original.firstInstallment, 0.01));
      expect(Money.sum(p.after.rows.map((e) => e.principal)), 100000);
    });

    test('lower installment keeps the term', () {
      final p = engine.prepay(input, afterMonth: 24, amount: 20000, mode: PrepaymentMode.lowerPayment);
      expect(p.monthsSaved, 0);
      expect(p.newInstallment, lessThan(p.original.firstInstallment));
      expect(p.after.rows.length, 120);
    });

    test('a payment larger than the balance clears it', () {
      final p = engine.prepay(input, afterMonth: 110, amount: 1e9);
      expect(p.paidOff, isTrue);
      expect(p.after.rows.length, 110);
      expect(p.after.rows.last.balance, 0);
    });

    test('the prepayment fee reduces the net saving', () {
      final p = engine.prepay(input, afterMonth: 24, amount: 20000, feePercent: 1);
      expect(p.fee, 200);
      expect(p.netSaving, Money.sub(p.interestSaved, 200));
    });
  });

  group('deposit', () {
    const deposit = DepositEngine();

    test('interest at maturity, taxed once', () {
      final r = deposit.compute(const DepositInput(principal: 10000, annualRatePercent: 3, months: 12, taxPercent: 15));
      expect(r.grossInterest, 300);
      expect(r.tax, 45);
      expect(r.finalBalance, 10255);
      expect(r.effectiveAnnualYield, closeTo(0.0255, 1e-9));
    });

    test('monthly compounding credits net interest every month', () {
      final r = deposit.compute(const DepositInput(principal: 10000, annualRatePercent: 3, months: 12, compounding: Compounding.monthly));
      expect(r.grossInterest, closeTo(304.16, 0.01));
      expect(r.finalBalance, Money.sum([10000, r.grossInterest]));
    });

    test('monthly additions are counted as paid in', () {
      final r = deposit.compute(const DepositInput(principal: 0, annualRatePercent: 0, months: 12, monthlyContribution: 100));
      expect(r.totalContributed, 1100, reason: 'added at the end of months 1–11');
      expect(r.finalBalance, 1100);
    });

    test('yearly rows end at the final balance', () {
      final r = deposit.compute(const DepositInput(principal: 5000, annualRatePercent: 4, months: 30, compounding: Compounding.annually, taxPercent: 15));
      expect(r.years.length, 3);
      expect(r.years.last.balance, r.finalBalance);
    });

    test('validation', () {
      expect(const DepositInput(principal: -1, annualRatePercent: 3, months: 12).validate(), DepositInputError.principal);
      expect(const DepositInput(principal: 100, annualRatePercent: 3, months: 0).validate(), isNotNull);
    });
  });

  group('saved inputs', () {
    test('loan inputs survive a JSON round trip and reject junk', () {
      const inputs = LoanInputs(principal: 5000, currency: 'EUR', rate: 4.5, months: 48, type: RepaymentType.linear, feePercent: 1);
      final back = LoanInputs.fromJson(inputs.toJson(), fallbackCurrency: 'RSD')!;
      expect(back.toJson(), inputs.toJson());
      final junk = LoanInputs.fromJson({'principal': 'x', 'months': 9999, 'type': 'nope'}, fallbackCurrency: 'RSD')!;
      expect(junk.principal, isNull);
      expect(junk.months, 60);
      expect(junk.type, RepaymentType.annuity);
      expect(junk.currency, 'RSD');
    });
  });

  group('IRR', () {
    test('finds the rate of a simple investment', () {
      expect(CashFlow.irr([-1000, 1100])!, closeTo(0.10, 1e-9));
      expect(CashFlow.irr([-1000, 500, 500, 500])!, closeTo(0.2338, 1e-4));
    });

    test('returns null without a sign change', () {
      expect(CashFlow.irr([100, 100]), isNull);
      expect(CashFlow.irr([-100, -100]), isNull);
      expect(CashFlow.irr([0]), isNull);
    });

    test('NPV discounts from period 0', () {
      expect(CashFlow.npv(0.1, [-1000, 1100]), closeTo(0, 1e-9));
      expect(CashFlow.npv(0, [1, 2, 3]), 6);
    });
  });
}

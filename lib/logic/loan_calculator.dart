import 'dart:math';

/// One month's line in an amortization schedule.
class AmortizationRow {
  final int month;
  final double payment;
  final double principalPortion;
  final double interestPortion;
  final double remainingBalance;

  const AmortizationRow({
    required this.month,
    required this.payment,
    required this.principalPortion,
    required this.interestPortion,
    required this.remainingBalance,
  });
}

class LoanPaymentResult {
  final double monthlyPayment;
  final double totalPaid;
  final double totalInterest;
  final List<AmortizationRow> schedule;

  const LoanPaymentResult({
    required this.monthlyPayment,
    required this.totalPaid,
    required this.totalInterest,
    required this.schedule,
  });
}

class LoanPayoffResult {
  final int months;
  final double totalPaid;
  final double totalInterest;

  const LoanPayoffResult({
    required this.months,
    required this.totalPaid,
    required this.totalInterest,
  });
}

/// A fixed monthly payment that would never reduce the balance (it doesn't
/// even cover the interest accruing each month).
class PaymentTooLowException implements Exception {
  final String message;
  const PaymentTooLowException(this.message);
  @override
  String toString() => message;
}

/// Standard amortizing-loan math: currency-agnostic, works for any of the
/// app's currencies since it's pure arithmetic on whatever unit is passed
/// in.
class LoanCalculator {
  LoanCalculator._();

  /// The fixed monthly payment for a [principal] loan at [annualRatePercent]
  /// (e.g. 6.5 for 6.5%) over [months], plus the full amortization schedule.
  static LoanPaymentResult paymentFor({
    required double principal,
    required double annualRatePercent,
    required int months,
  }) {
    if (principal <= 0 || months <= 0) {
      return const LoanPaymentResult(
        monthlyPayment: 0,
        totalPaid: 0,
        totalInterest: 0,
        schedule: [],
      );
    }

    final r = annualRatePercent / 100 / 12;
    final basePayment = r == 0
        ? principal / months
        : principal * r * pow(1 + r, months) / (pow(1 + r, months) - 1);

    final schedule = <AmortizationRow>[];
    var balance = principal;
    var totalInterest = 0.0;
    var payment = basePayment;

    for (var m = 1; m <= months; m++) {
      final interestPortion = balance * r;
      var principalPortion = payment - interestPortion;
      if (m == months || principalPortion > balance) {
        // Last installment (or rounding drift) clears the exact remainder
        // instead of under/over-shooting the balance by a few cents.
        principalPortion = balance;
        payment = principalPortion + interestPortion;
      }
      balance = (balance - principalPortion).clamp(0, double.infinity);
      totalInterest += interestPortion;
      schedule.add(AmortizationRow(
        month: m,
        payment: payment,
        principalPortion: principalPortion,
        interestPortion: interestPortion,
        remainingBalance: balance,
      ));
      payment = basePayment;
    }

    return LoanPaymentResult(
      monthlyPayment: schedule.first.payment,
      totalPaid: principal + totalInterest,
      totalInterest: totalInterest,
      schedule: schedule,
    );
  }

  /// How many months a fixed [monthlyPayment] takes to pay off [principal]
  /// at [annualRatePercent]. Throws [PaymentTooLowException] rather than
  /// looping forever or returning a nonsense answer if the payment doesn't
  /// even cover the interest accruing each month.
  static LoanPayoffResult payoffFor({
    required double principal,
    required double annualRatePercent,
    required double monthlyPayment,
  }) {
    if (monthlyPayment <= 0) {
      throw const PaymentTooLowException('Payment must be greater than zero.');
    }
    final r = annualRatePercent / 100 / 12;
    if (r > 0 && monthlyPayment <= principal * r) {
      throw const PaymentTooLowException(
        'This payment is too low to ever pay off the balance — it does not '
        'even cover the interest that accrues each month.',
      );
    }

    var balance = principal;
    var totalInterest = 0.0;
    var months = 0;
    // 1200 months (100 years) is a generous safety cap; any real loan
    // clears long before this given the check above.
    while (balance > 0.005 && months < 1200) {
      final interest = balance * r;
      var principalPortion = monthlyPayment - interest;
      if (principalPortion > balance) principalPortion = balance;
      balance -= principalPortion;
      totalInterest += interest;
      months++;
    }

    return LoanPayoffResult(
      months: months,
      totalPaid: principal + totalInterest,
      totalInterest: totalInterest,
    );
  }
}

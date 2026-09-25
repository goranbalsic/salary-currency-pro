import 'dart:math' as math;

import '../../../core/money/cash_flow.dart';
import '../../../core/money/money.dart';

enum RepaymentType { annuity, linear }

enum PrepaymentMode { shortenTerm, lowerPayment }

class LoanInput {
  const LoanInput({
    required this.principal,
    required this.annualRatePercent,
    required this.months,
    this.type = RepaymentType.annuity,
    this.upfrontFeePercent = 0,
    this.upfrontFeeFixed = 0,
    this.monthlyFee = 0,
    this.firstPaymentDate,
  });

  final double principal;

  /// Nominal annual interest rate in percent (7.49 = 7.49 %).
  final double annualRatePercent;
  final int months;
  final RepaymentType type;

  /// One-off processing fee as a percentage of the principal.
  final double upfrontFeePercent;

  /// One-off fixed fees (appraisal, notary, ...).
  final double upfrontFeeFixed;

  /// Recurring monthly fee (account maintenance, insurance, ...).
  final double monthlyFee;
  final DateTime? firstPaymentDate;

  static const maxMonths = 600;
  static const maxRatePercent = 100.0;
  static const maxPrincipal = 1e11;

  /// Null when valid, otherwise which field is out of range.
  LoanInputError? validate() {
    if (!principal.isFinite || principal <= 0) return LoanInputError.principal;
    if (principal > maxPrincipal) return LoanInputError.principal;
    if (!annualRatePercent.isFinite || annualRatePercent < 0 || annualRatePercent > maxRatePercent) {
      return LoanInputError.rate;
    }
    if (months < 1 || months > maxMonths) return LoanInputError.term;
    if (!upfrontFeePercent.isFinite || upfrontFeePercent < 0 || upfrontFeePercent >= 100) {
      return LoanInputError.fee;
    }
    if (!upfrontFeeFixed.isFinite || upfrontFeeFixed < 0 || !monthlyFee.isFinite || monthlyFee < 0) {
      return LoanInputError.fee;
    }
    if (upfrontFeeTotal >= principal) return LoanInputError.fee;
    return null;
  }

  double get upfrontFeeTotal => Money.sum([principal * upfrontFeePercent / 100, upfrontFeeFixed]);

  LoanInput copyWith({
    double? principal,
    double? annualRatePercent,
    int? months,
    RepaymentType? type,
    double? upfrontFeePercent,
    double? upfrontFeeFixed,
    double? monthlyFee,
  }) => LoanInput(
    principal: principal ?? this.principal,
    annualRatePercent: annualRatePercent ?? this.annualRatePercent,
    months: months ?? this.months,
    type: type ?? this.type,
    upfrontFeePercent: upfrontFeePercent ?? this.upfrontFeePercent,
    upfrontFeeFixed: upfrontFeeFixed ?? this.upfrontFeeFixed,
    monthlyFee: monthlyFee ?? this.monthlyFee,
    firstPaymentDate: firstPaymentDate,
  );
}

enum LoanInputError { principal, rate, term, fee }

class LoanRow {
  const LoanRow({
    required this.index,
    required this.date,
    required this.interest,
    required this.principal,
    required this.fee,
    required this.balance,
  });

  /// 1-based installment number.
  final int index;
  final DateTime? date;
  final double interest;
  final double principal;
  final double fee;

  /// Outstanding principal after this installment.
  final double balance;

  /// Installment excluding fees (principal + interest).
  double get installment => Money.sum([interest, principal]);

  /// Everything paid this month, fees included.
  double get outflow => Money.sum([interest, principal, fee]);
}

class LoanResult {
  const LoanResult({
    required this.input,
    required this.rows,
    required this.eirAnnual,
  });

  final LoanInput input;
  final List<LoanRow> rows;

  /// Effective annual interest rate (EKS / EIR) including fees, as a
  /// fraction, or null when it cannot be determined.
  final double? eirAnnual;

  double get firstInstallment => rows.isEmpty ? 0 : rows.first.installment;
  double get lastInstallment => rows.isEmpty ? 0 : rows.last.installment;
  double get totalInterest => Money.sum(rows.map((r) => r.interest));
  double get totalMonthlyFees => Money.sum(rows.map((r) => r.fee));
  double get totalFees => Money.sum([input.upfrontFeeTotal, totalMonthlyFees]);

  /// Principal + interest + all fees.
  double get totalCost => Money.sum([input.principal, totalInterest, totalFees]);
  int get months => rows.length;

  /// Interest and principal paid per loan year (index 0 = first 12 months).
  List<({double interest, double principal})> get byYear {
    final out = <({double interest, double principal})>[];
    for (var start = 0; start < rows.length; start += 12) {
      final chunk = rows.sublist(start, math.min(start + 12, rows.length));
      out.add((
        interest: Money.sum(chunk.map((r) => r.interest)),
        principal: Money.sum(chunk.map((r) => r.principal)),
      ));
    }
    return out;
  }
}

class PrepaymentResult {
  const PrepaymentResult({
    required this.original,
    required this.after,
    required this.afterMonth,
    required this.amount,
    required this.fee,
    required this.paidOff,
  });

  final LoanResult original;

  /// The full schedule with the prepayment applied after [afterMonth].
  final LoanResult after;
  final int afterMonth;

  /// Principal actually repaid early (capped at the outstanding balance).
  final double amount;
  final double fee;

  /// Whether the prepayment cleared the whole balance.
  final bool paidOff;

  double get interestSaved => Money.sub(original.totalInterest, after.totalInterest);
  double get netSaving => Money.sub(interestSaved, fee);
  int get monthsSaved => original.months - after.months;
  double get newInstallment => after.rows.length > afterMonth ? after.rows[afterMonth].installment : 0;
}

/// Amortizing-loan math with bank-style rounding: the annuity is rounded to
/// cents, every month's interest is rounded to cents, and the final
/// installment absorbs the remainder so the balance ends at exactly zero.
class LoanEngine {
  const LoanEngine();

  static double annuityPayment(double principal, double monthlyRate, int months) {
    if (months <= 0) return 0;
    if (monthlyRate == 0) return principal / months;
    final f = math.pow(1 + monthlyRate, months).toDouble();
    return principal * monthlyRate * f / (f - 1);
  }

  LoanResult compute(LoanInput input) {
    final error = input.validate();
    if (error != null) throw ArgumentError('invalid loan input: $error');
    final rows = _schedule(
      principal: input.principal,
      monthlyRate: input.annualRatePercent / 100 / 12,
      months: input.months,
      type: input.type,
      monthlyFee: input.monthlyFee,
      firstPaymentDate: input.firstPaymentDate,
    );
    return LoanResult(input: input, rows: rows, eirAnnual: _eir(input, rows));
  }

  /// Applies a one-off extra principal payment made together with
  /// installment [afterMonth].
  PrepaymentResult prepay(
    LoanInput input, {
    required int afterMonth,
    required double amount,
    PrepaymentMode mode = PrepaymentMode.shortenTerm,
    double feePercent = 0,
  }) {
    final original = compute(input);
    final k = afterMonth.clamp(1, input.months - 1);
    final monthlyRate = input.annualRatePercent / 100 / 12;
    final head = original.rows.sublist(0, k);
    final balance = head.last.balance;
    final extra = Money.round(math.min(math.max(0, amount), balance));
    final remaining = Money.sub(balance, extra);
    final fee = Money.round(extra * math.max(0, feePercent) / 100);

    final headWithExtra = [
      ...head.sublist(0, k - 1),
      LoanRow(
        index: head.last.index,
        date: head.last.date,
        interest: head.last.interest,
        principal: Money.sum([head.last.principal, extra]),
        fee: Money.sum([head.last.fee, fee]),
        balance: remaining,
      ),
    ];

    var tail = <LoanRow>[];
    if (remaining > 0) {
      final remainingMonths = input.months - k;
      final DateTime? nextDate = head.last.date == null ? null : _addMonths(head.last.date!, 1);
      if (mode == PrepaymentMode.lowerPayment) {
        tail = _schedule(
          principal: remaining,
          monthlyRate: monthlyRate,
          months: remainingMonths,
          type: input.type,
          monthlyFee: input.monthlyFee,
          firstPaymentDate: nextDate,
          startIndex: k + 1,
        );
      } else {
        final fixedPrincipal = input.type == RepaymentType.linear ? original.rows.first.principal : null;
        tail = _scheduleKeepingPayment(
          principal: remaining,
          monthlyRate: monthlyRate,
          payment: original.firstInstallment,
          fixedPrincipal: fixedPrincipal,
          monthlyFee: input.monthlyFee,
          firstPaymentDate: nextDate,
          startIndex: k + 1,
          maxMonths: remainingMonths,
        );
      }
    }
    final rows = [...headWithExtra, ...tail];
    final after = LoanResult(input: input, rows: rows, eirAnnual: _eir(input, rows));
    return PrepaymentResult(
      original: original,
      after: after,
      afterMonth: k,
      amount: extra,
      fee: fee,
      paidOff: remaining <= 0,
    );
  }

  // ----------------------------------------------------------- internals

  static DateTime _addMonths(DateTime d, int months) {
    final y = d.year + (d.month - 1 + months) ~/ 12;
    final m = (d.month - 1 + months) % 12 + 1;
    final lastDay = DateTime(y, m + 1, 0).day;
    return DateTime(y, m, math.min(d.day, lastDay));
  }

  List<LoanRow> _schedule({
    required double principal,
    required double monthlyRate,
    required int months,
    required RepaymentType type,
    required double monthlyFee,
    required DateTime? firstPaymentDate,
    int startIndex = 1,
  }) {
    final rows = <LoanRow>[];
    var balance = Money.round(principal);
    final fee = Money.round(monthlyFee);
    final annuity = Money.round(annuityPayment(principal, monthlyRate, months));
    final linearPrincipal = Money.round(principal / months);
    for (var i = 0; i < months; i++) {
      final interest = Money.round(balance * monthlyRate);
      double principalPart;
      if (i == months - 1) {
        principalPart = balance;
      } else if (type == RepaymentType.annuity) {
        principalPart = Money.sub(annuity, interest);
      } else {
        principalPart = linearPrincipal;
      }
      principalPart = Money.clamp(principalPart, 0, balance);
      balance = Money.sub(balance, principalPart);
      rows.add(
        LoanRow(
          index: startIndex + i,
          date: firstPaymentDate == null ? null : _addMonths(firstPaymentDate, i),
          interest: interest,
          principal: principalPart,
          fee: fee,
          balance: balance,
        ),
      );
      if (balance <= 0) break;
    }
    return rows;
  }

  List<LoanRow> _scheduleKeepingPayment({
    required double principal,
    required double monthlyRate,
    required double payment,
    required double? fixedPrincipal,
    required double monthlyFee,
    required DateTime? firstPaymentDate,
    required int startIndex,
    required int maxMonths,
  }) {
    final rows = <LoanRow>[];
    var balance = Money.round(principal);
    final fee = Money.round(monthlyFee);
    for (var i = 0; i < maxMonths && balance > 0; i++) {
      final interest = Money.round(balance * monthlyRate);
      var principalPart = fixedPrincipal ?? Money.sub(payment, interest);
      if (principalPart <= 0 || i == maxMonths - 1) principalPart = balance;
      principalPart = Money.clamp(principalPart, 0, balance);
      balance = Money.sub(balance, principalPart);
      rows.add(
        LoanRow(
          index: startIndex + i,
          date: firstPaymentDate == null ? null : _addMonths(firstPaymentDate, i),
          interest: interest,
          principal: principalPart,
          fee: fee,
          balance: balance,
        ),
      );
    }
    return rows;
  }

  /// EIR per the EU consumer-credit formula with monthly periods:
  /// the rate equating net funds received with all payments made.
  static double? _eir(LoanInput input, List<LoanRow> rows) {
    final flows = <double>[
      Money.sub(input.principal, input.upfrontFeeTotal),
      for (final r in rows) -r.outflow,
    ];
    final monthly = CashFlow.irr(flows);
    if (monthly == null) return null;
    final annual = CashFlow.annualize(monthly);
    return annual.isFinite ? annual : null;
  }
}

import 'dart:math' as math;

import '../../../core/money/money.dart';

/// How interest is credited on a term deposit.
enum Compounding {
  /// Simple interest paid once at maturity.
  atMaturity,

  /// Interest capitalised every month.
  monthly,

  /// Interest capitalised every 12 months (simple interest for a partial year).
  annually,
}

class DepositInput {
  const DepositInput({
    required this.principal,
    required this.annualRatePercent,
    required this.months,
    this.compounding = Compounding.atMaturity,
    this.taxPercent = 0,
    this.monthlyContribution = 0,
  });

  final double principal;
  final double annualRatePercent;
  final int months;
  final Compounding compounding;

  /// Withholding tax on interest, in percent.
  final double taxPercent;

  /// Optional amount added at the end of every month.
  final double monthlyContribution;

  static const maxMonths = 600;

  DepositInputError? validate() {
    if (!principal.isFinite || principal < 0 || principal > 1e11) return DepositInputError.principal;
    if (!monthlyContribution.isFinite || monthlyContribution < 0 || monthlyContribution > 1e10) {
      return DepositInputError.contribution;
    }
    if (principal <= 0 && monthlyContribution <= 0) return DepositInputError.principal;
    if (!annualRatePercent.isFinite || annualRatePercent < 0 || annualRatePercent > 100) {
      return DepositInputError.rate;
    }
    if (months < 1 || months > maxMonths) return DepositInputError.term;
    if (!taxPercent.isFinite || taxPercent < 0 || taxPercent > 100) return DepositInputError.tax;
    return null;
  }
}

enum DepositInputError { principal, contribution, rate, term, tax }

class DepositYear {
  const DepositYear({
    required this.year,
    required this.contributed,
    required this.grossInterest,
    required this.tax,
    required this.balance,
  });

  final int year;
  final double contributed;
  final double grossInterest;
  final double tax;
  final double balance;
}

class DepositResult {
  const DepositResult({
    required this.input,
    required this.totalContributed,
    required this.grossInterest,
    required this.tax,
    required this.finalBalance,
    required this.years,
  });

  final DepositInput input;
  final double totalContributed;
  final double grossInterest;
  final double tax;
  final double finalBalance;
  final List<DepositYear> years;

  double get netInterest => Money.sub(grossInterest, tax);

  /// Net return per year on the opening principal (lump-sum deposits only).
  double? get effectiveAnnualYield {
    if (input.monthlyContribution > 0 || input.principal <= 0) return null;
    final growth = finalBalance / input.principal;
    if (growth <= 0) return null;
    return math.pow(growth, 12 / input.months).toDouble() - 1;
  }
}

/// Term-deposit and savings-plan math. Tax is withheld whenever interest is
/// credited, as banks do, so it reduces the compounding base.
class DepositEngine {
  const DepositEngine();

  DepositResult compute(DepositInput input) {
    final error = input.validate();
    if (error != null) throw ArgumentError('invalid deposit input: $error');
    final r = input.annualRatePercent / 100;
    final t = input.taxPercent / 100;
    final c = Money.round(input.monthlyContribution);
    var balance = Money.round(input.principal);
    var contributed = balance;
    var gross = 0.0;
    var tax = 0.0;
    var pendingInterest = 0.0; // accrued but not yet credited (annual / at maturity)
    final years = <DepositYear>[];
    var yearGross = 0.0;
    var yearTax = 0.0;
    var yearContrib = balance;

    void credit(double interest) {
      final rounded = Money.round(interest);
      final withheld = Money.round(rounded * t);
      gross = Money.sum([gross, rounded]);
      tax = Money.sum([tax, withheld]);
      yearGross = Money.sum([yearGross, rounded]);
      yearTax = Money.sum([yearTax, withheld]);
      balance = Money.sum([balance, rounded, -withheld]);
    }

    for (var m = 1; m <= input.months; m++) {
      switch (input.compounding) {
        case Compounding.monthly:
          credit(balance * r / 12);
        case Compounding.annually:
          pendingInterest += balance * r / 12;
          if (m % 12 == 0 || m == input.months) {
            credit(pendingInterest);
            pendingInterest = 0;
          }
        case Compounding.atMaturity:
          pendingInterest += balance * r / 12;
          if (m == input.months) {
            credit(pendingInterest);
            pendingInterest = 0;
          }
      }
      if (c > 0 && m < input.months) {
        balance = Money.sum([balance, c]);
        contributed = Money.sum([contributed, c]);
        yearContrib = Money.sum([yearContrib, c]);
      }
      if (m % 12 == 0 || m == input.months) {
        years.add(DepositYear(
          year: (m + 11) ~/ 12,
          contributed: yearContrib,
          grossInterest: yearGross,
          tax: yearTax,
          balance: Money.round(balance + pendingInterest * (1 - t)),
        ));
        yearGross = 0;
        yearTax = 0;
        yearContrib = 0;
      }
    }
    return DepositResult(
      input: input,
      totalContributed: contributed,
      grossInterest: gross,
      tax: tax,
      finalBalance: balance,
      years: years,
    );
  }
}

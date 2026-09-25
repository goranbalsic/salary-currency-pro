import 'deposit_engine.dart';
import 'loan_engine.dart';

double? _pos(Object? v) => v is num && v.isFinite && v >= 0 ? v.toDouble() : null;

/// Loan calculator inputs as typed (nullable while a field is empty).
class LoanInputs {
  const LoanInputs({
    this.principal,
    required this.currency,
    this.rate,
    this.months = 60,
    this.type = RepaymentType.annuity,
    this.feePercent,
    this.monthlyFee,
  });

  final double? principal;
  final String currency;
  final double? rate;
  final int months;
  final RepaymentType type;
  final double? feePercent;
  final double? monthlyFee;

  static LoanInputs defaults(String currency) => LoanInputs(currency: currency, principal: null, rate: null, months: 60);

  LoanInputs copyWith({
    double? principal,
    bool clearPrincipal = false,
    String? currency,
    double? rate,
    bool clearRate = false,
    int? months,
    RepaymentType? type,
    double? feePercent,
    bool clearFee = false,
    double? monthlyFee,
    bool clearMonthlyFee = false,
  }) => LoanInputs(
    principal: clearPrincipal ? null : (principal ?? this.principal),
    currency: currency ?? this.currency,
    rate: clearRate ? null : (rate ?? this.rate),
    months: months ?? this.months,
    type: type ?? this.type,
    feePercent: clearFee ? null : (feePercent ?? this.feePercent),
    monthlyFee: clearMonthlyFee ? null : (monthlyFee ?? this.monthlyFee),
  );

  LoanInput? toInput() {
    final p = principal;
    final r = rate;
    if (p == null || r == null) return null;
    return LoanInput(
      principal: p,
      annualRatePercent: r,
      months: months,
      type: type,
      upfrontFeePercent: feePercent ?? 0,
      monthlyFee: monthlyFee ?? 0,
    );
  }

  Map<String, Object?> toJson() => {
    'principal': principal,
    'currency': currency,
    'rate': rate,
    'months': months,
    'type': type.name,
    'fee': feePercent,
    'monthlyFee': monthlyFee,
  };

  static LoanInputs? fromJson(Object? raw, {required String fallbackCurrency}) {
    if (raw is! Map) return null;
    final months = raw['months'];
    return LoanInputs(
      principal: _pos(raw['principal']),
      currency: raw['currency'] is String ? raw['currency'] as String : fallbackCurrency,
      rate: _pos(raw['rate']),
      months: months is int && months >= 1 && months <= LoanInput.maxMonths ? months : 60,
      type: RepaymentType.values.where((t) => t.name == raw['type']).firstOrNull ?? RepaymentType.annuity,
      feePercent: _pos(raw['fee']),
      monthlyFee: _pos(raw['monthlyFee']),
    );
  }
}

class DepositInputs {
  const DepositInputs({
    this.principal,
    required this.currency,
    this.rate,
    this.months = 12,
    this.compounding = Compounding.atMaturity,
    this.taxPercent,
    this.contribution,
  });

  final double? principal;
  final String currency;
  final double? rate;
  final int months;
  final Compounding compounding;
  final double? taxPercent;
  final double? contribution;

  DepositInputs copyWith({
    double? principal,
    bool clearPrincipal = false,
    String? currency,
    double? rate,
    bool clearRate = false,
    int? months,
    Compounding? compounding,
    double? taxPercent,
    bool clearTax = false,
    double? contribution,
    bool clearContribution = false,
  }) => DepositInputs(
    principal: clearPrincipal ? null : (principal ?? this.principal),
    currency: currency ?? this.currency,
    rate: clearRate ? null : (rate ?? this.rate),
    months: months ?? this.months,
    compounding: compounding ?? this.compounding,
    taxPercent: clearTax ? null : (taxPercent ?? this.taxPercent),
    contribution: clearContribution ? null : (contribution ?? this.contribution),
  );

  DepositInput? toInput() {
    final r = rate;
    if (r == null) return null;
    return DepositInput(
      principal: principal ?? 0,
      annualRatePercent: r,
      months: months,
      compounding: compounding,
      taxPercent: taxPercent ?? 0,
      monthlyContribution: contribution ?? 0,
    );
  }

  Map<String, Object?> toJson() => {
    'principal': principal,
    'currency': currency,
    'rate': rate,
    'months': months,
    'compounding': compounding.name,
    'tax': taxPercent,
    'contribution': contribution,
  };

  static DepositInputs? fromJson(Object? raw, {required String fallbackCurrency}) {
    if (raw is! Map) return null;
    final months = raw['months'];
    return DepositInputs(
      principal: _pos(raw['principal']),
      currency: raw['currency'] is String ? raw['currency'] as String : fallbackCurrency,
      rate: _pos(raw['rate']),
      months: months is int && months >= 1 && months <= DepositInput.maxMonths ? months : 12,
      compounding: Compounding.values.where((c) => c.name == raw['compounding']).firstOrNull ?? Compounding.atMaturity,
      taxPercent: _pos(raw['tax']),
      contribution: _pos(raw['contribution']),
    );
  }
}

/// One loan offer in the comparison (principal is shared).
class LoanOffer {
  const LoanOffer({this.rate, this.months = 60, this.feePercent, this.monthlyFee});

  final double? rate;
  final int months;
  final double? feePercent;
  final double? monthlyFee;

  LoanOffer copyWith({
    double? rate,
    bool clearRate = false,
    int? months,
    double? feePercent,
    bool clearFee = false,
    double? monthlyFee,
    bool clearMonthlyFee = false,
  }) => LoanOffer(
    rate: clearRate ? null : (rate ?? this.rate),
    months: months ?? this.months,
    feePercent: clearFee ? null : (feePercent ?? this.feePercent),
    monthlyFee: clearMonthlyFee ? null : (monthlyFee ?? this.monthlyFee),
  );

  Map<String, Object?> toJson() => {'rate': rate, 'months': months, 'fee': feePercent, 'monthlyFee': monthlyFee};

  static LoanOffer fromJson(Object? raw) {
    if (raw is! Map) return const LoanOffer();
    final m = raw['months'];
    return LoanOffer(
      rate: _pos(raw['rate']),
      months: m is int && m >= 1 && m <= LoanInput.maxMonths ? m : 60,
      feePercent: _pos(raw['fee']),
      monthlyFee: _pos(raw['monthlyFee']),
    );
  }
}

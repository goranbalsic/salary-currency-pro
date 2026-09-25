import 'payroll_models.dart';

/// Everything needed to reproduce a payroll calculation.
class PayrollInputs {
  const PayrollInputs({required this.system, this.mode = PayrollInputMode.gross, this.amount, this.options = const PayrollOptions()});

  final PayrollSystem system;
  final PayrollInputMode mode;
  final double? amount;
  final PayrollOptions options;

  PayrollInputs copyWith({PayrollSystem? system, PayrollInputMode? mode, double? amount, bool clearAmount = false, PayrollOptions? options}) =>
      PayrollInputs(
        system: system ?? this.system,
        mode: mode ?? this.mode,
        amount: clearAmount ? null : (amount ?? this.amount),
        options: options ?? this.options,
      );

  Map<String, Object?> toJson() => {
        'system': system.name,
        'mode': mode.name,
        'amount': amount,
        'options': options.toJson(),
      };

  static PayrollInputs? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final system = PayrollSystem.byName(raw['system'] as String?);
    if (system == null) return null;
    final amount = raw['amount'];
    return PayrollInputs(
      system: system,
      mode: PayrollInputMode.values.where((m) => m.name == raw['mode']).firstOrNull ?? PayrollInputMode.gross,
      amount: amount is num && amount.isFinite && amount > 0 ? amount.toDouble() : null,
      options: raw['options'] is Map ? PayrollOptions.fromJson((raw['options'] as Map).cast<String, Object?>()) : const PayrollOptions(),
    );
  }
}

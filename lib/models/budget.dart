/// A user-set monthly spending limit for one expense category. Compared
/// against [ExpenseService.categoryTotalsForMonth] to show progress — never
/// enforced automatically (no spending is blocked), purely informational.
class CategoryBudget {
  static const currentSchemaVersion = 1;

  final String categoryId;
  final int schemaVersion;
  final double monthlyLimit;
  final String currencyCode;

  const CategoryBudget({
    required this.categoryId,
    this.schemaVersion = currentSchemaVersion,
    required this.monthlyLimit,
    required this.currencyCode,
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'schemaVersion': schemaVersion,
        'monthlyLimit': monthlyLimit,
        'currencyCode': currencyCode,
      };

  factory CategoryBudget.fromJson(Map<String, dynamic> json) => CategoryBudget(
        categoryId: json['categoryId'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
        currencyCode: json['currencyCode'] as String,
      );
}

/// A savings goal with manually-logged progress. There is no bank
/// integration in this app, so [currentAmount] only ever changes when the
/// user explicitly adds to it — never inferred or estimated, so the number
/// shown is always exactly what the user recorded, never a guess.
class SavingsGoal {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currencyCode;
  final DateTime? targetDate;
  final DateTime createdAt;

  const SavingsGoal({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.currencyCode,
    this.targetDate,
    required this.createdAt,
  });

  double get progressFraction =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);

  bool get isComplete => currentAmount >= targetAmount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'name': name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'currencyCode': currencyCode,
        'targetDate': targetDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        name: json['name'] as String,
        targetAmount: (json['targetAmount'] as num).toDouble(),
        currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0,
        currencyCode: json['currencyCode'] as String,
        targetDate: json['targetDate'] == null
            ? null
            : DateTime.parse(json['targetDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

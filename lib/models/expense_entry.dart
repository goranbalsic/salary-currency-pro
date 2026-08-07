/// A transaction's direction: money in or money out.
enum TransactionType { income, expense }

/// Stable category ids, kept separate from their localized labels (see
/// `l10n/l10n_lookups.dart`'s `localizedCategoryLabel`) so the stored data
/// never depends on the app's current language.
class ExpenseCategories {
  ExpenseCategories._();

  static const housing = 'housing';
  static const utilities = 'utilities';
  static const groceries = 'groceries';
  static const transport = 'transport';
  static const health = 'health';
  static const education = 'education';
  static const entertainment = 'entertainment';
  static const otherExpense = 'other_expense';

  static const salary = 'salary';
  static const freelance = 'freelance';
  static const otherIncome = 'other_income';

  static const expenseIds = [
    housing,
    utilities,
    groceries,
    transport,
    health,
    education,
    entertainment,
    otherExpense,
  ];

  static const incomeIds = [salary, freelance, otherIncome];

  /// Falls back to the first id in the relevant list if [categoryId] isn't
  /// recognized — keeps forms usable even if stored data predates a
  /// category being renamed/removed.
  static String defaultFor(TransactionType type) =>
      type == TransactionType.income ? salary : otherExpense;
}

/// One local, on-device-only income or expense record. Distinct from
/// [HistoryEntry] (auto-logged calculator activity) and [Scenario] (a saved,
/// reopenable tool input) — this is ongoing ledger data the user enters
/// directly, the basis for the monthly income/expense/balance overview.
class ExpenseEntry {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final TransactionType type;
  final String categoryId;
  final double amount;
  final String currencyCode;
  final DateTime date;
  final String note;

  const ExpenseEntry({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.currencyCode,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'type': type.name,
        'categoryId': categoryId,
        'amount': amount,
        'currencyCode': currencyCode,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) => ExpenseEntry(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        type: TransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => TransactionType.expense,
        ),
        categoryId: json['categoryId'] as String,
        amount: (json['amount'] as num).toDouble(),
        currencyCode: json['currencyCode'] as String,
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String? ?? '',
      );
}

/// A single currency's totals for a period. The tracker deliberately does
/// not convert between currencies (that would require a live rate and turn
/// a simple offline ledger into something that can silently misrepresent
/// money) — mixed-currency months show one summary per currency instead.
class MonthlySummary {
  final String currencyCode;
  final double totalIncome;
  final double totalExpense;

  const MonthlySummary({
    required this.currencyCode,
    required this.totalIncome,
    required this.totalExpense,
  });

  double get balance => totalIncome - totalExpense;
}

import 'expense_entry.dart';

enum RecurrenceFrequency { weekly, monthly }

/// A user-defined template for a transaction that repeats — PROMPT-003
/// Stage B item 5 ("define-once, auto-post, review-before-post option").
/// [autoPost] controls what happens when an occurrence comes due:
/// `true` creates the [ExpenseEntry] immediately via
/// [RecurringTransactionService.checkDue]; `false` queues a
/// [RecurringReviewItem] instead, and the user must explicitly confirm or
/// skip it.
///
/// [lastResolvedDate] is the occurrence date this template has been
/// resolved through — whether that occurrence was auto-posted or, for a
/// review-required template, explicitly confirmed or skipped by the user.
/// `null` means no occurrence has ever been resolved (not even the first).
/// Only the single most recent missed occurrence is ever surfaced if the
/// app wasn't opened for a while — this deliberately does not backfill
/// every missed month, matching the "no polling, no surprise flood of
/// entries" spirit of this app's other offline-first features.
class RecurringTransaction {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final TransactionType type;
  final String categoryId;
  final double amount;
  final String currencyCode;
  final String note;
  final RecurrenceFrequency frequency;
  final DateTime startDate;
  final bool autoPost;
  final bool active;
  final DateTime createdAt;
  final DateTime? lastResolvedDate;

  const RecurringTransaction({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.currencyCode,
    this.note = '',
    required this.frequency,
    required this.startDate,
    required this.autoPost,
    this.active = true,
    required this.createdAt,
    this.lastResolvedDate,
  });

  static DateTime _advance(DateTime date, RecurrenceFrequency freq) {
    if (freq == RecurrenceFrequency.weekly) {
      return date.add(const Duration(days: 7));
    }
    final targetMonth = date.month == 12 ? 1 : date.month + 1;
    final targetYear = date.month == 12 ? date.year + 1 : date.year;
    final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final day = date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;
    return DateTime(targetYear, targetMonth, day);
  }

  /// The most recent occurrence date that is due as of [asOf] and has not
  /// yet been resolved — `null` if inactive or nothing is due yet. If
  /// several occurrences were missed (app unused for a while), only the
  /// latest one is returned; earlier missed ones are silently skipped, not
  /// backfilled.
  DateTime? dueOccurrenceAsOf(DateTime asOf) {
    if (!active) return null;
    var candidate = lastResolvedDate == null ? startDate : _advance(lastResolvedDate!, frequency);
    if (candidate.isAfter(asOf)) return null;
    while (true) {
      final next = _advance(candidate, frequency);
      if (next.isAfter(asOf)) break;
      candidate = next;
    }
    return candidate;
  }

  RecurringTransaction copyWith({
    TransactionType? type,
    String? categoryId,
    double? amount,
    String? currencyCode,
    String? note,
    RecurrenceFrequency? frequency,
    DateTime? startDate,
    bool? autoPost,
    bool? active,
    DateTime? lastResolvedDate,
  }) =>
      RecurringTransaction(
        id: id,
        schemaVersion: schemaVersion,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        note: note ?? this.note,
        frequency: frequency ?? this.frequency,
        startDate: startDate ?? this.startDate,
        autoPost: autoPost ?? this.autoPost,
        active: active ?? this.active,
        createdAt: createdAt,
        lastResolvedDate: lastResolvedDate ?? this.lastResolvedDate,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'type': type.name,
        'categoryId': categoryId,
        'amount': amount,
        'currencyCode': currencyCode,
        'note': note,
        'frequency': frequency.name,
        'startDate': startDate.toIso8601String(),
        'autoPost': autoPost,
        'active': active,
        'createdAt': createdAt.toIso8601String(),
        'lastResolvedDate': lastResolvedDate?.toIso8601String(),
      };

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) => RecurringTransaction(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        type: TransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => TransactionType.expense,
        ),
        categoryId: json['categoryId'] as String,
        amount: (json['amount'] as num).toDouble(),
        currencyCode: json['currencyCode'] as String,
        note: json['note'] as String? ?? '',
        frequency: RecurrenceFrequency.values.firstWhere(
          (f) => f.name == json['frequency'],
          orElse: () => RecurrenceFrequency.monthly,
        ),
        startDate: DateTime.parse(json['startDate'] as String),
        autoPost: json['autoPost'] as bool? ?? false,
        active: json['active'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastResolvedDate: json['lastResolvedDate'] == null
            ? null
            : DateTime.parse(json['lastResolvedDate'] as String),
      );
}

/// One due occurrence of a review-required (`autoPost: false`)
/// [RecurringTransaction], queued for the user to confirm or skip. A
/// frozen snapshot of the template's fields at the time it came due, so
/// editing the template later doesn't retroactively change a
/// still-pending review item.
class RecurringReviewItem {
  final String id;
  final String recurringId;
  final DateTime occurrenceDate;
  final TransactionType type;
  final String categoryId;
  final double amount;
  final String currencyCode;
  final String note;

  const RecurringReviewItem({
    required this.id,
    required this.recurringId,
    required this.occurrenceDate,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.currencyCode,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'recurringId': recurringId,
        'occurrenceDate': occurrenceDate.toIso8601String(),
        'type': type.name,
        'categoryId': categoryId,
        'amount': amount,
        'currencyCode': currencyCode,
        'note': note,
      };

  factory RecurringReviewItem.fromJson(Map<String, dynamic> json) => RecurringReviewItem(
        id: json['id'] as String,
        recurringId: json['recurringId'] as String,
        occurrenceDate: DateTime.parse(json['occurrenceDate'] as String),
        type: TransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => TransactionType.expense,
        ),
        categoryId: json['categoryId'] as String,
        amount: (json['amount'] as num).toDouble(),
        currencyCode: json['currencyCode'] as String,
        note: json['note'] as String? ?? '',
      );
}

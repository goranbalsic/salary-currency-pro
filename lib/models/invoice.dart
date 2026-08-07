/// A minimal offline invoice record for freelancers/small businesses:
/// client, amount, issue/due dates, and whether it's been paid. Deliberately
/// two real states (paid/unpaid) rather than a draft/sent/paid/overdue
/// enum — "overdue" is derived live from [isPaid]/[dueDate] rather than
/// stored, so it can never go stale relative to today's date, and "draft/
/// sent" tracking wasn't judged to add real value for a single-user offline
/// tool (see the app's product-judgment notes on avoiding unnecessary
/// complexity).
class Invoice {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final String clientName;
  final String description;
  final double amount;
  final String currencyCode;
  final DateTime issueDate;
  final DateTime dueDate;
  final bool isPaid;
  final DateTime? paidDate;

  const Invoice({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.clientName,
    this.description = '',
    required this.amount,
    required this.currencyCode,
    required this.issueDate,
    required this.dueDate,
    this.isPaid = false,
    this.paidDate,
  });

  bool isOverdueAsOf(DateTime now) => !isPaid && dueDate.isBefore(now);

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'clientName': clientName,
        'description': description,
        'amount': amount,
        'currencyCode': currencyCode,
        'issueDate': issueDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'isPaid': isPaid,
        'paidDate': paidDate?.toIso8601String(),
      };

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        clientName: json['clientName'] as String,
        description: json['description'] as String? ?? '',
        amount: (json['amount'] as num).toDouble(),
        currencyCode: json['currencyCode'] as String,
        issueDate: DateTime.parse(json['issueDate'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        isPaid: json['isPaid'] as bool? ?? false,
        paidDate: json['paidDate'] == null ? null : DateTime.parse(json['paidDate'] as String),
      );
}

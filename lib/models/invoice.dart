import '../utils/money.dart';
import 'invoice_line_item.dart';

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

  /// Editable invoice identity shown on the PDF. No auto-numbering
  /// scheme is imposed — an empty string just means "not set yet."
  final String invoiceNumber;

  /// Optional itemized lines for the PDF. When empty, the PDF falls back
  /// to rendering [description]/[amount] as a single implied line — the
  /// existing simple-invoice flow is unaffected. When non-empty, callers
  /// must keep [amount] equal to [totalFromItems] of this list (see that
  /// static helper) so every other screen that reads [amount] directly
  /// (e.g. outstanding/overdue totals) stays correct.
  final List<InvoiceLineItem> items;

  /// Optional free text for the NBS IPS QR "S" (purpose) tag; also shown
  /// as a plain PDF note for non-eligible invoices.
  final String? purpose;

  /// Optional NBS IPS QR "RO" (model + reference number) tag content.
  final String? paymentReference;

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
    this.invoiceNumber = '',
    this.items = const [],
    this.purpose,
    this.paymentReference,
  });

  bool isOverdueAsOf(DateTime now) => !isPaid && dueDate.isBefore(now);

  /// The deterministic, rounded-once total of [items] — each line is
  /// rounded to the nearest cent, then cents are summed as integers, so
  /// no floating-point artifact can appear in the stored `amount`. See
  /// lib/utils/money.dart.
  static double totalFromItems(List<InvoiceLineItem> items) => minorUnitsToAmount(
        sumMinorUnits(items.map((i) => i.subtotalMinorUnits)),
      );

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
        'invoiceNumber': invoiceNumber,
        'items': items.map((i) => i.toJson()).toList(),
        'purpose': purpose,
        'paymentReference': paymentReference,
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
        invoiceNumber: json['invoiceNumber'] as String? ?? '',
        items: (json['items'] as List?)
                ?.map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        purpose: json['purpose'] as String?,
        paymentReference: json['paymentReference'] as String?,
      );
}

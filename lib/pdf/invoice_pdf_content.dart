import 'package:intl/intl.dart';

import '../models/business_profile.dart';
import '../models/invoice.dart';
import '../utils/money.dart';

/// The exact, pre-formatted content that goes into a generated invoice
/// PDF — deliberately kept separate from the `pw.Widget` layout tree (see
/// `lib/services/invoice_pdf_service.dart`) so every piece of content
/// (totals, itemization, pagination-worthy line counts, currency/date
/// formatting, QR eligibility) can be unit-tested without depending on
/// the `pdf` package at all. See `OPEN_QUESTIONS.md` QUESTION-009 for why
/// PDF tests assert against this model rather than the rendered document.
class InvoicePdfLineContent {
  final String description;
  final String quantity;
  final String unitPrice;
  final String subtotal;

  const InvoicePdfLineContent({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}

class InvoicePdfContent {
  final String issuerName;
  final List<String> issuerAddressLines;
  final String recipientName;
  final String invoiceNumber;
  final String issueDate;
  final String dueDate;
  final String statusLabel;
  final List<InvoicePdfLineContent> lines;
  final InvoicePdfTableLabels tableLabels;
  final String currencyCode;

  /// The deterministic, rounded-once total — see [Invoice.totalFromItems]
  /// and [roundToMinorUnits]. Always equal to the sum of [lines]'
  /// subtotals.
  final String totalFormatted;

  /// Non-null only for an eligible, successfully-validated Serbian RSD
  /// invoice (wired in checkpoint 4/12.3) — the raw NBS IPS payload
  /// string to encode as a QR code.
  final String? qrPayload;

  const InvoicePdfContent({
    required this.issuerName,
    required this.issuerAddressLines,
    required this.recipientName,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.statusLabel,
    required this.lines,
    required this.tableLabels,
    required this.currencyCode,
    required this.totalFormatted,
    this.qrPayload,
  });
}

/// Localized status labels, resolved by the caller (from [AppLocalizations])
/// before calling [buildInvoicePdfContent] — keeps this file free of any
/// BuildContext/l10n dependency so it stays trivially unit-testable.
class InvoicePdfStatusLabels {
  final String paid;
  final String unpaid;
  final String overdue;

  const InvoicePdfStatusLabels({
    required this.paid,
    required this.unpaid,
    required this.overdue,
  });
}

/// Localized column headers for the itemized-lines table — the PDF itself
/// must render in the invoice's language (12.2), not just its content.
class InvoicePdfTableLabels {
  final String description;
  final String quantity;
  final String unitPrice;
  final String subtotal;

  const InvoicePdfTableLabels({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}

InvoicePdfContent buildInvoicePdfContent({
  required Invoice invoice,
  required BusinessProfile profile,
  required String localeCode,
  required InvoicePdfStatusLabels statusLabels,
  required InvoicePdfTableLabels tableLabels,
  String? qrPayload,
  DateTime? now,
}) {
  final dateFmt = DateFormat.yMMMd(localeCode);
  final overdue = invoice.isOverdueAsOf(now ?? DateTime.now());
  final statusLabel = invoice.isPaid
      ? statusLabels.paid
      : (overdue ? statusLabels.overdue : statusLabels.unpaid);

  final lines = invoice.items.isNotEmpty
      ? [
          for (final item in invoice.items)
            InvoicePdfLineContent(
              description: item.description,
              quantity: _plainNumber(item.quantity),
              unitPrice: formatMinorUnits(roundToMinorUnits(item.unitPrice)),
              subtotal: formatMinorUnits(item.subtotalMinorUnits),
            ),
        ]
      : [
          InvoicePdfLineContent(
            description: invoice.description,
            quantity: '1',
            unitPrice: formatMinorUnits(roundToMinorUnits(invoice.amount)),
            subtotal: formatMinorUnits(roundToMinorUnits(invoice.amount)),
          ),
        ];

  final issuerAddress = [
    if (profile.addressLine1.isNotEmpty) profile.addressLine1,
    if (profile.addressLine2.isNotEmpty) profile.addressLine2,
  ];

  return InvoicePdfContent(
    issuerName: profile.businessName,
    issuerAddressLines: issuerAddress,
    recipientName: invoice.clientName,
    invoiceNumber: invoice.invoiceNumber,
    issueDate: dateFmt.format(invoice.issueDate),
    dueDate: dateFmt.format(invoice.dueDate),
    statusLabel: statusLabel,
    lines: lines,
    tableLabels: tableLabels,
    currencyCode: invoice.currencyCode,
    totalFormatted: formatMinorUnits(roundToMinorUnits(invoice.amount)),
    qrPayload: qrPayload,
  );
}

String _plainNumber(double v) =>
    v == v.truncateToDouble() ? v.toInt().toString() : v.toString();

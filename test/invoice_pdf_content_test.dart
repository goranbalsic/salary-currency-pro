import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:salary_currency_pro/models/business_profile.dart';
import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/models/invoice_line_item.dart';
import 'package:salary_currency_pro/pdf/invoice_pdf_content.dart';

const _labels = InvoicePdfStatusLabels(paid: 'Paid', unpaid: 'Unpaid', overdue: 'Overdue');
const _table = InvoicePdfTableLabels(
  description: 'Description',
  quantity: 'Qty',
  unitPrice: 'Unit price',
  subtotal: 'Subtotal',
);

Invoice _invoice({
  double amount = 500,
  String description = '',
  List<InvoiceLineItem> items = const [],
  bool isPaid = false,
  DateTime? dueDate,
  String invoiceNumber = '',
}) =>
    Invoice(
      id: 'x',
      clientName: 'Acme d.o.o.',
      description: description,
      amount: amount,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 1, 1),
      dueDate: dueDate ?? DateTime(2026, 1, 15),
      isPaid: isPaid,
      items: items,
      invoiceNumber: invoiceNumber,
    );

void main() {
  // buildInvoicePdfContent formats dates via intl's DateFormat, which
  // (unlike in the running app, where flutter_localizations initializes
  // this at startup) needs explicit locale-data initialization in a bare
  // `flutter test` unit-test environment.
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('buildInvoicePdfContent — single-line fallback (no items)', () {
    test('renders the description/amount as one implied line', () {
      final content = buildInvoicePdfContent(
        invoice: _invoice(amount: 500, description: 'Website redesign'),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
      );

      expect(content.lines, hasLength(1));
      expect(content.lines.single.description, 'Website redesign');
      expect(content.lines.single.subtotal, '500.00');
      expect(content.totalFormatted, '500.00');
    });
  });

  group('buildInvoicePdfContent — itemized', () {
    test('renders one row per item with a deterministic, rounded subtotal '
        'that avoids a floating-point artifact', () {
      final content = buildInvoicePdfContent(
        invoice: _invoice(
          amount: Invoice.totalFromItems(const [
            InvoiceLineItem(description: 'A', quantity: 3, unitPrice: 0.1),
          ]),
          items: const [InvoiceLineItem(description: 'A', quantity: 3, unitPrice: 0.1)],
        ),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
      );

      expect(content.lines, hasLength(1));
      expect(content.lines.single.subtotal, '0.30'); // not 0.30000000000000004
      expect(content.totalFormatted, '0.30');
    });

    test('handles enough lines to be pagination-worthy without truncating '
        'any of them', () {
      final items = [
        for (var i = 0; i < 60; i++)
          InvoiceLineItem(description: 'Item $i', quantity: 1, unitPrice: 10),
      ];
      final content = buildInvoicePdfContent(
        invoice: _invoice(amount: Invoice.totalFromItems(items), items: items),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
      );

      expect(content.lines, hasLength(60));
      expect(content.totalFormatted, '600.00');
    });
  });

  group('buildInvoicePdfContent — status label selection', () {
    test('unpaid and not yet due', () {
      final content = buildInvoicePdfContent(
        invoice: _invoice(dueDate: DateTime(2026, 6, 1)),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
        now: DateTime(2026, 1, 1),
      );
      expect(content.statusLabel, 'Unpaid');
    });

    test('unpaid and past due is Overdue, not Unpaid', () {
      final content = buildInvoicePdfContent(
        invoice: _invoice(dueDate: DateTime(2026, 1, 1)),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
        now: DateTime(2026, 6, 1),
      );
      expect(content.statusLabel, 'Overdue');
    });

    test('paid stays Paid even past the due date', () {
      final content = buildInvoicePdfContent(
        invoice: _invoice(dueDate: DateTime(2026, 1, 1), isPaid: true),
        profile: const BusinessProfile(),
        localeCode: 'en',
        statusLabels: _labels,
        tableLabels: _table,
        now: DateTime(2026, 6, 1),
      );
      expect(content.statusLabel, 'Paid');
    });
  });

  test('issuer identity comes from the business profile, not the invoice', () {
    final content = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(
        businessName: 'Čigra doo',
        addressLine1: 'Bulevar 12',
        addressLine2: 'Leskovac',
      ),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );

    expect(content.issuerName, 'Čigra doo');
    expect(content.issuerAddressLines, ['Bulevar 12', 'Leskovac']);
    expect(content.recipientName, 'Acme d.o.o.');
  });

  test('an empty business profile produces an empty issuer, not a crash — '
      'a normal PDF must still generate for a missing profile', () {
    final content = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    expect(content.issuerName, '');
    expect(content.issuerAddressLines, isEmpty);
  });

  test('invoice number is carried through when set, blank when not', () {
    final withNumber = buildInvoicePdfContent(
      invoice: _invoice(invoiceNumber: '2026-001'),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    expect(withNumber.invoiceNumber, '2026-001');

    final withoutNumber = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    expect(withoutNumber.invoiceNumber, '');
  });

  test('qrPayload passes through untouched, and is null when not supplied '
      '(no QR builder exists yet — checkpoint 4)', () {
    final withQr = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
      qrPayload: 'K:PR|V:01|C:1|R:840000000095584510|N:Test|I:RSD500,00|SF:289',
    );
    expect(withQr.qrPayload, isNotNull);

    final withoutQr = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    expect(withoutQr.qrPayload, isNull);
  });
}

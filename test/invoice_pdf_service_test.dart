import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:salary_currency_pro/models/business_profile.dart';
import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/models/invoice_line_item.dart';
import 'package:salary_currency_pro/pdf/invoice_pdf_content.dart';
import 'package:salary_currency_pro/services/invoice_pdf_service.dart';

/// Smoke tests only: confirms the `pdf` package successfully lays out
/// each representative [InvoicePdfContent] shape into valid PDF bytes
/// without throwing. What content should appear is asserted separately
/// and far more thoroughly in test/invoice_pdf_content_test.dart, which
/// needs no `pdf` package dependency at all — see OPEN_QUESTIONS.md
/// QUESTION-009 for why this file doesn't assert rendered text/structure:
/// the `pdf` package doesn't expose a text-content introspection API to
/// assert against, only raw bytes.
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
  String currencyCode = 'EUR',
}) =>
    Invoice(
      id: 'x',
      clientName: 'Acme d.o.o.',
      description: description,
      amount: amount,
      currencyCode: currencyCode,
      issueDate: DateTime(2026, 1, 1),
      dueDate: DateTime(2026, 1, 15),
      isPaid: isPaid,
      items: items,
    );

void main() {
  // Real asset loading (the bundled Noto Sans font) needs an initialized
  // binding even in a pure-Dart-style unit test.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting();
  });

  final service = InvoicePdfService();

  bool looksLikeAValidPdf(List<int> bytes) =>
      bytes.length > 4 && String.fromCharCodes(bytes.take(5)) == '%PDF-';

  test('one-item (no itemization) invoice generates valid PDF bytes', () async {
    final content = buildInvoicePdfContent(
      invoice: _invoice(description: 'Website redesign'),
      profile: const BusinessProfile(businessName: 'Čigra doo'),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('multi-item invoice generates valid PDF bytes', () async {
    final items = const [
      InvoiceLineItem(description: 'Design', quantity: 2, unitPrice: 50),
      InvoiceLineItem(description: 'Hosting', quantity: 1, unitPrice: 12.5),
    ];
    final content = buildInvoicePdfContent(
      invoice: _invoice(amount: Invoice.totalFromItems(items), items: items),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('enough line items to force pagination generates valid PDF bytes',
      () async {
    final items = [
      for (var i = 0; i < 80; i++)
        InvoiceLineItem(description: 'Item number $i with a longer description', quantity: 1, unitPrice: 5),
    ];
    final content = buildInvoicePdfContent(
      invoice: _invoice(amount: Invoice.totalFromItems(items), items: items),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('long issuer/recipient names and descriptions do not break generation',
      () async {
    final content = buildInvoicePdfContent(
      invoice: _invoice(
        description: 'A very long line-item description that should wrap '
            'across multiple lines in the rendered table instead of being '
            'silently truncated, per the quality bar this feature is held to.',
      ),
      profile: const BusinessProfile(
        businessName: 'A Very Long Registered Business Name That Might Not Fit On One Line d.o.o.',
        addressLine1: 'Some Long Street Name 12345',
        addressLine2: 'A City With A Long Name',
      ),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('different currencies and paid/unpaid status generate valid PDF bytes',
      () async {
    for (final currency in ['EUR', 'USD', 'RSD', 'BAM']) {
      for (final paid in [true, false]) {
        final content = buildInvoicePdfContent(
          invoice: _invoice(currencyCode: currency, isPaid: paid),
          profile: const BusinessProfile(),
          localeCode: 'en',
          statusLabels: _labels,
          tableLabels: _table,
        );
        final bytes = await service.generate(content);
        expect(looksLikeAValidPdf(bytes), isTrue, reason: '$currency paid=$paid');
      }
    }
  });

  test('a missing/empty business profile still produces a valid PDF — a '
      'normal PDF must generate even without issuer data set up yet',
      () async {
    final content = buildInvoicePdfContent(
      invoice: _invoice(),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('a validated NBS IPS QR payload generates a valid, larger PDF (the '
      'QR code was actually drawn, not silently skipped)', () async {
    final withoutQr = buildInvoicePdfContent(
      invoice: _invoice(currencyCode: 'RSD'),
      profile: const BusinessProfile(businessName: 'Čigra doo'),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final withQr = buildInvoicePdfContent(
      invoice: _invoice(currencyCode: 'RSD'),
      profile: const BusinessProfile(businessName: 'Čigra doo'),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
      qrPayload: 'K:PR|V:01|C:1|R:840000000095584510|N:Čigra doo|I:RSD500,00|SF:289',
    );

    final bytesWithoutQr = await service.generate(withoutQr);
    final bytesWithQr = await service.generate(withQr);

    expect(looksLikeAValidPdf(bytesWithoutQr), isTrue);
    expect(looksLikeAValidPdf(bytesWithQr), isTrue);
    expect(bytesWithQr.length, greaterThan(bytesWithoutQr.length));
  });

  test('a non-eligible invoice never receives a QR payload from the content '
      'builder, so InvoicePdfService never has one to draw', () async {
    final content = buildInvoicePdfContent(
      invoice: _invoice(currencyCode: 'EUR'),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
      // No qrPayload passed — mirrors InvoiceDetailScreen only ever
      // passing one when NbsIpsEligibility.isEligible is true.
    );
    expect(content.qrPayload, isNull);
    final bytes = await service.generate(content);
    expect(looksLikeAValidPdf(bytes), isTrue);
  });

  test('generate() never mutates its input content', () async {
    final content = buildInvoicePdfContent(
      invoice: _invoice(description: 'Website redesign'),
      profile: const BusinessProfile(),
      localeCode: 'en',
      statusLabels: _labels,
      tableLabels: _table,
    );
    final before = content.totalFormatted;
    await service.generate(content);
    expect(content.totalFormatted, before);
  });
}

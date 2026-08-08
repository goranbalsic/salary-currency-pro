import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:salary_currency_pro/models/business_profile.dart';
import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/models/invoice_line_item.dart';
import 'package:salary_currency_pro/pdf/invoice_pdf_content.dart';
import 'package:salary_currency_pro/services/invoice_pdf_service.dart';

/// PROMPT-003 Stage C item 12.4: exercises representative text for all 9
/// supported app locales — Latin diacritics (hr/bs/sr/sl/sq), Cyrillic
/// (mk/bg), and Romanian ș/ț — through the real bundled font.
///
/// This proves generation *succeeds* with the bundled Noto Sans font for
/// every locale's characters (no missing-glyph exception, valid PDF
/// bytes). It does **not** prove the glyphs render correctly on screen or
/// in print — that needs actual visual/device verification, which this
/// automated test explicitly does not claim.
const _labels = InvoicePdfStatusLabels(paid: 'Paid', unpaid: 'Unpaid', overdue: 'Overdue');
const _table = InvoicePdfTableLabels(
  description: 'Description',
  quantity: 'Qty',
  unitPrice: 'Unit price',
  subtotal: 'Subtotal',
);

/// One representative client-name/description string per locale, chosen
/// to exercise that language's actual diacritics/script.
const _localeSamples = <String, String>{
  'en': 'Acme Ltd — Website redesign',
  'sr': 'Čigra d.o.o. — Izrada veb sajta za klijenta',
  'hr': 'Žitnjak d.o.o. — Izrada računalnog programa',
  'bs': 'Šumar d.o.o. — Konsultantske usluge',
  'sl': 'Žito d.o.o. — Svetovalne storitve',
  'sq': 'Shqiponja SH.P.K. — Shërbime këshillimi',
  'ro': 'Ștefăniță SRL — Servicii de consultanță',
  'mk': 'Чигра ДООЕЛ — Изработка на веб-страница',
  'bg': 'Щастие ЕООД — Консултантски услуги',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting();
  });

  final service = InvoicePdfService();

  bool looksLikeAValidPdf(List<int> bytes) =>
      bytes.length > 4 && String.fromCharCodes(bytes.take(5)) == '%PDF-';

  for (final entry in _localeSamples.entries) {
    test('${entry.key}: "${entry.value}" generates valid PDF bytes with the '
        'bundled font', () async {
      final invoice = Invoice(
        id: 'x',
        clientName: entry.value,
        description: entry.value,
        amount: 1000,
        currencyCode: 'EUR',
        issueDate: DateTime(2026, 1, 1),
        dueDate: DateTime(2026, 1, 15),
        items: [
          InvoiceLineItem(description: entry.value, quantity: 1, unitPrice: 1000),
        ],
      );
      final content = buildInvoicePdfContent(
        invoice: invoice,
        profile: BusinessProfile(businessName: entry.value),
        localeCode: entry.key,
        statusLabels: _labels,
        tableLabels: _table,
      );
      final bytes = await service.generate(content);
      expect(looksLikeAValidPdf(bytes), isTrue, reason: entry.key);
    });
  }
}

import 'package:bilans/features/business/data/business_store.dart';
import 'package:bilans/features/business/domain/business_math.dart';
import 'package:bilans/features/business/domain/identifiers.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/business/domain/invoice_qr.dart';
import 'package:bilans/features/business/domain/ips_qr.dart';
import 'package:bilans/features/business/domain/pausal.dart';
import 'package:bilans/features/business/domain/payment_details.dart';
import 'package:flutter_test/flutter_test.dart';

Invoice invoice({
  String id = 'a',
  String number = '1/2026',
  InvoiceStatus status = InvoiceStatus.issued,
  String currency = 'RSD',
  List<InvoiceItem> items = const [InvoiceItem(description: 'Web development', quantity: 10, unit: 'h', unitPrice: 5000)],
  bool vat = false,
  double? rate,
  DateTime? issue,
  DateTime? due,
  String reference = '',
}) {
  final d = issue ?? DateTime(2026, 3, 10);
  return Invoice(
    id: id,
    number: number,
    status: status,
    issueDate: d,
    serviceDate: d,
    dueDate: due ?? DateTime(d.year, d.month, d.day + 15),
    place: 'Beograd',
    client: const InvoiceParty(name: 'Klijent d.o.o.', address: 'Knez Mihailova 1', city: '11000 Beograd'),
    currency: currency,
    items: items,
    vatRegistered: vat,
    rsdRate: rate,
    rsdRateDate: rate == null ? null : d,
    reference: reference,
    createdAt: d,
  );
}

void main() {
  group('identifiers', () {
    test('PIB check digit (ISO 7064 MOD 11,10)', () {
      for (final valid in ['100020009', '101134702', '105209313', '112233446']) {
        expect(Identifiers.isValidPib(valid), isTrue, reason: valid);
      }
      expect(Identifiers.isValidPib('101134703'), isFalse);
      expect(Identifiers.isValidPib('10113470'), isFalse);
      expect(Identifiers.isValidPib('10113470a'), isFalse);
    });

    test('registration number (MB) check digit', () {
      for (final valid in ['07012349', '20123450', '17345677', '10000003']) {
        expect(Identifiers.isValidMaticniBroj(valid), isTrue, reason: valid);
      }
      expect(Identifiers.isValidMaticniBroj('07012348'), isFalse);
      expect(Identifiers.isValidMaticniBroj('0701234'), isFalse);
    });

    test('Serbian account: short and 18-digit forms, MOD 97-10', () {
      expect(Identifiers.isValidSerbianAccount('160-5020001234-64'), isTrue);
      expect(Identifiers.isValidSerbianAccount('160000502000123464'), isTrue);
      expect(Identifiers.isValidSerbianAccount('265-1100310000123-68'), isTrue);
      expect(Identifiers.isValidSerbianAccount('205-123456-66'), isTrue);
      expect(Identifiers.isValidSerbianAccount('160-5020001234-65'), isFalse);
      expect(Identifiers.isValidSerbianAccount('160-5020001234'), isFalse);
      expect(Identifiers.normalizeSerbianAccount('205-123456-66'), '205000000012345666');
      expect(Identifiers.formatSerbianAccount('205000000012345666'), '205-123456-66');
    });

    test('IBAN check and construction', () {
      expect(Identifiers.isValidIban('DE89 3704 0044 0532 0130 00'), isTrue);
      expect(Identifiers.isValidIban('DE88370400440532013000'), isFalse);
      expect(Identifiers.ibanFrom('RS', '160000502000123464'), 'RS35160000502000123464');
      expect(Identifiers.isValidIban('RS35160000502000123464'), isTrue);
      expect(Identifiers.formatIban('rs35160000502000123464'), 'RS35 1600 0050 2000 1234 64');
    });

    test('SWIFT/BIC shape', () {
      expect(Identifiers.isValidBic('AIKBRS22'), isTrue);
      expect(Identifiers.isValidBic('DEUTDEFF500'), isTrue);
      expect(Identifiers.isValidBic('AIKB22'), isFalse);
      expect(Identifiers.isValidBic('AIKBRS22X'), isFalse);
    });
  });

  group('NBS IPS QR', () {
    test('builds the documented payload', () {
      final r = IpsQr.build(
        account: '160-5020001234-64',
        recipient: 'Studio Zeleni\nBeograd',
        amountRsd: 12345.6,
        payer: 'Klijent d.o.o.',
        purpose: 'Faktura 1/2026',
        reference: '97 1234',
      );
      expect(r.errors, isEmpty);
      expect(r.payload, 'K:PR|V:01|C:1|R:160000502000123464|N:Studio Zeleni\nBeograd|I:RSD12345,60|P:Klijent d.o.o.|SF:221|S:Faktura 1/2026|RO:971234');
    });

    test('rounds the amount to para and never emits a "|" inside a field', () {
      final r = IpsQr.build(account: '160-5020001234-64', recipient: 'A|B', amountRsd: 0.005);
      expect(r.payload, contains('I:RSD0,01'));
      expect(r.payload, contains('N:A B'));
    });

    test('reports every invalid field', () {
      final r = IpsQr.build(account: '160-1-00', recipient: '', amountRsd: 0, paymentCode: '999', reference: '97-12');
      expect(r.payload, isNull);
      expect(r.errors, containsAll([IpsQrError.account, IpsQrError.recipient, IpsQrError.amount, IpsQrError.paymentCode, IpsQrError.reference]));
    });

    test('invoice QR only for dinar invoices, fitting long names', () {
      const profile = BusinessProfile(
        party: InvoiceParty(
          name: 'Preduzetnička radnja za programiranje i savetovanje Marko Marković PR',
          address: 'Bulevar kralja Aleksandra 123',
          city: '11000 Beograd',
        ),
        bankAccount: '160-5020001234-64',
      );
      final qr = invoiceIpsQr(invoice(), profile, purposeLabel: 'Faktura')!;
      expect(qr.errors, isEmpty);
      final name = RegExp(r'N:([^|]*)').firstMatch(qr.payload!)!.group(1)!;
      expect(name.length, lessThanOrEqualTo(70));
      expect(invoiceIpsQr(invoice(currency: 'EUR'), profile, purposeLabel: 'Faktura'), isNull);
    });

    test('fitLines keeps whole lines within the limit', () {
      expect(fitLines(['Name', 'Street 1', '11000 City'], max: 20), 'Name\nStreet 1');
      expect(fitLines(['', 'Only']), 'Only');
      expect(fitLines(['x' * 80]).length, 70);
    });
  });

  group('invoice', () {
    test('totals per line, rounded like a bill', () {
      final inv = invoice(vat: true, items: const [
        InvoiceItem(description: 'A', quantity: 3, unitPrice: 33.333, vatPercent: 20),
        InvoiceItem(description: 'B', quantity: 1, unitPrice: 0.05, vatPercent: 10),
        InvoiceItem(),
      ]);
      expect(inv.lines.length, 2, reason: 'blank lines are ignored');
      expect(inv.netTotal, 100.05);
      expect(inv.vatTotal, 20.01);
      expect(inv.total, 120.06);
    });

    test('RSD counter-value needs a rate for foreign currency', () {
      expect(invoice().totalRsd, 50000);
      expect(invoice(currency: 'EUR', items: const [InvoiceItem(description: 'x', unitPrice: 1000)]).totalRsd, isNull);
      expect(invoice(currency: 'EUR', rate: 117.1234, items: const [InvoiceItem(description: 'x', unitPrice: 1000)]).totalRsd, 117123.4);
    });

    test('overdue only when issued and past the due date', () {
      final inv = invoice(due: DateTime(2026, 3, 20));
      expect(inv.isOverdue(DateTime(2026, 3, 20, 23)), isFalse);
      expect(inv.isOverdue(DateTime(2026, 3, 21)), isTrue);
      expect(invoice(status: InvoiceStatus.paid, due: DateTime(2026, 3, 20)).isOverdue(DateTime(2026, 4, 1)), isFalse);
    });

    test('survives a JSON round trip and rejects damaged records', () {
      final inv = invoice(currency: 'EUR', rate: 117.2, vat: true, reference: '97 12');
      final back = Invoice.tryFromJson(inv.toJson())!;
      expect(back.toJson(), inv.toJson());
      expect(Invoice.tryFromJson({'id': 'x'}), isNull);
      expect(Invoice.tryFromJson('nope'), isNull);
      final partial = Invoice.tryFromJson({'id': 'x', 'issue': '2026-01-02T00:00:00.000', 'status': 'bogus'})!;
      expect(partial.status, InvoiceStatus.draft);
      expect(partial.currency, 'RSD');
    });

    test('next number continues the year’s sequence', () {
      final list = [invoice(number: '1/2026'), invoice(number: '7/2026'), invoice(number: '12/2025'), invoice(number: 'X-9')];
      expect(nextInvoiceNumber(list, 2026), '8/2026');
      expect(nextInvoiceNumber(list, 2027), '1/2027');
    });
  });

  group('payment details', () {
    test('dinar invoices print the domestic account and reference', () {
      const p = BusinessProfile(bankAccount: '160-5020001234-64', bankName: 'Banka');
      final d = PaymentDetails.of(p, invoice(reference: '97 12'));
      expect(d.account, '160-5020001234-64');
      expect(d.iban, isNull);
      expect(d.reference, '97 12');
    });

    test('foreign-currency invoices derive the IBAN from a Serbian account', () {
      const p = BusinessProfile(bankAccount: '160-5020001234-64', swift: 'intesars');
      final d = PaymentDetails.of(p, invoice(currency: 'EUR'));
      expect(d.iban, 'RS35 1600 0050 2000 1234 64');
      expect(d.account, isNull);
      expect(d.swift, 'INTESARS');
    });

    test('an explicit IBAN wins', () {
      const p = BusinessProfile(bankAccount: '160-5020001234-64', iban: 'DE89370400440532013000');
      expect(PaymentDetails.of(p, invoice(currency: 'EUR')).iban, 'DE89 3704 0044 0532 0130 00');
    });
  });

  group('paušal limits', () {
    test('calendar year and rolling 12 months', () {
      final today = DateTime(2026, 9, 25);
      final status = PausalTracker.compute([
        RevenueEntry(date: DateTime(2025, 9, 25), amountRsd: 1000000), // outside the window by one day
        RevenueEntry(date: DateTime(2025, 9, 26), amountRsd: 2000000), // first day of the window
        RevenueEntry(date: DateTime(2026, 1, 1), amountRsd: 3000000),
        RevenueEntry(date: DateTime(2026, 9, 26), amountRsd: 500000), // future: ignored
      ], today);
      expect(status.yearToDate, 3000000);
      expect(status.last12Months, 5000000);
      expect(status.annualRemaining, 3000000);
      expect(status.vatRemaining, 3000000);
      expect(status.projectedYearEnd, closeTo(3000000 / 268 * 365, 1));
    });

    test('leap day window start', () {
      final status = PausalTracker.compute([RevenueEntry(date: DateTime(2027, 3, 1), amountRsd: 1)], DateTime(2028, 2, 29));
      expect(status.last12Months, 1);
    });

    test('no projection before 30 days of data', () {
      final status = PausalTracker.compute([RevenueEntry(date: DateTime(2026, 1, 3), amountRsd: 100)], DateTime(2026, 1, 10));
      expect(status.projectedYearEnd, isNull);
    });
  });

  group('business math', () {
    test('VAT add and extract', () {
      expect(Vat.add(1000, 20), (net: 1000.0, vat: 200.0, gross: 1200.0));
      expect(Vat.extract(1200, 20), (net: 1000.0, vat: 200.0, gross: 1200.0));
      final e = Vat.extract(99.99, 20);
      expect(e.net + e.vat, closeTo(99.99, 1e-9));
    });

    test('margin and markup', () {
      const b = PriceBreakdown(cost: 80, price: 100, discountPercent: 0, vatPercent: 20);
      expect(b.profit, 20);
      expect(b.marginPercent, 20);
      expect(b.markupPercent, 25);
      expect(b.priceWithVat, 120);
      expect(PriceBreakdown.priceFromMarkup(80, 25), 100);
      expect(PriceBreakdown.priceFromMargin(80, 20), 100);
      expect(PriceBreakdown.priceFromMargin(80, 100), isNull);
      const d = PriceBreakdown(cost: 80, price: 100, discountPercent: 10, vatPercent: 0);
      expect(d.discountedPrice, 90);
      expect(d.profit, 10);
    });

    test('break-even rounds units up', () {
      final r = BreakEven.compute(fixedCosts: 1000, unitPrice: 30, unitVariableCost: 10)!;
      expect(r.units, 50);
      expect(r.revenue, 1500);
      expect(BreakEven.compute(fixedCosts: 1001, unitPrice: 30, unitVariableCost: 10)!.units, 51);
      expect(BreakEven.compute(fixedCosts: 1000, unitPrice: 10, unitVariableCost: 10), isNull);
      expect(BreakEven.compute(fixedCosts: 0, unitPrice: 10, unitVariableCost: 1)!.units, 0);
    });

    test('investment: NPV, IRR, paybacks', () {
      final r = Investment.analyze(initial: 1000, discountRatePercent: 10, flows: [500, 500, 500]);
      expect(r.npv, closeTo(243.43, 0.005));
      expect(r.irr!, closeTo(0.2338, 1e-4));
      expect(r.paybackYears, 2);
      expect(r.discountedPaybackYears!, closeTo(2.352, 0.001), reason: '132.23 of 375.66 into year 3');
      expect(r.profitabilityIndex!, closeTo(1.2434, 1e-4));
      final never = Investment.analyze(initial: 1000, discountRatePercent: 10, flows: [100, 100]);
      expect(never.paybackYears, isNull);
      expect(never.npv, lessThan(0));
    });
  });
}

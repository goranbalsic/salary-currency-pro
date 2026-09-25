import 'dart:convert';
import 'dart:io';

import 'package:bilans/core/format/formats.dart';
import 'package:bilans/features/business/data/business_store.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/credit/domain/deposit_engine.dart';
import 'package:bilans/features/credit/domain/loan_engine.dart';
import 'package:bilans/features/payroll/data/team_store.dart';
import 'package:bilans/features/payroll/domain/payroll_engine.dart';
import 'package:bilans/features/payroll/domain/payroll_models.dart';
import 'package:bilans/features/reports/pdf_kit.dart';
import 'package:bilans/features/reports/pdf_reports.dart';
import 'package:bilans/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ReportFonts fonts;
  final outDir = Directory('build/test-pdf')..createSync(recursive: true);

  setUpAll(() async => fonts = await ReportFonts.load());

  ReportKit kit(String lang, {String? script}) => ReportKit(
        fonts: fonts,
        l: lookupAppLocalizations(Locale.fromSubtags(languageCode: lang, scriptCode: script)),
        f: Formats(lang, script: script),
        issuer: 'Studio Zeleni · PIB 101134702',
      );

  void check(String name, List<int> bytes) {
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(2000));
    File('${outDir.path}/$name.pdf').writeAsBytesSync(bytes);
  }

  final invoice = Invoice(
    id: 'x',
    number: '12/2026',
    status: InvoiceStatus.issued,
    issueDate: DateTime(2026, 9, 25),
    serviceDate: DateTime(2026, 9, 25),
    dueDate: DateTime(2026, 10, 10),
    place: 'Beograd',
    client: const InvoiceParty(name: 'Klijent d.o.o.', address: 'Knez Mihailova 1', city: '11000 Beograd', taxId: '100020009'),
    currency: 'RSD',
    items: [for (var i = 1; i <= 40; i++) InvoiceItem(description: 'Stavka $i — razvoj softvera', quantity: i.toDouble(), unit: 'h', unitPrice: 2500)],
    vatRegistered: false,
    reference: '97 1234',
    createdAt: DateTime(2026, 9, 25),
  );
  const profile = BusinessProfile(
    party: InvoiceParty(name: 'Studio Zeleni PR', address: 'Bulevar 1', city: '11000 Beograd', taxId: '101134702', registrationNo: '07012349'),
    bankAccount: '160-5020001234-64',
    swift: 'INTESARS',
  );

  test('payroll report in every script the app ships', () async {
    final r = const PayrollEngine().fromGross(PayrollSystem.croatia, 2000);
    check('payroll-en', await buildPayrollPdf(kit('en'), r));
    check('payroll-sr-cyrl', await buildPayrollPdf(kit('sr'), const PayrollEngine().fromGross(PayrollSystem.serbia, 150000), annual: true));
    check('payroll-mk', await buildPayrollPdf(kit('mk'), const PayrollEngine().fromGross(PayrollSystem.northMacedonia, 75000)));
    check('payroll-ro', await buildPayrollPdf(kit('ro'), const PayrollEngine().fromGross(PayrollSystem.romania, 4325)));
  });

  test('loan report with a 30-year schedule spans pages', () async {
    final r = const LoanEngine().compute(const LoanInput(principal: 100000, annualRatePercent: 5, months: 360, upfrontFeePercent: 1));
    check('loan', await buildLoanPdf(kit('sr', script: 'Latn'), r, 'EUR'));
  });

  test('deposit report', () async {
    final r = const DepositEngine().compute(const DepositInput(principal: 10000, annualRatePercent: 3, months: 36, compounding: Compounding.annually, taxPercent: 15));
    check('deposit', await buildDepositPdf(kit('hr'), r, 'EUR'));
  });

  test('team report', () async {
    final members = [
      const TeamMember(id: '1', name: 'Ana', role: 'Developer', system: PayrollSystem.serbia, mode: PayrollInputMode.gross, amount: 250000),
      const TeamMember(id: '2', name: 'Marko', system: PayrollSystem.croatia, mode: PayrollInputMode.net, amount: 1800),
    ];
    check('team', await buildTeamPdf(kit('bs'), members, annual: true));
  });

  test('invoices: dinar with IPS QR, bilingual foreign-currency, long item lists', () async {
    check('invoice-rsd', await buildInvoicePdf(kit('sr', script: 'Latn'), invoice, profile, serbian: true));
    final eur = invoice.copyWith(currency: 'EUR', rsdRate: 117.4831, rsdRateDate: DateTime(2026, 9, 25), items: const [InvoiceItem(description: 'Consulting', quantity: 1, unitPrice: 3000)]);
    check('invoice-eur-bilingual', await buildInvoicePdf(kit('sr', script: 'Latn'), eur, profile, serbian: true, secondary: lookupAppLocalizations(const Locale('en'))));
    final vat = invoice.copyWith(vatRegistered: true, items: const [InvoiceItem(description: 'Roba', quantity: 3, unitPrice: 1000, vatPercent: 20)]);
    check('invoice-vat', await buildInvoicePdf(kit('en'), vat, profile, serbian: false));
  });

  // Every report in every language the app ships, so a translation that is
  // too long for a table column or a glyph missing from the fonts shows up.
  const languages = [('en', null), ('sr', 'Latn'), ('sr', null), ('hr', null), ('bs', null), ('sl', null), ('mk', null), ('bg', null), ('ro', null)];
  for (final (lang, script) in languages) {
    final tag = script == null ? lang : '$lang-$script';
    test('all reports in $tag', () async {
      final k = kit(lang, script: script);
      for (final system in PayrollSystem.values) {
        final r = const PayrollEngine().fromGross(system, const {'RSD': 180000.0, 'MKD': 60000.0, 'RON': 9000.0, 'BAM': 2500.0}[system.currency] ?? 2500);
        check('all-$tag-payroll-${system.name}', await buildPayrollPdf(k, r, annual: system.index.isEven));
      }
      final loan = const LoanEngine().compute(const LoanInput(principal: 25000, annualRatePercent: 6.5, months: 84, upfrontFeePercent: 1, monthlyFee: 3));
      check('all-$tag-loan', await buildLoanPdf(k, loan, 'EUR'));
      final dep = const DepositEngine().compute(const DepositInput(principal: 5000, annualRatePercent: 4, months: 24, compounding: Compounding.monthly, taxPercent: 15, monthlyContribution: 100));
      check('all-$tag-deposit', await buildDepositPdf(k, dep, 'EUR'));
      final members = [
        for (final system in PayrollSystem.values)
          TeamMember(id: system.name, name: 'Ime ${system.index}', role: 'Role', system: system, mode: PayrollInputMode.gross, amount: system.currency == 'RSD' ? 150000 : 2000),
      ];
      check('all-$tag-team', await buildTeamPdf(k, members, annual: false));
      final eur = invoice.copyWith(
        currency: 'EUR',
        vatRegistered: true,
        rsdRate: 117.1726,
        rsdRateDate: DateTime(2026, 9, 25),
        items: const [InvoiceItem(description: 'Consulting', quantity: 12.5, unit: 'h', unitPrice: 85, vatPercent: 20)],
      );
      check('all-$tag-invoice', await buildInvoicePdf(k, eur, profile, serbian: true));
      check('all-$tag-invoice-bilingual', await buildInvoicePdf(k, eur, profile, serbian: true, secondary: lookupAppLocalizations(const Locale('en'))));
      check('all-$tag-invoice-foreign', await buildInvoicePdf(k, invoice, profile, serbian: false));
    });
  }
}

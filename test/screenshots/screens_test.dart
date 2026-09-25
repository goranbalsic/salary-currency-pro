// Renders key screens to PNG for visual review and store screenshots:
//   flutter test --update-goldens --tags screenshots test/screenshots
// Output: test/screenshots/out/<theme>/<name>.png (not committed).
@Tags(['screenshots'])
library;

import 'package:bilans/app/bootstrap.dart';
import 'package:bilans/features/business/data/business_store.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/payroll/data/team_store.dart';
import 'package:bilans/features/payroll/domain/payroll_models.dart';
import 'package:bilans/features/reports/pdf_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/harness.dart';

Future<void> seed(AppServices s) async {
  await s.business.saveProfile(
    const BusinessProfile(
      party: InvoiceParty(name: 'Studio Zeleni PR', address: 'Bulevar oslobođenja 12', city: '21000 Novi Sad', taxId: '101134702', registrationNo: '07012349'),
      bankAccount: '160-5020001234-64',
      bankName: 'Banca Intesa',
      swift: 'DBDBRSBG',
    ),
  );
  final today = DateTime.now();
  DateTime d(int back) => DateTime(today.year, today.month, today.day - back);
  var n = 0;
  Future<void> add(String client, double price, int back, InvoiceStatus status, {String currency = 'RSD', double? rate}) async {
    n++;
    await s.business.upsertInvoice(
      Invoice(
        id: 'i$n',
        number: '$n/${today.year}',
        status: status,
        issueDate: d(back),
        serviceDate: d(back),
        dueDate: d(back - 15),
        place: 'Novi Sad',
        client: InvoiceParty(name: client, city: 'Beograd'),
        currency: currency,
        items: [InvoiceItem(description: 'Razvoj softvera', quantity: 1, unit: 'kom', unitPrice: price)],
        vatRegistered: false,
        rsdRate: rate,
        rsdRateDate: rate == null ? null : d(back),
        createdAt: d(back),
      ),
    );
  }

  await add('Nordlicht GmbH', 4200, 200, InvoiceStatus.paid, currency: 'EUR', rate: 117.2);
  await add('Nordlicht GmbH', 4200, 170, InvoiceStatus.paid, currency: 'EUR', rate: 117.2);
  await add('Panonija d.o.o.', 180000, 120, InvoiceStatus.paid);
  await add('Nordlicht GmbH', 4200, 90, InvoiceStatus.paid, currency: 'EUR', rate: 117.3);
  await add('Panonija d.o.o.', 240000, 40, InvoiceStatus.paid);
  await add('Nordlicht GmbH', 4400, 20, InvoiceStatus.issued, currency: 'EUR', rate: 117.4);
  await add('Kafeterija Dunav', 96000, 3, InvoiceStatus.issued);
  for (final (name, role, amount) in [
    ('Ana Petrović', 'Developer', 320000.0),
    ('Marko Ilić', 'Designer', 210000.0),
    ('Jelena Kovač', 'Accountant', 150000.0),
  ]) {
    await s.team.upsert(TeamMember(id: name, name: name, role: role, system: PayrollSystem.serbia, mode: PayrollInputMode.gross, amount: amount));
  }
  await s.store.writeJson('payroll.last.v1', {'system': 'serbia', 'mode': 'gross', 'amount': 150000, 'options': <String, Object?>{}});
  await s.store.writeJson('credit.loan.v1', {'principal': 1200000, 'currency': 'RSD', 'rate': 7.49, 'months': 84, 'type': 'annuity', 'fee': 1});
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await ReportFonts.load();
  });

  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';
    testWidgets('screens $theme', (tester) async {
      // 1080 x 1920 physical: Play Store's 9:16 phone format.
      tester.view.devicePixelRatio = 2.7;
      tester.view.physicalSize = const Size(1080, 1920);
      addTearDown(tester.view.reset);
      final s = await makeServices(pro: true);
      await seed(s);
      await s.settings.setTheme(dark ? ThemeMode.dark : ThemeMode.light);
      await pumpApp(tester, s);
      Future<void> shot(String name) async {
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('out/$theme/$name.png'));
      }

      Future<void> tab(String label) async {
        await tester.tap(find.bySemanticsLabel(label).last);
        await tester.pumpAndSettle();
      }

      await shot('01_home');
      await tab('Pay');
      await shot('02_pay');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
      await shot('03_pay_breakdown');
      await tab('Loans');
      await shot('04_loan');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -650));
      await shot('05_loan_years');
      await tab('Rates');
      await shot('06_rates');
      await tab('Business');
      await shot('07_business');
      await tester.tap(find.text('Kafeterija Dunav'));
      await tester.pumpAndSettle();
      await shot('08_invoice');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await shot('09_invoice_qr');
      Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Paušal ·'));
      await tester.pumpAndSettle();
      await shot('10_pausal');
      Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
      await tester.pumpAndSettle();
      await tab('Home');
      await tester.tap(find.text('Team cost'));
      await tester.pumpAndSettle();
      await shot('11_team');
      Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Compare countries'));
      await tester.pumpAndSettle();
      await shot('12_compare');
    });
  }

  testWidgets('paywall', (tester) async {
    tester.view.devicePixelRatio = 2.7;
    tester.view.physicalSize = const Size(1080, 1920);
    addTearDown(tester.view.reset);
    final s = await makeServices();
    await pumpApp(tester, s);
    await tester.tap(find.text('Team cost'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('out/light/13_paywall.png'));
  });
}

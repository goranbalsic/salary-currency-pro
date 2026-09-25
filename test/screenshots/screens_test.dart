// Renders key screens to PNG for visual review and store screenshots:
//   flutter test --update-goldens --run-skipped --tags screenshots test/screenshots
// Languages: SHOT_LANGS=en,srLatn (default) — any AppLanguage names.
// Output: test/screenshots/out/<language>/<theme>/<name>.png (not committed).
// Store graphics are then framed by tool/launch/make_store_graphics.py.
@Tags(['screenshots'])
library;

import 'dart:io';

import 'package:bilans/app/bootstrap.dart';
import 'package:bilans/features/business/data/business_store.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/payroll/data/team_store.dart';
import 'package:bilans/features/payroll/domain/payroll_models.dart';
import 'package:bilans/features/reports/pdf_kit.dart';
import 'package:bilans/features/settings/settings_controller.dart';
import 'package:bilans/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/harness.dart';

/// What each market's screenshots show: its own country, currency and
/// payroll system, with a plausible local business.
class Market {
  const Market({
    required this.country,
    required this.system,
    required this.gross,
    required this.currency,
    required this.loan,
    required this.business,
    required this.city,
    required this.clients,
    required this.team,
  });

  final String country;
  final PayrollSystem system;
  final double gross;
  final String currency;
  final double loan;
  final String business;
  final String city;
  final List<String> clients;
  final List<(String, String, double)> team;

  bool get serbian => country == 'RS';

  /// City name without the postcode.
  String get place => city.split(' ').skip(1).join(' ');
}

const _serbia = Market(
  country: 'RS',
  system: PayrollSystem.serbia,
  gross: 150000,
  currency: 'RSD',
  loan: 1200000,
  business: 'Studio Zeleni PR',
  city: '21000 Novi Sad',
  clients: ['Nordlicht GmbH', 'Panonija d.o.o.', 'Kafeterija Dunav'],
  team: [('Ana Petrović', 'Developer', 320000), ('Marko Ilić', 'Designer', 210000), ('Jelena Kovač', 'Accountant', 150000)],
);

const markets = <AppLanguage, Market>{
  AppLanguage.en: _serbia,
  AppLanguage.srLatn: _serbia,
  AppLanguage.srCyrl: _serbia,
  AppLanguage.hr: Market(
    country: 'HR',
    system: PayrollSystem.croatia,
    gross: 2000,
    currency: 'EUR',
    loan: 20000,
    business: 'Studio Zeleni j.d.o.o.',
    city: '10000 Zagreb',
    clients: ['Nordlicht GmbH', 'Jadran d.o.o.', 'Kavana Korzo'],
    team: [('Ana Horvat', 'Developer', 2800), ('Marko Kovačić', 'Designer', 2100), ('Ivana Babić', 'Accountant', 1600)],
  ),
  AppLanguage.bs: Market(
    country: 'BA',
    system: PayrollSystem.fbih,
    gross: 2000,
    currency: 'BAM',
    loan: 30000,
    business: 'Studio Zeleni d.o.o.',
    city: '71000 Sarajevo',
    clients: ['Nordlicht GmbH', 'Bistrica d.o.o.', 'Kafana Baščaršija'],
    team: [('Amra Hodžić', 'Developer', 3200), ('Emir Begić', 'Designer', 2400), ('Lejla Delić', 'Accountant', 1800)],
  ),
  AppLanguage.sl: Market(
    country: 'SI',
    system: PayrollSystem.slovenia,
    gross: 2500,
    currency: 'EUR',
    loan: 20000,
    business: 'Studio Zeleni s.p.',
    city: '1000 Ljubljana',
    clients: ['Nordlicht GmbH', 'Triglav d.o.o.', 'Kavarna Tromostovje'],
    team: [('Ana Novak', 'Developer', 3400), ('Marko Horvat', 'Designer', 2600), ('Maja Kranjc', 'Accountant', 2100)],
  ),
  AppLanguage.mk: Market(
    country: 'MK',
    system: PayrollSystem.northMacedonia,
    gross: 60000,
    currency: 'MKD',
    loan: 900000,
    business: 'Студио Зелени ДООЕЛ',
    city: '1000 Скопје',
    clients: ['Nordlicht GmbH', 'Вардар ДОО', 'Кафе Чаршија'],
    team: [('Ана Стојанова', 'Developer', 95000), ('Марко Петровски', 'Designer', 70000), ('Елена Трајкова', 'Accountant', 55000)],
  ),
  AppLanguage.bg: Market(
    country: 'BG',
    system: PayrollSystem.bulgaria,
    gross: 2000,
    currency: 'EUR',
    loan: 20000,
    business: 'Студио Зелени ЕООД',
    city: '1000 София',
    clients: ['Nordlicht GmbH', 'Витоша ООД', 'Кафе Централ'],
    team: [('Анна Иванова', 'Developer', 2600), ('Марко Петров', 'Designer', 1900), ('Елена Георгиева', 'Accountant', 1400)],
  ),
  AppLanguage.ro: Market(
    country: 'RO',
    system: PayrollSystem.romania,
    gross: 9000,
    currency: 'RON',
    loan: 100000,
    business: 'Studio Zeleni SRL',
    city: '010011 București',
    clients: ['Nordlicht GmbH', 'Carpați SRL', 'Cafeneaua Centrală'],
    team: [('Ana Popescu', 'Developer', 14000), ('Mihai Ionescu', 'Designer', 10000), ('Elena Stan', 'Accountant', 7500)],
  ),
};

Future<void> seed(AppServices s, [Market m = _serbia]) async {
  await s.business.saveProfile(
    BusinessProfile(
      party: InvoiceParty(
        name: m.business,
        address: m.serbian ? 'Bulevar oslobođenja 12' : '',
        city: m.city,
        taxId: m.serbian ? '101134702' : '',
        registrationNo: m.serbian ? '07012349' : '',
      ),
      bankAccount: m.serbian ? '160-5020001234-64' : 'DE89 3704 0044 0532 0130 00',
      bankName: m.serbian ? 'Banca Intesa' : '',
      swift: m.serbian ? 'DBDBRSBG' : 'COBADEFFXXX',
    ),
  );
  final today = DateTime.now();
  DateTime d(int back) => DateTime(today.year, today.month, today.day - back);
  var n = 0;
  Future<void> add(String client, double price, int back, InvoiceStatus status, {String? currency, double? rate}) async {
    n++;
    await s.business.upsertInvoice(
      Invoice(
        id: 'i$n',
        number: '$n/${today.year}',
        status: status,
        issueDate: d(back),
        serviceDate: d(back),
        dueDate: d(back - 15),
        place: m.place,
        client: InvoiceParty(name: client, city: m.place),
        currency: currency ?? m.currency,
        items: [InvoiceItem(description: 'Razvoj softvera', quantity: 1, unit: 'kom', unitPrice: price)],
        vatRegistered: false,
        rsdRate: rate,
        rsdRateDate: rate == null ? null : d(back),
        createdAt: d(back),
      ),
    );
  }

  // Local-currency invoice amounts, scaled from the dinar figures.
  final scale = switch (m.currency) {
    'RSD' => 1.0,
    'MKD' => 0.52,
    'RON' => 0.042,
    'BAM' => 0.0167,
    _ => 0.0085,
  };
  double local(double rsd) => (rsd * scale).roundToDouble();
  double? rate(double r) => m.serbian ? r : null;
  await add(m.clients[0], 4200, 200, InvoiceStatus.paid, currency: 'EUR', rate: rate(117.2));
  await add(m.clients[0], 4200, 170, InvoiceStatus.paid, currency: 'EUR', rate: rate(117.2));
  await add(m.clients[1], local(180000), 120, InvoiceStatus.paid);
  await add(m.clients[0], 4200, 90, InvoiceStatus.paid, currency: 'EUR', rate: rate(117.3));
  await add(m.clients[1], local(240000), 40, InvoiceStatus.paid);
  await add(m.clients[0], 4400, 20, InvoiceStatus.issued, currency: 'EUR', rate: rate(117.4));
  await add(m.clients[2], local(96000), 3, InvoiceStatus.issued);
  for (final (name, role, amount) in m.team) {
    await s.team.upsert(TeamMember(id: name, name: name, role: role, system: m.system, mode: PayrollInputMode.gross, amount: amount));
  }
  await s.store.writeJson('payroll.last.v1', {'system': m.system.name, 'mode': 'gross', 'amount': m.gross, 'options': <String, Object?>{}});
  await s.store.writeJson('credit.loan.v1', {'principal': m.loan, 'currency': m.currency, 'rate': 7.49, 'months': 84, 'type': 'annuity', 'fee': 1});
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await ReportFonts.load();
  });

  final languages = (Platform.environment['SHOT_LANGS'] ?? 'en,srLatn').split(',').map((n) => AppLanguage.byName(n.trim())).nonNulls;
  for (final lang in languages) {
    final l = lookupAppLocalizations(lang.locale);
    final market = markets[lang]!;
    for (final dark in [false, true]) {
      final theme = dark ? 'dark' : 'light';
      testWidgets('screens ${lang.name} $theme', (tester) async {
        // 1080 x 1920 physical: Play Store's 9:16 phone format.
        tester.view.devicePixelRatio = 2.7;
        tester.view.physicalSize = const Size(1080, 1920);
        addTearDown(tester.view.reset);
        final s = await makeServices(pro: true, language: lang.name, country: market.country);
        await seed(s, market);
        await s.settings.setTheme(dark ? ThemeMode.dark : ThemeMode.light);
        await pumpApp(tester, s);
        Future<void> shot(String name) async {
          await tester.pumpAndSettle();
          await expectLater(find.byType(MaterialApp), matchesGoldenFile('out/${lang.name}/$theme/$name.png'));
        }

        Future<void> tab(String label) async {
          await tester.tap(find.bySemanticsLabel(label).last);
          await tester.pumpAndSettle();
        }

        Future<void> pop() async {
          Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
          await tester.pumpAndSettle();
        }

        await shot('01_home');
        await tab(l.navPayroll);
        await shot('02_pay');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
        await shot('03_pay_breakdown');
        await tab(l.navCredit);
        await shot('04_loan');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -650));
        await shot('05_loan_years');
        await tab(l.navFx);
        await shot('06_rates');
        await tab(l.navBusiness);
        await shot('07_business');
        await tester.tap(find.text(market.clients[2]).first);
        await tester.pumpAndSettle();
        await shot('08_invoice');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
        await shot('09_invoice_qr');
        await pop();
        if (market.serbian) {
          await tester.tap(find.textContaining(l.bizPausalCard(DateTime.now().year)));
          await tester.pumpAndSettle();
          await shot('10_pausal');
          await pop();
        }
        await tab(l.navHome);
        await tester.tap(find.text(l.toolTeam));
        await tester.pumpAndSettle();
        await shot('11_team');
        await pop();
        await tester.tap(find.text(l.toolCompare));
        await tester.pumpAndSettle();
        await shot('12_compare');
      });
    }

    testWidgets('paywall ${lang.name}', (tester) async {
      tester.view.devicePixelRatio = 2.7;
      tester.view.physicalSize = const Size(1080, 1920);
      addTearDown(tester.view.reset);
      final s = await makeServices(language: lang.name, country: market.country);
      await pumpApp(tester, s);
      await tester.tap(find.text(l.toolTeam));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('out/${lang.name}/light/13_paywall.png'));
    });
  }
}

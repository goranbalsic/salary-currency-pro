import 'package:bilans/core/format/formats.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/reports/pdf_kit.dart';
import 'package:bilans/features/settings/settings_controller.dart';
import 'package:bilans/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'flows_test.dart' show Driver, bigAmount, labelled, numberField;
import 'harness.dart';

/// The main flows in every language the app ships, at normal and at the
/// largest supported text size: longer translations must not overflow,
/// and every screen must be reachable with the localized labels.
void main() {
  setUpAll(() async {
    await loadAppFonts();
    await ReportFonts.load();
  });

  for (final lang in AppLanguage.values) {
    final l = lookupAppLocalizations(lang.locale);
    final f = Formats(lang.languageCode, script: lang.scriptCode);

    for (final scale in [1.0, 1.6]) {
      final tag = '${lang.name} @${scale}x';

      testWidgets('pay, loans, rates and settings in $tag', (tester) async {
        setScreen(tester, width: 360, height: 800, textScale: scale);
        final services = await makeServices(pro: true, country: lang.defaultCountry, language: lang.name);
        await pumpApp(tester, services);
        final d = Driver(tester);

        await d.tab(l.navPayroll);
        await d.enter('gross', bigAmount(), _typicalGross(services.settings.payrollSystem.currency));
        await d.tap('annual', find.text(l.payAnnualToggle));
        await d.tap('net mode', find.text(l.payModeNet));
        await d.tap('cost mode', find.text(l.payModeCost));
        await d.tap('gross mode', find.text(l.payModeGross));
        if (find.text(l.payOptions).evaluate().isNotEmpty) {
          await d.tap('options', find.text(l.payOptions));
          await d.back('options close');
        }

        await d.tab(l.navCredit);
        await d.enter('principal', numberField(l.loanAmount), '25000');
        await d.enter('rate', numberField(l.loanRate), '6');
        await d.tap('schedule', find.textContaining(l.loanScheduleAll(60).split('·').first.trim()));
        await d.back('schedule back');
        await d.tap('savings', find.text(l.creditTabDeposit));
        await d.tap('compare', find.text(l.creditTabCompare));
        await d.tap('loan', find.text(l.creditTabLoan));

        await d.tab(l.navFx);
        await d.tap('rate list', find.text(l.fxTabList));
        await d.tap('converter', find.text(l.fxTabConverter));

        await d.tab(l.navHome);
        await d.scrollToTop();
        await d.tap('settings', find.byTooltip(l.homeSettings));
        await d.tap('dark', find.text(l.settingsThemeDark));
        await d.tap('light', find.text(l.settingsThemeLight));
        await d.back('settings back');
      });

      testWidgets('invoice from scratch and paušal in $tag', (tester) async {
        setScreen(tester, width: 360, height: 800, textScale: scale);
        final services = await makeServices(pro: true, country: 'RS', language: lang.name);
        await pumpApp(tester, services);
        final d = Driver(tester);

        await d.tab(l.navBusiness);
        await d.tap('new invoice', find.text(l.bizNewInvoice));
        await d.enter('name', labelled(l.profName), 'Studio Zeleni');
        await d.enter('city', labelled(l.profCity), '11000 Beograd');
        await d.enter('pib', labelled(l.profTaxId), '101134702');
        await d.enter('account', labelled(l.profAccount), '160-5020001234-64');
        await d.tap('save profile', find.widgetWithText(FilledButton, l.actionSave));
        expect(services.business.profile.party.name, 'Studio Zeleni');

        await d.enter('client', labelled(l.invClientName), 'Klijent d.o.o.');
        await d.enter('item', labelled(l.invItemDescription), 'Web development');
        await d.enter('qty', labelled(l.invItemQty), '10');
        await d.enter('price', labelled(l.invItemPrice), '5000');
        await d.tap('issue', find.text(l.invIssue));
        expect(services.business.invoices.single.status, InvoiceStatus.issued);
        expect(find.text(l.invQrCaption), findsWidgets);
        expect(find.textContaining(f.money(50000, 'RSD')), findsWidgets);
        await d.tap('mark paid', find.text(l.invMarkPaid));
        expect(services.business.invoices.single.status, InvoiceStatus.paid);
        await d.back('view back');

        await d.tap('pausal card', find.textContaining(l.bizPausalCard(DateTime.now().year)));
        await d.tap('add revenue', find.text(l.pausalManualAdd));
        await d.enter('revenue amount', labelled(l.pausalManualAmount), '120000');
        await d.tap('save revenue', find.widgetWithText(FilledButton, l.actionSave));
        expect(services.business.manualRevenue.length, 1);
        await d.back('pausal back');
      });

      testWidgets('business calculators, team and comparison in $tag', (tester) async {
        setScreen(tester, width: 360, height: 800, textScale: scale);
        final services = await makeServices(pro: true, country: lang.defaultCountry, language: lang.name);
        await pumpApp(tester, services);
        final d = Driver(tester);

        await d.tap('vat', find.text(l.toolVat));
        await d.enter('vat amount', bigAmount(), '1000');
        await d.tap('extract', find.text(l.vatExtract));
        await d.back();

        await d.tap('margin', find.text(l.toolMargin));
        await d.enter('cost', numberField(l.mrgCost), '80');
        await d.enter('price', numberField(l.mrgPrice), '100');
        await d.tap('markup mode', find.text(l.mrgFromMarkup));
        await d.back();

        await d.tap('break-even', find.text(l.toolBreakEven));
        await d.enter('fixed', numberField(l.beFixed), '100000');
        await d.enter('unit price', numberField(l.bePrice), '1500');
        await d.enter('variable', numberField(l.beVariable), '700');
        expect(find.textContaining(l.beUnitsValue(125, f.number(125, decimals: 0))), findsWidgets);
        await d.back();

        await d.tap('investment', find.text(l.toolInvestment));
        await d.enter('initial', numberField(l.invsInitial), '1000000');
        await d.enter('year 1', numberField(l.invsYear(1)), '400000');
        await d.enter('year 2', numberField(l.invsYear(2)), '600000');
        await d.enter('year 3', numberField(l.invsYear(3)), '700000');
        await d.back();

        await d.tap('team', find.text(l.toolTeam));
        await d.tap('add employee', find.text(l.teamAdd).last);
        await d.enter('member name', labelled(l.teamName), 'Ana');
        await d.enter('member pay', bigAmount(), '3000');
        await d.tap('member save', find.widgetWithText(FilledButton, l.actionSave));
        expect(services.team.members.length, 1);
        await d.back();

        await d.tap('compare countries', find.text(l.toolCompare));
        await d.enter('compare amount', bigAmount(), '3000');
        expect(find.text(l.cmpRankedByNet.toUpperCase()), findsOneWidget);
        await d.back();
      });

      testWidgets('pay below the minimum base warns instead of showing a negative net in $tag', (tester) async {
        setScreen(tester, width: 360, height: 800, textScale: scale);
        final services = await makeServices(pro: true, country: 'MK', language: lang.name);
        await pumpApp(tester, services);
        final d = Driver(tester);

        await d.tab(l.navPayroll);
        await d.enter('gross', bigAmount(), '4000');
        expect(find.text(l.payNoteNonPositive), findsOneWidget);
        expect(find.text(l.payResultNet.toUpperCase()), findsNothing, reason: 'no net pay figure');
        expect(find.textContaining('−'), findsNothing, reason: 'no negative amounts');
        await d.enter('gross', bigAmount(), '60000');
        expect(find.text(l.payNoteNonPositive), findsNothing);
        expect(find.text(l.payResultNet.toUpperCase()), findsOneWidget);
      });

      testWidgets('free plan paywall in $tag', (tester) async {
        setScreen(tester, width: 360, height: 800, textScale: scale);
        final services = await makeServices(country: lang.defaultCountry, language: lang.name);
        await pumpApp(tester, services);
        final d = Driver(tester);

        await d.tap('locked tool', find.text(l.toolTeam));
        expect(find.textContaining('Bilans Pro'), findsWidgets, reason: 'paywall opens');
        await d.tap('monthly plan', find.text(l.proMonthly));
        await d.tap('lifetime plan', find.text(l.proLifetime));
        await d.tap('yearly plan', find.text(l.proYearly));
        expect(find.text(l.proStartTrial(7)), findsOneWidget);
        expect(services.pro.isPro, isFalse);
        await d.back('close paywall');
      });
    }
  }
}

/// A monthly gross above every country's minimum, in [currency].
String _typicalGross(String currency) => switch (currency) {
      'RSD' => '150000',
      'MKD' => '60000',
      'RON' => '9000',
      _ => '4000',
    };

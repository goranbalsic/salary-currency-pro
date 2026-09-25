import 'package:bilans/app/app_config.dart';
import 'package:bilans/core/format/formats.dart';
import 'package:bilans/core/widgets/controls.dart';
import 'package:bilans/features/credit/domain/loan_engine.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/history/history_store.dart';
import 'package:bilans/features/reports/pdf_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../pro/pro_controller_test.dart' show purchase;
import 'harness.dart';

/// Drives the app like a person would. Any framework error (layout
/// overflow, exception, assertion) fails the test; the STEP log lines show
/// where it happened.
class Driver {
  Driver(this.tester);

  final WidgetTester tester;
  String step = 'start';

  /// Settles with a short timeout so a stuck animation fails fast and
  /// names the step instead of hanging for ten minutes.
  Future<void> settle() async {
    try {
      await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 8));
    } on FlutterError catch (e) {
      fail('[$step] never settled: ${e.message.split('\n').first}');
    }
  }

  /// Lazy lists only build what is on screen: scroll until [finder] exists.
  Future<void> reveal(Finder finder) async {
    if (finder.evaluate().isNotEmpty) return;
    await scrollToTop();
    final scrollable = find.byType(Scrollable);
    for (var i = 0; i < 40 && finder.evaluate().isEmpty && scrollable.evaluate().isNotEmpty; i++) {
      await tester.dragFrom(_grip(scrollable.first), const Offset(0, -250));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await settle();
  }

  Future<void> tap(String name, Finder finder) async {
    step = name;
    debugPrint('STEP $name');
    await reveal(finder);
    expect(finder, findsWidgets, reason: 'step "$name" found nothing to tap');
    await tester.ensureVisible(finder.first);
    await settle();
    await tester.tap(finder.first, warnIfMissed: false);
    await settle();
  }

  Future<void> enter(String name, Finder field, String text) async {
    step = name;
    debugPrint('STEP $name');
    await reveal(field);
    expect(field, findsWidgets, reason: 'step "$name" found no field');
    await tester.ensureVisible(field.first);
    await settle();
    await tester.enterText(field.first, text);
    await settle();
  }

  Future<void> back([String name = 'back']) async {
    step = name;
    final NavigatorState nav = tester.state(find.byType(Navigator).last);
    await nav.maybePop();
    await settle();
  }

  Future<void> tab(String label) => tap('tab $label', find.bySemanticsLabel(label).last);

  Future<void> scrollToTop() async {
    final scrollables = find.byType(Scrollable);
    if (scrollables.evaluate().isEmpty) return;
    await tester.flingFrom(_grip(scrollables.first), const Offset(0, 5000), 5000);
    await settle();
  }

  /// Where a thumb scrolls: the page margin at the left edge, so a drag
  /// never starts on a focused field's selection handle or on a chart.
  Offset _grip(Finder scrollable) {
    final r = tester.getRect(scrollable);
    return Offset(r.left + 6, r.center.dy);
  }
}

Finder numberField(String label) => find.descendant(of: find.widgetWithText(NumberInputRow, label), matching: find.byType(TextField));
Finder labelled(String label) => find.widgetWithText(TextField, label);
Finder bigAmount() => find.descendant(of: find.byType(AmountField), matching: find.byType(TextField));

const sizes = [(360.0, 800.0, 1.0), (320.0, 640.0, 1.0), (360.0, 800.0, 1.6)];

void main() {
  setUpAll(() async {
    await loadAppFonts();
    // Asset I/O does not complete inside a widget test's fake clock, so
    // the PDF fonts are loaded (and cached) up front.
    await ReportFonts.load();
  });

  for (final (w, h, s) in sizes) {
    final tag = '${w.toInt()}x${h.toInt()}@$s';

    testWidgets('payroll, loans and rates with real numbers $tag', (tester) async {
      setScreen(tester, width: w, height: h, textScale: s);
      final services = await makeServices(pro: true);
      await pumpApp(tester, services);
      final d = Driver(tester);

      await d.tab('Pay');
      await d.enter('gross', bigAmount(), '150000');
      expect(find.textContaining('108,572.10'), findsWidgets);
      await d.tap('annual', find.text('Annual ×12'));
      await d.tap('annual off', find.text('Annual ×12'));
      await d.tap('net mode', find.text('Net → gross'));
      await d.tap('cost mode', find.text('Total cost'));
      await d.tap('gross mode', find.text('Gross → net'));
      await d.tap('save', find.text('Save'));
      await d.enter('save name', find.byType(TextField).last, 'Offer');
      await d.tap('save confirm', find.widgetWithText(FilledButton, 'Save'));
      expect(services.history.savedCount, 1);
      await d.tap('share', find.text('Share'));
      await d.tap('pdf', find.text('Download PDF'));
      await d.scrollToTop();
      await d.tap('system sheet', find.byTooltip('Tax system').evaluate().isNotEmpty ? find.byTooltip('Tax system') : find.text('RS'));
      await d.tap('pick Croatia', find.text('Croatia'));
      await d.enter('croatia gross', bigAmount(), '2000');
      expect(find.textContaining('1,400.00'), findsWidgets);
      await d.tap('options', find.text('Options'));
      await d.back('options close');

      await d.tab('Loans');
      await d.enter('principal', numberField('Loan amount'), '1200000');
      await d.enter('rate', numberField('Nominal interest rate'), '7.49');
      final loan = const LoanEngine().compute(const LoanInput(principal: 1200000, annualRatePercent: 7.49, months: 60));
      expect(find.textContaining(Formats('en').number(loan.firstInstallment)), findsWidgets);
      await d.tap('schedule', find.textContaining('Full schedule'));
      await d.back('schedule back');
      await d.tap('prepay cta', find.textContaining('Calculate your scenario'));
      await d.enter('prepay amount', numberField('Extra payment'), '200000');
      await d.back('prepay back');
      await d.scrollToTop();
      await d.tap('savings', find.text('Savings'));
      await d.enter('deposit', numberField('Deposit'), '10000');
      await d.enter('deposit rate', numberField('Interest rate'), '3');
      await d.tap('compare', find.text('Compare'));
      await d.enter('compare amount', numberField('Loan amount'), '1000000');
      await d.enter('offer 1 rate', numberField('Nominal interest rate'), '6');
      await d.tap('add offer', find.text('Add offer'));

      await d.tab('Rates');
      await d.enter('fx amount', bigAmount(), '250');
      await d.tap('swap', find.byTooltip('Swap currencies'));
      await d.tap('buying', find.text('Buying'));
      await d.tap('365 days', find.text('365 d'));
      await d.scrollToTop();
      await d.tap('rate list', find.text('Rate list'));
    });

    testWidgets('business: profile, invoice lifecycle, paušal $tag', (tester) async {
      setScreen(tester, width: w, height: h, textScale: s);
      final services = await makeServices(pro: true);
      await pumpApp(tester, services);
      final d = Driver(tester);

      await d.tab('Business');
      await d.tap('new invoice', find.text('New'));
      // First run: business details.
      await d.enter('name', labelled('Business name'), 'Studio Zeleni');
      await d.enter('city', labelled('Postcode and city'), '11000 Beograd');
      await d.enter('pib bad', labelled('Tax ID (PIB)'), '101134703');
      await d.tap('save invalid', find.widgetWithText(FilledButton, 'Save'));
      expect(
        find.text('The PIB check digit doesn’t match — please check it.').evaluate().isNotEmpty || find.textContaining('check digit').evaluate().isNotEmpty,
        isTrue,
      );
      await d.enter('pib good', labelled('Tax ID (PIB)'), '101134702');
      await d.enter('account', labelled('Bank account'), '160-5020001234-64');
      await d.tap('save profile', find.widgetWithText(FilledButton, 'Save'));
      expect(services.business.profile.party.name, 'Studio Zeleni');

      // Editor.
      expect(find.text('New invoice'), findsOneWidget);
      await d.tap('issue empty', find.text('Issue invoice'));
      expect(services.business.invoices, isEmpty, reason: 'incomplete invoice must not be issued');
      await d.enter('client', labelled('Client name'), 'Klijent d.o.o.');
      await d.enter('item', labelled('Description'), 'Web development');
      await d.enter('qty', labelled('Quantity'), '10');
      await d.enter('price', labelled('Unit price'), '5000');
      await d.tap('add item', find.text('Add item'));
      await d.tap('remove item', find.byTooltip('Remove item').last);
      await d.tap('issue', find.text('Issue invoice'));
      expect(services.business.invoices.single.status, InvoiceStatus.issued);
      expect(services.business.invoices.single.total, 50000);

      // Viewer.
      expect(find.text('Scan to pay (NBS IPS)'), findsWidgets);
      await d.tap('mark paid', find.text('Mark as paid'));
      expect(services.business.invoices.single.status, InvoiceStatus.paid);
      await d.tap('share pdf', find.text('Share PDF'));
      await d.tap('menu', find.byTooltip('More options'));
      await d.tap('duplicate', find.text('Duplicate'));
      await d.tap('save draft', find.text('Save draft'));
      expect(services.business.invoices.length, 2);
      await d.back('view back');

      // List, paušal, delete.
      await d.tap('invoice row', find.text('Klijent d.o.o.').first);
      await d.tap('menu 2', find.byTooltip('More options'));
      await d.tap('delete', find.text('Delete invoice'));
      await d.tap('confirm delete', find.text('Delete'));
      expect(services.business.invoices.length, 1);
      await d.tap('pausal card', find.textContaining('Paušal ·'));
      await d.tap('add revenue', find.text('Add revenue'));
      await d.enter('revenue amount', labelled('Amount in RSD'), '120000');
      await d.tap('save revenue', find.widgetWithText(FilledButton, 'Save'));
      expect(services.business.manualRevenue.length, 1);
      await d.back('pausal back');
    });

    testWidgets('calculators, team, comparison, history, settings $tag', (tester) async {
      setScreen(tester, width: w, height: h, textScale: s);
      final services = await makeServices(pro: true);
      await pumpApp(tester, services);
      final d = Driver(tester);

      await d.tap('vat', find.text('VAT'));
      await d.enter('vat amount', bigAmount(), '1000');
      expect(find.textContaining('1,200.00'), findsWidgets);
      await d.tap('extract', find.text('Extract VAT'));
      await d.tap('other rate', find.text('Other'));
      await d.back();

      await d.tap('margin', find.text('Margin and markup'));
      await d.enter('cost', numberField('Cost price'), '80');
      await d.enter('price', numberField('Selling price (excl. VAT)'), '100');
      await d.tap('markup mode', find.text('Markup'));
      await d.tap('margin mode', find.text('Margin'));
      await d.back();

      await d.tap('break-even', find.text('Break-even'));
      await d.enter('fixed', numberField('Fixed costs per month'), '100000');
      await d.enter('unit price', numberField('Price per unit'), '1500');
      await d.enter('variable', numberField('Variable cost per unit'), '700');
      expect(find.textContaining('125 units'), findsWidgets);
      await d.back();

      await d.tap('investment', find.text('Investment'));
      await d.enter('initial', numberField('Initial investment'), '1000000');
      await d.enter('year 1', numberField('Year 1'), '-100000');
      await d.enter('year 2', numberField('Year 2'), '600000');
      await d.enter('year 3', numberField('Year 3'), '700000');
      await d.tap('add year', find.text('Add year'));
      await d.back();

      await d.tap('team', find.text('Team cost'));
      await d.tap('add employee', find.text('Add employee').last);
      await d.enter('member name', labelled('Name'), 'Ana');
      await d.enter('member pay', bigAmount(), '200000');
      await d.tap('member save', find.widgetWithText(FilledButton, 'Save'));
      expect(services.team.members.length, 1);
      await d.tap('annual', find.text('Annual'));
      await d.back();

      await d.tap('compare countries', find.text('Compare countries'));
      await d.enter('compare amount', bigAmount(), '3000');
      expect(find.text('Ranked by net pay'.toUpperCase()), findsOneWidget);
      await d.tap('net mode', find.text('Net → gross'));
      await d.back();

      await d.scrollToTop();
      await d.settle();
      await d.tap('see all', find.text('See all'));
      expect(find.text('Offer').evaluate().isNotEmpty || services.history.all.isNotEmpty, isTrue);
      await d.back();

      await d.scrollToTop();
      await d.tap('settings', find.byTooltip('Settings'));
      await d.tap('country', find.text('Country').evaluate().isNotEmpty ? find.text('Country') : find.text('Your country'));
      await d.tap('pick BA', find.text('Bosnia and Herzegovina').last);
      expect(services.settings.country.code, 'BA');
      await d.tap('export', find.text('Export backup'));
      await d.tap('dark', find.text('Dark'));
    });

    testWidgets('free plan: locks, paywall and limits $tag', (tester) async {
      setScreen(tester, width: w, height: h, textScale: s);
      final services = await makeServices();
      await pumpApp(tester, services);
      final d = Driver(tester);

      await d.tap('locked tool', find.text('Team cost'));
      expect(find.textContaining('is part of Bilans Pro'), findsWidgets, reason: 'paywall opens');
      await d.reveal(find.text('2.490 RSD'));
      expect(find.text('2.490 RSD'), findsOneWidget);
      await d.tap('monthly plan', find.text('Monthly'));
      d.step = 'buy';
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(lastGateway.bought, [AppConfig.proMonthly]);
      // Play reports the person backed out of the payment sheet.
      lastGateway.controller.add([purchase(AppConfig.proMonthly, PurchaseStatus.canceled)]);
      await d.settle();
      expect(services.pro.isPro, isFalse);
      await d.back('close paywall');
      expect(find.text('Team cost'), findsWidgets);
      // A second attempt succeeds and unlocks the tool.
      await d.tap('locked tool again', find.text('Team cost'));
      await d.tap('yearly plan', find.text('Yearly'));
      await tester.tap(find.text('Start 7-day free trial'));
      await tester.pump();
      lastGateway.controller.add([purchase(AppConfig.proYearly, PurchaseStatus.purchased, pendingComplete: true)]);
      await d.settle();
      expect(services.pro.isPro, isTrue);
      await d.tap('welcome continue', find.text('Continue'));
      expect(find.text('Team cost'), findsWidgets, reason: 'the tool opens after purchase');
      await d.back('team back');

      // Saved-calculation limit (on a fresh free account).
      await services.pro.reconcile();
      lastGateway.owned = const [];
      await services.pro.reconcile();
      expect(services.pro.isPro, isFalse);
      for (var i = 0; i < 5; i++) {
        await services.history.saveNamed(ToolId.vat, {'amount': i + 1, 'rate': 20.0}, 'n$i');
      }
      await d.tap('vat', find.text('VAT'));
      await d.enter('vat amount', bigAmount(), '1000');
      await d.tap('save over limit', find.text('Save'));
      expect(find.textContaining('Unlimited saved calculations'), findsWidgets, reason: 'paywall names the limit');
      await d.back('close paywall 2');
      await d.back();
    });
  }
}

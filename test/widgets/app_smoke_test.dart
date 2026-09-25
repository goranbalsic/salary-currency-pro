import 'package:bilans/app/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'flows_test.dart' show Driver;
import 'harness.dart';

/// Taps the first widget matching [finder], scrolling lazy lists until it
/// is built (short landscape screens build little at a time).
Future<void> tapOn(WidgetTester tester, Finder finder) => Driver(tester).tap(finder.toString(), finder);

Future<void> back(WidgetTester tester) async {
  final NavigatorState nav = tester.state(find.byType(Navigator).last);
  await nav.maybePop();
  await tester.pumpAndSettle();
}

Future<void> goTab(WidgetTester tester, String label) async {
  await tester.tap(find.bySemanticsLabel(label).last);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  for (final (width, height, scale) in [
    (360.0, 800.0, 1.0),
    (320.0, 640.0, 1.0),
    (360.0, 800.0, 1.6),
    (412.0, 915.0, 1.3),
    // Unfolded foldable, tablet portrait and landscape, landscape phone.
    (673.0, 841.0, 1.0),
    (800.0, 1280.0, 1.0),
    (1280.0, 800.0, 1.0),
    (800.0, 360.0, 1.0),
  ]) {
    group('${width.toInt()}x${height.toInt()} @${scale}x', () {
      testWidgets('onboarding to home', (tester) async {
        setScreen(tester, width: width, height: height, textScale: scale);
        final services = await makeServices(onboarded: false);
        await pumpApp(tester, services);
        expect(find.text('Numbers you can trust.'), findsOneWidget);
        await tapOn(tester, find.text('Croatia'));
        await tapOn(tester, find.text('Continue'));
        expect(services.settings.country.code, 'HR');
        expect(find.text('RATES TODAY'), findsOneWidget);
      });

      testWidgets('every tab and every tool opens without errors', (tester) async {
        setScreen(tester, width: width, height: height, textScale: scale);
        final services = await makeServices(pro: true);
        await pumpApp(tester, services);
        await _visitEverything(tester, services);
      });
    });
  }
}

Future<void> _visitEverything(WidgetTester tester, AppServices services) async {
  // Home: open each stand-alone tool from the index and come back.
  for (final title in ['Team cost', 'Compare countries', 'Early repayment', 'Paušal limits', 'VAT', 'Margin and markup', 'Break-even', 'Investment']) {
    await tapOn(tester, find.text(title));
    expect(find.byType(AppBar), findsWidgets, reason: title);
    await back(tester);
  }

  // Pay tab: enter an amount, switch modes.
  await goTab(tester, 'Pay');
  await tester.enterText(find.byType(TextField).first, '150000');
  await tester.pumpAndSettle();
  expect(find.textContaining('108.572,10').evaluate().isNotEmpty || find.textContaining('108,572.10').evaluate().isNotEmpty, isTrue);
  await tapOn(tester, find.text('Net → gross'));
  await tapOn(tester, find.text('Total cost'));

  // Loans tab: loan, savings, compare.
  await goTab(tester, 'Loans');
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), '1200000');
  await tester.enterText(fields.at(1), '7,49');
  await tester.pumpAndSettle();
  await tapOn(tester, find.text('Savings'));
  await tapOn(tester, find.text('Compare'));
  await tapOn(tester, find.text('Loan'));

  // Rates tab: converter and list.
  await goTab(tester, 'Rates');
  await tapOn(tester, find.text('Rate list'));
  await tapOn(tester, find.text('Converter'));

  // Business tab: profile, invoice, tools.
  await goTab(tester, 'Business');
  await tapOn(tester, find.byTooltip('Business details'));
  await back(tester);
  await tapOn(tester, find.text('New'));
  expect(find.text('Business details'), findsWidgets, reason: 'first invoice asks for business details');
  await back(tester);

  // Settings.
  await goTab(tester, 'Home');
  await tester.fling(find.byType(Scrollable).first, const Offset(0, 4000), 4000);
  await tester.pumpAndSettle();
  await tapOn(tester, find.byTooltip('Settings'));
  await tapOn(tester, find.text('Dark'));
  await tapOn(tester, find.text('Light'));
  await back(tester);
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
  });

  testWidgets(
    'Salary tab: gross-to-net calculation shows a full breakdown with the disclaimer',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SalaryCurrencyProApp());
      await tester.pumpAndSettle();

      // Home's own shortcut list also has a "Salary" label, so scope this
      // to the bottom NavigationBar specifically.
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Salary'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Serbia Salary Calculator'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '100000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
      await tester.pumpAndSettle();

      // Hand-verified: bruto1=100,000 -> neto=73,522.10 RSD.
      expect(find.textContaining('73,522.10'), findsOneWidget);
      expect(find.textContaining('not constitute tax'), findsOneWidget);
    },
  );

  testWidgets(
    'Salary tab: rejects negative input without crashing and without calculating',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SalaryCurrencyProApp());
      await tester.pumpAndSettle();

      // Home's own shortcut list also has a "Salary" label, so scope this
      // to the bottom NavigationBar specifically.
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Salary'),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '-500');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
      await tester.pumpAndSettle();

      expect(find.text("Salary can't be negative."), findsOneWidget);
      expect(find.text('Neto (take-home)'), findsNothing);
    },
  );

  testWidgets(
    'Salary tab: switching mode clears any stale result',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SalaryCurrencyProApp());
      await tester.pumpAndSettle();

      // Home's own shortcut list also has a "Salary" label, so scope this
      // to the bottom NavigationBar specifically.
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Salary'),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '100000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
      await tester.pumpAndSettle();
      expect(find.text('Neto (take-home)'), findsOneWidget);

      await tester.tap(find.text('Net → Gross'));
      await tester.pumpAndSettle();

      expect(find.text('Neto (take-home)'), findsNothing);
    },
  );

  testWidgets(
    'Salary tab: a free-tier user switching countries sees an upgrade '
    'prompt instead, and stays on their current country',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SalaryCurrencyProApp());
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Salary'),
      ));
      await tester.pumpAndSettle();

      // Default country is Serbia — open the picker and lock icons should
      // mark every other country.
      await tester.tap(find.text('Serbia'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.lock_outline), findsWidgets);

      await tester.tap(find.text('Croatia'));
      await tester.pumpAndSettle();

      expect(find.text('Switch countries with Pro'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Still Serbia — the picker sheet closed without switching.
      expect(find.text('Serbia'), findsOneWidget);
    },
  );

  testWidgets(
    'Salary tab: a Pro user can switch countries freely, no lock icons '
    'or upgrade prompt',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        'entitlement_state_v1': '{"schemaVersion":1,"status":"lifetime","productId":"pro_lifetime"}',
      });
      await tester.pumpWidget(const SalaryCurrencyProApp());
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Salary'),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Serbia'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.lock_outline), findsNothing);

      await tester.tap(find.text('Croatia'));
      await tester.pumpAndSettle();

      expect(find.text('Switch countries with Pro'), findsNothing);
      expect(find.text('Croatia'), findsOneWidget);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003 Stage C item 12.1: the invoice detail screen's action
/// hierarchy (Generate PDF first, then mark paid/unpaid, then delete last
/// and visually separated) and its no-duplicate-export-state behavior.
void main() {
  setUp(() {
    // Same as test/widget_test.dart: skip onboarding, and give the
    // viewport enough height that the detail screen's action buttons are
    // never left outside the visible/hit-testable area.
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  });

  Future<void> openInvoicesTab(WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invoices'));
    await tester.pumpAndSettle();
  }

  Future<void> addInvoiceAndOpenDetail(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('invoice_client_field')), 'Acme d.o.o.');
    await tester.enterText(find.byKey(const Key('invoice_amount_field')), '500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Acme d.o.o.'));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Invoice detail: tapping a tile opens the detail screen with the '
      'expected action hierarchy', (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    // Identity/status header is scannable at a glance.
    expect(find.text('Acme d.o.o.'), findsWidgets);
    expect(find.text('Unpaid'), findsOneWidget);

    // Generate PDF is the primary, document action.
    expect(find.widgetWithText(ElevatedButton, 'Generate PDF'), findsOneWidget);
    // Mark paid/unpaid is a secondary action.
    expect(find.widgetWithText(OutlinedButton, 'Mark as paid'), findsOneWidget);
    // Delete is present but visually separated (a plain TextButton, not an
    // ElevatedButton/OutlinedButton like the actions above it).
    expect(find.widgetWithText(TextButton, 'Delete'), findsOneWidget);
  });

  testWidgets(
      'Invoice detail: Generate PDF shows feedback and does not double-fire '
      'on a rapid second tap', (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate PDF'));
    // Immediately tap again before the first call settles — the button
    // should already be disabled (in-flight), so this must not queue a
    // second action.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate PDF'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('PDF export is coming in a future update.'), findsOneWidget);
  });

  testWidgets(
      'Invoice detail: marking paid updates the status shown on the detail '
      'screen itself', (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Mark as paid'));
    await tester.pumpAndSettle();

    expect(find.text('Paid'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Mark as unpaid'), findsOneWidget);
  });

  testWidgets(
      'Invoice detail: deleting (after confirmation) returns to the list '
      'with the invoice gone', (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete this invoice?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('No invoices yet'), findsOneWidget);
  });
}

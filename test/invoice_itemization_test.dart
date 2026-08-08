import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003 Stage C item 12.1: itemization in the invoice add/edit sheet
/// is additive — it doesn't disturb the original single-amount flow, and
/// when used, the amount field becomes a read-only, correctly-rounded
/// total.
void main() {
  setUp(() {
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

  testWidgets(
      'Adding line items switches the amount field to a read-only, '
      'correctly-rounded total, and the invoice list shows that total',
      (WidgetTester tester) async {
    await openInvoicesTab(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('invoice_client_field')), 'Acme d.o.o.');

    // Before any item is added, the amount field is a normal editable
    // field — unchanged from the pre-item-12 flow.
    final amountFieldBefore = tester.widget<TextField>(find.byKey(const Key('invoice_amount_field')));
    expect(amountFieldBefore.readOnly, isFalse);

    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();
    // Field order: client(0), description(1), invoice number(2), amount(3),
    // then the new item row's description(4)/quantity(5)/unit price(6).
    await tester.enterText(find.byType(TextField).at(4), 'Design');
    await tester.enterText(find.byType(TextField).at(5), '3');
    await tester.enterText(find.byType(TextField).at(6), '0.1');
    await tester.pumpAndSettle();

    // Once an item exists, the amount field becomes read-only and reflects
    // the deterministic, rounded total (3 * 0.1 -> 0.30, not a raw-double
    // artifact like 0.30000000000000004).
    final amountFieldAfter = tester.widget<TextField>(find.byKey(const Key('invoice_amount_field')));
    expect(amountFieldAfter.readOnly, isTrue);
    expect(amountFieldAfter.controller!.text, '0.3');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('0.3'), findsWidgets);
  });

  testWidgets('Removing the only item reverts the amount field to editable',
      (WidgetTester tester) async {
    await openInvoicesTab(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('invoice_client_field')), 'Acme');
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byKey(const Key('invoice_amount_field'))).readOnly,
      isTrue,
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byKey(const Key('invoice_amount_field'))).readOnly,
      isFalse,
    );
  });
}

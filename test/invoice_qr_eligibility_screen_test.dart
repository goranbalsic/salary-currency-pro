import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003 Stage C item 12.3: the invoice detail screen's NBS IPS QR
/// eligibility transparency — shown only for RSD invoices, and always as
/// plain text (never a bare disabled control) explaining availability.
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

  Future<void> addInvoice(WidgetTester tester, {required String currencyCode}) async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('invoice_client_field')), 'Acme');
    await tester.enterText(find.byKey(const Key('invoice_amount_field')), '500');
    if (currencyCode != 'EUR') {
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(currencyCode).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Acme').first);
    await tester.pumpAndSettle();
  }

  testWidgets('A non-RSD invoice shows no QR messaging at all', (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoice(tester, currencyCode: 'EUR');

    expect(find.textContaining('NBS IPS'), findsNothing);
  });

  testWidgets(
      'An RSD invoice with no business profile set up shows the '
      'incomplete-data explanation, not a bare disabled control',
      (WidgetTester tester) async {
    await openInvoicesTab(tester);
    await addInvoice(tester, currencyCode: 'RSD');

    expect(
      find.text('Add your bank account and payment code in Settings → Business profile '
          'to include a scannable payment QR code on this invoice.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'An RSD invoice with a complete business profile shows the eligible '
      'confirmation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'business_profile_v1':
          '{"businessName":"Čigra doo","addressLine1":"","addressLine2":"",'
              '"bankAccountNumber":"840-955845-10","defaultPaymentCode":"289"}',
    });

    await openInvoicesTab(tester);
    await addInvoice(tester, currencyCode: 'RSD');

    expect(
      find.text('This invoice will include a scannable NBS IPS payment code.'),
      findsOneWidget,
    );
  });
}

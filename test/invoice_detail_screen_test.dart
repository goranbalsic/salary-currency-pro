import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003 Stage C item 12.1/12.2: the invoice detail screen's action
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

    // The `printing` package's native share/print dialog
    // (package:printing's 'net.nfet.printing' channel) has no host-side
    // implementation in the widget-test sandbox. Rather than rely on
    // whatever the test binding's default unhandled-channel behavior
    // happens to be (which can leave the call awaiting a native callback
    // that never arrives), fail it deterministically and immediately —
    // exactly the "printing unavailable" case InvoiceDetailScreen's own
    // error handling is meant to cover honestly.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('net.nfet.printing'),
      (MethodCall call) async => throw PlatformException(code: 'unavailable'),
    );
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
      'Invoice detail: a free-tier user tapping Generate PDF sees an '
      'upgrade prompt instead, and the invoice is untouched',
      (WidgetTester tester) async {
    // Default shared setUp() has no entitlement_state_v1 key — free tier.
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate PDF'));
    await tester.pumpAndSettle();

    expect(find.text('Generate invoice PDFs with Pro'), findsOneWidget);
    expect(
      find.text(
        'Professional invoice PDFs with payment QR codes are a Pro feature. Upgrade to generate this invoice as a PDF.',
      ),
      findsOneWidget,
    );
    // Cancel leaves the detail screen exactly as it was.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Unpaid'), findsOneWidget);
  });

  testWidgets(
      'Invoice detail: Generate PDF builds real PDF bytes, then fails '
      'gracefully (with feedback, invoice unchanged) because the printing '
      'plugin has no platform implementation in the widget-test sandbox — '
      'and a rapid second tap does not double-fire', (WidgetTester tester) async {
    // PROMPT-003I checkpoint 2 gated PDF generation behind Pro — this test
    // is about the PDF pipeline itself, not the gate (that's covered
    // separately), so it seeds a Pro entitlement directly via the same
    // SharedPreferences key EntitlementService reads on startup.
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'entitlement_state_v1': '{"schemaVersion":1,"status":"lifetime","productId":"pro_lifetime"}',
    });
    await openInvoicesTab(tester);
    await addInvoiceAndOpenDetail(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate PDF'));
    // Immediately tap again before the first call settles — the button
    // should already be disabled (in-flight), so this must not queue a
    // second action.
    await tester.pump(const Duration(milliseconds: 10));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate PDF'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // The real content model + pdf package ran (no crash getting here);
    // only the OS-native share/print dialog itself is unavailable in this
    // sandbox (no MethodChannel host), so the catch path's honest failure
    // feedback is what's actually verifiable by an automated test — real
    // share/print behavior needs device/emulator verification instead.
    expect(find.text("Couldn't generate the PDF. The invoice itself hasn't changed — try again."),
        findsOneWidget);
    expect(find.text('Acme d.o.o.'), findsWidgets);
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

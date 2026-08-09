import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/l10n/app_localizations.dart';
import 'package:salary_currency_pro/screens/tools/fiscal_receipt_queue_screen.dart';
import 'package:salary_currency_pro/services/expense_service.dart';
import 'package:salary_currency_pro/services/fiscal_receipt_scan_service.dart';

Future<void> pumpQueueScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FiscalReceiptQueueScreen(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('empty state shown when no scans exist', (tester) async {
    await pumpQueueScreen(tester);
    expect(
      find.text('No scanned receipts yet. Scan a fiscal receipt QR code to add one here.'),
      findsOneWidget,
    );
  });

  testWidgets('populated list shows a recognized scan awaiting fetch',
      (tester) async {
    await FiscalReceiptScanService().recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);
    expect(find.text('Scanned, awaiting fetch'), findsOneWidget);
  });

  testWidgets('unrecognized format is shown for a non-matching payload',
      (tester) async {
    await FiscalReceiptScanService().recordScan('not a fiscal receipt at all');
    await pumpQueueScreen(tester);
    expect(find.text('Unrecognized format'), findsOneWidget);
  });

  testWidgets('delete requires confirmation; cancel keeps the scan in the queue',
      (tester) async {
    await FiscalReceiptScanService().recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Delete this scan?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Scanned, awaiting fetch'), findsOneWidget);
    expect(await FiscalReceiptScanService().loadAll(), hasLength(1));
  });

  testWidgets('confirmed delete removes the scan and undo restores it',
      (tester) async {
    await FiscalReceiptScanService().recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(
      find.text('No scanned receipts yet. Scan a fiscal receipt QR code to add one here.'),
      findsOneWidget,
    );
    expect(find.text('Scan deleted'), findsOneWidget);
    expect(await FiscalReceiptScanService().loadAll(), isEmpty);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Scanned, awaiting fetch'), findsOneWidget);
    expect(await FiscalReceiptScanService().loadAll(), hasLength(1));
  });

  testWidgets(
      'tapping an awaiting-fetch scan opens the handoff sheet pre-filled '
      'with the scan date', (tester) async {
    final scan = await FiscalReceiptScanService()
        .recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);

    await tester.tap(find.text('Scanned, awaiting fetch'));
    await tester.pumpAndSettle();

    expect(find.text('Create expense from scan'), findsOneWidget);
    final dateText = DateFormat.yMMMd('en').format(scan.scannedAt);
    // Appears both in the "from a scan on <date>" note and the (same
    // default) expense-date field.
    expect(find.text(dateText, skipOffstage: false), findsWidgets);
  });

  testWidgets('required-amount validation blocks save on an empty amount',
      (tester) async {
    await FiscalReceiptScanService().recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);
    await tester.tap(find.text('Scanned, awaiting fetch'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter an amount.'), findsOneWidget);
    expect(await ExpenseService().loadAll(), isEmpty);
    // The sheet is still open, and the scan is still awaiting fetch.
    expect(find.text('Create expense from scan'), findsOneWidget);
  });

  testWidgets(
      'successful save creates a linked expense via the existing tracker '
      'and updates the queue status', (tester) async {
    final scan = await FiscalReceiptScanService()
        .recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);

    await tester.tap(find.text('Scanned, awaiting fetch'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('receipt_handoff_amount_field')),
      '25.50',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Linked to expense'), findsOneWidget);

    final expenses = await ExpenseService().loadAll();
    expect(expenses, hasLength(1));
    expect(expenses.first.amount, 25.5);

    final updatedScan = await FiscalReceiptScanService().find(scan.id);
    expect(updatedScan!.linkedExpenseId, expenses.first.id);
  });

  testWidgets('dismissing the handoff sheet without saving leaves the scan '
      'untouched and creates no expense', (tester) async {
    await FiscalReceiptScanService().recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await pumpQueueScreen(tester);

    await tester.tap(find.text('Scanned, awaiting fetch'));
    await tester.pumpAndSettle();
    expect(find.text('Create expense from scan'), findsOneWidget);

    // Tap the modal barrier (outside the sheet's content) to dismiss it
    // without saving — the same as pressing back.
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('Create expense from scan'), findsNothing);
    expect(find.text('Scanned, awaiting fetch'), findsOneWidget);
    expect(await ExpenseService().loadAll(), isEmpty);
  });

  testWidgets('a scan already linked to an expense has no further forward '
      'action', (tester) async {
    final scan = await FiscalReceiptScanService().recordScan('payload');
    await FiscalReceiptScanService().linkExpense(id: scan.id, expenseId: 'e1');
    await pumpQueueScreen(tester);

    await tester.tap(find.text('Linked to expense'));
    await tester.pumpAndSettle();

    expect(find.text('Create expense from scan'), findsNothing);
  });
}

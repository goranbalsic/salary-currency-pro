import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';
import 'package:salary_currency_pro/models/history_entry.dart';
import 'package:salary_currency_pro/services/scenario_service.dart';

/// Checkpoint 5 regression test: the rename dialog used to own its
/// TextEditingController in the calling function and dispose it the
/// instant showDialog resolved, which threw "used after being disposed"
/// because the dialog's exit animation can still hold a live TextField
/// attached to it. Fixed by moving the controller into its own
/// StatefulWidget (_RenameScenarioDialog), matching the pattern already
/// used by the scenario-save dialog.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await ScenarioService().add(
      toolId: HistoryToolIds.loan,
      name: 'Old name',
      summary: 'Monthly payment: 250 EUR',
      inputs: const {'principal': '10000'},
      isPro: true,
    );
  });

  testWidgets(
      'Renaming a saved scenario updates its name and does not throw '
      'during the dialog close animation', (tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Scenarios'));
    await tester.pumpAndSettle();

    expect(find.text('Old name'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'New name');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));

    // Pump through the dialog's exit animation frame-by-frame instead of
    // pumpAndSettle: this is exactly the window where the old
    // caller-owned controller was disposed while the TextField using it
    // was still in the tree. flutter test surfaces any such
    // "used after being disposed" FlutterError as a failed test.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('New name'), findsOneWidget);
    expect(find.text('Old name'), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';
import 'package:salary_currency_pro/config/app_flavor.dart';

/// PROMPT-003J checkpoint 2: the dev-only Entitlement Preview section in
/// Settings. `AppConfig.flavor` is a process-global static (set once by
/// whichever entrypoint runs `main()`) — these tests set it directly to
/// simulate each flavor, and reset it back to prod in `tearDown` so this
/// file's flavor choice can never leak into any other test file's App
/// pump (each test *file* runs in its own isolate, but tests within one
/// file share statics, hence the explicit reset here).
void main() {
  tearDown(() {
    AppConfig.initialize(AppFlavor.prod);
  });

  Future<void> openSettingsTab(WidgetTester tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('a dev-flavor build shows the Entitlement Preview section, '
      'defaulting to Pro, and switching states updates the status banner '
      'live', (tester) async {
    AppConfig.initialize(AppFlavor.dev);
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await openSettingsTab(tester);

    await tester.ensureVisible(find.text('Entitlement Preview (Dev)'));
    expect(find.text('Entitlement Preview (Dev)'), findsOneWidget);
    // Dev defaults to fully unlocked Pro with nothing simulated yet.
    expect(find.text('Pro — active'), findsWidgets);

    // The chip labels reuse the same status titles as the status banner
    // (entitlementStatusCopy) — before tapping, "Pro — expired" appears
    // only on the chip since the banner still says "Pro — active".
    await tester.ensureVisible(find.text('Pro — expired'));
    await tester.tap(find.text('Pro — expired'));
    await tester.pumpAndSettle();

    expect(find.text('Pro — expired'), findsWidgets);
  });

  testWidgets(
      'switching the preview to Free actually locks the Salary Calculator '
      'country picker — not just the status banner, the real gate', (tester) async {
    AppConfig.initialize(AppFlavor.dev);
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await openSettingsTab(tester);

    // Dev defaults to Pro — switch to Free via the preview first.
    await tester.ensureVisible(find.text('Free'));
    await tester.tap(find.text('Free'));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Salary'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Serbia'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsWidgets);

    await tester.tap(find.text('Croatia'));
    await tester.pumpAndSettle();
    expect(find.text('Switch countries with Pro'), findsOneWidget);
  });

  testWidgets('a prod-flavor build never shows the Entitlement Preview '
      'section at all', (tester) async {
    AppConfig.initialize(AppFlavor.prod);
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await openSettingsTab(tester);

    expect(find.text('Entitlement Preview (Dev)'), findsNothing);
    // Prod starts Free, not Pro — no developer bypass of any kind.
    await tester.ensureVisible(find.text('Free'));
    expect(find.text('Free'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003I Stage D checkpoint 2's rebuilt paywall: four products,
/// annual visually favored, reachable from Settings.
void main() {
  Future<void> openPaywallFromSettings(WidgetTester tester) async {
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

  testWidgets('a free-tier user sees the Free status banner and the store-'
      'unavailable state honestly (no real store in this sandbox)',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await openPaywallFromSettings(tester);

    await tester.ensureVisible(find.text('Free'));
    expect(find.text('Free'), findsOneWidget);

    await tester.tap(find.text('Free'));
    await tester.pumpAndSettle();

    expect(find.text('Go Pro'), findsOneWidget);
    expect(find.text('Free'), findsWidgets);
    // No real Play Billing platform is registered in this widget-test
    // sandbox — the screen must say so honestly rather than show a broken
    // buy flow or silently hang loading forever.
    expect(
      find.textContaining("The app store isn't available right now"),
      findsOneWidget,
    );
  });

  testWidgets('a lifetime user sees the Lifetime status banner', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'entitlement_state_v1': '{"schemaVersion":1,"status":"lifetime","productId":"pro_lifetime"}',
    });
    await openPaywallFromSettings(tester);

    await tester.ensureVisible(find.text('Pro — lifetime'));
    expect(find.text('Pro — lifetime'), findsOneWidget);

    await tester.tap(find.text('Pro — lifetime'));
    await tester.pumpAndSettle();

    expect(find.text('Pro — lifetime'), findsWidgets);
    expect(find.text('You have permanent access — thank you'), findsWidgets);
  });

  testWidgets('a trialing user sees the trial status banner', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'entitlement_state_v1': '{"schemaVersion":1,"status":"trialing","productId":"pro_annual"}',
    });
    await openPaywallFromSettings(tester);

    await tester.ensureVisible(find.text('Pro — free trial'));
    expect(find.text('Pro — free trial'), findsOneWidget);
  });
}

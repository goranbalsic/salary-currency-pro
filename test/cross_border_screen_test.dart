import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';

/// PROMPT-003G — Stage C item 13: the Cross-Border Pack comparison screen.
/// Covers initial/populated/narrow-layout/unavailable-data/accessible-label
/// states, per the prompt's own test requirements.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
  });

  Future<void> openCrossBorderScreen(WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Cross-Border Comparison'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cross-Border Comparison'));
    await tester.pumpAndSettle();
  }

  testWidgets('initial state: shows the empty-state hint, no table yet', (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);

    expect(find.text('Enter a gross salary and tap Calculate to compare all 9 countries.'), findsOneWidget);
    expect(find.byType(DataTable), findsNothing);
  });

  testWidgets(
      'populated + unavailable-data state: EUR-native countries show real figures, '
      'non-cached currencies show an explicit unavailable cell, not a guessed number',
      (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);

    await tester.enterText(find.byKey(const Key('cross_border_gross_field')), '2000');
    await tester.tap(find.byKey(const Key('cross_border_calculate_button')));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    // Croatia is EUR-native — always resolvable even with an empty rate cache.
    expect(find.text('Croatia'), findsOneWidget);
    // Serbia (RSD) has no cached rate on a fresh install — must show an
    // explicit unavailable marker for every numeric cell in that row, never
    // a guessed figure.
    expect(find.text('Serbia'), findsOneWidget);
    expect(find.text('—'), findsWidgets);
  });

  testWidgets('accessible-label state: an unavailable cell carries a real, readable tooltip/semantics message',
      (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);
    await tester.enterText(find.byKey(const Key('cross_border_gross_field')), '2000');
    await tester.tap(find.byKey(const Key('cross_border_calculate_button')));
    await tester.pumpAndSettle();

    expect(
      find.byTooltip('No cached rate for RSD yet — convert it once in the Currency Converter to enable this row.'),
      findsWidgets,
    );
  });

  testWidgets('narrow-screen layout: the table scrolls horizontally without an overflow error',
      (tester) async {
    final view = tester.view;
    // A realistic small phone width — the table is wider than this and must
    // scroll rather than overflow.
    view.physicalSize = const Size(360, 1800);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);
    await tester.enterText(find.byKey(const Key('cross_border_gross_field')), '2000');
    await tester.tap(find.byKey(const Key('cross_border_calculate_button')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(DataTable), findsOneWidget);
    // The table lives inside a horizontally-scrollable ancestor so it can
    // exceed the narrow viewport width without clipping/overflowing.
    expect(
      find.ancestor(of: find.byType(DataTable), matching: find.byType(SingleChildScrollView)),
      findsOneWidget,
    );
  });

  testWidgets('tapping an available row opens the full breakdown detail sheet', (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);
    await tester.enterText(find.byKey(const Key('cross_border_gross_field')), '2000');
    await tester.tap(find.byKey(const Key('cross_border_calculate_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Croatia'));
    await tester.pumpAndSettle();

    expect(find.text('Bruto (gross)'), findsWidgets);
    expect(find.text('Neto (take-home)'), findsWidgets);
  });

  testWidgets('an amount validation issue shows an explicit error, not a silent no-op', (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await openCrossBorderScreen(tester);
    await tester.tap(find.byKey(const Key('cross_border_calculate_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a salary.'), findsOneWidget);
    expect(find.byType(DataTable), findsNothing);
  });
}

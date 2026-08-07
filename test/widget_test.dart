import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/app.dart';
import 'package:salary_currency_pro/screens/settings/settings_screen.dart';

void main() {
  setUp(() {
    // Onboarding is covered by its own dedicated tests below; every other
    // test in this file exercises the main app past onboarding, so it
    // starts pre-completed here exactly like a returning real user.
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});

    // The test environment has no default handler for the clipboard
    // platform channel, so Clipboard.setData/getData otherwise hang
    // indefinitely rather than throwing — mock it in-memory, the standard
    // pattern for testing clipboard-based features.
    final clipboardStore = <String, dynamic>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        if (call.method == 'Clipboard.setData') {
          clipboardStore['text'] = (call.arguments as Map)['text'];
          return null;
        }
        if (call.method == 'Clipboard.getData') {
          return {'text': clipboardStore['text']};
        }
        return null;
      },
    );
    // The expense tracker/budgets screens keep growing taller (summary,
    // category breakdown, insights cards) as features are added — rather
    // than chasing scroll offsets after every addition, give these tests a
    // tall virtual viewport so the content they check for isn't clipped or
    // left outside the ListView's lazily-built range in the first place.
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(800, 2400);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  });

  testWidgets('Onboarding: shown on first launch, skip completes it and opens on Home',
      (WidgetTester tester) async {
    // Overrides setUp()'s default so onboarding hasn't been completed yet —
    // this is the one scenario in this file that specifically needs that.
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Salary & Currency Pro'), findsOneWidget);

    // A fresh widget tree (simulated relaunch) never shows onboarding again.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Welcome'), findsNothing);
  });

  testWidgets(
      'Onboarding: picking the salary goal completes onboarding on the Salary tab',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_welcome_continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_privacy_continue')));
    await tester.pumpAndSettle();

    // "Get started" stays disabled until a goal is picked.
    final getStartedBefore =
        tester.widget<ElevatedButton>(find.byKey(const Key('onboarding_get_started')));
    expect(getStartedBefore.onPressed, isNull);

    await tester.tap(find.byKey(const Key('onboarding_goal_salary')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_get_started')));
    await tester.pumpAndSettle();

    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 2); // Salary tab, per the chosen goal.
  });

  testWidgets('App launches on Home and can navigate to the currency converter',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    expect(find.text('Salary & Currency Pro'), findsOneWidget);

    // Home's own shortcut list also has a "Convert" label, so scope this
    // tap to the bottom NavigationBar specifically.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Convert'),
    ));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Convert'), findsOneWidget);
  });

  testWidgets('Tools tab groups tools into categories and search filters them',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    // Category headers and tool tiles visible before searching. The Track &
    // Plan category (Expense Tracker) sits first now, pushing Budgeting &
    // Tax/Freelance below the initial viewport — those are checked after
    // scrolling, further down.
    expect(find.text('Track & Plan'), findsOneWidget);
    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Loans & Savings'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'VAT');
    await tester.pumpAndSettle();

    expect(find.text('VAT Calculator'), findsOneWidget);
    expect(find.text('Loans & Debt'), findsNothing);
    expect(find.text('Loans & Savings'), findsNothing);

    await tester.enterText(find.byType(TextField), 'no such tool');
    await tester.pumpAndSettle();
    expect(find.text('No tools found'), findsOneWidget);

    // PROMPT-005 Part 4: the retired Serbia-only "Freelancer Tax" tool's
    // legal search terms must still find the unified replacement, via its
    // non-displayed searchKeywords — not just its generic title/subtitle.
    await tester.enterText(find.byType(TextField), 'samooporezivanje');
    await tester.pumpAndSettle();
    expect(find.text('Freelancer Self-Assessment'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'PP OPO-K');
    await tester.pumpAndSettle();
    expect(find.text('Freelancer Self-Assessment'), findsOneWidget);

    // Clear the search, then drag the list down to confirm the categories
    // further down (off the initial viewport) are also present. The Tools
    // ListView is dragged directly rather than relying on
    // scrollUntilVisible's automatic Scrollable lookup, which also matches
    // the search field's internal (EditableText) scrollable and errors on
    // ambiguity.
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Budgeting & Tax'), findsOneWidget);
    expect(find.text('VAT Calculator'), findsOneWidget);
    expect(find.text('Loans & Debt'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Freelance'), findsOneWidget);
  });

  testWidgets('Settings clear history removes the Tools "Recently used" section',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    // Run the VAT calculator once so a "recently used" entry exists to clear.
    // The My Scenarios card and the Track & Plan/Expense Tracker category
    // above the search bar push this below the initial viewport — the
    // ListView's Sliver won't have built a far-off-screen item for
    // find.text/ensureVisible to see, so drag first to bring it into the
    // built range, then ensureVisible for exact positioning before tapping.
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('VAT Calculator'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('VAT Calculator'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '100');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Scroll back to the top — "Recently used" sits above the point we
    // scrolled to for the VAT Calculator tap, and the ListView's Sliver
    // won't have built it while it's out of range.
    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();

    expect(find.text('Recently used'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();

    final settingsScrollable = find.descendant(
      of: find.byType(SettingsScreen),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Clear history'),
      200,
      scrollable: settingsScrollable,
    );
    await tester.tap(find.text('Clear history'));
    await tester.pumpAndSettle();
    expect(find.text('Clear history?'), findsOneWidget);

    // Cancel leaves the history untouched.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Recently used'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Clear history'),
      200,
      scrollable: settingsScrollable,
    );
    await tester.tap(find.text('Clear history'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('History cleared'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Recently used'), findsNothing);
  });

  testWidgets(
      'Expense tracker: Home shows an empty-state card, adding an income '
      'entry updates the balance shown both in the tracker and back on Home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    // Home's overview card starts in its empty state — no transactions yet.
    expect(find.text('Track your income and expenses'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet this month. Tap + to add your first income or expense.'),
        findsOneWidget);
    // The empty state pairs the message with an icon (Phase 11 visual
    // polish), matching the app's existing icon+text empty-state pattern
    // (see My Scenarios).
    expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add income'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('expense_amount_field')), '1000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    // The sheet closed and the new income now drives a EUR balance card.
    expect(find.text('Balance'), findsOneWidget);
    expect(find.textContaining('1,000'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Home'),
    ));
    await tester.pumpAndSettle();

    // Home's overview card now reflects the same balance instead of the
    // empty state.
    expect(find.text('Track your income and expenses'), findsNothing);
    expect(find.textContaining('1,000'), findsWidgets);
  });

  testWidgets(
      'Expense tracker: editing a transaction updates it in place, and '
      'deleting offers an undo that restores it',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    // The 500.00 figure shows up in both the summary card and the
    // transaction row, so there's more than one match.
    expect(find.textContaining('500.00'), findsWidgets);

    // Tap the transaction row (not the trailing delete icon) to edit it.
    // "Other" also appears in the Spending by category card, so scope the
    // tap to the transaction's own ListTile specifically.
    await tester.tap(find.descendant(of: find.byType(ListTile), matching: find.text('Other')));
    await tester.pumpAndSettle();
    expect(find.text('Edit transaction'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('expense_amount_field')), '750');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('750.00'), findsWidgets);
    expect(find.textContaining('500.00'), findsNothing);

    // Delete it, confirm, then use the snackbar's Undo to bring it back.
    // The Spending by category card now pushes the single transaction row
    // down near the bottom-right corner, where it can sit directly under
    // the floating action button (which stays fixed on screen regardless
    // of scroll and always wins the hit test) — scroll up first so the
    // delete icon's tap doesn't land on the FAB instead.
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(ListTile),
      matching: find.byIcon(Icons.delete_outline),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Transaction deleted'), findsOneWidget);
    expect(find.textContaining('750.00'), findsNothing);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.textContaining('750.00'), findsWidgets);
  });

  testWidgets(
      'Expense tracker: search and the income/expense filter narrow the '
      'visible list without changing the underlying data',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();

    // One income (defaults to the Salary category) and one expense
    // explicitly categorized as Groceries.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add income'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '1000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Groceries'));
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '50');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    // "Groceries" also appears in the Spending by category card once it has
    // data, so list-membership checks are scoped to the transaction row's
    // own ListTile — the category card is a running total independent of
    // the search/filter controls below, and is checked separately.
    Finder inList(String text) =>
        find.descendant(of: find.byType(ListTile), matching: find.text(text));

    expect(find.text('Salary'), findsOneWidget);
    expect(inList('Groceries'), findsOneWidget);

    // Search narrows to just the matching entry and reports the count —
    // note this doesn't touch the summary card's totals.
    await tester.enterText(find.byKey(const Key('expense_search_field')), 'sal');
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
    expect(inList('Groceries'), findsNothing);
    expect(find.text('1 of 2'), findsOneWidget);

    // Clearing search restores the full list.
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
    expect(inList('Groceries'), findsOneWidget);

    // The Income filter chip narrows the *list* to just the income entry —
    // but the category breakdown still reflects the full month regardless
    // of the list filter, so "Groceries" survives there while disappearing
    // from the list itself.
    await tester.tap(find.widgetWithText(ChoiceChip, 'Income'));
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
    expect(inList('Groceries'), findsNothing);
    expect(find.text('Groceries'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
    expect(inList('Groceries'), findsOneWidget);

    // Spending by category: the lone Groceries expense is 100% of expenses,
    // and never counts the Salary income entry.
    expect(find.textContaining('Spending by category'), findsOneWidget);
    expect(find.textContaining('50 EUR (100%)'), findsOneWidget);
  });

  testWidgets(
      'Budgets & Goals: a savings goal can be created and progressed, and a '
      'category budget shows spend-vs-limit once set',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Budgets & Goals'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No savings goals yet'), findsOneWidget);
    // Empty state pairs the message with an icon (Phase 11 visual polish),
    // matching the app's existing icon+text empty-state pattern.
    expect(find.byIcon(Icons.savings_outlined), findsOneWidget);

    // Add a goal, then log progress toward it.
    await tester.tap(find.widgetWithText(OutlinedButton, 'Add goal'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('goal_name_field')), 'Vacation');
    await tester.enterText(find.byKey(const Key('goal_target_field')), '500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Vacation'), findsOneWidget);
    expect(find.textContaining('0 / 500 EUR'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Add progress'));
    await tester.pumpAndSettle();
    // The sheet explains its manual, non-automated nature — a trust
    // requirement, not just a UI label.
    expect(find.textContaining("this app has no bank connection"), findsOneWidget);
    await tester.enterText(find.byKey(const Key('goal_progress_field')), '200');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('200 / 500 EUR'), findsOneWidget);

    // Set a category budget for Groceries (the 3rd category tile, pushed
    // off the initial viewport by the goal card above it) and confirm it
    // now shows spend-vs-limit instead of "No limit set".
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    final groceriesCard = find.ancestor(of: find.text('Groceries'), matching: find.byType(Card));
    expect(groceriesCard, findsOneWidget);
    await tester.tap(find.descendant(of: groceriesCard, matching: find.text('Set limit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('budget_limit_field')), '300');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    final updatedGroceriesCard =
        find.ancestor(of: find.text('Groceries'), matching: find.byType(Card));
    expect(find.descendant(of: updatedGroceriesCard, matching: find.textContaining('0 / 300 EUR')),
        findsOneWidget);
    expect(find.descendant(of: updatedGroceriesCard, matching: find.text('No limit set')),
        findsNothing);
  });

  testWidgets(
      'Expense tracker: insights show a top-category observation and CSV '
      'export copies real transaction data to the clipboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transport'));
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '80');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    // No prior-month data exists, so only the top-category insight shows —
    // Transport is 100% of this month's (single-entry) spending.
    expect(find.text('Insights'), findsOneWidget);
    expect(
      find.textContaining('Transport is your largest expense category this month, at 100%'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.ios_share));
    await tester.pumpAndSettle();
    expect(find.textContaining('CSV copied to clipboard'), findsOneWidget);

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboard?.text, contains('Date,Type,Category,Amount,Currency,Note'));
    expect(clipboard?.text, contains('Expense,Transport,80.00,EUR'));
  });

  testWidgets(
      'Settings: export all data copies every data type to the clipboard, '
      'and delete all local data actually wipes it after both confirmations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    // Create one expense transaction so there's real data to export/delete.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '25');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();

    final settingsScrollable = find.descendant(
      of: find.byType(SettingsScreen),
      matching: find.byType(Scrollable),
    );

    await tester.scrollUntilVisible(
      find.text('Export all data (CSV)'),
      200,
      scrollable: settingsScrollable,
    );
    await tester.tap(find.text('Export all data (CSV)'));
    await tester.pumpAndSettle();
    expect(find.text('All data copied to clipboard'), findsOneWidget);

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboard?.text, contains('# Transactions'));
    expect(clipboard?.text, contains('Expense,Other,25.00,EUR'));
    expect(clipboard?.text, contains('# Saved scenarios'));
    expect(clipboard?.text, contains('# Category budgets'));
    expect(clipboard?.text, contains('# Savings goals'));

    // Delete all local data — both confirmations required.
    await tester.scrollUntilVisible(
      find.text('Delete all local data'),
      200,
      scrollable: settingsScrollable,
    );
    await tester.tap(find.text('Delete all local data'));
    await tester.pumpAndSettle();
    expect(find.text('Delete all local data?'), findsOneWidget);

    // Cancelling the first dialog leaves data untouched.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete all local data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Are you absolutely sure?'), findsOneWidget);

    await tester.tap(find.text('Delete everything'));
    await tester.pumpAndSettle();
    expect(find.text('All local data deleted'), findsOneWidget);

    // Confirm the expense transaction is actually gone, not just the
    // confirmation snackbar shown.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('No transactions yet this month'),
      findsOneWidget,
    );
  });

  testWidgets(
      'Invoices: adding an invoice shows it as unpaid with an outstanding '
      'total, and marking it paid updates the status and clears the total',
      (WidgetTester tester) async {
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

    expect(find.textContaining('No invoices yet'), findsOneWidget);
    // Empty state pairs the message with an icon (Phase 11 visual polish),
    // matching the app's existing icon+text empty-state pattern.
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('invoice_client_field')), 'Acme d.o.o.');
    await tester.enterText(find.byKey(const Key('invoice_amount_field')), '500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Acme d.o.o.'), findsOneWidget);
    expect(find.text('Outstanding'), findsOneWidget);
    expect(find.textContaining('500'), findsWidgets);

    // Mark it paid — the outstanding total disappears and the row's status
    // switches from Unpaid to Paid.
    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Outstanding'), findsNothing);
    final invoiceCard = find.ancestor(of: find.text('Acme d.o.o.'), matching: find.byType(Card));
    expect(find.descendant(of: invoiceCard, matching: find.textContaining('Paid')), findsOneWidget);
  });

  testWidgets(
      'Data survives a simulated app restart: an expense transaction and a '
      'theme preference both reload correctly on a fresh widget tree',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    // Add an expense transaction.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add income'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('expense_amount_field')), '750');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('750'), findsWidgets);

    // Switch to dark theme (persisted separately via SharedPreferences in
    // app.dart, not through any of the services above).
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('dark'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // Simulate closing and reopening the app: unmount everything, then
    // build a completely fresh widget tree. SharedPreferences.
    // setMockInitialValues in setUp() only seeds the initial state — the
    // mock backing store itself is process-level, not tied to the widget
    // tree, so a fresh SalaryCurrencyProApp() here reads whatever was
    // actually persisted, exactly like a real app relaunch would.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    // Theme preference survived.
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    // The expense transaction survived.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Tracker'));
    await tester.pumpAndSettle();
    expect(find.textContaining('750'), findsWidgets);
  });

  testWidgets(
      'Freelancer Self-Assessment: computing a result shows a country-specific breakdown, '
      'a cliff warning, and the mandatory disclaimer', (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryCurrencyProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Tools'),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Freelancer Self-Assessment');
    await tester.pumpAndSettle();
    // Two matches now: the search field's own typed text, and the tool
    // tile's title — the tile is the later one in the widget tree.
    await tester.tap(find.text('Freelancer Self-Assessment').last);
    await tester.pumpAndSettle();

    // Defaults to Serbia (quarterly) — enter a quarterly gross and calculate.
    expect(find.text('Quarterly gross income'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '2000000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('Net income'), findsOneWidget);
    expect(find.text('Income tax'), findsOneWidget);
    expect(find.text('Total contributions'), findsOneWidget);
    // 2,000,000 RSD/quarter annualizes to 8,000,000 — over both the VAT
    // threshold and the paušal ceiling (RSD 6M), so the cliff warnings must
    // actually render, not just exist in code.
    expect(find.text('Crossed'), findsWidgets);
    expect(
      find.textContaining('does not constitute tax, legal, or financial advice'),
      findsOneWidget,
    );

    // Switching country changes the income-period label to annual.
    await tester.tap(find.text('🇷🇸 Serbia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('🇭🇷 Croatia').last);
    await tester.pumpAndSettle();
    expect(find.text('Annual gross income'), findsOneWidget);
  });
}

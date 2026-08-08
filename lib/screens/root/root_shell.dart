import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/budget_service.dart';
import '../../services/expense_service.dart';
import '../../services/home_widget_service.dart';
import '../../services/pinned_pair_service.dart';
import '../currency/currency_converter_screen.dart';
import '../home/home_screen.dart';
import '../salary/salary_calculator_screen.dart';
import '../settings/settings_screen.dart';
import '../tools/tools_hub_screen.dart';

class RootShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final IconData themeIcon;
  final String themeTooltip;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onSetThemeMode;
  final Locale? locale;
  final ValueChanged<Locale?> onSetLocale;

  /// Which bottom-nav tab to open on. Set once by onboarding's primary-goal
  /// screen (see PROMPT-003 Stage A item 1) so a user who picked "salary
  /// math" lands on Salary, not Home, from their very next launch onward.
  /// Defaults to 0 (Home) for anyone who completed onboarding before this
  /// existed or skipped the goal screen.
  final int initialIndex;

  const RootShell({
    super.key,
    required this.onToggleTheme,
    required this.themeIcon,
    required this.themeTooltip,
    required this.themeMode,
    required this.onSetThemeMode,
    required this.locale,
    required this.onSetLocale,
    this.initialIndex = 0,
  });

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late int _index = widget.initialIndex;

  // Tabs are only ever constructed once the user actually visits them, so a
  // tab that hasn't been opened yet can't trigger its own async work (e.g.
  // the salary calculator's tax config load) in the background.
  late final Set<int> _visited = {widget.initialIndex};

  final _homeWidgetService = HomeWidgetService();
  final _isWidgetPlatform = defaultTargetPlatform == TargetPlatform.android;
  bool _didInitialWidgetRefresh = false;

  @override
  void initState() {
    super.initState();
    if (_isWidgetPlatform) {
      // Widgets refresh on the data changing, not on a timer — the periodic
      // WorkManager task (widget_refresh_worker.dart) exists purely so the
      // pinned-pair rate stays fresh while the app isn't open, not to
      // replace this event-driven push. The initial refresh itself can't
      // happen here: `AppLocalizations.of(context)` isn't safe to call
      // until this element's Localizations ancestor has finished mounting
      // (this widget is built inside that very same pass in app.dart), so
      // it's deferred to didChangeDependencies below.
      ExpenseService.changes.addListener(_refreshBudgetWidget);
      BudgetService.changes.addListener(_refreshBudgetWidget);
      PinnedPairService.changes.addListener(_refreshPairWidget);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isWidgetPlatform && !_didInitialWidgetRefresh) {
      _didInitialWidgetRefresh = true;
      _refreshBudgetWidget();
      _refreshPairWidget();
    }
  }

  @override
  void dispose() {
    if (_isWidgetPlatform) {
      ExpenseService.changes.removeListener(_refreshBudgetWidget);
      BudgetService.changes.removeListener(_refreshBudgetWidget);
      PinnedPairService.changes.removeListener(_refreshPairWidget);
    }
    super.dispose();
  }

  void _refreshBudgetWidget() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    unawaited(_homeWidgetService.refreshBudgetWidget(l10n: l10n));
  }

  void _refreshPairWidget() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    unawaited(_homeWidgetService.refreshPinnedPairWidget(l10n: l10n));
  }

  void _goTo(int index) {
    setState(() {
      _index = index;
      _visited.add(index);
    });
  }

  Widget _pageAt(int index) {
    if (!_visited.contains(index)) return const SizedBox.shrink();
    return switch (index) {
      0 => HomeScreen(onNavigate: _goTo),
      1 => const CurrencyConverterScreen(),
      2 => const SalaryCalculatorScreen(),
      3 => const ToolsHubScreen(),
      4 => SettingsScreen(
          themeMode: widget.themeMode,
          onSetThemeMode: widget.onSetThemeMode,
          locale: widget.locale,
          onSetLocale: widget.onSetLocale,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.appTitle,
      l10n.navConvert,
      l10n.navSalary,
      l10n.navTools,
      l10n.navSettings,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.themeIcon),
            tooltip: widget.themeTooltip,
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          _pageAt(0),
          _pageAt(1),
          _pageAt(2),
          _pageAt(3),
          _pageAt(4),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.currency_exchange),
            label: l10n.navConvert,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet),
            label: l10n.navSalary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.build_outlined),
            selectedIcon: const Icon(Icons.build),
            label: l10n.navTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

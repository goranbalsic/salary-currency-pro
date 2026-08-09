import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/root/root_shell.dart';
import 'services/bg_euro_migration_service.dart';
import 'services/entitlement_service.dart';
import 'services/recurring_transaction_service.dart';
import 'services/samo_to_freelance_tax_migration_service.dart';
import 'theme/app_theme.dart';

const _prefsThemeModeKey = 'app_theme_mode';
const _prefsLocaleKey = 'app_locale_code';
const _prefsOnboardingCompleteKey = 'onboarding_complete';
const _prefsHomeTabIndexKey = 'home_default_tab_index';

class SalaryCurrencyProApp extends StatefulWidget {
  const SalaryCurrencyProApp({super.key});

  @override
  State<SalaryCurrencyProApp> createState() => _SalaryCurrencyProAppState();
}

class _SalaryCurrencyProAppState extends State<SalaryCurrencyProApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale; // null = follow system locale

  // Null while preferences are still loading — the app deliberately shows a
  // blank loading state rather than flashing RootShell and then swapping to
  // OnboardingScreen a frame later for a first-time user.
  bool? _onboardingComplete;
  int _homeTabIndex = 0;

  final EntitlementService _entitlementService = EntitlementService();

  @override
  void initState() {
    super.initState();
    _restorePreferences();
    // Fire-and-forget: idempotent, checks its own persisted flag first, and
    // never blocks the UI — see BgEuroMigrationService's own doc comment.
    BgEuroMigrationService().migrateIfNeeded();
    SamoToFreelanceTaxMigrationService().migrateIfNeeded();
    // PROMPT-003 Stage B item 5: post/queue any due recurring transactions.
    // Also re-run whenever the Expense Tracker screen opens (see
    // ExpenseTrackerScreen.initState), so newly-due occurrences show up
    // without requiring a full app restart.
    RecurringTransactionService().checkDue();
    // in_app_purchase's real purchase stream is Android/iOS-only; starting
    // it elsewhere (desktop/web dev builds) would throw on unsupported
    // platform channels. The service itself is still always provided so
    // PaywallScreen's context.read<EntitlementService>() never fails to
    // find one — see EntitlementService.isAvailable's own try/catch for
    // the rest.
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      _entitlementService.start();
    }
  }

  @override
  void dispose() {
    _entitlementService.dispose();
    super.dispose();
  }

  Future<void> _restorePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_prefsThemeModeKey);
      final savedLocale = prefs.getString(_prefsLocaleKey);
      final onboardingComplete = prefs.getBool(_prefsOnboardingCompleteKey) ?? false;
      final homeTabIndex = prefs.getInt(_prefsHomeTabIndexKey) ?? 0;
      if (!mounted) return;
      setState(() {
        if (savedTheme != null) {
          _themeMode = ThemeMode.values.firstWhere(
            (m) => m.name == savedTheme,
            orElse: () => ThemeMode.system,
          );
        }
        if (savedLocale != null && savedLocale.isNotEmpty) {
          _locale = Locale(savedLocale);
        }
        _onboardingComplete = onboardingComplete;
        _homeTabIndex = homeTabIndex;
      });
    } catch (_) {
      // Best-effort restore only — defaults are fine if unavailable. A
      // failed read defaults to onboarding-complete=true (never re-show
      // onboarding to a returning user just because prefs briefly failed).
      if (mounted) setState(() => _onboardingComplete = true);
    }
  }

  Future<void> _completeOnboarding(int homeTabIndex) async {
    setState(() {
      _onboardingComplete = true;
      _homeTabIndex = homeTabIndex;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsOnboardingCompleteKey, true);
      await prefs.setInt(_prefsHomeTabIndexKey, homeTabIndex);
    } catch (_) {
      // Best-effort persistence — onboarding still won't re-show this
      // session since [_onboardingComplete] is already true in memory.
    }
  }

  void _toggleTheme() {
    setThemeMode(switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    SharedPreferences.getInstance()
        .then((p) => p.setString(_prefsThemeModeKey, mode.name))
        .catchError((_) => false);
  }

  /// Pass null to follow the device's system locale.
  void setLocale(Locale? locale) {
    setState(() => _locale = locale);
    SharedPreferences.getInstance()
        .then((p) => p.setString(_prefsLocaleKey, locale?.languageCode ?? ''))
        .catchError((_) => false);
  }

  IconData get _themeIcon => switch (_themeMode) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
      };

  String _themeModeLabel(AppLocalizations l10n) => switch (_themeMode) {
        ThemeMode.system => l10n.themeModeSystem,
        ThemeMode.light => l10n.themeModeLight,
        ThemeMode.dark => l10n.themeModeDark,
      };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EntitlementService>.value(value: _entitlementService),
      ],
      child: _buildApp(context),
    );
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // A Builder gives us a context inside MaterialApp's subtree, where
      // AppLocalizations.of(context) is actually available — the context
      // this build() method receives is above MaterialApp and can't see it.
      home: Builder(
        builder: (context) {
          if (_onboardingComplete == null) {
            // Preferences still loading — blank rather than a flash of
            // RootShell that then gets replaced by OnboardingScreen.
            return const Scaffold(body: SizedBox.shrink());
          }
          if (_onboardingComplete == false) {
            return OnboardingScreen(
              locale: _locale,
              onSetLocale: setLocale,
              onComplete: _completeOnboarding,
            );
          }
          final l10n = AppLocalizations.of(context)!;
          return RootShell(
            onToggleTheme: _toggleTheme,
            themeIcon: _themeIcon,
            themeTooltip: l10n.themeToggleTooltip(_themeModeLabel(l10n)),
            themeMode: _themeMode,
            onSetThemeMode: setThemeMode,
            locale: _locale,
            onSetLocale: setLocale,
            initialIndex: _homeTabIndex,
          );
        },
      ),
    );
  }
}

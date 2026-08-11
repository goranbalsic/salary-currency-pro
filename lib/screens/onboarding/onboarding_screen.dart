import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/country.dart';
import '../../providers/salary_calculator_provider.dart' show prefsCountryKey, prefsEntityKey;
import '../../theme/app_theme.dart';

enum _Goal { salary, expenses, business }

/// Which bottom-nav tab index each primary goal opens onto — must match
/// [RootShell]'s tab order (0 Home, 1 Convert, 2 Salary, 3 Tools,
/// 4 Settings). Expense tracking has no dedicated tab (it lives on Home's
/// "This month" card), so it maps to Home, same as skipping.
const _goalTabIndex = <_Goal, int>{
  _Goal.salary: 2,
  _Goal.expenses: 0,
  _Goal.business: 3,
};

/// Best-effort match of the device's locale to one of this app's 9
/// supported countries: try the device region code first (they're the same
/// two letters as this app's country ids for every country it supports),
/// then fall back to a language match, then to Serbia — matching
/// [SalaryCalculatorProvider]'s own existing default.
Country detectCountryFromDeviceLocale(Locale deviceLocale) {
  final regionCode = deviceLocale.countryCode?.toLowerCase();
  if (regionCode != null) {
    final byRegion = kCountries.where((c) => c.id == regionCode);
    if (byRegion.isNotEmpty) return byRegion.first;
  }
  final byLanguage = kCountries.where((c) => c.localeCode == deviceLocale.languageCode);
  if (byLanguage.isNotEmpty) return byLanguage.first;
  return countryById('rs');
}

/// First-run flow (PROMPT-003 Stage A item 1): country + language, a
/// privacy promise, and a primary-goal picker that sets the default home
/// tab. Skippable from every page — skipping keeps whatever country/
/// language state was already chosen (starting from the device-detected
/// default) and opens on Home, same as picking no goal at all.
class OnboardingScreen extends StatefulWidget {
  final Locale? locale;
  final ValueChanged<Locale?> onSetLocale;
  final ValueChanged<int> onComplete;

  const OnboardingScreen({
    super.key,
    required this.locale,
    required this.onSetLocale,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  late Country _country;
  _Goal? _goal;

  @override
  void initState() {
    super.initState();
    // Reading platform locale via the binding (not `Localizations.of`) —
    // this runs before the first frame, ahead of any BuildContext.
    _country = detectCountryFromDeviceLocale(
      SchedulerBinding.instance.platformDispatcher.locale,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _persistCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefsCountryKey, _country.id);
      if (_country.hasEntities) {
        await prefs.setString(prefsEntityKey, _country.entities!.first.id);
      }
    } catch (_) {
      // Best-effort — the salary calculator falls back to its own default
      // (Serbia) if this never got persisted.
    }
  }

  void _next() {
    _pageController.nextPage(duration: Motion.medium, curve: Motion.curve);
  }

  Future<void> _finish(int homeTabIndex) async {
    await _persistCountry();
    if (!mounted) return;
    widget.onComplete(homeTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: i == _page ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  TextButton(
                    key: const Key('onboarding_skip'),
                    onPressed: () => _finish(0),
                    child: Text(l10n.onboardingSkip),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(
                    country: _country,
                    onSelectCountry: (c) => setState(() => _country = c),
                    locale: widget.locale,
                    onSetLocale: widget.onSetLocale,
                    onContinue: _next,
                  ),
                  _PrivacyPage(onContinue: _next),
                  _GoalPage(
                    selected: _goal,
                    onSelect: (g) => setState(() => _goal = g),
                    onGetStarted: _goal == null
                        ? null
                        : () => _finish(_goalTabIndex[_goal!]!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final Country country;
  final ValueChanged<Country> onSelectCountry;
  final Locale? locale;
  final ValueChanged<Locale?> onSetLocale;
  final VoidCallback onContinue;

  const _WelcomePage({
    required this.country,
    required this.onSelectCountry,
    required this.locale,
    required this.onSetLocale,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingWelcomeTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingWelcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(l10n.onboardingCountryLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              for (final c in kCountries)
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: c.id == country.id
                      ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)
                      : null,
                  child: ListTile(
                    leading: Text(c.flagEmoji, style: const TextStyle(fontSize: 22)),
                    title: Text(localizedCountryName(l10n, c.id)),
                    trailing: c.id == country.id
                        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () => onSelectCountry(c),
                  ),
                ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(l10n.settingsLanguage,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      value: locale?.languageCode,
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.settingsSystemDefault),
                        ),
                        for (final entry in kLanguageNames.entries)
                          DropdownMenuItem<String?>(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                      ],
                      onChanged: (code) => onSetLocale(code == null ? null : Locale(code)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            key: const Key('onboarding_welcome_continue'),
            onPressed: onContinue,
            child: Text(l10n.onboardingContinue),
          ),
        ),
      ],
    );
  }
}

class _PrivacyPage extends StatelessWidget {
  final VoidCallback onContinue;
  const _PrivacyPage({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.onboardingPrivacyTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.onboardingPrivacyBody,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            key: const Key('onboarding_privacy_continue'),
            onPressed: onContinue,
            child: Text(l10n.onboardingContinue),
          ),
        ),
      ],
    );
  }
}

class _GoalPage extends StatelessWidget {
  final _Goal? selected;
  final ValueChanged<_Goal> onSelect;
  final VoidCallback? onGetStarted;

  const _GoalPage({required this.selected, required this.onSelect, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingGoalTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(l10n.onboardingGoalSubtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _GoalCard(
                key: const Key('onboarding_goal_salary'),
                icon: Icons.account_balance_wallet_outlined,
                title: l10n.onboardingGoalSalaryTitle,
                subtitle: l10n.onboardingGoalSalaryDesc,
                selected: selected == _Goal.salary,
                onTap: () => onSelect(_Goal.salary),
              ),
              const SizedBox(height: 10),
              _GoalCard(
                key: const Key('onboarding_goal_expenses'),
                icon: Icons.savings_outlined,
                title: l10n.onboardingGoalExpensesTitle,
                subtitle: l10n.onboardingGoalExpensesDesc,
                selected: selected == _Goal.expenses,
                onTap: () => onSelect(_Goal.expenses),
              ),
              const SizedBox(height: 10),
              _GoalCard(
                key: const Key('onboarding_goal_business'),
                icon: Icons.receipt_long_outlined,
                title: l10n.onboardingGoalBusinessTitle,
                subtitle: l10n.onboardingGoalBusinessDesc,
                selected: selected == _Goal.business,
                onTap: () => onSelect(_Goal.business),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            key: const Key('onboarding_get_started'),
            onPressed: onGetStarted,
            child: Text(l10n.onboardingGetStarted),
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _GoalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? colorScheme.primaryContainer.withValues(alpha: 0.5) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: selected ? colorScheme.primary : Colors.transparent, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: selected ? Icon(Icons.check_circle, color: colorScheme.primary) : null,
        onTap: onTap,
      ),
    );
  }
}

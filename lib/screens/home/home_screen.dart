import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/country.dart';
import '../../models/expense_entry.dart';
import '../../models/finance_quote.dart';
import '../../models/history_entry.dart';
import '../../navigation/app_page_route.dart';
import '../../services/expense_service.dart';
import '../../services/history_service.dart';
import '../../services/quote_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_list_row.dart';
import '../../widgets/app_section_header.dart';
import '../expenses/expense_tracker_screen.dart';

/// Which bottom-nav tab a tap on a history entry should open. Toolkit
/// calculators (Loan/Savings/VAT/Budget/Freelancer Payout/Samo) all live as
/// sub-screens under the Tools tab rather than each having their own
/// top-level tab, so they all route to Tools (index 3) for now.
int _tabIndexForTool(String toolId) {
  switch (toolId) {
    case HistoryToolIds.convert:
      return 1;
    case HistoryToolIds.salary:
      return 2;
    default:
      return 3;
  }
}

/// Landing tab: quote of the day, a light-touch reminder of the last
/// country used for payroll, and shortcuts into the other tabs.
class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _quoteService = QuoteService();
  final _historyService = HistoryService();
  final _expenseService = ExpenseService();
  FinanceQuote? _quote;
  Country _country = countryById('rs');
  List<HistoryEntry> _recent = const [];
  HistoryEntry? _lastSalary;
  List<MonthlySummary> _monthSummaries = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    HistoryService.changes.addListener(_load);
    ExpenseService.changes.addListener(_loadExpenseSummary);
  }

  @override
  void dispose() {
    HistoryService.changes.removeListener(_load);
    ExpenseService.changes.removeListener(_loadExpenseSummary);
    super.dispose();
  }

  Future<void> _loadExpenseSummary() async {
    final summaries = await _expenseService.summaryForMonth(DateTime.now());
    if (!mounted) return;
    setState(() => _monthSummaries = summaries);
  }

  Future<void> _load() async {
    FinanceQuote? quote;
    try {
      final quotes = await _quoteService.loadAll();
      quote = _quoteService.quoteOfTheDay(quotes);
    } catch (_) {
      // No quote today is fine — the rest of the tab still works.
    }

    String? savedCountryId;
    try {
      final prefs = await SharedPreferences.getInstance();
      savedCountryId = prefs.getString('salary_selected_country_id');
    } catch (_) {}

    final recent = await _historyService.loadAll();
    final lastSalary = await _historyService.latestForTool(HistoryToolIds.salary);
    final monthSummaries = await _expenseService.summaryForMonth(DateTime.now());

    if (!mounted) return;
    setState(() {
      _quote = quote;
      if (savedCountryId != null) {
        final match = kCountries.where((c) => c.id == savedCountryId);
        if (match.isNotEmpty) _country = match.first;
      }
      _recent = recent.take(5).toList();
      _lastSalary = lastSalary;
      _monthSummaries = monthSummaries;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_loaded && _quote != null) _QuoteCard(quote: _quote!, l10n: l10n, localeCode: localeCode),
          if (_loaded && _quote != null) const SizedBox(height: AppSpacing.lg),
          if (_loaded) ...[
            _ExpenseOverviewCard(
              summaries: _monthSummaries,
              l10n: l10n,
              onTap: () => Navigator.of(context).push(
                appPageRoute((_) => const ExpenseTrackerScreen()),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _CountryCard(country: _country, l10n: l10n),
          if (_loaded) ...[
            const SizedBox(height: AppSpacing.md),
            _LastSalaryCard(
              entry: _lastSalary,
              l10n: l10n,
              onTap: () => widget.onNavigate(2),
            ),
          ],
          AppSectionHeader(l10n.homeQuickActions),
          AppListRow(
            icon: Icons.currency_exchange,
            title: l10n.navConvert,
            onTap: () => widget.onNavigate(1),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListRow(
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.navSalary,
            onTap: () => widget.onNavigate(2),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListRow(
            icon: Icons.build_outlined,
            title: l10n.navTools,
            onTap: () => widget.onNavigate(3),
          ),
          if (_recent.isNotEmpty) ...[
            AppSectionHeader(l10n.homeRecentlyUsed),
            for (final entry in _recent) ...[
              AppListRow(
                icon: Icons.history,
                iconColor: AppColors.neutralAccent(Theme.of(context).brightness),
                title: entry.title,
                subtitle:
                    '${entry.summary} · ${DateFormat.MMMd().add_Hm().format(entry.timestamp)}',
                onTap: () => widget.onNavigate(_tabIndexForTool(entry.toolId)),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}

class _LastSalaryCard extends StatelessWidget {
  final HistoryEntry? entry;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  const _LastSalaryCard({required this.entry, required this.l10n, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return AppListRow(
      icon: Icons.account_balance_wallet_outlined,
      title: l10n.homeLastSalaryTitle,
      subtitle: e == null
          ? l10n.homeLastSalaryEmpty
          : '${e.summary} · ${DateFormat.MMMd().add_Hm().format(e.timestamp)}',
      onTap: onTap,
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final FinanceQuote quote;
  final AppLocalizations l10n;
  final String localeCode;
  const _QuoteCard({required this.quote, required this.l10n, required this.localeCode});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.format_quote, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.homeQuoteOfDay,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              quote.textFor(localeCode),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(
              '— ${quote.author}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseOverviewCard extends StatelessWidget {
  final List<MonthlySummary> summaries;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  const _ExpenseOverviewCard({required this.summaries, required this.l10n, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (summaries.isEmpty) {
      return AppListRow(
        icon: Icons.savings_outlined,
        iconColor: Theme.of(context).colorScheme.secondary,
        title: l10n.homeExpenseTrackerTitle,
        subtitle: l10n.homeExpenseTrackerCtaEmpty,
        onTap: onTap,
      );
    }

    final s = summaries.first;
    final fmt = NumberFormat.currency(symbol: '${s.currencyCode} ', decimalDigits: 0);
    final balanceColor = s.balance >= 0
        ? AppColors.positiveAction(Theme.of(context).brightness)
        : Theme.of(context).colorScheme.error;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.homeExpenseTrackerTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.expenseBalance, style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    fmt.format(s.balance),
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: balanceColor),
                  ),
                ],
              ),
              if (summaries.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.homeExpenseTrackerMoreCurrencies,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final Country country;
  final AppLocalizations l10n;
  const _CountryCard({required this.country, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Text(country.flagEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizedCountryName(l10n, country.id),
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    country.currencyCode,
                    style: Theme.of(context).textTheme.bodySmall,
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

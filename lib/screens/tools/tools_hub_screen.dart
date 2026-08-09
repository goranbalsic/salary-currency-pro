import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/entitlement.dart';
import '../../models/history_entry.dart';
import '../../navigation/app_page_route.dart';
import '../../services/entitlement_service.dart';
import '../../services/history_service.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/upgrade_prompt.dart';
import '../budgets/budgets_screen.dart';
import '../business/invoices_screen.dart';
import '../expenses/expense_tracker_screen.dart';
import '../expenses/recurring_transactions_screen.dart';
import '../expenses/subscription_radar_screen.dart';
import '../scenarios/my_scenarios_screen.dart';
import 'budget_screen.dart';
import 'cross_border_screen.dart';
import 'fiscal_receipt_queue_screen.dart';
import 'fiscal_receipt_scanner_screen.dart';
import 'freelance_tax_screen.dart';
import 'freelancer_payout_screen.dart';
import 'loan_screen.dart';
import 'pausal_tracker_screen.dart';
import 'savings_screen.dart';
import 'vat_screen.dart';

enum _ToolCategory { tracking, loansSavings, budgetTax, freelance }

class _ToolEntry {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final _ToolCategory category;
  final WidgetBuilder builder;

  /// Extra, non-displayed search terms — e.g. a regime's own filing-form
  /// name in the local language, so a user searching for a specific legal
  /// term (like Serbia's "samooporezivanje" / "PP OPO-K") still finds the
  /// tool that implements it even though the tile's own title/subtitle is
  /// necessarily generic across 10 regimes. See DECISIONS.md D-022.
  final List<String> searchKeywords;

  /// PROMPT-003I Stage D checkpoint 2: true only for the paušal/VAT
  /// compliance pack — the one tool gated entirely behind Pro (every other
  /// tool stays reachable free; individual actions inside them are gated
  /// instead, e.g. the invoice PDF button).
  final bool proOnly;

  const _ToolEntry({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.builder,
    this.searchKeywords = const [],
    this.proOnly = false,
  });
}

class ToolsHubScreen extends StatefulWidget {
  const ToolsHubScreen({super.key});

  @override
  State<ToolsHubScreen> createState() => _ToolsHubScreenState();
}

class _ToolsHubScreenState extends State<ToolsHubScreen> {
  final _historyService = HistoryService();
  final _scenarioService = ScenarioService();
  final _searchCtrl = TextEditingController();
  String _query = '';
  List<HistoryEntry> _recent = const [];
  int _scenarioCount = 0;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
    _loadRecent();
    _loadScenarioCount();
    HistoryService.changes.addListener(_loadRecent);
    ScenarioService.changes.addListener(_loadScenarioCount);
  }

  Future<void> _loadRecent() async {
    final all = await _historyService.loadAll();
    if (!mounted) return;
    setState(() {
      _recent = all.where((e) => _kToolIds.contains(e.toolId)).take(5).toList();
    });
  }

  Future<void> _loadScenarioCount() async {
    final all = await _scenarioService.loadAll();
    if (!mounted) return;
    setState(() => _scenarioCount = all.length);
  }

  @override
  void dispose() {
    HistoryService.changes.removeListener(_loadRecent);
    ScenarioService.changes.removeListener(_loadScenarioCount);
    _searchCtrl.dispose();
    super.dispose();
  }

  static const _kToolIds = {
    HistoryToolIds.loan,
    HistoryToolIds.savings,
    HistoryToolIds.vat,
    HistoryToolIds.budget,
    HistoryToolIds.freelancerPayout,
    HistoryToolIds.freelanceTax,
    HistoryToolIds.pausalTracker,
    HistoryToolIds.crossBorder,
  };

  void _openTool(_ToolEntry tool) {
    if (tool.proOnly) {
      final l10n = AppLocalizations.of(context)!;
      final hasFullAccess = context.read<EntitlementService>().state.value.hasFullAccess;
      if (!hasFullAccess) {
        showUpgradePrompt(
          context,
          title: l10n.gatePausalTrackerTitle,
          body: l10n.gatePausalTrackerBody,
        );
        return;
      }
    }
    Navigator.of(context).push(appPageRoute(tool.builder));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tools = <_ToolEntry>[
      _ToolEntry(
        id: 'expense_tracker',
        icon: Icons.receipt_long,
        title: l10n.toolsExpenseTrackerTitle,
        subtitle: l10n.toolsExpenseTrackerSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const ExpenseTrackerScreen(),
      ),
      _ToolEntry(
        id: 'budgets_goals',
        icon: Icons.savings,
        title: l10n.toolsBudgetsGoalsTitle,
        subtitle: l10n.toolsBudgetsGoalsSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const BudgetsScreen(),
      ),
      _ToolEntry(
        id: 'recurring_transactions',
        icon: Icons.repeat,
        title: l10n.toolsRecurringTitle,
        subtitle: l10n.toolsRecurringSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const RecurringTransactionsScreen(),
      ),
      _ToolEntry(
        id: 'subscription_radar',
        icon: Icons.radar,
        title: l10n.toolsRadarTitle,
        subtitle: l10n.toolsRadarSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const SubscriptionRadarScreen(),
      ),
      _ToolEntry(
        id: 'fiscal_receipt_scanner',
        icon: Icons.qr_code_scanner,
        title: l10n.toolsReceiptScannerTitle,
        subtitle: l10n.toolsReceiptScannerSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const FiscalReceiptScannerScreen(),
      ),
      _ToolEntry(
        id: 'fiscal_receipt_queue',
        icon: Icons.inbox_outlined,
        title: l10n.toolsReceiptQueueTitle,
        subtitle: l10n.toolsReceiptQueueSubtitle,
        category: _ToolCategory.tracking,
        builder: (_) => const FiscalReceiptQueueScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.loan,
        icon: Icons.account_balance_outlined,
        title: l10n.toolsLoanTitle,
        subtitle: l10n.toolsLoanSubtitle,
        category: _ToolCategory.loansSavings,
        builder: (_) => const LoanScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.savings,
        icon: Icons.savings_outlined,
        title: l10n.toolsSavingsTitle,
        subtitle: l10n.toolsSavingsSubtitle,
        category: _ToolCategory.loansSavings,
        builder: (_) => const SavingsScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.vat,
        icon: Icons.receipt_long_outlined,
        title: l10n.toolsVatTitle,
        subtitle: l10n.toolsVatSubtitle,
        category: _ToolCategory.budgetTax,
        builder: (_) => const VatScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.budget,
        icon: Icons.pie_chart_outline,
        title: l10n.toolsBudgetTitle,
        subtitle: l10n.toolsBudgetSubtitle,
        category: _ToolCategory.budgetTax,
        builder: (_) => const BudgetScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.crossBorder,
        icon: Icons.compare_arrows_outlined,
        title: l10n.toolsCrossBorderTitle,
        subtitle: l10n.toolsCrossBorderSubtitle,
        category: _ToolCategory.budgetTax,
        builder: (_) => const CrossBorderScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.freelancerPayout,
        icon: Icons.laptop_mac_outlined,
        title: l10n.toolsFreelancerPayoutTitle,
        subtitle: l10n.toolsFreelancerPayoutSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const FreelancerPayoutScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.freelanceTax,
        icon: Icons.public_outlined,
        title: l10n.toolsFreelanceTaxTitle,
        subtitle: l10n.toolsFreelanceTaxSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const FreelanceTaxScreen(),
        // Filing-form/regime proper nouns from every covered country, so a
        // user searching for the specific legal term they already know
        // (e.g. Serbia's "samooporezivanje" / "PP OPO-K") still finds this
        // tool — see DECISIONS.md D-022.
        searchKeywords: const [
          'samooporezivanje', 'pp opo-k', 'paušal', 'pausal',
          'свободна професия', 'paušalni obrt', 'mali preduzetnik',
          'preduzetnik', 'самостојна дејност', 'normirani', 'popoldanski',
          's.p.', 'vetëpunësuar', 'pfa',
        ],
      ),
      _ToolEntry(
        id: 'invoices',
        icon: Icons.request_quote_outlined,
        title: l10n.toolsInvoicesTitle,
        subtitle: l10n.toolsInvoicesSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const InvoicesScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.pausalTracker,
        icon: Icons.speed_outlined,
        title: l10n.toolsPausalTrackerTitle,
        subtitle: l10n.toolsPausalTrackerSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const PausalTrackerScreen(),
        searchKeywords: const ['paušal', 'pausal', 'pdv', 'promet', 'ceiling', 'vat threshold'],
        proOnly: true,
      ),
    ];

    final byId = {for (final t in tools) t.id: t};

    final filtered = _query.isEmpty
        ? tools
        : tools
            .where((t) =>
                t.title.toLowerCase().contains(_query) ||
                t.subtitle.toLowerCase().contains(_query) ||
                t.searchKeywords.any((k) => k.toLowerCase().contains(_query)))
            .toList();

    String categoryLabel(_ToolCategory c) {
      switch (c) {
        case _ToolCategory.tracking:
          return l10n.categoryTracking;
        case _ToolCategory.loansSavings:
          return l10n.categoryLoansSavings;
        case _ToolCategory.budgetTax:
          return l10n.categoryBudgetTax;
        case _ToolCategory.freelance:
          return l10n.categoryFreelance;
      }
    }

    return ValueListenableBuilder<EntitlementState>(
      valueListenable: context.watch<EntitlementService>().state,
      builder: (context, entitlement, _) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.gold.withValues(alpha: 0.15),
              child: const Icon(Icons.bookmark_outline, color: AppColors.gold),
            ),
            title: Text(l10n.myScenariosTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              _scenarioCount == 0
                  ? l10n.myScenariosSubtitleEmpty
                  : l10n.myScenariosSubtitle(_scenarioCount),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              appPageRoute((_) => const MyScenariosScreen()),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: l10n.toolsSearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: l10n.commonClearSearch,
                    onPressed: () => _searchCtrl.clear(),
                  )
                : null,
          ),
        ),
        if (_query.isEmpty && _recent.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.homeRecentlyUsed, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final entry in _recent)
            if (byId[entry.toolId] != null)
              _RecentEntryTile(
                entry: entry,
                onTap: () => _openTool(byId[entry.toolId]!),
              ),
        ],
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text(
                l10n.toolsSearchNoResults,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          for (final category in _ToolCategory.values) ...[
            if (filtered.any((t) => t.category == category)) ...[
              const SizedBox(height: 20),
              Text(categoryLabel(category), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              for (final tool in filtered.where((t) => t.category == category))
                _ToolTile(
                  tool: tool,
                  locked: tool.proOnly && !entitlement.hasFullAccess,
                  onTap: () => _openTool(tool),
                ),
            ],
          ],
      ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final _ToolEntry tool;
  final bool locked;
  final VoidCallback onTap;
  const _ToolTile({required this.tool, this.locked = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.moneyGreen.withValues(alpha: 0.12),
          child: Icon(tool.icon, color: AppColors.moneyGreen),
        ),
        title: Text(tool.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(tool.subtitle),
        trailing: locked
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.toolsProBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _RecentEntryTile extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;
  const _RecentEntryTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat.MMMd().add_Hm();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.navy.withValues(alpha: 0.12),
          child: const Icon(Icons.history, color: AppColors.navy),
        ),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${entry.summary} · ${timeFmt.format(entry.timestamp)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

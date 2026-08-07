import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/history_entry.dart';
import '../../navigation/app_page_route.dart';
import '../../services/history_service.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../budgets/budgets_screen.dart';
import '../business/invoices_screen.dart';
import '../expenses/expense_tracker_screen.dart';
import '../scenarios/my_scenarios_screen.dart';
import 'budget_screen.dart';
import 'freelance_tax_screen.dart';
import 'freelancer_payout_screen.dart';
import 'loan_screen.dart';
import 'samooporezivanje_screen.dart';
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
  const _ToolEntry({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.builder,
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
    HistoryToolIds.samo,
    HistoryToolIds.freelanceTax,
  };

  void _openTool(_ToolEntry tool) {
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
        id: HistoryToolIds.freelancerPayout,
        icon: Icons.laptop_mac_outlined,
        title: l10n.toolsFreelancerPayoutTitle,
        subtitle: l10n.toolsFreelancerPayoutSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const FreelancerPayoutScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.samo,
        icon: Icons.description_outlined,
        title: l10n.toolsSamooporezivanjeTitle,
        subtitle: l10n.toolsSamooporezivanjeSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const SamooporezivanjeScreen(),
      ),
      _ToolEntry(
        id: HistoryToolIds.freelanceTax,
        icon: Icons.public_outlined,
        title: l10n.toolsFreelanceTaxTitle,
        subtitle: l10n.toolsFreelanceTaxSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const FreelanceTaxScreen(),
      ),
      _ToolEntry(
        id: 'invoices',
        icon: Icons.request_quote_outlined,
        title: l10n.toolsInvoicesTitle,
        subtitle: l10n.toolsInvoicesSubtitle,
        category: _ToolCategory.freelance,
        builder: (_) => const InvoicesScreen(),
      ),
    ];

    final byId = {for (final t in tools) t.id: t};

    final filtered = _query.isEmpty
        ? tools
        : tools
            .where((t) =>
                t.title.toLowerCase().contains(_query) ||
                t.subtitle.toLowerCase().contains(_query))
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

    return ListView(
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
                _ToolTile(tool: tool, onTap: () => _openTool(tool)),
            ],
          ],
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  final _ToolEntry tool;
  final VoidCallback onTap;
  const _ToolTile({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
        trailing: const Icon(Icons.chevron_right),
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

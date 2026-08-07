import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../navigation/app_page_route.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../currency/currency_converter_screen.dart';
import '../salary/salary_calculator_screen.dart';
import '../tools/budget_screen.dart';
import '../tools/freelance_tax_screen.dart';
import '../tools/freelancer_payout_screen.dart';
import '../tools/loan_screen.dart';
import '../tools/samooporezivanje_screen.dart';
import '../tools/savings_screen.dart';
import '../tools/vat_screen.dart';

IconData _iconFor(String toolId) {
  switch (toolId) {
    case HistoryToolIds.salary:
      return Icons.account_balance_wallet;
    case HistoryToolIds.convert:
      return Icons.currency_exchange;
    case HistoryToolIds.loan:
      return Icons.account_balance_outlined;
    case HistoryToolIds.savings:
      return Icons.savings_outlined;
    case HistoryToolIds.vat:
      return Icons.receipt_long_outlined;
    case HistoryToolIds.budget:
      return Icons.pie_chart_outline;
    case HistoryToolIds.freelancerPayout:
      return Icons.laptop_mac_outlined;
    case HistoryToolIds.samo:
      return Icons.description_outlined;
    case HistoryToolIds.freelanceTax:
      return Icons.public_outlined;
    default:
      return Icons.bookmark_outline;
  }
}

/// Reopens [scenario] on the tool screen that produced it, with its inputs
/// pre-filled. The tool re-runs its own calculation only when the user hits
/// Calculate again — reopening never invents a result from stale data.
Widget _screenForScenario(Scenario scenario) {
  switch (scenario.toolId) {
    case HistoryToolIds.salary:
      return SalaryCalculatorScreen(initialScenario: scenario);
    case HistoryToolIds.convert:
      return CurrencyConverterScreen(initialScenario: scenario);
    case HistoryToolIds.loan:
      return LoanScreen(initialScenario: scenario);
    case HistoryToolIds.savings:
      return SavingsScreen(initialScenario: scenario);
    case HistoryToolIds.vat:
      return VatScreen(initialScenario: scenario);
    case HistoryToolIds.budget:
      return BudgetScreen(initialScenario: scenario);
    case HistoryToolIds.freelancerPayout:
      return FreelancerPayoutScreen(initialScenario: scenario);
    case HistoryToolIds.samo:
      return SamooporezivanjeScreen(initialScenario: scenario);
    case HistoryToolIds.freelanceTax:
      return FreelanceTaxScreen(initialScenario: scenario);
    default:
      throw StateError('Unknown scenario toolId: ${scenario.toolId}');
  }
}

class MyScenariosScreen extends StatefulWidget {
  const MyScenariosScreen({super.key});

  @override
  State<MyScenariosScreen> createState() => _MyScenariosScreenState();
}

class _MyScenariosScreenState extends State<MyScenariosScreen> {
  final _service = ScenarioService();
  List<Scenario> _scenarios = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    ScenarioService.changes.addListener(_load);
  }

  @override
  void dispose() {
    ScenarioService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final all = await _service.loadAll();
    if (!mounted) return;
    setState(() {
      _scenarios = all;
      _loading = false;
    });
  }

  Future<void> _reopen(Scenario scenario) async {
    await Navigator.of(context).push(
      appPageRoute((_) => _screenForScenario(scenario)),
    );
  }

  Future<void> _rename(Scenario scenario, AppLocalizations l10n) async {
    final nameCtrl = TextEditingController(text: scenario.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.scenarioRenameDialogTitle),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.scenarioNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(
              nameCtrl.text.trim().isEmpty ? scenario.name : nameCtrl.text.trim(),
            ),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    nameCtrl.dispose();
    if (newName == null) return;
    await _service.rename(scenario.id, newName);
  }

  Future<void> _delete(Scenario scenario, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.scenarioDeleteDialogTitle),
        content: Text(l10n.scenarioDeleteDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.alertRed),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _service.delete(scenario.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFmt = DateFormat.MMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myScenariosTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _scenarios.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 40,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.myScenariosEmptyState,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = _scenarios[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.moneyGreen.withValues(alpha: 0.12),
                          child: Icon(_iconFor(scenario.toolId), color: AppColors.moneyGreen),
                        ),
                        title: Text(scenario.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          '${scenario.summary} · ${dateFmt.format(scenario.createdAt)}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (action) {
                            if (action == 'rename') _rename(scenario, l10n);
                            if (action == 'delete') _delete(scenario, l10n);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'rename', child: Text(l10n.commonRename)),
                            PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
                          ],
                        ),
                        onTap: () => _reopen(scenario),
                      ),
                    );
                  },
                ),
    );
  }
}

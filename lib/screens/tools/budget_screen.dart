import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/budget_planner.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/save_scenario_action.dart';

class BudgetScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const BudgetScreen({super.key, this.initialScenario});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _incomeCtrl = TextEditingController();
  BudgetSplit _split = kBudgetPresets.first;
  BudgetAllocation? _result;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs == null) return;
    _incomeCtrl.text = inputs['income'] as String? ?? '';
    final splitId = inputs['splitId'] as String?;
    final match = kBudgetPresets.where((p) => p.id == splitId);
    if (match.isNotEmpty) _split = match.first;
  }

  @override
  void dispose() {
    _incomeCtrl.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final income = double.tryParse(_incomeCtrl.text.replaceAll(',', '.'));
    if (income == null || income <= 0) {
      setState(() => _result = null);
      return;
    }
    setState(() => _result = BudgetPlanner.allocate(income, _split));
    _historyService.add(
      toolId: HistoryToolIds.budget,
      title: l10n.toolsBudgetTitle,
      summary: _split.label,
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final result = _result;
    if (result == null) return;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    await saveScenario(
      context,
      toolId: HistoryToolIds.budget,
      defaultName: '${l10n.toolsBudgetTitle} · ${_split.label}',
      summary: '${l10n.budgetNeeds} ${fmt.format(result.needs)} · '
          '${l10n.budgetWants} ${fmt.format(result.wants)} · '
          '${l10n.budgetSavings} ${fmt.format(result.savings)}',
      inputs: {
        'income': _incomeCtrl.text,
        'splitId': _split.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgetScreenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _incomeCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.budgetMonthlyIncome,
                        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.budgetSplit, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final preset in kBudgetPresets)
                          ChoiceChip(
                            label: Text(
                              '${preset.label} ${l10n.budgetPresetSuffix}',
                            ),
                            selected: _split.id == preset.id,
                            onSelected: (_) => setState(() => _split = preset),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _calculate(l10n),
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(l10n.commonCalculate),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_result != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _budgetBar(context, l10n.budgetNeeds, _result!.needs, _split.needsPercent, AppColors.navy),
                      const SizedBox(height: 12),
                      _budgetBar(context, l10n.budgetWants, _result!.wants, _split.wantsPercent, AppColors.gold),
                      const SizedBox(height: 12),
                      _budgetBar(context, l10n.budgetSavings, _result!.savings, _split.savingsPercent, AppColors.moneyGreen),
                    ],
                  ),
                ),
              ),
              SaveScenarioRow(onSave: () => _onSave(l10n)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _budgetBar(
    BuildContext context,
    String label,
    double amount,
    double percent,
    Color color,
  ) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label (${percent.toStringAsFixed(0)}%)',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(fmt.format(amount), style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

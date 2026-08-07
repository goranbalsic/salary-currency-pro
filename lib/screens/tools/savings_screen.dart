import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/savings_calculator.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

class SavingsScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const SavingsScreen({super.key, this.initialScenario});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final _principalCtrl = TextEditingController(text: '0');
  final _contributionCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();

  SavingsGrowthResult? _result;
  String? _error;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs == null) return;
    _principalCtrl.text = inputs['principal'] as String? ?? '0';
    _contributionCtrl.text = inputs['contribution'] as String? ?? '';
    _rateCtrl.text = inputs['rate'] as String? ?? '';
    _yearsCtrl.text = inputs['years'] as String? ?? '';
  }

  @override
  void dispose() {
    _principalCtrl.dispose();
    _contributionCtrl.dispose();
    _rateCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final principal = double.tryParse(_principalCtrl.text.replaceAll(',', '.')) ?? 0;
    final contribution =
        double.tryParse(_contributionCtrl.text.replaceAll(',', '.')) ?? 0;
    final rate = double.tryParse(_rateCtrl.text.replaceAll(',', '.'));
    final years = double.tryParse(_yearsCtrl.text.replaceAll(',', '.'));

    if (rate == null || rate < 0 || years == null || years <= 0) {
      setState(() {
        _error = l10n.savingsErrorRateYears;
        _result = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _result = SavingsCalculator.project(
        principal: principal,
        monthlyContribution: contribution,
        annualRatePercent: rate,
        years: years,
      );
    });
    _historyService.add(
      toolId: HistoryToolIds.savings,
      title: l10n.toolsSavingsTitle,
      summary: '${years.toStringAsFixed(0)} yr · ${rate.toStringAsFixed(1)}%',
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final result = _result;
    if (result == null) return;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    await saveScenario(
      context,
      toolId: HistoryToolIds.savings,
      defaultName: l10n.toolsSavingsTitle,
      summary: '${l10n.savingsFutureValue}: ${fmt.format(result.futureValue)}',
      inputs: {
        'principal': _principalCtrl.text,
        'contribution': _contributionCtrl.text,
        'rate': _rateCtrl.text,
        'years': _yearsCtrl.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.savingsScreenTitle)),
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
                      controller: _principalCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.savingsStartingAmount,
                        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contributionCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.savingsMonthlyContribution,
                        prefixIcon: const Icon(Icons.add_card_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _rateCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.savingsExpectedReturn,
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _yearsCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.savingsTimeHorizon,
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                      ),
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
            if (_error != null)
              Card(
                color: AppColors.alertRed.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error!, style: const TextStyle(color: AppColors.alertRed)),
                ),
              ),
            if (_result != null) ...[
              ResultCard(
                headlineLabel: l10n.savingsFutureValue,
                headlineValue: fmt.format(_result!.futureValue),
                rows: [
                  LabeledRow(l10n.savingsTotalContributed, fmt.format(_result!.totalContributed)),
                  LabeledRow(l10n.savingsInterestEarned, fmt.format(_result!.totalInterestEarned)),
                ],
              ),
              SaveScenarioRow(onSave: () => _onSave(l10n)),
            ],
          ],
        ),
      ),
    );
  }
}

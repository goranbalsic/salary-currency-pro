import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/samooporezivanje_calculator.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

class SamooporezivanjeScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const SamooporezivanjeScreen({super.key, this.initialScenario});

  @override
  State<SamooporezivanjeScreen> createState() =>
      _SamooporezivanjeScreenState();
}

class _SamooporezivanjeScreenState extends State<SamooporezivanjeScreen> {
  final _grossCtrl = TextEditingController();
  SamooporezivanjeModel _model = SamooporezivanjeModel.mixedExpense;
  SamooporezivanjeResult? _result;
  SamooporezivanjeModel? _cheaper;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs == null) return;
    _grossCtrl.text = inputs['gross'] as String? ?? '';
    _model = inputs['model'] == SamooporezivanjeModel.fixedExpense.name
        ? SamooporezivanjeModel.fixedExpense
        : SamooporezivanjeModel.mixedExpense;
  }

  @override
  void dispose() {
    _grossCtrl.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final gross = double.tryParse(_grossCtrl.text.replaceAll(',', '.'));
    if (gross == null || gross < 0) {
      setState(() {
        _result = null;
        _cheaper = null;
      });
      return;
    }
    setState(() {
      _result = SamooporezivanjeCalculator.compute(gross, _model);
      _cheaper = SamooporezivanjeCalculator.cheaperModel(gross);
    });
    _historyService.add(
      toolId: HistoryToolIds.samo,
      title: l10n.toolsSamooporezivanjeTitle,
      summary: _model == SamooporezivanjeModel.fixedExpense
          ? l10n.samoFixedModel
          : l10n.samoMixedModel,
      countryId: 'rs',
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final result = _result;
    if (result == null) return;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final modelLabel = _model == SamooporezivanjeModel.fixedExpense
        ? l10n.samoFixedModel
        : l10n.samoMixedModel;
    await saveScenario(
      context,
      toolId: HistoryToolIds.samo,
      defaultName: '${l10n.toolsSamooporezivanjeTitle} · $modelLabel',
      summary: '${l10n.samoIncomeTax}: ${fmt.format(result.incomeTax)} RSD',
      inputs: {
        'gross': _grossCtrl.text,
        'model': _model.name,
      },
      countryId: 'rs',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    String rsd(double v) => '${fmt.format(v)} RSD';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.samoScreenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.samoParamsLine(SamooporezivanjeCalculator.year),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.samoInfoBanner,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _grossCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.samoQuarterlyGrossInput,
                        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<SamooporezivanjeModel>(
                      segments: [
                        ButtonSegment(
                          value: SamooporezivanjeModel.fixedExpense,
                          label: Text(l10n.samoFixedModel),
                        ),
                        ButtonSegment(
                          value: SamooporezivanjeModel.mixedExpense,
                          label: Text(l10n.samoMixedModel),
                        ),
                      ],
                      selected: {_model},
                      onSelectionChanged: (s) => setState(() => _model = s.first),
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
              ResultCard(
                headlineLabel: l10n.samoIncomeTax,
                headlineValue: rsd(_result!.incomeTax),
                rows: [
                  LabeledRow(l10n.samoQuarterlyGrossRow, rsd(_result!.quarterlyGrossRsd)),
                  LabeledRow(l10n.samoTaxableBase, rsd(_result!.taxableBase)),
                  if (_cheaper != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _cheaper == _model ? l10n.samoCheaperSame : l10n.samoCheaperOther,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
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

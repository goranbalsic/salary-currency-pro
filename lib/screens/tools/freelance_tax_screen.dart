import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/freelance/freelance_tax_registry.dart';
import '../../logic/freelance/freelance_tax_strategy.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../services/tax_rules_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

class _RegimeOption {
  final String id;
  final String flag;
  final String label;
  const _RegimeOption(this.id, this.flag, this.label);
}

const List<_RegimeOption> _regimeOptions = [
  _RegimeOption('rs', '🇷🇸', 'Serbia'),
  _RegimeOption('bg', '🇧🇬', 'Bulgaria'),
  _RegimeOption('hr', '🇭🇷', 'Croatia'),
  _RegimeOption('ba_fbih', '🇧🇦', 'Bosnia and Herzegovina — FBiH'),
  _RegimeOption('ba_rs', '🇧🇦', 'Bosnia and Herzegovina — Republika Srpska'),
  _RegimeOption('me', '🇲🇪', 'Montenegro'),
  _RegimeOption('mk', '🇲🇰', 'North Macedonia'),
  _RegimeOption('si', '🇸🇮', 'Slovenia'),
  _RegimeOption('al', '🇦🇱', 'Albania'),
  _RegimeOption('ro', '🇷🇴', 'Romania'),
];

class FreelanceTaxScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const FreelanceTaxScreen({super.key, this.initialScenario});

  @override
  State<FreelanceTaxScreen> createState() => _FreelanceTaxScreenState();
}

class _FreelanceTaxScreenState extends State<FreelanceTaxScreen> {
  final _incomeCtrl = TextEditingController();
  final _historyService = HistoryService();
  final _rulesService = TaxRulesService();

  String _regimeId = 'rs';
  String _serbiaModel = 'model1';
  String _siVariant = 'normirani';
  String _fbihCategory = 'freeProfessions';
  String _baRsCategory = 'standard';
  String _meMunicipality = 'podgoricaCetinje';

  LoadedFreelanceTaxRules? _loadedRules;
  FreelanceTaxResult? _result;
  String? _serbiaCheaperModel;

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs != null) {
      _regimeId = inputs['regimeId'] as String? ?? _regimeId;
      _incomeCtrl.text = inputs['income'] as String? ?? '';
      _serbiaModel = inputs['serbiaModel'] as String? ?? _serbiaModel;
      _siVariant = inputs['siVariant'] as String? ?? _siVariant;
      _fbihCategory = inputs['fbihCategory'] as String? ?? _fbihCategory;
      _baRsCategory = inputs['baRsCategory'] as String? ?? _baRsCategory;
      _meMunicipality = inputs['meMunicipality'] as String? ?? _meMunicipality;
    }
    _loadRules();
  }

  Future<void> _loadRules() async {
    final loaded = await _rulesService.load();
    if (!mounted) return;
    setState(() => _loadedRules = loaded);
    // Fire-and-forget — never blocks this screen, never surfaces an error.
    unawaited(_rulesService.refreshInBackground());
  }

  @override
  void dispose() {
    _incomeCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _optionsForCurrentRegime => switch (_regimeId) {
        'rs' => {'model': _serbiaModel},
        'si' => {'variant': _siVariant},
        'ba_fbih' => {'activityCategory': _fbihCategory},
        'ba_rs' => {'category': _baRsCategory},
        'me' => {'municipality': _meMunicipality},
        _ => const {},
      };

  void _calculate(AppLocalizations l10n) {
    final loaded = _loadedRules;
    final income = double.tryParse(_incomeCtrl.text.replaceAll(',', '.'));
    if (loaded == null || income == null || income < 0) {
      setState(() {
        _result = null;
        _serbiaCheaperModel = null;
      });
      return;
    }

    final strategy = freelanceStrategyFor(_regimeId);
    final regime = loaded.rules.regime(_regimeId);
    final result = strategy.compute(
      regime,
      FreelanceTaxInput(income: income, options: _optionsForCurrentRegime),
    );

    setState(() {
      _result = result;
      _serbiaCheaperModel = _regimeId == 'rs'
          ? (strategy as dynamic).cheaperModel(regime, income) as String
          : null;
    });

    _historyService.add(
      toolId: HistoryToolIds.freelanceTax,
      title: l10n.toolsFreelanceTaxTitle,
      summary: _regimeOptions.firstWhere((r) => r.id == _regimeId).label,
      countryId: regime.countryId,
      currencyCode: regime.currencyCode,
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final result = _result;
    final loaded = _loadedRules;
    if (result == null || loaded == null) return;
    final regime = loaded.rules.regime(_regimeId);
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    await saveScenario(
      context,
      toolId: HistoryToolIds.freelanceTax,
      defaultName:
          '${l10n.toolsFreelanceTaxTitle} · ${_regimeOptions.firstWhere((r) => r.id == _regimeId).label}',
      summary: '${l10n.freelanceTaxNetIncome}: ${fmt.format(result.netIncome)} ${regime.currencyCode}',
      inputs: {
        'regimeId': _regimeId,
        'income': _incomeCtrl.text,
        'serbiaModel': _serbiaModel,
        'siVariant': _siVariant,
        'fbihCategory': _fbihCategory,
        'baRsCategory': _baRsCategory,
        'meMunicipality': _meMunicipality,
      },
      countryId: regime.countryId,
      currencyCode: regime.currencyCode,
    );
  }

  String _cliffMessage(AppLocalizations l10n, FreelanceCliffFlag flag, String currency) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final amount = fmt.format(flag.threshold);
    return switch (flag.id) {
      FreelanceCliffId.albaniaZeroTaxCliff => l10n.freelanceCliffAlbaniaZeroTax(amount, currency),
      FreelanceCliffId.sloveniaNormiraniDeemedExpenseCliff =>
        l10n.freelanceCliffSloveniaNormirani(amount, currency),
      FreelanceCliffId.sloveniaPopoldanskiDeemedExpenseCliff =>
        l10n.freelanceCliffSloveniaPopoldanski(amount, currency),
      FreelanceCliffId.serbiaPausalCeiling => l10n.freelanceCliffSerbiaPausal(amount, currency),
      _ => l10n.freelanceCliffVatThreshold(amount, currency),
    };
  }

  Widget? _regimeOptionsSelector(AppLocalizations l10n) {
    switch (_regimeId) {
      case 'rs':
        return SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'model1', label: Text(l10n.samoFixedModel)),
            ButtonSegment(value: 'model2', label: Text(l10n.samoMixedModel)),
          ],
          selected: {_serbiaModel},
          onSelectionChanged: (s) => setState(() => _serbiaModel = s.first),
        );
      case 'si':
        return SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'normirani', label: Text('Normirani s.p.')),
            ButtonSegment(value: 'popoldanski', label: Text('Popoldanski s.p.')),
          ],
          selected: {_siVariant},
          onSelectionChanged: (s) => setState(() => _siVariant = s.first),
        );
      case 'ba_fbih':
        return DropdownButtonFormField<String>(
          initialValue: _fbihCategory,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.freelanceTaxActivityCategoryLabel),
          items: [
            DropdownMenuItem(value: 'freeProfessions', child: Text(l10n.freelanceFbihCategoryFreeProfessions)),
            DropdownMenuItem(value: 'obrt', child: Text(l10n.freelanceFbihCategoryObrt)),
            DropdownMenuItem(value: 'agriculture', child: Text(l10n.freelanceFbihCategoryAgriculture)),
            DropdownMenuItem(value: 'lumpSumObrt', child: Text(l10n.freelanceFbihCategoryLumpSumObrt)),
            DropdownMenuItem(
                value: 'traditionalCraftsTaxi', child: Text(l10n.freelanceFbihCategoryTraditionalCraftsTaxi)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _fbihCategory = v);
          },
        );
      case 'ba_rs':
        return DropdownButtonFormField<String>(
          initialValue: _baRsCategory,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.freelanceTaxCategoryLabel),
          items: [
            DropdownMenuItem(value: 'standard', child: Text(l10n.freelanceBaRsCategoryStandard)),
            DropdownMenuItem(
                value: 'independentProfessions', child: Text(l10n.freelanceBaRsCategoryIndependentProfessions)),
            DropdownMenuItem(value: 'supplementaryActivity', child: Text(l10n.freelanceBaRsCategorySupplementary)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _baRsCategory = v);
          },
        );
      case 'me':
        return DropdownButtonFormField<String>(
          initialValue: _meMunicipality,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.freelanceTaxMunicipalityLabel),
          items: [
            DropdownMenuItem(
                value: 'podgoricaCetinje', child: Text(l10n.freelanceMeMunicipalityPodgoricaCetinje)),
            DropdownMenuItem(value: 'budva', child: Text(l10n.freelanceMeMunicipalityBudva)),
            DropdownMenuItem(value: 'other', child: Text(l10n.freelanceMeMunicipalityOther)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _meMunicipality = v);
          },
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loaded = _loadedRules;
    final period = loaded == null
        ? FreelanceIncomePeriod.annual
        : freelanceStrategyFor(_regimeId).period;
    final currency = loaded?.rules.regime(_regimeId).currencyCode ?? '';
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    String money(double v) => '${fmt.format(v)} $currency';
    final optionsSelector = loaded == null ? null : _regimeOptionsSelector(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freelanceTaxScreenTitle)),
      body: loaded == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          DropdownButtonFormField<String>(
                            initialValue: _regimeId,
                            isExpanded: true,
                            decoration: InputDecoration(labelText: l10n.freelanceTaxCountryLabel),
                            items: [
                              for (final r in _regimeOptions)
                                DropdownMenuItem(
                                  value: r.id,
                                  child: Text('${r.flag} ${r.label}', overflow: TextOverflow.ellipsis),
                                ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                _regimeId = v;
                                _result = null;
                                _serbiaCheaperModel = null;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _incomeCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: period == FreelanceIncomePeriod.quarterly
                                  ? l10n.freelanceTaxIncomeLabelQuarterly
                                  : l10n.freelanceTaxIncomeLabelAnnual,
                              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                            ),
                          ),
                          if (optionsSelector != null) ...[
                            const SizedBox(height: 12),
                            optionsSelector,
                          ],
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
                      headlineLabel: l10n.freelanceTaxNetIncome,
                      headlineValue: money(_result!.netIncome),
                      rows: [
                        LabeledRow(l10n.freelanceTaxGrossIncomeRow, money(_result!.grossIncome)),
                        LabeledRow(l10n.freelanceTaxDeductionRow, money(_result!.totalDeduction)),
                        LabeledRow(l10n.freelanceTaxTaxableBaseRow, money(_result!.taxableBase)),
                        LabeledRow(l10n.freelanceTaxIncomeTaxRow, money(_result!.incomeTax), bold: true),
                        for (final entry in _result!.contributions.entries)
                          LabeledRow(entry.key, money(entry.value)),
                        LabeledRow(l10n.freelanceTaxContributionsTotalRow, money(_result!.totalContributions),
                            bold: true),
                        if (_serbiaCheaperModel != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              _serbiaCheaperModel == _serbiaModel
                                  ? l10n.samoCheaperSame
                                  : l10n.samoCheaperOther,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        if (_result!.cliffFlags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          for (final flag in _result!.cliffFlags)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (flag.crossed ? AppColors.alertRed : AppColors.gold)
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      flag.crossed ? Icons.error_outline : Icons.info_outline,
                                      size: 18,
                                      color: flag.crossed ? AppColors.alertRed : AppColors.gold,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _cliffMessage(l10n, flag, currency),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            flag.crossed
                                                ? l10n.freelanceCliffStatusCrossed
                                                : l10n.freelanceCliffStatusApproaching,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                    SaveScenarioRow(onSave: () => _onSave(l10n)),
                  ],
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loaded.source == FreelanceTaxRulesSource.updated
                                ? l10n.freelanceTaxRulesVersionUpdated(loaded.rules.rulesVersion)
                                : l10n.freelanceTaxRulesVersionBundle(loaded.rules.rulesVersion),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.freelanceTaxSourcesLabel(
                              loaded.rules.regime(_regimeId).sources.join(', '),
                            ),
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.salaryDisclaimer, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/country.dart';
import '../../models/cross_border_comparison.dart';
import '../../models/history_entry.dart';
import '../../services/cross_border_comparison_service.dart';
import '../../services/entitlement_service.dart';
import '../../services/history_service.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/save_scenario_action.dart';
import '../../widgets/upgrade_prompt.dart';

String _amountIssueMessage(AppLocalizations l10n, AmountIssue issue) {
  switch (issue) {
    case AmountIssue.empty:
      return l10n.salaryAmountIssueEmpty;
    case AmountIssue.invalid:
      return l10n.salaryAmountIssueInvalid;
    case AmountIssue.negative:
      return l10n.salaryAmountIssueNegative;
    case AmountIssue.zeroNotAllowed:
      return l10n.salaryAmountIssueZero;
    case AmountIssue.tooLarge:
      return l10n.salaryAmountIssueTooLarge;
  }
}

/// PROMPT-003G — Stage C item 13: cross-border salary/employer-cost
/// comparison across all 9 countries from one "same gross" figure. See
/// DECISIONS.md D-031 for the full semantics this screen presents (EUR
/// comparison currency, cache-only conversion, monthly-native engine with
/// annual = monthly × 12). Purely offline — the underlying service never
/// makes a network call.
class CrossBorderScreen extends StatefulWidget {
  const CrossBorderScreen({super.key});

  @override
  State<CrossBorderScreen> createState() => _CrossBorderScreenState();
}

class _CrossBorderScreenState extends State<CrossBorderScreen> {
  final _grossCtrl = TextEditingController();
  final _service = CrossBorderComparisonService();
  final _historyService = HistoryService();
  final _scenarioService = ScenarioService();

  CrossBorderPayPeriod _period = CrossBorderPayPeriod.monthly;
  String _baEntityId = 'fbih';
  CrossBorderComparisonResult? _result;
  AmountIssue? _amountIssue;
  bool _calculating = false;

  @override
  void dispose() {
    _grossCtrl.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final parsed = parseAmountInput(_grossCtrl.text, allowZero: false);
    setState(() => _amountIssue = parsed.issue);
    if (!parsed.isValid) {
      setState(() => _result = null);
      return;
    }

    setState(() => _calculating = true);
    final result = await _service.compare(
      grossComparisonCurrency: parsed.value!,
      payPeriod: _period,
      baEntityId: _baEntityId,
    );
    if (!mounted) return;
    setState(() {
      _result = result;
      _calculating = false;
    });

    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      _historyService.add(
        toolId: HistoryToolIds.crossBorder,
        title: l10n.toolsCrossBorderTitle,
        summary: '${result.regimes.length}/${kCountries.length}',
        currencyCode: 'EUR',
      );
    }
  }

  /// Cross-Border comparisons have their own, tighter free-tier save cap
  /// (1, not the generic `ScenarioService.freeLimit` of 3 every other tool
  /// shares) — PROMPT-003I Stage D checkpoint 2's "one saved cross-border
  /// comparison at a time" for free, unlimited for Pro. Running a
  /// comparison itself (above) is never gated; only saving one is. Checked
  /// here, before the shared `saveScenario()` helper, so a free user with
  /// zero saves never even reaches that helper's own (looser) 3-scenario
  /// ceiling.
  Future<void> _saveComparison(AppLocalizations l10n) async {
    final result = _result;
    if (result == null) return;
    final isPro = context.read<EntitlementService>().state.value.hasFullAccess;
    if (!isPro) {
      final existing = await _scenarioService.loadForTool(HistoryToolIds.crossBorder);
      if (existing.isNotEmpty) {
        if (!mounted) return;
        await showUpgradePrompt(
          context,
          title: l10n.gateCrossBorderSaveTitle,
          body: l10n.gateCrossBorderSaveBody,
        );
        return;
      }
    }
    if (!mounted) return;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    await saveScenario(
      context,
      toolId: HistoryToolIds.crossBorder,
      defaultName: '${l10n.toolsCrossBorderTitle} · EUR ${fmt.format(result.grossInputComparisonCurrency)}',
      summary: '${result.regimes.length}/${kCountries.length} · EUR ${fmt.format(result.grossInputComparisonCurrency)}',
      inputs: {
        'grossComparisonCurrency': result.grossInputComparisonCurrency,
        'payPeriod': result.payPeriod.name,
        'baEntityId': result.selectedBaEntityId,
      },
      currencyCode: 'EUR',
    );
  }

  void _openDetail(CrossBorderRegimeResult regime) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RegimeDetailSheet(regime: regime),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final baEntities = countryById('ba').entities!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.toolsCrossBorderTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const Key('cross_border_gross_field'),
                    controller: _grossCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.crossBorderGrossLabel,
                      prefixIcon: const Icon(Icons.public_outlined),
                      errorText: _amountIssue == null ? null : _amountIssueMessage(l10n, _amountIssue!),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<CrossBorderPayPeriod>(
                    segments: [
                      ButtonSegment(
                        value: CrossBorderPayPeriod.monthly,
                        label: Text(l10n.crossBorderPeriodMonthly),
                      ),
                      ButtonSegment(
                        value: CrossBorderPayPeriod.annual,
                        label: Text(l10n.crossBorderPeriodAnnual),
                      ),
                    ],
                    selected: {_period},
                    onSelectionChanged: (s) => setState(() => _period = s.first),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: const Key('cross_border_ba_entity_field'),
                    initialValue: _baEntityId,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.crossBorderBaEntityLabel),
                    items: [
                      for (final e in baEntities)
                        DropdownMenuItem(value: e.id, child: Text(localizedEntityName(l10n, e.id))),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _baEntityId = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    key: const Key('cross_border_calculate_button'),
                    onPressed: _calculating ? null : _calculate,
                    icon: _calculating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.calculate_outlined),
                    label: Text(l10n.commonCalculate),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_result == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.crossBorderInitialEmptyState,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else ...[
            Text(l10n.crossBorderScopeNote, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _ComparisonTable(result: _result!, l10n: l10n, onRowTap: _openDetail),
            const SizedBox(height: 8),
            Text(
              l10n.crossBorderTapForDetail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            SaveScenarioRow(onSave: () => _saveComparison(l10n)),
          ],
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.crossBorderDisclaimer, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final CrossBorderComparisonResult result;
  final AppLocalizations l10n;
  final ValueChanged<CrossBorderRegimeResult> onRowTap;

  const _ComparisonTable({required this.result, required this.l10n, required this.onRowTap});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    String money(double v) => fmt.format(v);

    Widget unavailableCell(String message) => Tooltip(
          message: message,
          child: Semantics(
            label: message,
            child: const Text('—', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        );

    final rowsByCountry = <String, DataRow>{};

    for (final regime in result.regimes) {
      final name = regime.entityId == null
          ? localizedCountryName(l10n, regime.countryId)
          : '${localizedCountryName(l10n, regime.countryId)} — ${localizedEntityName(l10n, regime.entityId!)}';
      final deductions = regime.breakdown.bruto1 - regime.breakdown.neto;
      rowsByCountry[regime.rowId] = DataRow(
        onSelectChanged: (_) => onRowTap(regime),
        cells: [
          DataCell(Text(name)),
          DataCell(Text('${money(regime.grossLocal)} ${regime.currencyCode}')),
          DataCell(Text('${money(deductions)} ${regime.currencyCode}')),
          DataCell(Text('${money(regime.breakdown.neto)} ${regime.currencyCode}')),
          DataCell(Text(money(regime.netInComparisonCurrency))),
          DataCell(Text('${money(regime.breakdown.bruto2)} ${regime.currencyCode}')),
          DataCell(Text(money(regime.employerCostInComparisonCurrency))),
        ],
      );
    }
    for (final error in result.errors) {
      final name = error.entityId == null
          ? localizedCountryName(l10n, error.countryId)
          : '${localizedCountryName(l10n, error.countryId)} — ${localizedEntityName(l10n, error.entityId!)}';
      final message = error.reason == CrossBorderUnavailableReason.noCachedRate
          ? l10n.crossBorderUnavailableNoRate(error.currencyCode)
          : l10n.crossBorderUnavailableConfig;
      rowsByCountry[error.rowId] = DataRow(
        cells: [
          DataCell(Text(name)),
          for (var i = 0; i < 6; i++) DataCell(unavailableCell(message)),
        ],
      );
    }

    // Deterministic order: kCountries' own fixed order (see D-031), with
    // Bosnia's row keyed to whichever entity is currently selected.
    final orderedRows = [
      for (final country in kCountries)
        rowsByCountry[country.id] ??
            rowsByCountry['${country.id}_${result.selectedBaEntityId}'] ??
            rowsByCountry.entries.firstWhere((e) => e.key.startsWith('${country.id}_')).value,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.crossBorderColumnCountry)),
          DataColumn(label: Text(l10n.crossBorderColumnGross), numeric: true),
          DataColumn(label: Text(l10n.crossBorderColumnDeductions), numeric: true),
          DataColumn(label: Text(l10n.crossBorderColumnNet), numeric: true),
          DataColumn(
            label: Text(l10n.crossBorderColumnComparisonSuffix(l10n.crossBorderColumnNet, 'EUR')),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.crossBorderColumnEmployerCost), numeric: true),
          DataColumn(
            label: Text(l10n.crossBorderColumnComparisonSuffix(l10n.crossBorderColumnEmployerCost, 'EUR')),
            numeric: true,
          ),
        ],
        rows: orderedRows,
      ),
    );
  }
}

class _RegimeDetailSheet extends StatelessWidget {
  final CrossBorderRegimeResult regime;
  const _RegimeDetailSheet({required this.regime});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = regime.breakdown;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    String money(double v) => '${fmt.format(v)} ${regime.currencyCode}';
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);

    final title = regime.entityId == null
        ? localizedCountryName(l10n, regime.countryId)
        : '${localizedCountryName(l10n, regime.countryId)} — ${localizedEntityName(l10n, regime.entityId!)}';

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              regime.rateInfo.isSameCurrency
                  ? l10n.crossBorderSameCurrencyLabel
                  : l10n.crossBorderRateSourceLabel(regime.rateInfo.source, dateFmt.format(regime.rateInfo.asOf)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 32),
            LabeledRow(l10n.salaryBruto, money(result.bruto1)),
            LabeledRow(l10n.salaryAllowance, money(result.allowanceAmount)),
            LabeledRow(l10n.salaryTaxableBase, money(result.taxBase)),
            LabeledRow(l10n.salaryIncomeTax, money(result.tax)),
            if (result.localSurtaxAmount > 0)
              LabeledRow(l10n.salaryLocalSurtax, money(result.localSurtaxAmount)),
            const SizedBox(height: 8),
            for (final c in result.contributions)
              if (c.employeeAmount > 0)
                LabeledRow(
                  '${localizedContributionLabel(l10n, c.id)} (${l10n.suffixEmployee})',
                  money(c.employeeAmount),
                ),
            LabeledRow(l10n.salaryEmployeeContribTotal, money(result.employeeContributionsTotal), bold: true),
            LabeledRow(l10n.salaryNeto, money(result.neto), bold: true),
            const Divider(height: 32),
            for (final c in result.contributions)
              if (c.employerAmount > 0)
                LabeledRow(
                  '${localizedContributionLabel(l10n, c.id)} (${l10n.suffixEmployer})',
                  money(c.employerAmount),
                ),
            LabeledRow(l10n.salaryEmployerContribTotal, money(result.employerContributionsTotal)),
            LabeledRow(l10n.salaryBruto2, money(result.bruto2), bold: true),
            const SizedBox(height: 16),
            Text(
              regime.rateInfo.isSameCurrency
                  ? l10n.crossBorderSameCurrencyLabel
                  : '${l10n.crossBorderColumnComparisonSuffix(l10n.salaryNeto, 'EUR')}: '
                      '${fmt.format(regime.netInComparisonCurrency)} EUR',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.positiveAction(Theme.of(context).brightness),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

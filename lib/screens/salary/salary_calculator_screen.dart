import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../logic/salary_calculator.dart';
import '../../models/country.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../providers/salary_calculator_provider.dart';
import '../../services/entitlement_service.dart';
import '../../services/history_service.dart';
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

class SalaryCalculatorScreen extends StatelessWidget {
  final Scenario? initialScenario;
  const SalaryCalculatorScreen({super.key, this.initialScenario});

  @override
  Widget build(BuildContext context) {
    final inputs = initialScenario?.inputs;
    return ChangeNotifierProvider(
      create: (_) => SalaryCalculatorProvider(
        initialCountryId: inputs?['countryId'] as String?,
        initialEntityId: inputs?['entityId'] as String?,
        initialMode: inputs == null
            ? null
            : (inputs['mode'] == SalaryCalcMode.netToGross.name
                ? SalaryCalcMode.netToGross
                : SalaryCalcMode.grossToNet),
        initialAmountText: inputs?['amountText'] as String?,
        initialSurtaxRate: (inputs?['surtaxRate'] as num?)?.toDouble(),
      ),
      child: const _SalaryCalculatorView(),
    );
  }
}

class _SalaryCalculatorView extends StatelessWidget {
  const _SalaryCalculatorView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalaryCalculatorProvider>();

    switch (provider.configStatus) {
      case ConfigLoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ConfigLoadStatus.error:
        return _ConfigErrorState(provider: provider);
      case ConfigLoadStatus.ready:
        return _CalculatorBody(provider: provider);
    }
  }
}

class _ConfigErrorState extends StatelessWidget {
  final SalaryCalculatorProvider provider;
  const _ConfigErrorState({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 40),
            const SizedBox(height: 12),
            Text(
              provider.configError ??
                  l10n.salaryConfigError(
                      localizedCountryName(l10n, provider.selectedCountry.id)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: provider.retryLoadConfig,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorBody extends StatefulWidget {
  final SalaryCalculatorProvider provider;
  const _CalculatorBody({required this.provider});

  @override
  State<_CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<_CalculatorBody> {
  late final TextEditingController _controller;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.provider.amountText);
  }

  @override
  void didUpdateWidget(covariant _CalculatorBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.amountText.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  /// Records a recent-activity entry only when the calculation actually
  /// succeeded — invalid/incomplete input never reaches this.
  void _onCalculate(AppLocalizations l10n) {
    final provider = widget.provider;
    provider.calculate();
    if (provider.result == null) return;

    final country = provider.selectedCountry;
    final modeLabel = provider.mode == SalaryCalcMode.grossToNet
        ? l10n.salaryModeGrossToNet
        : l10n.salaryModeNetToGross;
    _historyService.add(
      toolId: HistoryToolIds.salary,
      title: l10n.navSalary,
      summary: '${localizedCountryName(l10n, country.id)} · $modeLabel',
      countryId: country.id,
      currencyCode: country.currencyCode,
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final provider = widget.provider;
    final result = provider.result;
    if (result == null) return;

    final country = provider.selectedCountry;
    final modeLabel = provider.mode == SalaryCalcMode.grossToNet
        ? l10n.salaryModeGrossToNet
        : l10n.salaryModeNetToGross;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    await saveScenario(
      context,
      toolId: HistoryToolIds.salary,
      defaultName: '${localizedCountryName(l10n, country.id)} · $modeLabel',
      summary: '${l10n.salaryNeto}: ${fmt.format(result.neto)} ${country.currencySymbol}',
      inputs: {
        'countryId': country.id,
        'entityId': provider.selectedEntity?.id,
        'mode': provider.mode.name,
        'amountText': provider.amountText,
        'surtaxRate': provider.localSurtaxRate,
      },
      countryId: country.id,
      currencyCode: country.currencyCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final cfg = provider.config!;
    final country = provider.selectedCountry;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
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
                  _CountryPickerRow(provider: provider),
                  if (country.hasEntities) ...[
                    const SizedBox(height: 12),
                    _EntityToggle(provider: provider),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    l10n.salaryTitle(localizedCountryName(l10n, country.id)),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.salaryParamsLine(
                      cfg.year,
                      DateFormat('MMM d, yyyy', l10n.localeName)
                          .format(cfg.effectiveFrom),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (cfg.localSurtax != null) ...[
                    const SizedBox(height: 8),
                    _SurtaxSlider(provider: provider),
                  ],
                  const SizedBox(height: 16),
                  SegmentedButton<SalaryCalcMode>(
                    segments: [
                      ButtonSegment(
                        value: SalaryCalcMode.grossToNet,
                        label: Text(l10n.salaryModeGrossToNet),
                        icon: const Icon(Icons.arrow_downward),
                      ),
                      ButtonSegment(
                        value: SalaryCalcMode.netToGross,
                        label: Text(l10n.salaryModeNetToGross),
                        icon: const Icon(Icons.arrow_upward),
                      ),
                    ],
                    selected: {provider.mode},
                    onSelectionChanged: (selection) {
                      provider.setMode(selection.first);
                      _controller.clear();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: provider.mode == SalaryCalcMode.grossToNet
                          ? l10n.salaryGrossLabel(country.currencyCode)
                          : l10n.salaryNetLabel(country.currencyCode),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      errorText: provider.amountIssue != null
                          ? _amountIssueMessage(l10n, provider.amountIssue!)
                          : null,
                    ),
                    onChanged: provider.setAmount,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _onCalculate(l10n),
                    icon: const Icon(Icons.calculate_outlined),
                    label: Text(l10n.commonCalculate),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (provider.result != null) ...[
            _BreakdownCard(
              result: provider.result!,
              mode: provider.mode,
              country: country,
            ),
            SaveScenarioRow(onSave: () => _onSave(l10n)),
          ] else
            _EmptyState(hasError: provider.amountIssue != null),
        ],
      ),
    );
  }
}

class _CountryPickerRow extends StatelessWidget {
  final SalaryCalculatorProvider provider;
  const _CountryPickerRow({required this.provider});

  void _openPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // PROMPT-003I Stage D checkpoint 2: the free tier's salary calculator
    // covers only the country the user is currently on — switching to any
    // other country is the Pro differentiator ("all 9 countries' full
    // calculator/adapter set"). Read once per sheet-open rather than
    // per-tile: entitlement can't change while this modal sheet is open.
    final hasFullAccess = context.read<EntitlementService>().state.value.hasFullAccess;
    final homeCountryId = provider.selectedCountry.id;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final country in kCountries)
              ListTile(
                leading: Text(country.flagEmoji, style: const TextStyle(fontSize: 24)),
                title: Text(localizedCountryName(l10n, country.id)),
                subtitle: Text(country.currencyCode),
                trailing: country.id == provider.selectedCountry.id
                    ? Icon(Icons.check,
                        color: AppColors.positiveAction(
                            Theme.of(sheetContext).brightness))
                    : (!hasFullAccess && country.id != homeCountryId)
                        ? Icon(Icons.lock_outline,
                            color: Theme.of(sheetContext).colorScheme.outline)
                        : null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (!hasFullAccess && country.id != homeCountryId) {
                    showUpgradePrompt(
                      context,
                      title: l10n.gateCountrySwitchTitle,
                      body: l10n.gateCountrySwitchBody,
                    );
                    return;
                  }
                  provider.selectCountry(country);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final country = provider.selectedCountry;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openPicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Text(country.flagEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                localizedCountryName(l10n, country.id),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.unfold_more, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EntityToggle extends StatelessWidget {
  final SalaryCalculatorProvider provider;
  const _EntityToggle({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entities = provider.selectedCountry.entities!;
    final selected = provider.selectedEntity ?? entities.first;
    return SegmentedButton<CountryEntity>(
      segments: [
        for (final e in entities)
          ButtonSegment(value: e, label: Text(localizedEntityName(l10n, e.id))),
      ],
      selected: {selected},
      onSelectionChanged: (s) => provider.selectEntity(s.first),
    );
  }
}

class _SurtaxSlider extends StatelessWidget {
  final SalaryCalculatorProvider provider;
  const _SurtaxSlider({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localSurtax = provider.config!.localSurtax!;
    final rate = provider.localSurtaxRate ?? localSurtax.defaultRate;
    final divisions = (localSurtax.maxRate * 1000).round().clamp(1, 1000);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.salarySurtaxLabel((rate * 100).toStringAsFixed(1)),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Slider(
          value: rate.clamp(0, localSurtax.maxRate),
          min: 0,
          max: localSurtax.maxRate,
          divisions: divisions,
          label: '${(rate * 100).toStringAsFixed(1)}%',
          onChanged: provider.setLocalSurtaxRate,
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasError;
  const _EmptyState({required this.hasError});

  @override
  Widget build(BuildContext context) {
    if (hasError) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.salaryEmptyState,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final SalaryBreakdown result;
  final SalaryCalcMode mode;
  final Country country;
  const _BreakdownCard({
    required this.result,
    required this.mode,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    String money(double v) => '${fmt.format(v)} ${country.currencySymbol}';

    final hasFlooredBase =
        result.contributions.any((c) => c.base > result.bruto1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (result.neto <= 0)
          Builder(builder: (context) {
            final errorColor = Theme.of(context).colorScheme.error;
            return Card(
              color: errorColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: errorColor),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        hasFlooredBase
                            ? l10n.salaryNegativeNetoFloored(
                                money(result.highestContributionBase))
                            : l10n.salaryNegativeNetoGeneric,
                        style: TextStyle(color: errorColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        if (result.neto <= 0) const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.salaryNeto,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  money(result.neto),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: result.neto > 0
                            ? AppColors.positiveAction(
                                Theme.of(context).brightness)
                            : Theme.of(context).colorScheme.error,
                      ),
                ),
                if (result.bruto1 > 0) ...[
                  const SizedBox(height: 16),
                  _BreakdownChart(result: result, l10n: l10n),
                ],
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
                LabeledRow(
                  l10n.salaryEmployeeContribTotal,
                  money(result.employeeContributionsTotal),
                  bold: true,
                ),
                const Divider(height: 32),
                for (final c in result.contributions)
                  if (c.employerAmount > 0)
                    LabeledRow(
                      '${localizedContributionLabel(l10n, c.id)} (${l10n.suffixEmployer})',
                      money(c.employerAmount),
                    ),
                LabeledRow(
                  l10n.salaryEmployerContribTotal,
                  money(result.employerContributionsTotal),
                ),
                LabeledRow(
                  l10n.salaryBruto2,
                  money(result.bruto2),
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _DisclaimerBanner(),
      ],
    );
  }
}

/// Where the gross salary actually goes: take-home vs. tax vs. employee
/// contributions, at a glance.
class _BreakdownChart extends StatelessWidget {
  final SalaryBreakdown result;
  final AppLocalizations l10n;
  const _BreakdownChart({required this.result, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final total = result.bruto1;
    final neto = result.neto.clamp(0, double.infinity).toDouble();
    final tax = result.totalTax.clamp(0, double.infinity).toDouble();
    final contributions =
        result.employeeContributionsTotal.clamp(0, double.infinity).toDouble();

    final netoPct = neto / total * 100;
    final taxPct = tax / total * 100;
    final contribPct = contributions / total * 100;

    final colorScheme = Theme.of(context).colorScheme;
    final netoColor = AppColors.positiveAction(colorScheme.brightness);
    final taxColor = colorScheme.error;
    final contribColor = colorScheme.secondary;

    return SizedBox(
      height: 140,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    value: netoPct <= 0 ? 0.001 : netoPct,
                    color: netoColor,
                    title: '',
                    radius: 26,
                  ),
                  PieChartSectionData(
                    value: taxPct <= 0 ? 0.001 : taxPct,
                    color: taxColor,
                    title: '',
                    radius: 26,
                  ),
                  PieChartSectionData(
                    value: contribPct <= 0 ? 0.001 : contribPct,
                    color: contribColor,
                    title: '',
                    radius: 26,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendRow(netoColor, l10n.chartTakeHome, netoPct),
                const SizedBox(height: AppSpacing.sm),
                _legendRow(taxColor, l10n.chartTax, taxPct),
                const SizedBox(height: AppSpacing.sm),
                _legendRow(contribColor, l10n.chartContributions, contribPct),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label, double pct) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(
          '${pct.clamp(0, 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.salaryDisclaimer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

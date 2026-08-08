import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/history_entry.dart';
import '../../models/pausal_turnover.dart';
import '../../models/freelance_tax_rules.dart';
import '../../services/history_service.dart';
import '../../services/invoice_service.dart';
import '../../services/pausal_tracker_service.dart';
import '../../services/tax_rules_service.dart';
import '../../theme/app_theme.dart';

/// Serbia paušal ceiling & VAT registration threshold tracker —
/// PROMPT-003E item 11.1. Fed entirely by the existing invoice tracker;
/// no new turnover data-entry surface. Tracks two limits simultaneously,
/// each with its own measurement window (calendar year vs rolling 12
/// months) — see `PausalTrackerService`'s own doc comment for the honest
/// rate-history design note this screen's "rate captured" labeling refers
/// to.
class PausalTrackerScreen extends StatefulWidget {
  const PausalTrackerScreen({super.key});

  @override
  State<PausalTrackerScreen> createState() => _PausalTrackerScreenState();
}

class _PausalTrackerScreenState extends State<PausalTrackerScreen> {
  final _service = PausalTrackerService();
  final _historyService = HistoryService();
  final _taxRulesService = TaxRulesService();
  final _assessedAmountCtrl = TextEditingController();

  PausalTurnoverSummary? _summary;
  FreelanceRegimeRules? _regimeRules;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRules();
    _load();
    InvoiceService.changes.addListener(_load);
    PausalTrackerService.changes.addListener(_load);
  }

  Future<void> _loadRules() async {
    final loaded = await _taxRulesService.load();
    if (!mounted) return;
    setState(() => _regimeRules = loaded.rules.regime('rs'));
  }

  @override
  void dispose() {
    InvoiceService.changes.removeListener(_load);
    PausalTrackerService.changes.removeListener(_load);
    _assessedAmountCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final summary = await _service.computeSummary();
    final assessed = await _service.getAssessedMonthlyAmount();
    if (!mounted) return;
    setState(() {
      _summary = summary;
      _assessedAmountCtrl.text = assessed == null ? '' : _plain(assessed);
      _loading = false;
    });
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      _historyService.add(
        toolId: HistoryToolIds.pausalTracker,
        title: l10n.toolsPausalTrackerTitle,
        summary: _stateLabel(l10n, summary.calendarYear.state),
        countryId: 'rs',
        currencyCode: 'RSD',
      );
    }
  }

  static String _plain(double v) => v == v.truncateToDouble() ? v.toInt().toString() : v.toString();

  static String _pct(double fraction) {
    final p = fraction * 100;
    return p == p.truncateToDouble() ? '${p.toInt()}%' : '${p.toStringAsFixed(1)}%';
  }

  Future<void> _saveAssessedAmount() async {
    final text = _assessedAmountCtrl.text.trim();
    final amount = text.isEmpty ? null : double.tryParse(text.replaceAll(',', '.'));
    await _service.setAssessedMonthlyAmount(amount);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.pausalTrackerAssessedAmountSaved)),
    );
  }

  String _stateLabel(AppLocalizations l10n, PausalThresholdState state) => switch (state) {
        PausalThresholdState.ok => l10n.pausalTrackerStateOk,
        PausalThresholdState.warning70 => l10n.pausalTrackerStateWarning70,
        PausalThresholdState.warning85 => l10n.pausalTrackerStateWarning85,
        PausalThresholdState.warning95 => l10n.pausalTrackerStateWarning95,
        PausalThresholdState.exceeded => l10n.pausalTrackerStateExceeded,
      };

  Color _stateColor(PausalThresholdState state) => switch (state) {
        PausalThresholdState.ok => AppColors.moneyGreen,
        PausalThresholdState.exceeded => AppColors.alertRed,
        _ => AppColors.gold,
      };

  void _showBreakdown(AppLocalizations l10n, PausalTurnoverSummary summary) {
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.pausalTrackerBreakdownTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final c in summary.contributions.where((c) => !c.excluded))
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(c.clientName),
                subtitle: Text(
                  '${dateFmt.format(c.issueDate)} · ${fmt.format(c.originalAmount)} ${c.originalCurrency}'
                  '${c.rateSource != null ? ' · ${l10n.pausalTrackerBreakdownRateLabel(c.rateSource!)}' : ''}',
                ),
                trailing: Text('${fmt.format(c.rsdAmount!)} RSD', style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            if (summary.excludedCount > 0) ...[
              const Divider(),
              Text(l10n.pausalTrackerBreakdownExcludedHeader, style: Theme.of(sheetContext).textTheme.titleSmall),
              for (final c in summary.contributions.where((c) => c.excluded))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.warning_amber_outlined, color: AppColors.alertRed),
                  title: Text(c.clientName),
                  subtitle: Text(
                    '${dateFmt.format(c.issueDate)} · ${fmt.format(c.originalAmount)} ${c.originalCurrency}\n'
                    '${l10n.pausalTrackerBreakdownExcludedReason}',
                  ),
                  isThreeLine: true,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _limitCard(AppLocalizations l10n, String title, PausalLimitStatus status) {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final color = _stateColor(status.state);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (status.percent / 100).clamp(0, 1),
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${fmt.format(status.totalRsd)} / ${fmt.format(status.thresholdRsd)} RSD '
              '(${status.percent.toStringAsFixed(0)}%)',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              _stateLabel(l10n, status.state),
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = _summary;
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.toolsPausalTrackerTitle)),
      body: _loading || summary == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _limitCard(l10n, l10n.pausalTrackerCeilingCardTitle, summary.calendarYear),
                const SizedBox(height: 12),
                _limitCard(l10n, l10n.pausalTrackerVatCardTitle, summary.rollingTwelveMonths),
                if (summary.projectedCeilingDate != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: AppColors.gold.withValues(alpha: 0.10),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        l10n.pausalTrackerProjection(dateFmt.format(summary.projectedCeilingDate!)),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
                if (summary.excludedCount > 0) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: AppColors.alertRed.withValues(alpha: 0.10),
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber_outlined, color: AppColors.alertRed),
                      title: Text(l10n.pausalTrackerExcludedBanner(summary.excludedCount)),
                      onTap: () => _showBreakdown(l10n, summary),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showBreakdown(l10n, summary),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: Text(l10n.pausalTrackerSeeBreakdown),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l10n.pausalTrackerAssessedAmountLabel, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          l10n.pausalTrackerAssessedAmountHint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _assessedAmountCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(suffixText: 'RSD'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _saveAssessedAmount,
                              child: Text(l10n.commonSave),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_regimeRules != null)
                          Text(
                            l10n.pausalTrackerAssessedAmountDecomposition(
                              _pct(_regimeRules!.field('pausalTaxRatePercentOfDeemedBase').asDouble!),
                              _pct(_regimeRules!.field('pioContributionRate').asDouble!),
                              _pct(_regimeRules!.field('healthContributionRate').asDouble!),
                              _pct(_regimeRules!.field('unemploymentContributionRate').asDouble!),
                              _pct(_regimeRules!.field('pausalTotalBurdenPercentOfDeemedBase').asDouble!),
                            ),
                            style: const TextStyle(fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

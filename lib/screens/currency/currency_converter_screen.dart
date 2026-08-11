import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/currency.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../providers/currency_converter_provider.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/rate_status_banner.dart';
import '../../widgets/save_scenario_action.dart';

String _amountIssueMessage(AppLocalizations l10n, AmountIssue issue) {
  switch (issue) {
    case AmountIssue.empty:
      return l10n.convertAmountIssueEmpty;
    case AmountIssue.invalid:
      return l10n.convertAmountIssueInvalid;
    case AmountIssue.negative:
      return l10n.convertAmountIssueNegative;
    case AmountIssue.zeroNotAllowed:
      return l10n.convertAmountIssueZero;
    case AmountIssue.tooLarge:
      return l10n.convertAmountIssueTooLarge;
  }
}

class CurrencyConverterScreen extends StatelessWidget {
  final Scenario? initialScenario;
  const CurrencyConverterScreen({super.key, this.initialScenario});

  @override
  Widget build(BuildContext context) {
    final inputs = initialScenario?.inputs;
    return ChangeNotifierProvider(
      create: (_) => CurrencyConverterProvider(
        initialFrom: inputs?['from'] as String?,
        initialTo: inputs?['to'] as String?,
        initialAmountText: inputs?['amount'] as String?,
      ),
      child: const _CurrencyConverterView(),
    );
  }
}

class _CurrencyConverterView extends StatelessWidget {
  const _CurrencyConverterView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrencyConverterProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AmountAndCurrencyCard(provider: provider),
          const SizedBox(height: 16),
          _ResultArea(provider: provider),
        ],
      ),
    );
  }
}

class _AmountAndCurrencyCard extends StatefulWidget {
  final CurrencyConverterProvider provider;
  const _AmountAndCurrencyCard({required this.provider});

  @override
  State<_AmountAndCurrencyCard> createState() =>
      _AmountAndCurrencyCardState();
}

class _AmountAndCurrencyCardState extends State<_AmountAndCurrencyCard> {
  late final TextEditingController _controller;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.provider.amountText);
  }

  /// Records a recent-activity entry only when the conversion actually
  /// succeeded — invalid input or a failed rate lookup never reaches this.
  Future<void> _onConvert(AppLocalizations l10n) async {
    final provider = widget.provider;
    await provider.convert();
    if (provider.status != LoadStatus.success || provider.result == null) {
      return;
    }
    final result = provider.result!;
    _historyService.add(
      toolId: HistoryToolIds.convert,
      title: l10n.navConvert,
      summary: '${result.from} → ${result.to}',
      currencyCode: result.to,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.convertCardTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.commonAmount,
                prefixIcon: const Icon(Icons.payments_outlined),
                errorText: provider.amountIssue != null
                    ? _amountIssueMessage(l10n, provider.amountIssue!)
                    : null,
              ),
              onChanged: provider.setAmount,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CurrencyDropdown(
                    value: provider.from,
                    label: l10n.commonFrom,
                    onChanged: (code) {
                      if (code != null) provider.setFrom(code);
                    },
                  ),
                ),
                IconButton(
                  onPressed: provider.swap,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: l10n.commonSwapCurrencies,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppColors.moneyGreen.withValues(alpha: 0.12),
                  ),
                ),
                Expanded(
                  child: _CurrencyDropdown(
                    value: provider.to,
                    label: l10n.commonTo,
                    onChanged: (code) {
                      if (code != null) provider.setTo(code);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.status == LoadStatus.loading
                  ? null
                  : () => _onConvert(l10n),
              icon: const Icon(Icons.sync_alt),
              label: Text(l10n.commonConvert),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String value;
  final String label;
  final ValueChanged<String?> onChanged;

  const _CurrencyDropdown({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: supportedCurrencies
          .map(
            (c) => DropdownMenuItem(
              value: c.code,
              child: Text(c.code, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _ResultArea extends StatelessWidget {
  final CurrencyConverterProvider provider;
  const _ResultArea({required this.provider});

  @override
  Widget build(BuildContext context) {
    switch (provider.status) {
      case LoadStatus.idle:
        return const _EmptyState();
      case LoadStatus.loading:
        return const _LoadingState();
      case LoadStatus.error:
        if (provider.amountIssue != null) {
          // Input validation error is already shown inline on the field.
          return const _EmptyState();
        }
        return _ErrorState(
          message: provider.errorMessage ??
              AppLocalizations.of(context)!.commonSomethingWentWrong,
          onRetry: () => provider.convert(),
        );
      case LoadStatus.success:
        return _SuccessState(provider: provider);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AppEmptyState(
        icon: Icons.currency_exchange,
        message: AppLocalizations.of(context)!.convertEmptyState,
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.alertRed.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.alertRed, size: 32),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.alertRed),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.commonRetry),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.alertRed,
                side: const BorderSide(color: AppColors.alertRed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final CurrencyConverterProvider provider;
  const _SuccessState({required this.provider});

  Future<void> _onSave(BuildContext context, AppLocalizations l10n) async {
    final result = provider.result;
    final converted = provider.convertedAmount;
    if (result == null || converted == null) return;
    final numberFormat = NumberFormat.currency(
      symbol: '',
      decimalDigits: result.to == 'JPY' ? 0 : 2,
    );
    await saveScenario(
      context,
      toolId: HistoryToolIds.convert,
      defaultName: '${result.from} → ${result.to}',
      summary: '${numberFormat.format(converted)} ${result.to}',
      inputs: {
        'amount': provider.amountText,
        'from': result.from,
        'to': result.to,
      },
      currencyCode: result.to,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = provider.result!;
    final converted = provider.convertedAmount;
    final numberFormat = NumberFormat.currency(
      symbol: '',
      decimalDigits: result.to == 'JPY' ? 0 : 2,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              converted != null
                  ? '${numberFormat.format(converted)} ${result.to}'
                  : '—',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.moneyGreen,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '1 ${result.from} = ${result.rate.toStringAsFixed(6)} ${result.to}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            RateStatusBanner(
              isLive: result.isLive,
              asOf: result.asOf,
              source: result.source,
            ),
            SaveScenarioRow(onSave: () => _onSave(context, l10n)),
          ],
        ),
      ),
    );
  }
}

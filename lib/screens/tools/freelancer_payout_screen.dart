import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/freelancer_payout_calculator.dart';
import '../../models/currency.dart';
import '../../models/history_entry.dart';
import '../../models/rate_snapshot.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/rate_status_banner.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

String _platformLabel(AppLocalizations l10n, PlatformFeePreset preset) {
  switch (preset.id) {
    case 'custom':
      return l10n.freelancerPlatformCustom;
    case 'direct':
      return l10n.freelancerPlatformDirect;
    default:
      return preset.label;
  }
}

class FreelancerPayoutScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const FreelancerPayoutScreen({super.key, this.initialScenario});

  @override
  State<FreelancerPayoutScreen> createState() => _FreelancerPayoutScreenState();
}

class _FreelancerPayoutScreenState extends State<FreelancerPayoutScreen> {
  final _calculator = FreelancerPayoutCalculator();
  final _grossCtrl = TextEditingController();
  final _platformFeeCtrl = TextEditingController(text: '0');
  final _bankFlatCtrl = TextEditingController(text: '0');
  final _bankPercentCtrl = TextEditingController(text: '0');

  String _foreignCurrency = 'USD';
  String _localCurrency = 'RSD';
  PlatformFeePreset _preset = kPlatformFeePresets.first;

  bool _loading = false;
  String? _error;
  FreelancerPayoutResult? _result;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs == null) return;
    _grossCtrl.text = inputs['gross'] as String? ?? '';
    _foreignCurrency = inputs['foreignCurrency'] as String? ?? _foreignCurrency;
    _localCurrency = inputs['localCurrency'] as String? ?? _localCurrency;
    final presetId = inputs['presetId'] as String?;
    final match = kPlatformFeePresets.where((p) => p.id == presetId);
    if (match.isNotEmpty) _preset = match.first;
    _platformFeeCtrl.text = inputs['platformFee'] as String? ?? '0';
    _bankFlatCtrl.text = inputs['bankFlat'] as String? ?? '0';
    _bankPercentCtrl.text = inputs['bankPercent'] as String? ?? '0';
  }

  @override
  void dispose() {
    _grossCtrl.dispose();
    _platformFeeCtrl.dispose();
    _bankFlatCtrl.dispose();
    _bankPercentCtrl.dispose();
    super.dispose();
  }

  Future<void> _calculate(AppLocalizations l10n) async {
    final gross = double.tryParse(_grossCtrl.text.replaceAll(',', '.'));
    final platformFee =
        double.tryParse(_platformFeeCtrl.text.replaceAll(',', '.')) ?? 0;
    final bankFlat =
        double.tryParse(_bankFlatCtrl.text.replaceAll(',', '.')) ?? 0;
    final bankPercent =
        double.tryParse(_bankPercentCtrl.text.replaceAll(',', '.')) ?? 0;

    if (gross == null || gross <= 0) {
      setState(() {
        _error = l10n.freelancerErrorInvoice;
        _result = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _calculator.compute(
        grossForeign: gross,
        foreignCurrency: _foreignCurrency,
        platformFeePercent: platformFee,
        bankFeeFlat: bankFlat,
        bankFeePercent: bankPercent,
        localCurrency: _localCurrency,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _loading = false;
      });
      _historyService.add(
        toolId: HistoryToolIds.freelancerPayout,
        title: l10n.toolsFreelancerPayoutTitle,
        summary: '$_foreignCurrency → $_localCurrency',
        currencyCode: _localCurrency,
      );
    } on RateUnavailableException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = l10n.freelancerErrorUnexpected('$e');
        _loading = false;
      });
    }
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final result = _result;
    if (result == null) return;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    await saveScenario(
      context,
      toolId: HistoryToolIds.freelancerPayout,
      defaultName: '$_foreignCurrency → $_localCurrency',
      summary: '${l10n.freelancerRealPayout}: ${fmt.format(result.localAmount)} $_localCurrency',
      inputs: {
        'gross': _grossCtrl.text,
        'foreignCurrency': _foreignCurrency,
        'localCurrency': _localCurrency,
        'presetId': _preset.id,
        'platformFee': _platformFeeCtrl.text,
        'bankFlat': _bankFlatCtrl.text,
        'bankPercent': _bankPercentCtrl.text,
      },
      currencyCode: _localCurrency,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freelancerScreenTitle)),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _grossCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: l10n.freelancerInvoiceAmount,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _foreignCurrency,
                            decoration: InputDecoration(labelText: l10n.freelancerCurrency),
                            items: [
                              for (final c in supportedCurrencies)
                                DropdownMenuItem(value: c.code, child: Text(c.code)),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _foreignCurrency = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<PlatformFeePreset>(
                      initialValue: _preset,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.freelancerPlatform),
                      items: [
                        for (final p in kPlatformFeePresets)
                          DropdownMenuItem(
                            value: p,
                            child: Text(
                              _platformLabel(l10n, p),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (p) {
                        if (p == null) return;
                        setState(() {
                          _preset = p;
                          _platformFeeCtrl.text = p.feePercent.toStringAsFixed(1);
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _platformFeeCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.freelancerPlatformFee,
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _bankFlatCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: l10n.freelancerBankFeeFlat(_foreignCurrency),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _bankPercentCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: l10n.freelancerBankFeePercent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _localCurrency,
                      decoration: InputDecoration(labelText: l10n.freelancerPayoutCurrency),
                      items: [
                        for (final c in supportedCurrencies)
                          DropdownMenuItem(value: c.code, child: Text(c.code)),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _localCurrency = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loading ? null : () => _calculate(l10n),
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(l10n.freelancerCalculateButton),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
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
                headlineLabel: l10n.freelancerRealPayout,
                headlineValue: '${fmt.format(_result!.localAmount)} $_localCurrency',
                leading: RateStatusBanner(
                  isLive: _result!.rateResult.isLive,
                  asOf: _result!.rateResult.asOf,
                  source: _result!.rateResult.source,
                ),
                rows: [
                  LabeledRow(l10n.freelancerInvoiceAmountRow, '${fmt.format(_result!.grossForeign)} $_foreignCurrency'),
                  LabeledRow(l10n.freelancerPlatformFeeRow, '- ${fmt.format(_result!.platformFeeAmount)} $_foreignCurrency'),
                  LabeledRow(l10n.freelancerBankFeeRow, '- ${fmt.format(_result!.bankFeeAmount)} $_foreignCurrency'),
                  LabeledRow(l10n.freelancerNetForeignAmount, '${fmt.format(_result!.netForeign)} $_foreignCurrency', bold: true),
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

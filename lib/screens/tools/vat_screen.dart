import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../logic/vat_calculator.dart';
import '../../models/country.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../services/vat_rate_service.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

enum _VatMode { add, remove }

class VatScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const VatScreen({super.key, this.initialScenario});

  @override
  State<VatScreen> createState() => _VatScreenState();
}

class _VatScreenState extends State<VatScreen> {
  final _service = VatRateService();
  final _amountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  _VatMode _mode = _VatMode.add;
  Map<String, double>? _rates;
  DateTime? _ratesAsOf;
  Country _country = countryById('rs');
  ({double vatAmount, double gross})? _addResult;
  ({double vatAmount, double net})? _removeResult;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs != null) {
      _mode = inputs['mode'] == _VatMode.remove.name
          ? _VatMode.remove
          : _VatMode.add;
      final countryId = inputs['countryId'] as String?;
      final match = kCountries.where((c) => c.id == countryId);
      if (match.isNotEmpty) _country = match.first;
      _amountCtrl.text = inputs['amount'] as String? ?? '';
    }
    _service.loadRates().then((rates) {
      if (!mounted) return;
      setState(() {
        _rates = rates;
        _ratesAsOf = _service.lastUpdated;
        _rateCtrl.text = (inputs?['rate'] as String?) ??
            (rates[_country.id] ?? 20).toStringAsFixed(1);
      });
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    final rate = double.tryParse(_rateCtrl.text.replaceAll(',', '.'));
    if (amount == null || amount < 0 || rate == null || rate < 0) {
      setState(() {
        _addResult = null;
        _removeResult = null;
      });
      return;
    }
    setState(() {
      if (_mode == _VatMode.add) {
        _addResult = VatCalculator.addVat(amount, rate);
        _removeResult = null;
      } else {
        _removeResult = VatCalculator.removeVat(amount, rate);
        _addResult = null;
      }
    });
    _historyService.add(
      toolId: HistoryToolIds.vat,
      title: l10n.toolsVatTitle,
      summary:
          '${localizedCountryName(l10n, _country.id)} · ${rate.toStringAsFixed(0)}%',
      countryId: _country.id,
    );
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final defaultName =
        '${localizedCountryName(l10n, _country.id)} · ${_rateCtrl.text}%';
    final inputs = {
      'mode': _mode.name,
      'amount': _amountCtrl.text,
      'rate': _rateCtrl.text,
      'countryId': _country.id,
    };

    if (_mode == _VatMode.add && _addResult != null) {
      await saveScenario(
        context,
        toolId: HistoryToolIds.vat,
        defaultName: defaultName,
        summary: '${l10n.vatGrossWithVat}: ${fmt.format(_addResult!.gross)}',
        inputs: inputs,
        countryId: _country.id,
      );
    } else if (_mode == _VatMode.remove && _removeResult != null) {
      await saveScenario(
        context,
        toolId: HistoryToolIds.vat,
        defaultName: defaultName,
        summary: '${l10n.vatNetWithoutVat}: ${fmt.format(_removeResult!.net)}',
        inputs: inputs,
        countryId: _country.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vatScreenTitle)),
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
                    if (_rates != null)
                      DropdownButtonFormField<Country>(
                        initialValue: _country,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.vatStandardRateFor,
                        ),
                        items: [
                          for (final c in kCountries)
                            DropdownMenuItem(
                              value: c,
                              child: Text(
                                '${c.flagEmoji} ${localizedCountryName(l10n, c.id)} — ${(_rates![c.id] ?? 0).toStringAsFixed(0)}%',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (c) {
                          if (c == null) return;
                          setState(() {
                            _country = c;
                            _rateCtrl.text =
                                (_rates![c.id] ?? 20).toStringAsFixed(1);
                          });
                        },
                      ),
                    if (_ratesAsOf != null) ...[
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          l10n.vatRatesAsOf(
                            DateFormat('MMM d, yyyy', l10n.localeName)
                                .format(_ratesAsOf!),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SegmentedButton<_VatMode>(
                      segments: [
                        ButtonSegment(value: _VatMode.add, label: Text(l10n.vatAdd)),
                        ButtonSegment(value: _VatMode.remove, label: Text(l10n.vatRemove)),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (s) => setState(() {
                        _mode = s.first;
                        _addResult = null;
                        _removeResult = null;
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: _mode == _VatMode.add
                            ? l10n.vatNetAmount
                            : l10n.vatGrossAmount,
                        prefixIcon: const Icon(Icons.payments_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _rateCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.vatRateEditable,
                        prefixIcon: const Icon(Icons.percent),
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
            if (_addResult != null) ...[
              ResultCard(
                headlineLabel: l10n.vatGrossWithVat,
                headlineValue: fmt.format(_addResult!.gross),
                rows: [LabeledRow(l10n.vatAmountLabel, fmt.format(_addResult!.vatAmount))],
              ),
              SaveScenarioRow(onSave: () => _onSave(l10n)),
            ],
            if (_removeResult != null) ...[
              ResultCard(
                headlineLabel: l10n.vatNetWithoutVat,
                headlineValue: fmt.format(_removeResult!.net),
                rows: [LabeledRow(l10n.vatAmountLabel, fmt.format(_removeResult!.vatAmount))],
              ),
              SaveScenarioRow(onSave: () => _onSave(l10n)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/loan_calculator.dart';
import '../../models/history_entry.dart';
import '../../models/scenario.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/labeled_row.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_scenario_action.dart';

enum _LoanMode { payment, payoff }

class LoanScreen extends StatefulWidget {
  final Scenario? initialScenario;
  const LoanScreen({super.key, this.initialScenario});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  _LoanMode _mode = _LoanMode.payment;
  final _principalCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();

  LoanPaymentResult? _paymentResult;
  LoanPayoffResult? _payoffResult;
  String? _error;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    final inputs = widget.initialScenario?.inputs;
    if (inputs == null) return;
    _mode = inputs['mode'] == _LoanMode.payoff.name
        ? _LoanMode.payoff
        : _LoanMode.payment;
    _principalCtrl.text = inputs['principal'] as String? ?? '';
    _rateCtrl.text = inputs['rate'] as String? ?? '';
    if (_mode == _LoanMode.payment) {
      _monthsCtrl.text = inputs['months'] as String? ?? '';
    } else {
      _paymentCtrl.text = inputs['payment'] as String? ?? '';
    }
  }

  @override
  void dispose() {
    _principalCtrl.dispose();
    _rateCtrl.dispose();
    _monthsCtrl.dispose();
    _paymentCtrl.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    setState(() {
      _error = null;
      _paymentResult = null;
      _payoffResult = null;
    });
    final principal = double.tryParse(_principalCtrl.text.replaceAll(',', '.'));
    final rate = double.tryParse(_rateCtrl.text.replaceAll(',', '.'));
    if (principal == null || principal <= 0 || rate == null || rate < 0) {
      setState(() => _error = l10n.loanErrorPrincipalRate);
      return;
    }

    if (_mode == _LoanMode.payment) {
      final months = int.tryParse(_monthsCtrl.text);
      if (months == null || months <= 0) {
        setState(() => _error = l10n.loanErrorTerm);
        return;
      }
      setState(() {
        _paymentResult = LoanCalculator.paymentFor(
          principal: principal,
          annualRatePercent: rate,
          months: months,
        );
      });
      _historyService.add(
        toolId: HistoryToolIds.loan,
        title: l10n.toolsLoanTitle,
        summary: l10n.loanModePayment,
      );
    } else {
      final payment = double.tryParse(_paymentCtrl.text.replaceAll(',', '.'));
      if (payment == null || payment <= 0) {
        setState(() => _error = l10n.loanErrorPayment);
        return;
      }
      try {
        setState(() {
          _payoffResult = LoanCalculator.payoffFor(
            principal: principal,
            annualRatePercent: rate,
            monthlyPayment: payment,
          );
        });
        _historyService.add(
          toolId: HistoryToolIds.loan,
          title: l10n.toolsLoanTitle,
          summary: l10n.loanModePayoff,
        );
      } on PaymentTooLowException {
        setState(() => _error = l10n.loanErrorTooLow);
      }
    }
  }

  Future<void> _onSave(AppLocalizations l10n) async {
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final modeLabel =
        _mode == _LoanMode.payment ? l10n.loanModePayment : l10n.loanModePayoff;

    if (_mode == _LoanMode.payment && _paymentResult != null) {
      await saveScenario(
        context,
        toolId: HistoryToolIds.loan,
        defaultName: '${l10n.toolsLoanTitle} · $modeLabel',
        summary: '${l10n.loanMonthlyPayment}: ${fmt.format(_paymentResult!.monthlyPayment)}',
        inputs: {
          'mode': _mode.name,
          'principal': _principalCtrl.text,
          'rate': _rateCtrl.text,
          'months': _monthsCtrl.text,
        },
      );
    } else if (_mode == _LoanMode.payoff && _payoffResult != null) {
      await saveScenario(
        context,
        toolId: HistoryToolIds.loan,
        defaultName: '${l10n.toolsLoanTitle} · $modeLabel',
        summary: '${l10n.loanTimeToPayOff}: ${l10n.loanMonthsCount(_payoffResult!.months)}',
        inputs: {
          'mode': _mode.name,
          'principal': _principalCtrl.text,
          'rate': _rateCtrl.text,
          'payment': _paymentCtrl.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loanScreenTitle)),
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
                    SegmentedButton<_LoanMode>(
                      segments: [
                        ButtonSegment(
                          value: _LoanMode.payment,
                          label: Text(l10n.loanModePayment),
                        ),
                        ButtonSegment(
                          value: _LoanMode.payoff,
                          label: Text(l10n.loanModePayoff),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (s) => setState(() {
                        _mode = s.first;
                        _paymentResult = null;
                        _payoffResult = null;
                        _error = null;
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _principalCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.loanPrincipal,
                        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _rateCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.loanRate,
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_mode == _LoanMode.payment)
                      TextField(
                        controller: _monthsCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.loanTermMonths,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                        ),
                      )
                    else
                      TextField(
                        controller: _paymentCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: l10n.loanFixedPayment,
                          prefixIcon: const Icon(Icons.payments_outlined),
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
            if (_paymentResult != null) ...[
              ResultCard(
                headlineLabel: l10n.loanMonthlyPayment,
                headlineValue: fmt.format(_paymentResult!.monthlyPayment),
                rows: [
                  LabeledRow(l10n.loanTotalPaid, fmt.format(_paymentResult!.totalPaid)),
                  LabeledRow(l10n.loanTotalInterest, fmt.format(_paymentResult!.totalInterest)),
                  LabeledRow(l10n.loanNumberOfPayments, '${_paymentResult!.schedule.length}'),
                ],
              ),
              SaveScenarioRow(onSave: () => _onSave(l10n)),
            ],
            if (_payoffResult != null) ...[
              ResultCard(
                headlineLabel: l10n.loanTimeToPayOff,
                headlineValue: l10n.loanMonthsCount(_payoffResult!.months),
                rows: [
                  LabeledRow(l10n.loanTotalPaid, fmt.format(_payoffResult!.totalPaid)),
                  LabeledRow(l10n.loanTotalInterest, fmt.format(_payoffResult!.totalInterest)),
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

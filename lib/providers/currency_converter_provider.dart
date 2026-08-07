import 'package:flutter/foundation.dart';

import '../models/rate_snapshot.dart';
import '../services/exchange_rate_service.dart';
import '../utils/validators.dart';

enum LoadStatus { idle, loading, success, error }

/// Max sane amount for a single currency conversion — anything above this is
/// flagged as a likely typo instead of silently converted.
const double kMaxConversionAmount = 1000000000; // 1 billion

class CurrencyConverterProvider extends ChangeNotifier {
  final ExchangeRateService _service;

  CurrencyConverterProvider({
    ExchangeRateService? service,
    String? initialFrom,
    String? initialTo,
    String? initialAmountText,
  }) : _service = service ?? ExchangeRateService() {
    if (initialFrom != null) from = initialFrom;
    if (initialTo != null) to = initialTo;
    if (initialAmountText != null) amountText = initialAmountText;
  }

  String from = 'EUR';
  String to = 'RSD';
  String amountText = '100';

  LoadStatus status = LoadStatus.idle;
  RateResult? result;
  String? errorMessage;
  AmountIssue? amountIssue;

  double? get convertedAmount {
    final r = result;
    if (r == null) return null;
    final parsed = parseAmountInput(amountText, max: kMaxConversionAmount);
    if (!parsed.isValid) return null;
    return parsed.value! * r.rate;
  }

  void setFrom(String code) {
    if (code == from) return;
    from = code;
    _clearStaleResult();
    notifyListeners();
  }

  void setTo(String code) {
    if (code == to) return;
    to = code;
    _clearStaleResult();
    notifyListeners();
  }

  void swap() {
    final tmp = from;
    from = to;
    to = tmp;
    _clearStaleResult();
    notifyListeners();
  }

  void setAmount(String text) {
    amountText = text;
    _clearStaleResult();
    notifyListeners();
  }

  void _clearStaleResult() {
    // Prevent any previously computed value/rate from lingering on screen
    // once inputs change — the user must re-run the conversion.
    result = null;
    errorMessage = null;
    amountIssue = null;
    status = LoadStatus.idle;
  }

  Future<void> convert() async {
    final parsed = parseAmountInput(amountText, max: kMaxConversionAmount);
    amountIssue = parsed.issue;
    if (!parsed.isValid) {
      status = LoadStatus.error;
      result = null;
      errorMessage = null;
      notifyListeners();
      return;
    }

    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final rateResult = await _service.getRate(from, to);
      result = rateResult;
      status = LoadStatus.success;
    } on RateUnavailableException catch (e) {
      result = null;
      errorMessage = e.message;
      status = LoadStatus.error;
    } catch (e) {
      result = null;
      errorMessage = 'Unexpected error: $e';
      status = LoadStatus.error;
    }
    notifyListeners();
  }
}

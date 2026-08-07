import '../models/rate_snapshot.dart';
import '../services/exchange_rate_service.dart';

/// A named platform-fee preset — a starting point the user can override,
/// not a promise that a given platform's fee never changes.
class PlatformFeePreset {
  final String id;
  final String label;
  final double feePercent;

  const PlatformFeePreset({
    required this.id,
    required this.label,
    required this.feePercent,
  });
}

const kPlatformFeePresets = <PlatformFeePreset>[
  PlatformFeePreset(id: 'custom', label: 'Custom', feePercent: 0),
  PlatformFeePreset(id: 'upwork', label: 'Upwork (10%)', feePercent: 10),
  PlatformFeePreset(id: 'fiverr', label: 'Fiverr (20%)', feePercent: 20),
  PlatformFeePreset(id: 'payoneer', label: 'Payoneer (~2%)', feePercent: 2),
  PlatformFeePreset(id: 'direct', label: 'Direct client / wire (0%)', feePercent: 0),
];

class FreelancerPayoutResult {
  final double grossForeign;
  final double platformFeeAmount;
  final double bankFeeAmount;
  final double netForeign;
  final double localAmount;
  final RateResult rateResult;

  const FreelancerPayoutResult({
    required this.grossForeign,
    required this.platformFeeAmount,
    required this.bankFeeAmount,
    required this.netForeign,
    required this.localAmount,
    required this.rateResult,
  });
}

/// Foreign invoice -> platform fee -> bank/wire fee -> real local-currency
/// take-home, using the app's existing [ExchangeRateService] (same
/// live-then-cached-then-explicit-error discipline as the Convert tab —
/// never a fabricated rate).
class FreelancerPayoutCalculator {
  final ExchangeRateService _rateService;

  FreelancerPayoutCalculator({ExchangeRateService? rateService})
      : _rateService = rateService ?? ExchangeRateService();

  Future<FreelancerPayoutResult> compute({
    required double grossForeign,
    required String foreignCurrency,
    required double platformFeePercent,
    required double bankFeeFlat,
    required double bankFeePercent,
    required String localCurrency,
  }) async {
    final platformFeeAmount = grossForeign * (platformFeePercent / 100);
    final afterPlatformFee = grossForeign - platformFeeAmount;
    final bankFeeAmount =
        bankFeeFlat + afterPlatformFee * (bankFeePercent / 100);
    final netForeign =
        (afterPlatformFee - bankFeeAmount).clamp(0, double.infinity);

    final rateResult = await _rateService.getRate(foreignCurrency, localCurrency);
    final localAmount = netForeign * rateResult.rate;

    return FreelancerPayoutResult(
      grossForeign: grossForeign,
      platformFeeAmount: platformFeeAmount,
      bankFeeAmount: bankFeeAmount,
      netForeign: netForeign.toDouble(),
      localAmount: localAmount,
      rateResult: rateResult,
    );
  }
}

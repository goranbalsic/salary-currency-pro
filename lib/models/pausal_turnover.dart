/// How close a tracked total is to one of the two paušal-related limits —
/// PROMPT-003E item 11.1. Text-labeled in the UI in addition to color, per
/// this app's accessibility rule (never color alone).
enum PausalThresholdState { ok, warning70, warning85, warning95, exceeded }

PausalThresholdState thresholdStateForPercent(double percent) {
  if (percent >= 100) return PausalThresholdState.exceeded;
  if (percent >= 95) return PausalThresholdState.warning95;
  if (percent >= 85) return PausalThresholdState.warning85;
  if (percent >= 70) return PausalThresholdState.warning70;
  return PausalThresholdState.ok;
}

/// One limit's status — either the calendar-year paušal ceiling or the
/// rolling-12-month VAT registration threshold. Both are tracked
/// simultaneously and shown separately since they use different windows and
/// have different consequences.
class PausalLimitStatus {
  final double totalRsd;
  final double thresholdRsd;

  const PausalLimitStatus({
    required this.totalRsd,
    required this.thresholdRsd,
  });

  double get percent => thresholdRsd <= 0 ? 0 : (totalRsd / thresholdRsd * 100).clamp(0, 999);

  PausalThresholdState get state =>
      thresholdRsd <= 0 ? PausalThresholdState.ok : thresholdStateForPercent(percent);
}

/// One invoice's contribution to the tracked turnover — included with its
/// converted RSD amount and the rate/source used, or excluded with a reason.
/// Every included invoice must be traceable back to a real, dated
/// conversion; nothing here is ever a guessed or substituted rate.
class PausalInvoiceContribution {
  final String invoiceId;
  final String clientName;
  final DateTime issueDate;
  final double originalAmount;
  final String originalCurrency;

  /// Null when [excluded] is true.
  final double? rsdAmount;
  final double? rateToRsd;
  final String? rateSource;
  final DateTime? rateCapturedAt;

  final bool excluded;

  const PausalInvoiceContribution({
    required this.invoiceId,
    required this.clientName,
    required this.issueDate,
    required this.originalAmount,
    required this.originalCurrency,
    this.rsdAmount,
    this.rateToRsd,
    this.rateSource,
    this.rateCapturedAt,
    this.excluded = false,
  });
}

/// Full computed turnover picture as of a moment in time — PROMPT-003E
/// 11.1. [calendarYear] tracks the paušal ceiling (Jan 1 - Dec 31 of
/// [asOf]'s year); [rollingTwelveMonths] tracks the VAT registration
/// threshold (the 365 days ending [asOf]). [contributions] lists every
/// invoice considered, included or excluded, for the tap-through
/// explanation; [projectedCeilingDate] is a simple current-pace projection
/// for the paušal ceiling only, null when there isn't enough data or the
/// pace doesn't point at ever reaching it.
class PausalTurnoverSummary {
  final DateTime asOf;
  final PausalLimitStatus calendarYear;
  final PausalLimitStatus rollingTwelveMonths;
  final List<PausalInvoiceContribution> contributions;
  final DateTime? projectedCeilingDate;

  const PausalTurnoverSummary({
    required this.asOf,
    required this.calendarYear,
    required this.rollingTwelveMonths,
    required this.contributions,
    this.projectedCeilingDate,
  });

  int get excludedCount => contributions.where((c) => c.excluded).length;
}

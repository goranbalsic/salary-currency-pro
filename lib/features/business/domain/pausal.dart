import 'dart:math' as math;

import '../../../core/money/money.dart';

/// Serbian flat-rate (paušal) entrepreneurs must stay under two limits:
/// 6,000,000 RSD of revenue in a calendar year to keep the flat-rate regime,
/// and 8,000,000 RSD in any 12 consecutive months to stay outside VAT.
abstract final class PausalLimits {
  static const annualLimitRsd = 6000000.0;
  static const vatLimitRsd = 8000000.0;
  static const warnShare = 0.8;
}

/// One revenue record in dinars: an invoice or a manual entry.
class RevenueEntry {
  const RevenueEntry({required this.date, required this.amountRsd});
  final DateTime date;
  final double amountRsd;
}

class PausalStatus {
  const PausalStatus({
    required this.yearToDate,
    required this.last12Months,
    required this.projectedYearEnd,
    required this.year,
  });

  final int year;
  final double yearToDate;
  final double last12Months;

  /// Year-to-date revenue extrapolated to 31 December at the same daily pace.
  final double? projectedYearEnd;

  double get annualShare => yearToDate / PausalLimits.annualLimitRsd;
  double get vatShare => last12Months / PausalLimits.vatLimitRsd;
  double get annualRemaining => math.max(0, PausalLimits.annualLimitRsd - yearToDate);
  double get vatRemaining => math.max(0, PausalLimits.vatLimitRsd - last12Months);
  bool get projectedOverAnnual => (projectedYearEnd ?? 0) > PausalLimits.annualLimitRsd;
}

abstract final class PausalTracker {
  static PausalStatus compute(Iterable<RevenueEntry> entries, DateTime today) {
    final day = DateTime(today.year, today.month, today.day);
    final yearStart = DateTime(day.year);
    // The 12-month window ends today and starts on the same day a year ago
    // (plus one day), i.e. 365 or 366 days inclusive.
    // Calendar arithmetic via the DateTime constructor, never Duration, so
    // daylight-saving changes cannot shift a day boundary.
    final lastDayPrevYearMonth = DateTime(day.year - 1, day.month + 1, 0).day;
    final windowStart = DateTime(day.year - 1, day.month, math.min(day.day, lastDayPrevYearMonth) + 1);
    final ytd = <double>[];
    final rolling = <double>[];
    for (final e in entries) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      if (d.isAfter(day)) continue;
      if (!d.isBefore(yearStart)) ytd.add(e.amountRsd);
      if (!d.isBefore(windowStart)) rolling.add(e.amountRsd);
    }
    final ytdTotal = Money.sum(ytd);
    final daysElapsed = DateTime.utc(day.year, day.month, day.day).difference(DateTime.utc(day.year)).inDays + 1;
    final daysInYear = DateTime.utc(day.year + 1).difference(DateTime.utc(day.year)).inDays;
    final projected = daysElapsed >= 30 && ytdTotal > 0 ? Money.round(ytdTotal / daysElapsed * daysInYear) : null;
    return PausalStatus(
      year: day.year,
      yearToDate: ytdTotal,
      last12Months: Money.sum(rolling),
      projectedYearEnd: projected,
    );
  }
}

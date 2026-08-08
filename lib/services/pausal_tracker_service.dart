import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pausal_turnover.dart';
import '../models/rate_snapshot.dart';
import 'exchange_rate_service.dart';
import 'invoice_service.dart';
import 'tax_rules_service.dart';

/// Serbia paušal & VAT turnover tracker — PROMPT-003E item 11.1. Fed by the
/// existing [InvoiceService] rather than a new data-entry surface. The two
/// sourced RSD limits (paušal ceiling, VAT registration threshold) always
/// come from the same `tax_rules.json` "rs" regime the freelance-tax
/// calculator uses (see [TaxRulesService]) — never a literal in this file,
/// so both features can never silently disagree if the figures are ever
/// updated.
///
/// **Rate-history design note (see DECISIONS.md):** this app has no
/// per-date historical FX archive — [ExchangeRateService] only ever fetches
/// the *latest* rate for a pair, and [RateCacheService] only caches the
/// most recent snapshot. Building a full historical-by-date archive was out
/// of this item's scope. Instead, the first time a foreign-currency
/// invoice is seen by this tracker, its RSD rate is captured once and
/// stored permanently against that invoice id — "the rate this tracker
/// first converted it at", not a guaranteed NBS rate for the invoice's own
/// issue date. This is disclosed in the UI, not silently presented as
/// authoritative. An invoice whose rate could never be captured (offline
/// the first time, and every time since) is excluded and counted, per the
/// "honest gaps over fake totals" rule — never silently priced at today's
/// rate.
class PausalTrackerService {
  static const _prefsConversionsKey = 'pausal_rsd_conversions_v1';
  static const _prefsAssessedAmountKey = 'pausal_assessed_amount_v1';

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  final InvoiceService _invoices;
  final ExchangeRateService _exchangeRates;
  final TaxRulesService _taxRules;

  PausalTrackerService({
    InvoiceService? invoiceService,
    ExchangeRateService? exchangeRateService,
    TaxRulesService? taxRulesService,
  })  : _invoices = invoiceService ?? InvoiceService(),
        _exchangeRates = exchangeRateService ?? ExchangeRateService(),
        _taxRules = taxRulesService ?? TaxRulesService();

  Future<double?> getAssessedMonthlyAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_prefsAssessedAmountKey);
  }

  Future<void> setAssessedMonthlyAmount(double? amount) async {
    final prefs = await SharedPreferences.getInstance();
    if (amount == null) {
      await prefs.remove(_prefsAssessedAmountKey);
    } else {
      await prefs.setDouble(_prefsAssessedAmountKey, amount);
    }
    changes.value++;
  }

  Future<Map<String, dynamic>> _loadConversions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsConversionsKey);
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveConversions(Map<String, dynamic> conversions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsConversionsKey, jsonEncode(conversions));
  }

  /// Computes the full turnover picture as of [asOf] (defaults to now).
  /// Attempts to capture a fresh RSD conversion for any non-RSD invoice
  /// that doesn't have one stored yet; every other invoice reuses its
  /// already-captured rate unchanged, even if a live rate is available now
  /// — captured rates are immutable once set, so totals stay stable between
  /// views rather than drifting every time the screen is reopened.
  Future<PausalTurnoverSummary> computeSummary({DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    final allInvoices = await _invoices.loadAll();
    final rules = (await _taxRules.load()).rules.regime('rs');
    final pausalCeiling = rules.field('pausalCeilingAnnual').asDouble!;
    final vatThreshold = rules.field('vatThresholdRolling12m').asDouble!;

    final conversions = await _loadConversions();
    // Prune conversions for invoices that no longer exist.
    final liveIds = allInvoices.map((i) => i.id).toSet();
    final beforePruneCount = conversions.length;
    conversions.removeWhere((id, _) => !liveIds.contains(id));
    var conversionsChanged = conversions.length != beforePruneCount;

    final contributions = <PausalInvoiceContribution>[];
    for (final invoice in allInvoices) {
      if (invoice.currencyCode == rsdCode) {
        contributions.add(PausalInvoiceContribution(
          invoiceId: invoice.id,
          clientName: invoice.clientName,
          issueDate: invoice.issueDate,
          originalAmount: invoice.amount,
          originalCurrency: invoice.currencyCode,
          rsdAmount: invoice.amount,
          rateToRsd: 1.0,
          rateSource: null,
        ));
        continue;
      }

      final stored = conversions[invoice.id] as Map<String, dynamic>?;
      if (stored != null && stored['currencyCode'] == invoice.currencyCode) {
        contributions.add(PausalInvoiceContribution(
          invoiceId: invoice.id,
          clientName: invoice.clientName,
          issueDate: invoice.issueDate,
          originalAmount: invoice.amount,
          originalCurrency: invoice.currencyCode,
          rsdAmount: invoice.amount * (stored['rateToRsd'] as num).toDouble(),
          rateToRsd: (stored['rateToRsd'] as num).toDouble(),
          rateSource: stored['source'] as String,
          rateCapturedAt: DateTime.tryParse(stored['capturedAt'] as String? ?? ''),
        ));
        continue;
      }

      // No usable stored conversion — try to capture one now.
      RateResult? result;
      try {
        result = await _exchangeRates.getRate(invoice.currencyCode, rsdCode);
      } catch (_) {
        result = null;
      }

      if (result == null) {
        contributions.add(PausalInvoiceContribution(
          invoiceId: invoice.id,
          clientName: invoice.clientName,
          issueDate: invoice.issueDate,
          originalAmount: invoice.amount,
          originalCurrency: invoice.currencyCode,
          excluded: true,
        ));
        continue;
      }

      final capturedAt = DateTime.now();
      conversions[invoice.id] = {
        'currencyCode': invoice.currencyCode,
        'rateToRsd': result.rate,
        'source': result.source,
        'capturedAt': capturedAt.toIso8601String(),
      };
      conversionsChanged = true;

      contributions.add(PausalInvoiceContribution(
        invoiceId: invoice.id,
        clientName: invoice.clientName,
        issueDate: invoice.issueDate,
        originalAmount: invoice.amount,
        originalCurrency: invoice.currencyCode,
        rsdAmount: invoice.amount * result.rate,
        rateToRsd: result.rate,
        rateSource: result.source,
        rateCapturedAt: capturedAt,
      ));
    }

    if (conversionsChanged) {
      await _saveConversions(conversions);
    }

    final yearStart = DateTime(now.year, 1, 1);
    final yearEnd = DateTime(now.year, 12, 31, 23, 59, 59);
    final rollingStart = now.subtract(const Duration(days: 365));

    double sumIncluded(bool Function(PausalInvoiceContribution) inWindow) => contributions
        .where((c) => !c.excluded && inWindow(c))
        .fold(0.0, (sum, c) => sum + c.rsdAmount!);

    final calendarYearTotal = sumIncluded(
      (c) => !c.issueDate.isBefore(yearStart) && !c.issueDate.isAfter(yearEnd),
    );
    final rollingTotal = sumIncluded(
      (c) => !c.issueDate.isBefore(rollingStart) && !c.issueDate.isAfter(now),
    );

    final calendarYear = PausalLimitStatus(totalRsd: calendarYearTotal, thresholdRsd: pausalCeiling);
    final rollingTwelveMonths = PausalLimitStatus(totalRsd: rollingTotal, thresholdRsd: vatThreshold);

    DateTime? projectedCeilingDate;
    final daysElapsedThisYear = now.difference(yearStart).inDays + 1;
    if (daysElapsedThisYear >= 14 && calendarYearTotal < pausalCeiling) {
      final dailyRate = calendarYearTotal / daysElapsedThisYear;
      if (dailyRate > 0) {
        final daysRemaining = ((pausalCeiling - calendarYearTotal) / dailyRate).ceil();
        if (daysRemaining <= 3650) {
          projectedCeilingDate = now.add(Duration(days: daysRemaining));
        }
      }
    }

    return PausalTurnoverSummary(
      asOf: now,
      calendarYear: calendarYear,
      rollingTwelveMonths: rollingTwelveMonths,
      contributions: contributions..sort((a, b) => b.issueDate.compareTo(a.issueDate)),
      projectedCeilingDate: projectedCeilingDate,
    );
  }
}

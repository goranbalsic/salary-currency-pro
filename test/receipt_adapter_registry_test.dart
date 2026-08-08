import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/logic/receipt_scan/receipt_adapter_registry.dart';
import 'package:salary_currency_pro/logic/receipt_scan/serbia_receipt_adapter.dart';
import 'package:salary_currency_pro/models/fiscal_receipt_scan.dart';

void main() {
  group('SerbiaReceiptAdapter', () {
    const adapter = SerbiaReceiptAdapter();

    test('recognizes the documented suf.purs.gov.rs fiscal URL format', () {
      final outcome = adapter.classify('https://suf.purs.gov.rs/v/?vl=ABC123XYZ');
      expect(outcome, ReceiptScanOutcome.recognized);
    });

    test('recognizes with extra query params alongside vl', () {
      final outcome =
          adapter.classify('https://suf.purs.gov.rs/v/?vl=ABC123&extra=1');
      expect(outcome, ReceiptScanOutcome.recognized);
    });

    test('rejects http (not https) as malformed, not recognized', () {
      final outcome = adapter.classify('http://suf.purs.gov.rs/v/?vl=ABC123');
      expect(outcome, ReceiptScanOutcome.malformed);
    });

    test('rejects missing vl parameter as malformed', () {
      final outcome = adapter.classify('https://suf.purs.gov.rs/v/');
      expect(outcome, ReceiptScanOutcome.malformed);
    });

    test('rejects empty vl parameter as malformed', () {
      final outcome = adapter.classify('https://suf.purs.gov.rs/v/?vl=');
      expect(outcome, ReceiptScanOutcome.malformed);
    });

    test('rejects wrong path as malformed', () {
      final outcome = adapter.classify('https://suf.purs.gov.rs/other/?vl=ABC123');
      expect(outcome, ReceiptScanOutcome.malformed);
    });

    test('rejects a lookalike subdomain/host as not-applicable (null)', () {
      // A phishing-style host must never be treated as a Serbia near-match.
      final outcome = adapter.classify('https://suf.purs.gov.rs.evil.example/v/?vl=x');
      expect(outcome, isNull);
    });

    test('returns null for a completely unrelated URL', () {
      expect(adapter.classify('https://example.com/'), isNull);
    });

    test('returns null for plain non-URL text', () {
      expect(adapter.classify('just some scanned text'), isNull);
    });

    test('treats non-URL text mentioning the host as malformed', () {
      final outcome = adapter.classify('broken data from suf.purs.gov.rs but not a url');
      expect(outcome, ReceiptScanOutcome.malformed);
    });
  });

  group('ReceiptAdapterRegistry', () {
    final registry = ReceiptAdapterRegistry();

    test('classifies a valid Serbian fiscal URL as recognized with countryId rs', () {
      final result = registry.classify('https://suf.purs.gov.rs/v/?vl=ABC123');
      expect(result.outcome, ReceiptScanOutcome.recognized);
      expect(result.countryId, 'rs');
    });

    test('classifies a malformed near-match with countryId rs still set', () {
      final result = registry.classify('https://suf.purs.gov.rs/v/');
      expect(result.outcome, ReceiptScanOutcome.malformed);
      expect(result.countryId, 'rs');
    });

    test('classifies an unrelated QR payload as unknownFormat with no countryId', () {
      final result = registry.classify('https://example.com/some-page');
      expect(result.outcome, ReceiptScanOutcome.unknownFormat);
      expect(result.countryId, isNull);
    });

    test('classifies empty payload as unknownFormat without throwing', () {
      final result = registry.classify('');
      expect(result.outcome, ReceiptScanOutcome.unknownFormat);
    });

    test('adapter selection is deterministic across repeated calls', () {
      const payload = 'https://suf.purs.gov.rs/v/?vl=ABC123';
      final first = registry.classify(payload);
      final second = registry.classify(payload);
      expect(first.outcome, second.outcome);
      expect(first.countryId, second.countryId);
    });
  });
}

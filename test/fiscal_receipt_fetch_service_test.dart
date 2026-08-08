import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/fiscal_receipt_scan.dart';
import 'package:salary_currency_pro/services/fiscal_receipt_fetch_service.dart';

void main() {
  test('UnavailableFiscalReceiptFetchService always reports unavailable',
      () async {
    const service = UnavailableFiscalReceiptFetchService();
    final scan = FiscalReceiptScan(
      id: 'x',
      rawPayload: 'https://suf.purs.gov.rs/v/?vl=ABC123',
      scannedAt: DateTime(2026, 1, 1),
      outcome: ReceiptScanOutcome.recognized,
      countryId: 'rs',
    );

    final result = await service.fetchReceiptContent(scan);

    expect(result.status, FiscalReceiptFetchStatus.unavailable);
    expect(result.isAvailable, isFalse);
  });

  test('fetchReceiptContent completes immediately with no pending network '
      'I/O — a real HTTP call would need a mocked client or would hang/'
      'fail in a unit-test sandbox with no network access; this returns '
      'synchronously instead', () async {
    const service = UnavailableFiscalReceiptFetchService();
    final scan = FiscalReceiptScan(
      id: 'x',
      rawPayload: 'anything',
      scannedAt: DateTime(2026, 1, 1),
      outcome: ReceiptScanOutcome.unknownFormat,
    );

    // A real network call in the flutter_test environment (no plugin
    // bindings, no sockets) would throw or hang. Racing against a short
    // timeout catches any accidental network attempt without needing to
    // mock an HTTP client that intentionally doesn't exist here.
    final result = await service
        .fetchReceiptContent(scan)
        .timeout(const Duration(milliseconds: 200));

    expect(result.status, FiscalReceiptFetchStatus.unavailable);
  });

  test('every outcome value in FiscalReceiptFetchStatus is unavailable — '
      'there is no code path in this app that can report otherwise', () {
    expect(FiscalReceiptFetchStatus.values, [FiscalReceiptFetchStatus.unavailable]);
  });
}

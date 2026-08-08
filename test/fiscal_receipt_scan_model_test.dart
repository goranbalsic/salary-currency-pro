import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/fiscal_receipt_scan.dart';

void main() {
  group('FiscalReceiptScan serialization', () {
    test('round-trips through toJson/fromJson unchanged', () {
      final scan = FiscalReceiptScan(
        id: 'abc-1',
        rawPayload: 'https://suf.purs.gov.rs/v/?vl=ABC123',
        scannedAt: DateTime(2026, 8, 8, 10, 30),
        outcome: ReceiptScanOutcome.recognized,
        countryId: 'rs',
        note: 'Lunch receipt',
      );
      final restored = FiscalReceiptScan.fromJson(scan.toJson());
      expect(restored.id, scan.id);
      expect(restored.rawPayload, scan.rawPayload);
      expect(restored.scannedAt, scan.scannedAt);
      expect(restored.outcome, scan.outcome);
      expect(restored.countryId, scan.countryId);
      expect(restored.status, scan.status);
      expect(restored.note, scan.note);
    });

    test('defaults status to awaitingFetch when constructed', () {
      final scan = FiscalReceiptScan(
        id: 'abc-2',
        rawPayload: 'raw',
        scannedAt: DateTime(2026, 1, 1),
        outcome: ReceiptScanOutcome.unknownFormat,
      );
      expect(scan.status, ScanQueueStatus.awaitingFetch);
      expect(scan.linkedExpenseId, isNull);
    });

    test('fromJson tolerates missing schemaVersion/status/note/linkedExpenseId '
        '(pre-migration or partially-written data) without crashing', () {
      final restored = FiscalReceiptScan.fromJson({
        'id': 'legacy-1',
        'rawPayload': 'https://suf.purs.gov.rs/v/?vl=X',
        'scannedAt': DateTime(2026, 1, 1).toIso8601String(),
        'outcome': 'recognized',
        'countryId': 'rs',
      });
      expect(restored.schemaVersion, 1);
      expect(restored.status, ScanQueueStatus.awaitingFetch);
      expect(restored.note, '');
      expect(restored.linkedExpenseId, isNull);
    });

    test('fromJson falls back to unknownFormat for an unrecognized outcome '
        'string rather than throwing', () {
      final restored = FiscalReceiptScan.fromJson({
        'id': 'x',
        'rawPayload': 'raw',
        'scannedAt': DateTime(2026, 1, 1).toIso8601String(),
        'outcome': 'some_future_value_not_yet_known',
      });
      expect(restored.outcome, ReceiptScanOutcome.unknownFormat);
    });

    test('fromJson falls back to awaitingFetch for an unrecognized status '
        'string rather than throwing', () {
      final restored = FiscalReceiptScan.fromJson({
        'id': 'x',
        'rawPayload': 'raw',
        'scannedAt': DateTime(2026, 1, 1).toIso8601String(),
        'outcome': 'unknownFormat',
        'status': 'some_future_status',
      });
      expect(restored.status, ScanQueueStatus.awaitingFetch);
    });

    test('copyWith updates status and linkedExpenseId without touching '
        'other fields', () {
      final scan = FiscalReceiptScan(
        id: 'abc-3',
        rawPayload: 'raw',
        scannedAt: DateTime(2026, 1, 1),
        outcome: ReceiptScanOutcome.recognized,
        countryId: 'rs',
      );
      final linked = scan.copyWith(
        status: ScanQueueStatus.expenseCreated,
        linkedExpenseId: 'expense-1',
      );
      expect(linked.status, ScanQueueStatus.expenseCreated);
      expect(linked.linkedExpenseId, 'expense-1');
      expect(linked.id, scan.id);
      expect(linked.rawPayload, scan.rawPayload);
      expect(linked.countryId, scan.countryId);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/fiscal_receipt_scan.dart';
import 'package:salary_currency_pro/services/fiscal_receipt_scan_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll on a fresh install returns an empty list, not null/crash',
      () async {
    final service = FiscalReceiptScanService();
    expect(await service.loadAll(), isEmpty);
  });

  test('recordScan classifies and persists a recognized Serbian scan',
      () async {
    final service = FiscalReceiptScanService();
    final scan = await service.recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    expect(scan.outcome, ReceiptScanOutcome.recognized);
    expect(scan.countryId, 'rs');
    expect(scan.status, ScanQueueStatus.awaitingFetch);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.id, scan.id);
    expect(all.first.rawPayload, 'https://suf.purs.gov.rs/v/?vl=ABC123');
  });

  test('recordScan persists unknown-format scans without discarding the '
      'raw payload', () async {
    final service = FiscalReceiptScanService();
    final scan = await service.recordScan('not a fiscal receipt at all');
    expect(scan.outcome, ReceiptScanOutcome.unknownFormat);
    expect(scan.countryId, isNull);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.rawPayload, 'not a fiscal receipt at all');
  });

  test('loadAll returns newest-first regardless of insertion order',
      () async {
    final service = FiscalReceiptScanService();
    await service.recordScan('payload-1');
    await Future<void>.delayed(const Duration(milliseconds: 2));
    await service.recordScan('payload-2');
    await Future<void>.delayed(const Duration(milliseconds: 2));
    await service.recordScan('payload-3');

    final all = await service.loadAll();
    expect(all, hasLength(3));
    expect(all.first.rawPayload, 'payload-3');
    expect(all.last.rawPayload, 'payload-1');
  });

  test('delete removes exactly the targeted scan', () async {
    final service = FiscalReceiptScanService();
    final a = await service.recordScan('payload-a');
    await service.recordScan('payload-b');

    await service.delete(a.id);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.rawPayload, 'payload-b');
  });

  test('linkExpense sets status to expenseCreated and stores the reference',
      () async {
    final service = FiscalReceiptScanService();
    final scan = await service.recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');

    await service.linkExpense(id: scan.id, expenseId: 'expense-42');

    final found = await service.find(scan.id);
    expect(found, isNotNull);
    expect(found!.status, ScanQueueStatus.expenseCreated);
    expect(found.linkedExpenseId, 'expense-42');
  });

  test('linkExpense is a no-op for an id that no longer exists', () async {
    final service = FiscalReceiptScanService();
    await service.linkExpense(id: 'nonexistent', expenseId: 'expense-1');
    expect(await service.loadAll(), isEmpty);
  });

  test('changes notifier increments on record, delete, and link', () async {
    final service = FiscalReceiptScanService();
    final before = FiscalReceiptScanService.changes.value;

    final scan = await service.recordScan('payload');
    expect(FiscalReceiptScanService.changes.value, greaterThan(before));

    final afterRecord = FiscalReceiptScanService.changes.value;
    await service.linkExpense(id: scan.id, expenseId: 'e1');
    expect(FiscalReceiptScanService.changes.value, greaterThan(afterRecord));

    final afterLink = FiscalReceiptScanService.changes.value;
    await service.delete(scan.id);
    expect(FiscalReceiptScanService.changes.value, greaterThan(afterLink));
  });

  test('restore re-inserts a previously-deleted scan unchanged', () async {
    final service = FiscalReceiptScanService();
    final scan = await service.recordScan('https://suf.purs.gov.rs/v/?vl=ABC123');
    await service.delete(scan.id);
    expect(await service.loadAll(), isEmpty);

    await service.restore(scan);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.id, scan.id);
    expect(all.first.rawPayload, scan.rawPayload);
  });

  test('restore is a no-op if a scan with the same id already exists',
      () async {
    final service = FiscalReceiptScanService();
    final scan = await service.recordScan('payload');

    await service.restore(scan);

    final all = await service.loadAll();
    expect(all, hasLength(1));
  });

  test('loadAll degrades to an empty list on corrupt stored data rather '
      'than crashing', () async {
    SharedPreferences.setMockInitialValues({
      'fiscal_receipt_scans_v1': 'not valid json',
    });
    final service = FiscalReceiptScanService();
    expect(await service.loadAll(), isEmpty);
  });
}

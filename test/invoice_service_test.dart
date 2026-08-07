import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/services/invoice_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll on a fresh install returns an empty list', () async {
    final service = InvoiceService();
    expect(await service.loadAll(), isEmpty);
  });

  test('add() persists an invoice, unpaid by default', () async {
    final service = InvoiceService();
    final invoice = await service.add(
      clientName: 'Acme d.o.o.',
      description: 'Website redesign',
      amount: 1500,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 15),
    );
    expect(invoice.isPaid, isFalse);
    expect(invoice.paidDate, isNull);

    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.clientName, 'Acme d.o.o.');
    expect(all.first.amount, 1500);
  });

  test('isOverdueAsOf is true only when unpaid and past the due date', () async {
    final service = InvoiceService();
    final invoice = await service.add(
      clientName: 'Acme',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );

    expect(invoice.isOverdueAsOf(DateTime(2026, 8, 5)), isFalse);
    expect(invoice.isOverdueAsOf(DateTime(2026, 8, 15)), isTrue);
  });

  test('markPaid(true) sets isPaid and records a paidDate, and an overdue '
      'invoice stops being overdue once paid', () async {
    final service = InvoiceService();
    final invoice = await service.add(
      clientName: 'Acme',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );

    await service.markPaid(invoice.id);
    final all = await service.loadAll();
    expect(all.first.isPaid, isTrue);
    expect(all.first.paidDate, isNotNull);
    expect(all.first.isOverdueAsOf(DateTime(2026, 9, 1)), isFalse);
  });

  test('markPaid(false) reverts a paid invoice back to unpaid with no paidDate',
      () async {
    final service = InvoiceService();
    final invoice = await service.add(
      clientName: 'Acme',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );
    await service.markPaid(invoice.id);
    await service.markPaid(invoice.id, paid: false);

    final all = await service.loadAll();
    expect(all.first.isPaid, isFalse);
    expect(all.first.paidDate, isNull);
  });

  test('update() replaces the full invoice record in place', () async {
    final service = InvoiceService();
    await service.add(
      clientName: 'Acme',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );

    final all = await service.loadAll();
    final updated = Invoice(
      id: all.first.id,
      clientName: 'Acme Renamed',
      amount: 250,
      currencyCode: 'USD',
      issueDate: all.first.issueDate,
      dueDate: all.first.dueDate,
    );
    await service.update(updated);

    final reloaded = await service.loadAll();
    expect(reloaded.first.clientName, 'Acme Renamed');
    expect(reloaded.first.amount, 250);
    expect(reloaded.first.currencyCode, 'USD');
  });

  test('delete() removes only the targeted invoice', () async {
    final service = InvoiceService();
    final a = await service.add(
      clientName: 'A',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );
    await service.add(
      clientName: 'B',
      amount: 200,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );

    await service.delete(a.id);
    final all = await service.loadAll();
    expect(all, hasLength(1));
    expect(all.first.clientName, 'B');
  });

  test('clear() empties the invoice ledger', () async {
    final service = InvoiceService();
    await service.add(
      clientName: 'A',
      amount: 100,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 8, 1),
      dueDate: DateTime(2026, 8, 10),
    );
    await service.clear();
    expect(await service.loadAll(), isEmpty);
  });

  test('corrupt locally-stored JSON degrades to an empty list rather than throwing',
      () async {
    SharedPreferences.setMockInitialValues({'invoices_v1': '{not valid json'});
    final service = InvoiceService();
    expect(await service.loadAll(), isEmpty);
  });
}

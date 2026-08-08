import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/invoice.dart';
import 'package:salary_currency_pro/models/invoice_line_item.dart';

void main() {
  test('fromJson on a pre-item-12 record defaults every new field safely',
      () {
    final invoice = Invoice.fromJson({
      'id': 'abc',
      'clientName': 'Acme',
      'amount': 100.0,
      'currencyCode': 'EUR',
      'issueDate': DateTime(2026, 1, 1).toIso8601String(),
      'dueDate': DateTime(2026, 1, 15).toIso8601String(),
    });

    expect(invoice.invoiceNumber, '');
    expect(invoice.items, isEmpty);
    expect(invoice.purpose, isNull);
    expect(invoice.paymentReference, isNull);
  });

  test('toJson/fromJson round-trips invoiceNumber, items, purpose, and '
      'paymentReference', () {
    final original = Invoice(
      id: 'abc',
      clientName: 'Acme',
      amount: Invoice.totalFromItems(const [
        InvoiceLineItem(description: 'Design', quantity: 2, unitPrice: 50),
        InvoiceLineItem(description: 'Hosting', quantity: 1, unitPrice: 12.5),
      ]),
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 1, 1),
      dueDate: DateTime(2026, 1, 15),
      invoiceNumber: '2026-001',
      items: const [
        InvoiceLineItem(description: 'Design', quantity: 2, unitPrice: 50),
        InvoiceLineItem(description: 'Hosting', quantity: 1, unitPrice: 12.5),
      ],
      purpose: 'Website work',
      paymentReference: '97-1412-3412',
    );

    final restored = Invoice.fromJson(original.toJson());

    expect(restored.invoiceNumber, '2026-001');
    expect(restored.items, hasLength(2));
    expect(restored.items[0].description, 'Design');
    expect(restored.items[0].quantity, 2);
    expect(restored.items[0].unitPrice, 50);
    expect(restored.purpose, 'Website work');
    expect(restored.paymentReference, '97-1412-3412');
    expect(restored.amount, 112.5);
  });
}

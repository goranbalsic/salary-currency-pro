import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/invoice.dart';
import '../models/invoice_line_item.dart';

/// Local, on-device-only invoice ledger — the offline-only start of a
/// "business mode." No client accounts, no payment processing, no sending
/// of invoices: just a record you keep yourself of what you're owed.
class InvoiceService {
  static const _prefsKey = 'invoices_v1';

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<Invoice>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      final invoices =
          decoded.map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList();
      invoices.sort((a, b) => b.issueDate.compareTo(a.issueDate));
      return invoices;
    } catch (_) {
      return [];
    }
  }

  Future<Invoice> add({
    required String clientName,
    String description = '',
    required double amount,
    required String currencyCode,
    required DateTime issueDate,
    required DateTime dueDate,
    String invoiceNumber = '',
    List<InvoiceLineItem> items = const [],
    String? purpose,
    String? paymentReference,
  }) async {
    final all = await loadAll();
    final invoice = Invoice(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      clientName: clientName,
      description: description,
      amount: amount,
      currencyCode: currencyCode,
      issueDate: issueDate,
      dueDate: dueDate,
      invoiceNumber: invoiceNumber,
      items: items,
      purpose: purpose,
      paymentReference: paymentReference,
    );
    all.insert(0, invoice);
    await _save(all);
    changes.value++;
    return invoice;
  }

  Future<void> update(Invoice updated) async {
    final all = await loadAll();
    final index = all.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    all[index] = updated;
    await _save(all);
    changes.value++;
  }

  Future<void> markPaid(String id, {bool paid = true}) async {
    final all = await loadAll();
    final index = all.indexWhere((i) => i.id == id);
    if (index == -1) return;
    final i = all[index];
    all[index] = Invoice(
      id: i.id,
      schemaVersion: i.schemaVersion,
      clientName: i.clientName,
      description: i.description,
      amount: i.amount,
      currencyCode: i.currencyCode,
      issueDate: i.issueDate,
      dueDate: i.dueDate,
      isPaid: paid,
      paidDate: paid ? DateTime.now() : null,
    );
    await _save(all);
    changes.value++;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((i) => i.id == id);
    await _save(all);
    changes.value++;
  }

  Future<void> clear() async {
    await _save(const []);
    changes.value++;
  }

  Future<void> _save(List<Invoice> invoices) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(invoices.map((i) => i.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

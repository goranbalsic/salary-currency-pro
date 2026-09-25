import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../core/storage/store.dart';
import '../domain/invoice.dart';
import '../domain/pausal.dart';

/// The issuer's details, printed on invoices and PDF reports.
class BusinessProfile {
  const BusinessProfile({
    this.party = const InvoiceParty(),
    this.bankAccount = '',
    this.bankName = '',
    this.iban = '',
    this.swift = '',
    this.phone = '',
    this.vatRegistered = false,
    this.paymentCode = '221',
    this.defaultDueDays = 15,
    this.defaultCurrency = 'RSD',
    this.defaultNote = '',
    this.showOnReports = true,
  });

  final InvoiceParty party;

  /// Serbian account (xxx-xxxxxxxxxxxxx-xx) or an IBAN.
  final String bankAccount;
  final String bankName;

  /// Account for payments from abroad (printed on foreign-currency
  /// invoices) and the bank's SWIFT/BIC code.
  final String iban;
  final String swift;
  final String phone;
  final bool vatRegistered;

  /// NBS IPS payment code (šifra plaćanja) for the QR code.
  final String paymentCode;
  final int defaultDueDays;
  final String defaultCurrency;
  final String defaultNote;

  /// Print the business name and IDs in PDF report headers.
  final bool showOnReports;

  bool get isEmpty => party.isEmpty;

  BusinessProfile copyWith({
    InvoiceParty? party,
    String? bankAccount,
    String? bankName,
    String? iban,
    String? swift,
    String? phone,
    bool? vatRegistered,
    String? paymentCode,
    int? defaultDueDays,
    String? defaultCurrency,
    String? defaultNote,
    bool? showOnReports,
  }) => BusinessProfile(
    party: party ?? this.party,
    bankAccount: bankAccount ?? this.bankAccount,
    bankName: bankName ?? this.bankName,
    iban: iban ?? this.iban,
    swift: swift ?? this.swift,
    phone: phone ?? this.phone,
    vatRegistered: vatRegistered ?? this.vatRegistered,
    paymentCode: paymentCode ?? this.paymentCode,
    defaultDueDays: defaultDueDays ?? this.defaultDueDays,
    defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    defaultNote: defaultNote ?? this.defaultNote,
    showOnReports: showOnReports ?? this.showOnReports,
  );

  Map<String, Object?> toJson() => {
    'party': party.toJson(),
    'account': bankAccount,
    'bank': bankName,
    'iban': iban,
    'swift': swift,
    'phone': phone,
    'vat': vatRegistered,
    'sf': paymentCode,
    'due': defaultDueDays,
    'currency': defaultCurrency,
    'note': defaultNote,
    'reports': showOnReports,
  };

  static BusinessProfile fromJson(Object? raw) {
    if (raw is! Map) return const BusinessProfile();
    String s(String k, [String d = '']) => raw[k] is String ? raw[k] as String : d;
    return BusinessProfile(
      party: raw['party'] is Map ? InvoiceParty.fromJson((raw['party'] as Map).cast<String, Object?>()) : const InvoiceParty(),
      bankAccount: s('account'),
      bankName: s('bank'),
      iban: s('iban'),
      swift: s('swift'),
      phone: s('phone'),
      vatRegistered: raw['vat'] == true,
      paymentCode: s('sf', '221'),
      defaultDueDays: raw['due'] is int ? (raw['due'] as int).clamp(0, 365) : 15,
      defaultCurrency: s('currency', 'RSD'),
      defaultNote: s('note'),
      showOnReports: raw['reports'] != false,
    );
  }
}

/// A revenue record entered by hand for the paušal tracker (for invoices
/// issued outside the app).
class ManualRevenue {
  const ManualRevenue({required this.id, required this.date, required this.amountRsd, this.note = ''});

  final String id;
  final DateTime date;
  final double amountRsd;
  final String note;

  Map<String, Object?> toJson() => {'id': id, 'date': date.toIso8601String(), 'amount': amountRsd, 'note': note};

  static ManualRevenue? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final date = raw['date'] is String ? DateTime.tryParse(raw['date'] as String) : null;
    final amount = raw['amount'];
    final id = raw['id'];
    if (date == null || amount is! num || !amount.isFinite || id is! String) return null;
    return ManualRevenue(id: id, date: date, amountRsd: amount.toDouble(), note: raw['note'] is String ? raw['note'] as String : '');
  }
}

class BusinessStore extends ChangeNotifier {
  BusinessStore(this._store) {
    _load();
  }

  final Store _store;
  static const _profileKey = 'business.profile.v1';
  static const _invoicesKey = 'business.invoices.v1';
  static const _manualKey = 'business.manual.v1';
  static const _createdKey = 'business.invoicesCreated';

  BusinessProfile _profile = const BusinessProfile();
  final List<Invoice> _invoices = [];
  final List<ManualRevenue> _manual = [];
  int _createdCount = 0;
  final _random = math.Random();

  BusinessProfile get profile => _profile;
  List<Invoice> get invoices => List.unmodifiable(_invoices);
  List<ManualRevenue> get manualRevenue => List.unmodifiable(_manual);

  /// Invoices ever created on this install (the free-tier quota counts
  /// creations, so deleting does not free a slot).
  int get createdCount => _createdCount;

  void _load() {
    _profile = BusinessProfile.fromJson(_store.readJson(_profileKey));
    _invoices.clear();
    final raw = _store.readJson(_invoicesKey);
    if (raw is List) {
      for (final e in raw) {
        final inv = Invoice.tryFromJson(e);
        if (inv != null) _invoices.add(inv);
      }
    }
    _sortInvoices();
    _manual.clear();
    final m = _store.readJson(_manualKey);
    if (m is List) {
      for (final e in m) {
        final r = ManualRevenue.tryFromJson(e);
        if (r != null) _manual.add(r);
      }
    }
    _manual.sort((a, b) => b.date.compareTo(a.date));
    _createdCount = math.max(_store.getInt(_createdKey) ?? 0, _invoices.length);
  }

  void _sortInvoices() => _invoices.sort((a, b) {
    final byDate = b.issueDate.compareTo(a.issueDate);
    return byDate != 0 ? byDate : b.createdAt.compareTo(a.createdAt);
  });

  String newId() => '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 20)}';

  Future<void> saveProfile(BusinessProfile p) async {
    _profile = p;
    notifyListeners();
    await _store.writeJson(_profileKey, p.toJson());
  }

  Invoice? invoiceById(String id) => _invoices.where((i) => i.id == id).firstOrNull;

  /// Inserts or replaces an invoice.
  Future<void> upsertInvoice(Invoice invoice) async {
    final i = _invoices.indexWhere((e) => e.id == invoice.id);
    if (i >= 0) {
      _invoices[i] = invoice;
    } else {
      _invoices.add(invoice);
      _createdCount++;
      await _store.setInt(_createdKey, _createdCount);
    }
    _sortInvoices();
    notifyListeners();
    await _persistInvoices();
  }

  Future<void> deleteInvoice(String id) async {
    _invoices.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persistInvoices();
  }

  Future<void> _persistInvoices() => _store.writeJson(_invoicesKey, [for (final i in _invoices) i.toJson()]);

  Future<void> addManual(DateTime date, double amountRsd, String note) async {
    _manual.add(ManualRevenue(id: newId(), date: date, amountRsd: amountRsd, note: note));
    _manual.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    await _store.writeJson(_manualKey, [for (final r in _manual) r.toJson()]);
  }

  Future<void> removeManual(String id) async {
    _manual.removeWhere((e) => e.id == id);
    notifyListeners();
    await _store.writeJson(_manualKey, [for (final r in _manual) r.toJson()]);
  }

  /// Revenue entries for the paušal tracker: issued/paid invoices (in
  /// dinars) plus manual entries. Invoices lacking an RSD counter-value
  /// are reported separately so the UI can flag them.
  ({List<RevenueEntry> entries, int missingRate}) revenue() {
    final entries = <RevenueEntry>[];
    var missing = 0;
    for (final inv in _invoices) {
      if (!inv.countsAsRevenue) continue;
      final rsd = inv.totalRsd;
      if (rsd == null) {
        missing++;
        continue;
      }
      entries.add(RevenueEntry(date: inv.serviceDate, amountRsd: rsd));
    }
    for (final m in _manual) {
      entries.add(RevenueEntry(date: m.date, amountRsd: m.amountRsd));
    }
    return (entries: entries, missingRate: missing);
  }

  /// Distinct clients from past invoices, most recent first.
  List<InvoiceParty> get recentClients {
    final seen = <String>{};
    final out = <InvoiceParty>[];
    for (final inv in _invoices) {
      final key = inv.client.name.trim().toLowerCase();
      if (key.isEmpty || !seen.add(key)) continue;
      out.add(inv.client);
    }
    return out;
  }

  void reload() {
    _load();
    notifyListeners();
  }
}

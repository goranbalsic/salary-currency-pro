import '../../../core/money/money.dart';

enum InvoiceStatus { draft, issued, paid, cancelled }

class InvoiceParty {
  const InvoiceParty({
    this.name = '',
    this.address = '',
    this.city = '',
    this.country = '',
    this.taxId = '',
    this.registrationNo = '',
    this.email = '',
  });

  final String name;
  final String address;
  final String city;
  final String country;
  final String taxId;
  final String registrationNo;
  final String email;

  bool get isEmpty => name.trim().isEmpty;

  InvoiceParty copyWith({
    String? name,
    String? address,
    String? city,
    String? country,
    String? taxId,
    String? registrationNo,
    String? email,
  }) => InvoiceParty(
    name: name ?? this.name,
    address: address ?? this.address,
    city: city ?? this.city,
    country: country ?? this.country,
    taxId: taxId ?? this.taxId,
    registrationNo: registrationNo ?? this.registrationNo,
    email: email ?? this.email,
  );

  Map<String, Object?> toJson() => {
    'name': name,
    'address': address,
    'city': city,
    'country': country,
    'taxId': taxId,
    'regNo': registrationNo,
    'email': email,
  };

  factory InvoiceParty.fromJson(Map<String, Object?> j) => InvoiceParty(
    name: _s(j['name']),
    address: _s(j['address']),
    city: _s(j['city']),
    country: _s(j['country']),
    taxId: _s(j['taxId']),
    registrationNo: _s(j['regNo']),
    email: _s(j['email']),
  );
}

class InvoiceItem {
  const InvoiceItem({
    this.description = '',
    this.quantity = 1,
    this.unit = '',
    this.unitPrice = 0,
    this.vatPercent = 0,
  });

  final String description;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double vatPercent;

  double get net => Money.round(quantity * unitPrice);
  double get vat => Money.round(net * vatPercent / 100);
  double get gross => Money.sum([net, vat]);

  bool get isBlank => description.trim().isEmpty && unitPrice == 0;

  InvoiceItem copyWith({String? description, double? quantity, String? unit, double? unitPrice, double? vatPercent}) => InvoiceItem(
    description: description ?? this.description,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    unitPrice: unitPrice ?? this.unitPrice,
    vatPercent: vatPercent ?? this.vatPercent,
  );

  Map<String, Object?> toJson() => {
    'd': description,
    'q': quantity,
    'u': unit,
    'p': unitPrice,
    'v': vatPercent,
  };

  factory InvoiceItem.fromJson(Map<String, Object?> j) => InvoiceItem(
    description: _s(j['d']),
    quantity: _d(j['q'], 1),
    unit: _s(j['u']),
    unitPrice: _d(j['p'], 0),
    vatPercent: _d(j['v'], 0),
  );
}

class Invoice {
  const Invoice({
    required this.id,
    required this.number,
    required this.status,
    required this.issueDate,
    required this.serviceDate,
    required this.dueDate,
    required this.place,
    required this.client,
    required this.currency,
    required this.items,
    required this.vatRegistered,
    this.note = '',
    this.reference = '',
    this.rsdRate,
    this.rsdRateDate,
    this.paidDate,
    required this.createdAt,
  });

  final String id;
  final String number;
  final InvoiceStatus status;
  final DateTime issueDate;
  final DateTime serviceDate;
  final DateTime dueDate;
  final String place;
  final InvoiceParty client;
  final String currency;
  final List<InvoiceItem> items;

  /// Whether the issuer was in the VAT system when this was created.
  final bool vatRegistered;
  final String note;

  /// Payment reference (model + reference number, e.g. "97 1234").
  final String reference;

  /// NBS middle rate RSD per 1 [currency] on the issue date (foreign-
  /// currency invoices only), and the date that rate was valid for.
  final double? rsdRate;
  final DateTime? rsdRateDate;
  final DateTime? paidDate;
  final DateTime createdAt;

  List<InvoiceItem> get lines => items.where((i) => !i.isBlank).toList();
  double get netTotal => Money.sum(lines.map((i) => i.net));
  double get vatTotal => Money.sum(lines.map((i) => i.vat));
  double get total => Money.sum([netTotal, vatTotal]);

  /// Total in dinars — the invoice total itself for RSD invoices, or the
  /// counter-value at [rsdRate]; null when a rate is missing.
  double? get totalRsd {
    if (currency == 'RSD') return total;
    final r = rsdRate;
    if (r == null || r <= 0) return null;
    return Money.round(total * r);
  }

  bool isOverdue(DateTime today) =>
      status == InvoiceStatus.issued && DateTime(dueDate.year, dueDate.month, dueDate.day).isBefore(DateTime(today.year, today.month, today.day));

  /// Whether this invoice counts toward revenue limits (issued or paid).
  bool get countsAsRevenue => status == InvoiceStatus.issued || status == InvoiceStatus.paid;

  Invoice copyWith({
    String? number,
    InvoiceStatus? status,
    DateTime? issueDate,
    DateTime? serviceDate,
    DateTime? dueDate,
    String? place,
    InvoiceParty? client,
    String? currency,
    List<InvoiceItem>? items,
    bool? vatRegistered,
    String? note,
    String? reference,
    double? rsdRate,
    DateTime? rsdRateDate,
    bool clearRsdRate = false,
    DateTime? paidDate,
    bool clearPaidDate = false,
  }) => Invoice(
    id: id,
    number: number ?? this.number,
    status: status ?? this.status,
    issueDate: issueDate ?? this.issueDate,
    serviceDate: serviceDate ?? this.serviceDate,
    dueDate: dueDate ?? this.dueDate,
    place: place ?? this.place,
    client: client ?? this.client,
    currency: currency ?? this.currency,
    items: items ?? this.items,
    vatRegistered: vatRegistered ?? this.vatRegistered,
    note: note ?? this.note,
    reference: reference ?? this.reference,
    rsdRate: clearRsdRate ? null : (rsdRate ?? this.rsdRate),
    rsdRateDate: clearRsdRate ? null : (rsdRateDate ?? this.rsdRateDate),
    paidDate: clearPaidDate ? null : (paidDate ?? this.paidDate),
    createdAt: createdAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'number': number,
    'status': status.name,
    'issue': issueDate.toIso8601String(),
    'service': serviceDate.toIso8601String(),
    'due': dueDate.toIso8601String(),
    'place': place,
    'client': client.toJson(),
    'currency': currency,
    'items': [for (final i in items) i.toJson()],
    'vat': vatRegistered,
    'note': note,
    'ref': reference,
    'rsdRate': rsdRate,
    'rsdRateDate': rsdRateDate?.toIso8601String(),
    'paid': paidDate?.toIso8601String(),
    'created': createdAt.toIso8601String(),
  };

  /// Returns null for a record that is too damaged to show.
  static Invoice? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, Object?>();
    final id = j['id'];
    final issue = _date(j['issue']);
    if (id is! String || id.isEmpty || issue == null) return null;
    final itemsRaw = j['items'];
    return Invoice(
      id: id,
      number: _s(j['number']),
      status: InvoiceStatus.values.firstWhere((s) => s.name == j['status'], orElse: () => InvoiceStatus.draft),
      issueDate: issue,
      serviceDate: _date(j['service']) ?? issue,
      dueDate: _date(j['due']) ?? issue,
      place: _s(j['place']),
      client: j['client'] is Map ? InvoiceParty.fromJson((j['client']! as Map).cast<String, Object?>()) : const InvoiceParty(),
      currency: _s(j['currency']).isEmpty ? 'RSD' : _s(j['currency']),
      items: itemsRaw is List
          ? [
              for (final i in itemsRaw)
                if (i is Map) InvoiceItem.fromJson(i.cast<String, Object?>()),
            ]
          : const [],
      vatRegistered: j['vat'] == true,
      note: _s(j['note']),
      reference: _s(j['ref']),
      rsdRate: j['rsdRate'] is num ? (j['rsdRate']! as num).toDouble() : null,
      rsdRateDate: _date(j['rsdRateDate']),
      paidDate: _date(j['paid']),
      createdAt: _date(j['created']) ?? issue,
    );
  }
}

/// Suggests the next invoice number in the "sequence/year" style
/// (e.g. `12/2026`) from the numbers already used in [year].
String nextInvoiceNumber(Iterable<Invoice> existing, int year) {
  var max = 0;
  final pattern = RegExp(r'^(\d+)\s*/\s*(\d{4})$');
  for (final inv in existing) {
    final m = pattern.firstMatch(inv.number.trim());
    if (m != null && int.parse(m[2]!) == year) {
      final n = int.parse(m[1]!);
      if (n > max) max = n;
    }
  }
  return '${max + 1}/$year';
}

String _s(Object? v) => v is String ? v : '';
double _d(Object? v, double fallback) => v is num && v.isFinite ? v.toDouble() : fallback;
DateTime? _date(Object? v) => v is String ? DateTime.tryParse(v) : null;

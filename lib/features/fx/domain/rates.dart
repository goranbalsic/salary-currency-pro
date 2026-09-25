/// Which official source a rate table comes from.
enum RateSource {
  /// National Bank of Serbia — official middle, buying and selling rates
  /// against the dinar.
  nbs,

  /// European Central Bank — euro foreign exchange reference rates.
  ecb,
}

/// Which NBS rate to apply. ECB publishes a single reference rate, so
/// buying/selling only differ for NBS-based conversions.
enum RateKind { middle, buy, sell }

/// Value of ONE unit of a currency expressed in a table's base currency.
class Quote {
  const Quote({required this.middle, this.buy, this.sell});

  final double middle;
  final double? buy;
  final double? sell;

  double valueFor(RateKind kind) => switch (kind) {
    RateKind.middle => middle,
    RateKind.buy => buy ?? middle,
    RateKind.sell => sell ?? middle,
  };

  Map<String, Object?> toJson() => {'m': middle, 'b': buy, 's': sell};

  static Quote? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = raw['m'];
    if (m is! num || !m.isFinite || m <= 0) return null;
    double? opt(Object? v) => v is num && v.isFinite && v > 0 ? v.toDouble() : null;
    return Quote(middle: m.toDouble(), buy: opt(raw['b']), sell: opt(raw['s']));
  }
}

/// One published rate list.
class RateTable {
  const RateTable({
    required this.source,
    required this.base,
    required this.date,
    required this.fetchedAt,
    required this.quotes,
  });

  final RateSource source;

  /// RSD for NBS, EUR for ECB.
  final String base;

  /// The date the rates are valid for.
  final DateTime date;
  final DateTime fetchedAt;
  final Map<String, Quote> quotes;

  bool covers(String code) => code == base || quotes.containsKey(code);

  /// Value of one unit of [code] in [base], or null if not listed.
  double? value(String code, RateKind kind) {
    if (code == base) return 1;
    return quotes[code]?.valueFor(kind);
  }

  Map<String, Object?> toJson() => {
    'source': source.name,
    'base': base,
    'date': date.toIso8601String(),
    'fetchedAt': fetchedAt.toIso8601String(),
    'quotes': {for (final e in quotes.entries) e.key: e.value.toJson()},
  };

  static RateTable? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final source = RateSource.values.where((s) => s.name == raw['source']).firstOrNull;
    final base = raw['base'];
    final date = raw['date'] is String ? DateTime.tryParse(raw['date'] as String) : null;
    final fetched = raw['fetchedAt'] is String ? DateTime.tryParse(raw['fetchedAt'] as String) : null;
    final q = raw['quotes'];
    if (source == null || base is! String || date == null || fetched == null || q is! Map) return null;
    final quotes = <String, Quote>{};
    for (final e in q.entries) {
      final quote = Quote.fromJson(e.value);
      if (e.key is String && quote != null) quotes[e.key as String] = quote;
    }
    if (quotes.isEmpty) return null;
    return RateTable(source: source, base: base, date: date, fetchedAt: fetched, quotes: quotes);
  }
}

class Conversion {
  const Conversion({
    required this.from,
    required this.to,
    required this.amount,
    required this.result,
    required this.rate,
    required this.source,
    required this.date,
    required this.kind,
    required this.cross,
  });

  final String from;
  final String to;
  final double amount;
  final double result;

  /// Units of [to] per one unit of [from].
  final double rate;
  final RateSource? source;
  final DateTime? date;
  final RateKind kind;

  /// True when neither side is the source's base currency.
  final bool cross;
}

/// Fixed conversion rate of the Bosnian convertible mark to the euro.
const bamPerEur = 1.95583;

/// Converts between currencies using the most authoritative table that
/// covers both sides: NBS for anything involving the dinar, ECB for euro
/// cross rates (with the BAM euro peg), NBS cross rates otherwise.
class RateBook {
  const RateBook({this.nbs, this.ecb});

  final RateTable? nbs;
  final RateTable? ecb;

  bool get isEmpty => nbs == null && ecb == null;

  Set<String> get currencies => {
    if (nbs != null) ...{nbs!.base, ...nbs!.quotes.keys},
    if (ecb != null) ...{ecb!.base, ...ecb!.quotes.keys, 'BAM'},
  };

  double? _ecbEurValue(String code) {
    final e = ecb;
    if (e == null) return null;
    if (code == 'EUR') return 1;
    if (code == 'BAM') return 1 / bamPerEur;
    final perEur = e.quotes[code]?.middle;
    return perEur == null ? null : 1 / perEur;
  }

  /// Units of [to] per one [from], plus the source used; null if no
  /// table covers the pair.
  ({double rate, RateSource? source, DateTime? date})? rate(String from, String to, [RateKind kind = RateKind.middle]) {
    if (from == to) return (rate: 1.0, source: null, date: null);
    final n = nbs;
    final involvesRsd = from == 'RSD' || to == 'RSD';
    if (!involvesRsd) {
      final a = _ecbEurValue(from);
      final b = _ecbEurValue(to);
      if (a != null && b != null) return (rate: a / b, source: RateSource.ecb, date: ecb!.date);
    }
    if (n != null && n.covers(from) && n.covers(to)) {
      final a = n.value(from, kind);
      final b = n.value(to, kind);
      if (a != null && b != null && b > 0) return (rate: a / b, source: RateSource.nbs, date: n.date);
    }
    return null;
  }

  Conversion? convert(double amount, String from, String to, [RateKind kind = RateKind.middle]) {
    final r = rate(from, to, kind);
    if (r == null || !amount.isFinite) return null;
    return Conversion(
      from: from,
      to: to,
      amount: amount,
      result: amount * r.rate,
      rate: r.rate,
      source: r.source,
      date: r.date,
      kind: kind,
      cross: r.source == RateSource.nbs ? (from != 'RSD' && to != 'RSD') : (from != 'EUR' && to != 'EUR'),
    );
  }
}

/// A dated point in a rate history series.
class RatePoint {
  const RatePoint(this.date, this.value);
  final DateTime date;
  final double value;
}

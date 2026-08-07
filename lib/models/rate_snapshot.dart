/// A set of exchange rates quoted against [base], as returned by one provider call.
class RateSnapshot {
  final String base;
  final Map<String, double> rates;

  /// The date/time the provider considers these rates valid for (e.g. the
  /// API's own "date" or "time_last_update" field) — NOT necessarily now.
  final DateTime asOf;

  /// When this device fetched (or last successfully fetched) this snapshot.
  final DateTime fetchedAt;

  /// Human-readable attribution shown to the user, e.g. "Frankfurter (ECB)".
  final String source;

  const RateSnapshot({
    required this.base,
    required this.rates,
    required this.asOf,
    required this.fetchedAt,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
        'base': base,
        'rates': rates,
        'asOf': asOf.toIso8601String(),
        'fetchedAt': fetchedAt.toIso8601String(),
        'source': source,
      };

  factory RateSnapshot.fromJson(Map<String, dynamic> json) {
    return RateSnapshot(
      base: json['base'] as String,
      rates: (json['rates'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      asOf: DateTime.parse(json['asOf'] as String),
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      source: json['source'] as String,
    );
  }
}

/// The outcome of asking for a single from->to conversion rate.
class RateResult {
  final String from;
  final String to;
  final double rate;
  final DateTime asOf;
  final DateTime fetchedAt;
  final String source;

  /// True only if this came from a network call made just now in this
  /// request. False means it was served from local cache.
  final bool isLive;

  const RateResult({
    required this.from,
    required this.to,
    required this.rate,
    required this.asOf,
    required this.fetchedAt,
    required this.source,
    required this.isLive,
  });
}

/// Thrown when no rate can be produced at all: the network call failed AND
/// there is no cached snapshot to fall back to. Callers must show this
/// explicitly — never substitute a guessed number.
class RateUnavailableException implements Exception {
  final String message;
  const RateUnavailableException(this.message);

  @override
  String toString() => message;
}

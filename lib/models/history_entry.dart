/// Stable ids for every tool that can write to the local activity history —
/// centralized here so wiring a new tool in later can't typo the string.
class HistoryToolIds {
  HistoryToolIds._();

  static const salary = 'salary';
  static const convert = 'convert';
  static const loan = 'loan';
  static const savings = 'savings';
  static const vat = 'vat';
  static const budget = 'budget';
  static const freelancerPayout = 'freelancer_payout';
  static const freelanceTax = 'freelance_tax';
  static const pausalTracker = 'pausal_tracker';
}

/// One entry in the local, automatic "recently used" activity log. This is
/// deliberately lightweight and privacy-conscious (a description, not raw
/// financial figures by default) — a distinct, smaller concept from a
/// future user-named "saved scenario" that can be reopened and edited.
class HistoryEntry {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final String toolId;
  final DateTime timestamp;
  final String title;
  final String summary;
  final String? countryId;
  final String? currencyCode;

  /// Reserved for a future "reopen this calculation" feature — not read by
  /// anything yet, but captured now so old entries don't need a schema
  /// migration once that feature exists.
  final String? inputLabel;
  final String? inputValue;

  const HistoryEntry({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.toolId,
    required this.timestamp,
    required this.title,
    required this.summary,
    this.countryId,
    this.currencyCode,
    this.inputLabel,
    this.inputValue,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'toolId': toolId,
        'timestamp': timestamp.toIso8601String(),
        'title': title,
        'summary': summary,
        'countryId': countryId,
        'currencyCode': currencyCode,
        'inputLabel': inputLabel,
        'inputValue': inputValue,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        toolId: json['toolId'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        title: json['title'] as String,
        summary: json['summary'] as String,
        countryId: json['countryId'] as String?,
        currencyCode: json['currencyCode'] as String?,
        inputLabel: json['inputLabel'] as String?,
        inputValue: json['inputValue'] as String?,
      );
}

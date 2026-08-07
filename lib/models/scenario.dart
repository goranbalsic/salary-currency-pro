/// One user-named, reopenable saved calculation. Distinct from
/// [HistoryEntry] (the lightweight, auto-logged, unnamed "recently used"
/// log): a scenario is an intentional save, never deduped or evicted by
/// recency, and carries enough of the original inputs to reopen and re-run
/// the calculation.
class Scenario {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final String toolId;
  final String name;
  final DateTime createdAt;
  final String? countryId;
  final String? currencyCode;

  /// A frozen snapshot of the result as it was when saved (e.g. "Neto
  /// 65,000 RSD") — shown in list/detail views so a saved scenario always
  /// reads like a receipt of what was true at save time, even if tax
  /// config data is updated later. Reopening the scenario pre-fills the
  /// tool's live inputs; hitting Calculate again recomputes with whatever
  /// config is current.
  final String summary;

  /// Per-tool input snapshot (e.g. salary: countryId/entityId/mode/amount;
  /// loan: principal/rate/termMonths). Each tool owns its own shape.
  final Map<String, dynamic> inputs;

  const Scenario({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.toolId,
    required this.name,
    required this.createdAt,
    this.countryId,
    this.currencyCode,
    required this.summary,
    required this.inputs,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'toolId': toolId,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'countryId': countryId,
        'currencyCode': currencyCode,
        'summary': summary,
        'inputs': inputs,
      };

  factory Scenario.fromJson(Map<String, dynamic> json) => Scenario(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        toolId: json['toolId'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        countryId: json['countryId'] as String?,
        currencyCode: json['currencyCode'] as String?,
        summary: json['summary'] as String,
        inputs: Map<String, dynamic>.from(json['inputs'] as Map? ?? const {}),
      );
}

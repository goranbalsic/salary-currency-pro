/// The outcome of locally classifying a scanned QR payload against the
/// known country adapters — see `ReceiptAdapterRegistry`. None of these
/// values imply the receipt was verified against any remote system; they
/// only describe what the payload's *format* locally looks like.
enum ReceiptScanOutcome {
  /// Matched a known country's fiscal-receipt URL/payload format exactly.
  recognized,

  /// Resembled a known country's fiscal-receipt format closely enough to
  /// identify which country it's likely from, but failed a required part
  /// of that format (wrong scheme, missing parameter, wrong path, ...).
  malformed,

  /// Did not resemble any known country's fiscal-receipt format — could be
  /// a non-fiscal QR code, an unsupported country, or unrelated text.
  unknownFormat,
}

/// A scan record's place in the local queue. Deliberately has no "fetched"
/// or "verified" state — this app never performs the network fetch (see
/// `FiscalReceiptFetchService`), so no state may imply that it did.
enum ScanQueueStatus {
  /// The default state for every scan: captured and classified locally,
  /// with content retrieval intentionally not attempted.
  awaitingFetch,

  /// The user created a manual expense from this scan. The scan record
  /// itself is unchanged and still inspectable/deletable.
  expenseCreated,
}

/// One local, on-device-only record of a scanned fiscal-receipt QR code.
/// Distinct from `ExpenseEntry`: this is the raw scan plus its local
/// classification, not a money transaction — see
/// `FiscalReceiptScanService` for how a user turns one into an expense.
class FiscalReceiptScan {
  static const currentSchemaVersion = 1;

  final String id;
  final int schemaVersion;
  final String rawPayload;
  final DateTime scannedAt;
  final ReceiptScanOutcome outcome;

  /// The adapter's country id (e.g. 'rs') when [outcome] is
  /// [ReceiptScanOutcome.recognized] or [ReceiptScanOutcome.malformed] (an
  /// adapter claimed the payload as its country's format even though it
  /// didn't fully validate). Null when [outcome] is
  /// [ReceiptScanOutcome.unknownFormat].
  final String? countryId;

  final ScanQueueStatus status;
  final String note;

  /// Local, non-authoritative reference to an `ExpenseEntry` created from
  /// this scan, if any. Does not change how expenses themselves work.
  final String? linkedExpenseId;

  const FiscalReceiptScan({
    required this.id,
    this.schemaVersion = currentSchemaVersion,
    required this.rawPayload,
    required this.scannedAt,
    required this.outcome,
    this.countryId,
    this.status = ScanQueueStatus.awaitingFetch,
    this.note = '',
    this.linkedExpenseId,
  });

  FiscalReceiptScan copyWith({
    ScanQueueStatus? status,
    String? note,
    String? linkedExpenseId,
  }) =>
      FiscalReceiptScan(
        id: id,
        schemaVersion: schemaVersion,
        rawPayload: rawPayload,
        scannedAt: scannedAt,
        outcome: outcome,
        countryId: countryId,
        status: status ?? this.status,
        note: note ?? this.note,
        linkedExpenseId: linkedExpenseId ?? this.linkedExpenseId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'schemaVersion': schemaVersion,
        'rawPayload': rawPayload,
        'scannedAt': scannedAt.toIso8601String(),
        'outcome': outcome.name,
        'countryId': countryId,
        'status': status.name,
        'note': note,
        'linkedExpenseId': linkedExpenseId,
      };

  factory FiscalReceiptScan.fromJson(Map<String, dynamic> json) => FiscalReceiptScan(
        id: json['id'] as String,
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        rawPayload: json['rawPayload'] as String? ?? '',
        scannedAt: DateTime.parse(json['scannedAt'] as String),
        outcome: ReceiptScanOutcome.values.firstWhere(
          (o) => o.name == json['outcome'],
          orElse: () => ReceiptScanOutcome.unknownFormat,
        ),
        countryId: json['countryId'] as String?,
        status: ScanQueueStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => ScanQueueStatus.awaitingFetch,
        ),
        note: json['note'] as String? ?? '',
        linkedExpenseId: json['linkedExpenseId'] as String?,
      );
}

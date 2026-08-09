/// A user's current paid-access level. Distinct from the old single-tier
/// `ProProvider.isPro` boolean (PROMPT-003 Stage A/B): PROMPT-003F's Stage D
/// go-ahead replaces that with four real products (monthly, annual w/ 7-day
/// trial, lifetime, a non-gating support purchase), so entitlement needs more
/// than a boolean.
enum EntitlementStatus {
  /// No active paid product. The default, and where a lapsed subscription
  /// returns to.
  free,

  /// Within the annual plan's 7-day free trial window. Grants the exact same
  /// access as [pro]/[lifetime] — this is a display-only distinction (e.g.
  /// "trial ends in 3 days" vs "renews on ..."), never a separate feature
  /// gate. See [EntitlementService] for how this is approximated without a
  /// purchase-verification backend.
  trialing,

  /// An active paid subscription (monthly or annual, past its trial window
  /// if any).
  pro,

  /// The one-time lifetime purchase. Permanent — never re-verified the way a
  /// subscription is, since there is nothing to lapse.
  lifetime,

  /// A previously trialing/pro subscription that the store confirmed is no
  /// longer active. Distinct from [free] only for potential "your
  /// subscription ended" messaging — grants the same (no) access as [free].
  expired,
}

/// Local, on-device cache of the current entitlement, mirroring every other
/// service's `SharedPreferences` JSON-blob pattern in this app. The store
/// (via [EntitlementService]) is the real source of truth; this is what lets
/// the app answer "does this user have Pro access" instantly and offline,
/// without a network round-trip on every screen build.
class EntitlementState {
  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final EntitlementStatus status;

  /// Which product granted [status] (e.g. `pro_annual`, `pro_lifetime`).
  /// Null when [status] is [EntitlementStatus.free].
  final String? productId;

  /// When the granting purchase's transaction completed. Used only to
  /// approximate the [EntitlementStatus.trialing] window for the annual
  /// plan (see [EntitlementService]) — never treated as an authoritative,
  /// store-verified trial-status signal, the same "approximate and label
  /// honestly, don't claim verified" discipline as D-029's invoice-date FX
  /// rate.
  final DateTime? purchaseDate;

  /// The last time this state was actually confirmed against the store
  /// (a successful `isAvailable()` + restore round-trip), not merely read
  /// from cache. Null if never verified this install.
  final DateTime? lastVerifiedAt;

  const EntitlementState({
    this.schemaVersion = currentSchemaVersion,
    this.status = EntitlementStatus.free,
    this.productId,
    this.purchaseDate,
    this.lastVerifiedAt,
  });

  /// Whether this state grants the Pro feature set. [EntitlementStatus.free]
  /// and [EntitlementStatus.expired] are the only non-access states.
  bool get hasFullAccess =>
      status == EntitlementStatus.trialing ||
      status == EntitlementStatus.pro ||
      status == EntitlementStatus.lifetime;

  EntitlementState copyWith({
    EntitlementStatus? status,
    String? productId,
    DateTime? purchaseDate,
    DateTime? lastVerifiedAt,
  }) =>
      EntitlementState(
        schemaVersion: schemaVersion,
        status: status ?? this.status,
        productId: productId ?? this.productId,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      );

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'status': status.name,
        'productId': productId,
        'purchaseDate': purchaseDate?.toIso8601String(),
        'lastVerifiedAt': lastVerifiedAt?.toIso8601String(),
      };

  factory EntitlementState.fromJson(Map<String, dynamic> json) => EntitlementState(
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        status: EntitlementStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => EntitlementStatus.free,
        ),
        productId: json['productId'] as String?,
        purchaseDate: json['purchaseDate'] == null
            ? null
            : DateTime.parse(json['purchaseDate'] as String),
        lastVerifiedAt: json['lastVerifiedAt'] == null
            ? null
            : DateTime.parse(json['lastVerifiedAt'] as String),
      );
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/monetization_config.dart';
import '../models/entitlement.dart';

/// The single boundary between this app and Play Billing/App Store
/// purchases (PROMPT-003F's Stage D go-ahead, checkpoint 1 — "entitlement
/// plumbing," no paywall UI yet). Supersedes the older single-product
/// `PurchaseService`/`ProProvider` pair for the new four-product lineup;
/// those two are left wired to the pre-existing paywall until checkpoint 2
/// replaces it, so this service does not yet touch either.
///
/// Same offline-first discipline as every other service in this app: a
/// [SharedPreferences]-cached [EntitlementState] is the value every screen
/// actually reads, and it holds through no-connectivity periods rather than
/// hard-locking mid-session on a network check — [verify] only ever
/// downgrades an active entitlement when the store is genuinely reachable
/// and explicitly confirms the granting product is gone.
///
/// PROMPT-003J's dev/prod build matrix adds one more mode, entirely inside
/// this same class rather than a parallel service: when
/// [devSimulationEnabled] is true (dev flavor only), [start] never touches
/// the real store at all — see [_loadDevSimulation]/[setDevSimulatedStatus].
class EntitlementService {
  static const _prefsKey = 'entitlement_state_v1';
  static const _devOverrideKey = 'dev_entitlement_override_v1';

  /// How long the annual plan's purchase is treated as [EntitlementStatus.trialing]
  /// after its transaction date, per Decision 2's "7-day free trial on the
  /// annual plan only." This is a local approximation for *display* purposes
  /// only (trialing and pro/lifetime grant identical access) — this app has
  /// no purchase-verification backend to read the store's actual trial
  /// state from, the same "approximate, label honestly, never claim
  /// verified" precedent as D-029's invoice-date FX rate.
  static const trialWindow = Duration(days: 7);

  final InAppPurchasePlatform? _injectedPlatform;
  InAppPurchasePlatform? _resolvedPlatform;

  /// How long [verify] waits for the store to confirm an entitlement via
  /// [InAppPurchasePlatform.restorePurchases] before treating "nothing
  /// arrived" as "confirmed absent." Not private: tests inject a short
  /// override so offline/expiry cases don't need to wait out the real
  /// production default.
  final Duration verifyResponseTimeout;

  /// The current, locally-cached entitlement. Starts at the default (free)
  /// value; call [start] to load whatever was last persisted and begin
  /// listening for purchase updates.
  final ValueNotifier<EntitlementState> state = ValueNotifier(const EntitlementState());

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Talks to [InAppPurchasePlatform] directly rather than through the
  /// `InAppPurchase` facade class that `PurchaseService` (the older,
  /// still-active single-product service) uses. This isn't just style: the
  /// facade's *first* `.instance` access unconditionally self-registers the
  /// real platform-specific implementation as a side effect (which then
  /// opens a real platform-channel connection) — harmless in the real app,
  /// but there's no way to prevent or await that side effect from a plain
  /// Dart test, where it fails asynchronously and gets misattributed to
  /// whichever test happens to be running. Depending on
  /// [InAppPurchasePlatform] instead means a test can inject a fake
  /// platform (this app's usual `PlatformInterface` test-double pattern —
  /// see `FakeMobileScannerPlatform`/`FakeInAppPurchasePlatform`) with zero
  /// risk of ever touching a real platform channel. Production behavior is
  /// identical either way: every `InAppPurchase` method is a one-line
  /// delegation to `InAppPurchasePlatform.instance` at call time.
  ///
  /// [platform] resolution is deliberately lazy (see [_platform]), not done
  /// here in the constructor: `in_app_purchase`'s real platform registration
  /// throws on platforms it doesn't support (desktop/web dev builds — see
  /// `main.dart`'s own Android/iOS-only gate around calling [start]).
  /// Resolving eagerly here would make constructing an `EntitlementService`
  /// itself crash the app on those platforms; deferring it to first actual
  /// use means the app can always safely hold an instance, exactly like the
  /// `PurchaseService` this supersedes.
  /// PROMPT-003J checkpoint 1/2: when true, this instance never talks to
  /// the real store at all — [start] loads (or defaults) a locally
  /// simulated entitlement instead of subscribing to the real purchase
  /// stream, and [setDevSimulatedStatus] becomes callable. Set only by
  /// `main_dev.dart`'s bootstrap (via `AppConfig.isDev`), never by
  /// `main_prod.dart` or the default `main.dart` — this is the one and
  /// only `EntitlementService` every gate consults either way, so a dev
  /// build never has two competing entitlement truths, it just has this
  /// one truth answer differently.
  final bool devSimulationEnabled;

  EntitlementService({
    InAppPurchasePlatform? platform,
    this.verifyResponseTimeout = const Duration(seconds: 5),
    this.devSimulationEnabled = false,
  }) : _injectedPlatform = platform;

  /// Resolves to the injected test platform if one was given, otherwise
  /// touches `InAppPurchase.instance` once (real registration side effect)
  /// and reads back `InAppPurchasePlatform.instance` — cached after the
  /// first call so that side effect only ever happens once per instance.
  InAppPurchasePlatform get _platform {
    final injected = _injectedPlatform;
    if (injected != null) return injected;
    return _resolvedPlatform ??= () {
      InAppPurchase.instance;
      return InAppPurchasePlatform.instance;
    }();
  }

  Future<void> start() async {
    if (devSimulationEnabled) {
      await _loadDevSimulation();
      return;
    }
    await _loadCached();
    _subscription = _platform.purchaseStream.listen(_handlePurchaseUpdates, onError: (_) {});
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Dev-only: loads whatever simulated status was last explicitly chosen
  /// via [setDevSimulatedStatus] (persisted separately from the real
  /// [_prefsKey] cache, so switching back to a prod build never picks up a
  /// stray simulated value). Defaults to [EntitlementStatus.pro] — "fully
  /// unlocked" — when nothing has been explicitly simulated yet, per the
  /// prompt's own "Defaults to fully unlocked Pro" requirement.
  Future<void> _loadDevSimulation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_devOverrideKey);
      if (raw != null && raw.isNotEmpty) {
        state.value = EntitlementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        return;
      }
    } catch (_) {
      // Falls through to the default below.
    }
    state.value = const EntitlementState(
      status: EntitlementStatus.pro,
      productId: 'dev_simulated_default',
    );
  }

  /// Dev-only: sets the simulated entitlement every gate immediately sees
  /// (same [state] notifier every gate already watches — no extra wiring
  /// needed anywhere else), persisted so it survives an app restart. A
  /// no-op outside [devSimulationEnabled] — defense in depth beyond the
  /// UI itself being compile-time absent in prod (see
  /// `EntitlementPreviewSection`, gated on `AppConfig.isDev`).
  Future<void> setDevSimulatedStatus(EntitlementStatus status) async {
    if (!devSimulationEnabled) return;
    final newState = EntitlementState(
      status: status,
      productId: 'dev_simulated_${status.name}',
      lastVerifiedAt: DateTime.now(),
    );
    state.value = newState;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_devOverrideKey, jsonEncode(newState.toJson()));
    } catch (_) {
      // Best-effort persistence only — in-memory state is already updated.
    }
  }

  Future<bool> get isAvailable => _platform.isAvailable();

  Future<ProductDetailsResponse> queryProducts() =>
      _platform.queryProductDetails(MonetizationConfig.entitlementProductIds);

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _platform.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restore() => _platform.restorePurchases();

  /// Re-confirms the current entitlement against the store. See the class
  /// doc for the offline-grace contract. A [EntitlementStatus.lifetime]
  /// purchase is never re-verified this way — by definition there is
  /// nothing for it to lapse from.
  Future<void> verify() async {
    bool available;
    try {
      available = await _platform.isAvailable();
    } catch (_) {
      available = false;
    }
    if (!available) return;
    if (state.value.status == EntitlementStatus.lifetime) return;

    final sawRelevantPurchase = Completer<bool>();
    final probe = _platform.purchaseStream.listen((purchases) {
      final relevant = purchases.any((p) =>
          MonetizationConfig.entitlementProductIds.contains(p.productID) &&
          (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored));
      if (relevant && !sawRelevantPurchase.isCompleted) {
        sawRelevantPurchase.complete(true);
      }
    }, onError: (_) {});

    try {
      await _platform.restorePurchases();
    } catch (_) {
      await probe.cancel();
      return;
    }

    final confirmed =
        await sawRelevantPurchase.future.timeout(verifyResponseTimeout, onTimeout: () => false);
    await probe.cancel();

    if (confirmed) {
      await _save(state.value.copyWith(lastVerifiedAt: DateTime.now()));
    } else if (state.value.hasFullAccess) {
      await _save(state.value.copyWith(
        status: EntitlementStatus.expired,
        lastVerifiedAt: DateTime.now(),
      ));
    }
  }

  Future<void> _loadCached() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return;
      state.value = EntitlementState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Default free state stands if this can't be read.
    }
  }

  Future<void> _save(EntitlementState newState) async {
    state.value = newState;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(newState.toJson()));
    } catch (_) {
      // Best-effort persistence only — in-memory state is already updated.
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _applyPurchase(purchase);
      if (purchase.pendingCompletePurchase) {
        _platform.completePurchase(purchase);
      }
    }
  }

  void _applyPurchase(PurchaseDetails purchase) {
    if (purchase.status != PurchaseStatus.purchased &&
        purchase.status != PurchaseStatus.restored) {
      return;
    }
    // The support purchase never gates anything — deliberately not recorded
    // into EntitlementState at all (checkpoint 2 can add its own "thank
    // you" acknowledgment if wanted; not required for entitlement plumbing).
    if (purchase.productID == MonetizationConfig.supportDeveloperPurchaseId) {
      return;
    }
    if (!MonetizationConfig.entitlementProductIds.contains(purchase.productID)) {
      return;
    }

    final purchaseDate = purchase.transactionDate == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(purchase.transactionDate!) ?? DateTime.now().millisecondsSinceEpoch,
          );

    unawaited(_save(EntitlementState(
      status: _statusFor(purchase.productID, purchaseDate),
      productId: purchase.productID,
      purchaseDate: purchaseDate,
      lastVerifiedAt: DateTime.now(),
    )));
  }

  EntitlementStatus _statusFor(String productId, DateTime purchaseDate) {
    if (productId == MonetizationConfig.proLifetimePurchaseId) {
      return EntitlementStatus.lifetime;
    }
    if (productId == MonetizationConfig.proAnnualSubscriptionId) {
      final inTrial = DateTime.now().difference(purchaseDate) < trialWindow;
      return inTrial ? EntitlementStatus.trialing : EntitlementStatus.pro;
    }
    // Monthly plan: no trial per Decision 2.
    return EntitlementStatus.pro;
  }
}

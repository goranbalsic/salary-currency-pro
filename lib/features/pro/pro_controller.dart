import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../app/app_config.dart';
import '../../core/storage/store.dart';
import 'billing_gateway.dart';

/// Pro features, so every gate names what it guards.
enum ProFeature {
  allCountries,
  teamPayroll,
  compareCountries,
  compareLoans,
  earlyRepayment,
  fxHistory,
  unlimitedInvoices,
  pausalTracker,
  investment,
  pdfExport,
  unlimitedSaves,
}

enum PurchaseFlow { idle, loadingProducts, purchasing, pending, success, error, cancelled }

/// Owns the Pro entitlement. The store is the source of truth: on every
/// start the app asks Play which products the account owns. A cached
/// entitlement covers offline use for [AppConfig.entitlementOfflineGrace].
class ProController extends ChangeNotifier {
  ProController(this._store, {this._gateway, bool? billingSupported, DateTime Function()? clock})
    : _billingSupported = billingSupported ?? (defaultTargetPlatform == TargetPlatform.android && !kIsWeb),
      _now = clock ?? DateTime.now {
    _loadCache();
  }

  final Store _store;
  BillingGateway? _gateway;
  final bool _billingSupported;
  final DateTime Function() _now;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  static const _cacheKey = 'pro.v1';
  static const _devKey = 'pro.dev.simulated';

  bool _active = false;
  String? _productId;
  DateTime? _verifiedAt;
  bool _devSimulated = false;
  bool _storeAvailable = false;
  List<StoreProduct> _products = const [];
  PurchaseFlow _flow = PurchaseFlow.idle;
  String? _lastError;

  bool get isPro => AppConfig.isDev ? (_devSimulated || _active) : _active;
  String? get productId => _productId;
  bool get isSubscription => _productId != null && AppConfig.subscriptionIds.contains(_productId);
  bool get storeAvailable => _storeAvailable;
  List<StoreProduct> get products => _products;
  PurchaseFlow get flow => _flow;
  String? get lastError => _lastError;
  bool get devSimulated => _devSimulated;

  bool can(ProFeature feature) => isPro;

  StoreProduct? product(String id) => _products.where((p) => p.id == id).firstOrNull;

  void _loadCache() {
    final raw = _store.readJson(_cacheKey);
    if (raw is Map) {
      final verified = raw['verifiedAt'] is String ? DateTime.tryParse(raw['verifiedAt'] as String) : null;
      final withinGrace = verified != null && _now().difference(verified) < AppConfig.entitlementOfflineGrace;
      _active = raw['active'] == true && withinGrace;
      _productId = raw['productId'] as String?;
      _verifiedAt = verified;
      // A lifetime purchase never lapses; keep it even past the grace window.
      if (raw['active'] == true && _productId == AppConfig.proLifetime) _active = true;
    }
    _devSimulated = AppConfig.isDev && (_store.getBool(_devKey) ?? false);
  }

  Future<void> _saveCache() => _store.writeJson(_cacheKey, {
    'active': _active,
    'productId': _productId,
    'verifiedAt': _verifiedAt?.toIso8601String(),
  });

  /// Connects to the store and reconciles the entitlement. Safe to call on
  /// platforms without billing (it becomes a no-op).
  Future<void> start() async {
    if (!_billingSupported) return;
    try {
      _gateway ??= PlayBillingGateway();
      final gateway = _gateway!;
      await _sub?.cancel();
      _sub = gateway.purchaseStream.listen(
        _onPurchases,
        onError: (Object e) {
          _setFlow(PurchaseFlow.error, e.toString());
        },
      );
      await reconcile();
    } catch (e) {
      debugPrint('ProController.start failed: $e');
    }
  }

  /// Asks the store what the account owns and updates the entitlement.
  Future<bool> reconcile() async {
    final gateway = _gateway;
    if (gateway == null) return false;
    _storeAvailable = await gateway.isAvailable();
    if (!_storeAvailable) {
      notifyListeners();
      return false;
    }
    final owned = await gateway.queryOwned();
    if (owned == null) {
      notifyListeners();
      return false;
    }
    PurchaseDetails? best;
    for (final p in owned) {
      if (!AppConfig.allProductIds.contains(p.productID)) continue;
      if (p.pendingCompletePurchase) {
        try {
          await gateway.complete(p);
        } catch (_) {}
      }
      if (best == null || p.productID == AppConfig.proLifetime) best = p;
    }
    _active = best != null;
    _productId = best?.productID;
    _verifiedAt = _now();
    await _saveCache();
    notifyListeners();
    return _active;
  }

  Future<void> loadProducts() async {
    final gateway = _gateway;
    if (gateway == null) {
      _setFlow(PurchaseFlow.error, 'unavailable');
      return;
    }
    _setFlow(PurchaseFlow.loadingProducts);
    try {
      _storeAvailable = await gateway.isAvailable();
      if (!_storeAvailable) {
        _setFlow(PurchaseFlow.error, 'unavailable');
        return;
      }
      _products = await gateway.queryProducts(AppConfig.allProductIds);
      _setFlow(_products.isEmpty ? PurchaseFlow.error : PurchaseFlow.idle, _products.isEmpty ? 'no-products' : null);
    } catch (e) {
      _setFlow(PurchaseFlow.error, e.toString());
    }
  }

  Future<void> buy(StoreProduct product) async {
    final gateway = _gateway;
    if (gateway == null) return;
    _setFlow(PurchaseFlow.purchasing);
    try {
      final launched = await gateway.buy(product);
      if (!launched) _setFlow(PurchaseFlow.error, 'launch-failed');
    } catch (e) {
      _setFlow(PurchaseFlow.error, e.toString());
    }
  }

  Future<bool> restore() async {
    _setFlow(PurchaseFlow.loadingProducts);
    final ok = await reconcile();
    _setFlow(PurchaseFlow.idle);
    return ok;
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (!AppConfig.allProductIds.contains(p.productID)) {
        if (p.pendingCompletePurchase) await _safeComplete(p);
        continue;
      }
      switch (p.status) {
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          _active = true;
          if (_productId != AppConfig.proLifetime) _productId = p.productID;
          _verifiedAt = _now();
          await _saveCache();
          if (p.pendingCompletePurchase) await _safeComplete(p);
          _setFlow(PurchaseFlow.success);
        case PurchaseStatus.pending:
          _setFlow(PurchaseFlow.pending);
        case PurchaseStatus.error:
          if (p.pendingCompletePurchase) await _safeComplete(p);
          _setFlow(PurchaseFlow.error, p.error?.message);
        case PurchaseStatus.canceled:
          if (p.pendingCompletePurchase) await _safeComplete(p);
          _setFlow(PurchaseFlow.cancelled);
      }
    }
  }

  Future<void> _safeComplete(PurchaseDetails p) async {
    try {
      await _gateway?.complete(p);
    } catch (e) {
      debugPrint('completePurchase failed: $e');
    }
  }

  void _setFlow(PurchaseFlow flow, [String? error]) {
    _flow = flow;
    _lastError = error;
    notifyListeners();
  }

  void acknowledgeFlow() {
    if (_flow == PurchaseFlow.success || _flow == PurchaseFlow.error || _flow == PurchaseFlow.cancelled) {
      _flow = PurchaseFlow.idle;
      _lastError = null;
      notifyListeners();
    }
  }

  /// Starts a fresh paywall session. A purchase that never reported back
  /// (Play closed without an update) must not leave the button spinning;
  /// a pending payment stays visible until Play resolves it.
  void resetFlow() {
    if (_flow == PurchaseFlow.pending || _flow == PurchaseFlow.idle) return;
    _flow = PurchaseFlow.idle;
    _lastError = null;
    notifyListeners();
  }

  /// Dev flavor only: toggles a simulated Pro entitlement.
  Future<void> setDevSimulated(bool value) async {
    if (!AppConfig.isDev) return;
    _devSimulated = value;
    await _store.setBool(_devKey, value);
    notifyListeners();
  }

  void reloadCache() {
    _loadCache();
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }
}

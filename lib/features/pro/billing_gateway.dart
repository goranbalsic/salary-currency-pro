import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

/// What the Pro controller needs from a store. Real implementation below;
/// tests supply a fake.
abstract class BillingGateway {
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<bool> isAvailable();
  Future<List<StoreProduct>> queryProducts(Set<String> ids);
  Future<bool> buy(StoreProduct product);
  Future<void> complete(PurchaseDetails purchase);

  /// Purchases the store currently reports as owned, or null when the
  /// store could not answer (offline, not signed in...).
  Future<List<PurchaseDetails>?> queryOwned();
}

/// A purchasable product as shown on the paywall.
class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    this.hasFreeTrial = false,
    this.freeTrialDays,
    this.native,
  });

  final String id;

  /// Localized formatted price of the recurring (or one-time) charge.
  final String price;
  final double rawPrice;
  final String currencyCode;
  final bool hasFreeTrial;
  final int? freeTrialDays;

  /// The platform object used to launch the purchase.
  final ProductDetails? native;
}

/// Google Play implementation over the in_app_purchase plugin.
class PlayBillingGateway implements BillingGateway {
  PlayBillingGateway() : _iap = InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<StoreProduct>> queryProducts(Set<String> ids) async {
    final response = await _iap.queryProductDetails(ids);
    final out = <StoreProduct>[];
    // Subscriptions arrive once per offer (base plan + e.g. a trial offer).
    final byId = <String, List<ProductDetails>>{};
    for (final p in response.productDetails) {
      byId.putIfAbsent(p.id, () => []).add(p);
    }
    for (final entry in byId.entries) {
      final chosen = _pickOffer(entry.value);
      if (chosen != null) out.add(chosen);
    }
    return out;
  }

  /// Prefers the offer with a free-trial phase (Play only returns offers the
  /// user is still eligible for); the displayed price is the recurring one.
  static StoreProduct? _pickOffer(List<ProductDetails> offers) {
    StoreProduct? best;
    for (final p in offers) {
      if (p is GooglePlayProductDetails && p.subscriptionIndex != null) {
        final offer = p.productDetails.subscriptionOfferDetails![p.subscriptionIndex!];
        final phases = offer.pricingPhases;
        final free = phases.where((ph) => ph.priceAmountMicros == 0).firstOrNull;
        final recurring = phases.lastWhere((ph) => ph.priceAmountMicros > 0, orElse: () => phases.last);
        final candidate = StoreProduct(
          id: p.id,
          price: recurring.formattedPrice,
          rawPrice: recurring.priceAmountMicros / 1e6,
          currencyCode: recurring.priceCurrencyCode,
          hasFreeTrial: free != null,
          freeTrialDays: free == null ? null : _days(free.billingPeriod),
          native: p,
        );
        if (best == null || (candidate.hasFreeTrial && !best.hasFreeTrial)) best = candidate;
      } else {
        best ??= StoreProduct(
          id: p.id,
          price: p.price,
          rawPrice: p.rawPrice,
          currencyCode: p.currencyCode,
          native: p,
        );
      }
    }
    return best;
  }

  /// ISO-8601 period ("P7D", "P1W", "P1M") to days, roughly.
  static int? _days(String period) {
    final m = RegExp(r'^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?$').firstMatch(period);
    if (m == null) return null;
    int g(int i) => int.tryParse(m.group(i) ?? '') ?? 0;
    return g(1) * 365 + g(2) * 30 + g(3) * 7 + g(4);
  }

  @override
  Future<bool> buy(StoreProduct product) async {
    final native = product.native;
    if (native == null) return false;
    return _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: native));
  }

  @override
  Future<void> complete(PurchaseDetails purchase) => _iap.completePurchase(purchase);

  @override
  Future<List<PurchaseDetails>?> queryOwned() async {
    try {
      final addition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      if (response.error != null) return null;
      return response.pastPurchases.where((p) => p.billingClientPurchase.purchaseState == PurchaseStateWrapper.purchased).toList();
    } catch (_) {
      return null;
    }
  }
}

import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../config/monetization_config.dart';

/// Thin wrapper around `in_app_purchase` for the single Pro subscription
/// product. Real purchases require a real product configured in Play
/// Console (see [MonetizationConfig.proMonthlySubscriptionId]) — until
/// that exists, [loadProProduct] returns null and the paywall shows a
/// "not available yet" state instead of a broken buy button.
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final void Function(bool isPro) onProStatusChanged;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  PurchaseService({required this.onProStatusChanged});

  Future<bool> get isAvailable => _iap.isAvailable();

  void start() {
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) {},
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<ProductDetails?> loadProProduct() async {
    final response = await _iap.queryProductDetails(
      {MonetizationConfig.proMonthlySubscriptionId},
    );
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return null;
    }
    return response.productDetails.first;
  }

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restore() => _iap.restorePurchases();

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID == MonetizationConfig.proMonthlySubscriptionId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          onProStatusChanged(true);
        }
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }
}

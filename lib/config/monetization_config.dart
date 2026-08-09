import 'dart:io';

/// AdMob and Play Billing identifiers. Every value here is a placeholder —
/// **before publishing to the Play Store**, replace the test IDs with real
/// ones from your own AdMob and Play Console accounts. Shipping the test
/// IDs is safe (Google's own placeholders, no real ads/charges) but means
/// no real ad revenue and no real subscription purchases.
class MonetizationConfig {
  MonetizationConfig._();

  /// TODO: replace with your real AdMob app ID before release, and add it
  /// to android/app/src/main/AndroidManifest.xml's
  /// com.google.android.gms.ads.APPLICATION_ID meta-data.
  static const String androidAdMobAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// TODO: replace with your real banner ad unit ID before release.
  static String get bannerAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
    return '';
  }

  /// TODO: create this as a real subscription product in Play Console
  /// before release — this ID must match exactly.
  static const String proMonthlySubscriptionId = 'pro_monthly';

  /// PROMPT-003F Stage D go-ahead's four-product lineup. Every id below is
  /// a placeholder the same way [proMonthlySubscriptionId] is — none of
  /// these has been created in Play Console yet. See DECISIONS.md for the
  /// final pricing table (monthly $3.99, annual $19.99 w/ 7-day trial,
  /// lifetime $49.99, support $2.99) — pricing itself is configured in Play
  /// Console, not in this app.
  ///
  /// TODO: create as a real annual subscription product (with a 7-day free
  /// trial configured on it) in Play Console before release.
  static const String proAnnualSubscriptionId = 'pro_annual';

  /// TODO: create as a real one-time (non-consumable) product in Play
  /// Console before release.
  static const String proLifetimePurchaseId = 'pro_lifetime';

  /// A non-gating, one-time "support the developer" purchase — never checked
  /// by any Pro feature gate. TODO: create as a real one-time (non-
  /// consumable) product in Play Console before release.
  static const String supportDeveloperPurchaseId = 'support_developer';

  /// The full Stage D product lineup, for a single `queryProductDetails`
  /// call. [proMonthlySubscriptionId] is deliberately included — Decision 2
  /// keeps a monthly plan alongside annual/lifetime/support, it's simply
  /// no longer this app's only product.
  static const Set<String> entitlementProductIds = {
    proMonthlySubscriptionId,
    proAnnualSubscriptionId,
    proLifetimePurchaseId,
    supportDeveloperPurchaseId,
  };
}

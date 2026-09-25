/// Build-time configuration. `main_dev.dart` switches to the dev flavor,
/// which unlocks a Pro simulator in Settings; `main.dart` is production.
enum Flavor { dev, prod }

abstract final class AppConfig {
  static Flavor flavor = Flavor.prod;
  static bool get isDev => flavor == Flavor.dev;

  /// Must match `applicationId` in android/app/build.gradle.kts.
  static const androidPackage = 'rs.bilans.app';

  /// Play Billing product IDs — create these exact IDs in Play Console
  /// (see docs/launch/PLAY_CONSOLE.md). Subscriptions: one base plan each;
  /// the yearly plan carries a 7-day free-trial offer.
  static const proMonthly = 'pro_monthly';
  static const proYearly = 'pro_yearly';
  static const proLifetime = 'pro_lifetime';
  static const subscriptionIds = {proMonthly, proYearly};
  static const allProductIds = {proMonthly, proYearly, proLifetime};

  /// Public web pages required by Google Play. Host docs/web/ (GitHub
  /// Pages works) and update these if the address differs.
  static const privacyPolicyUrl = 'https://goranbalsic.github.io/salary-currency-pro/privacy.html';
  static const termsUrl = 'https://goranbalsic.github.io/salary-currency-pro/terms.html';

  /// Support address shown in Settings → Contact. Leave empty to hide the
  /// row; set it before release (it is also your Play Console contact).
  static const supportEmail = '';

  /// Free-tier limits.
  static const freeInvoiceLimit = 3;
  static const freeSavedLimit = 5;

  /// How long a cached Pro entitlement stays valid without reaching Play.
  static const entitlementOfflineGrace = Duration(days: 21);

  static Uri get playStoreUri => Uri.parse('https://play.google.com/store/apps/details?id=$androidPackage');

  static Uri manageSubscriptionUri(String? productId) => Uri.parse(
        'https://play.google.com/store/account/subscriptions'
        '${productId == null ? '' : '?sku=$productId&package=$androidPackage'}',
      );
}

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
}

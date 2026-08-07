import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/monetization_config.dart';
import 'consent_service.dart';

/// Thin wrapper around loading a single banner ad. Callers own disposing
/// the returned [BannerAd].
class AdsService {
  static bool _initialized = false;

  /// True once GDPR/UK consent has been resolved (or wasn't required) and
  /// the Mobile Ads SDK is initialized — i.e. it's safe to request an ad.
  /// Stays false for the whole session if consent couldn't be resolved
  /// (declined, or [ConsentService] timed out) — no ad is ever requested
  /// in that case, by design.
  static bool _adsAllowed = false;

  /// Call once, early in app startup (main.dart). Resolves ad consent
  /// (via [ConsentService]) before ever touching [MobileAds] — required
  /// so no ad request can be made ahead of a GDPR/UK consent decision.
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    final canRequestAds =
        await ConsentService.resolveConsentAndCheckCanRequestAds();
    if (!canRequestAds) return;
    await MobileAds.instance.initialize();
    _adsAllowed = true;
  }

  /// Returns null (no ad requested) if consent hasn't been resolved to
  /// "ads allowed" — callers already treat a null banner as "show
  /// nothing," so this needs no special handling beyond that.
  BannerAd? createBanner({required void Function() onLoaded, required void Function() onFailed}) {
    if (!_adsAllowed) return null;
    return BannerAd(
      adUnitId: MonetizationConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed();
        },
      ),
    )..load();
  }
}

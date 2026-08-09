import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../models/entitlement.dart';
import '../services/ads_service.dart';
import '../services/entitlement_service.dart';

/// A banner ad, or nothing at all: for Pro subscribers, on platforms
/// AdMob doesn't support (web/desktop — this app also runs there via
/// `flutter run -d chrome` during development), or if the ad simply fails
/// to load. Never reserves layout space it isn't using.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  final _adsService = AdsService();
  BannerAd? _bannerAd;
  bool _loaded = false;

  bool get _platformSupportsAds =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    if (_platformSupportsAds) {
      _bannerAd = _adsService.createBanner(
        onLoaded: () {
          if (mounted) setState(() => _loaded = true);
        },
        onFailed: () {
          if (mounted) setState(() => _bannerAd = null);
        },
      );
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    return ValueListenableBuilder<EntitlementState>(
      valueListenable: context.read<EntitlementService>().state,
      builder: (context, entitlement, _) {
        if (entitlement.hasFullAccess || !_loaded || ad == null) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        );
      },
    );
  }
}

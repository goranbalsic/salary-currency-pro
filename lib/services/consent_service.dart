import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Wraps Google's User Messaging Platform (UMP) SDK so ad code never runs
/// ahead of GDPR/UK consent. EEA/UK users may be shown a native consent
/// form; everyone else resolves immediately from a cached "not required"
/// result. Startup must never hang on this: every path — success, failure,
/// or a slow/no network — resolves within [_timeout], and a timeout is
/// treated the same as "consent not yet available," i.e. no ads this
/// launch, tried again next launch (the SDK's own consent cache means a
/// once-resolved user resolves near-instantly on later launches).
class ConsentService {
  ConsentService._();

  static const _timeout = Duration(seconds: 3);

  /// Requests consent info, shows the UMP form if the SDK determines one
  /// is required, and reports whether ads may now be requested. Never
  /// throws.
  static Future<bool> resolveConsentAndCheckCanRequestAds() async {
    final completer = Completer<bool>();

    void finish(bool canRequestAds) {
      if (!completer.isCompleted) completer.complete(canRequestAds);
    }

    try {
      final params = ConsentRequestParameters(
        consentDebugSettings: _debugSettings,
      );
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          } catch (_) {
            // Form failed to load/show (e.g. offline after the initial
            // info update succeeded) — canRequestAds() below still gives
            // the correct answer: false if consent was required and
            // still isn't obtained.
          }
          finish(await ConsentInformation.instance.canRequestAds());
        },
        (_) => finish(false),
      );
    } catch (_) {
      finish(false);
    }

    return completer.future.timeout(_timeout, onTimeout: () => false);
  }

  /// Only used in debug builds, so a developer with a real device/emulator
  /// can force EEA geography to actually see and test the consent form —
  /// never shipped active in a release build. Add this build's device ID
  /// (from the "This request is sent from a test device" logcat line) to
  /// [_testDeviceIds] to also see it reflected as a recognized test device
  /// in the AdMob UI.
  static const List<String> _testDeviceIds = [];

  static ConsentDebugSettings? get _debugSettings {
    if (!kDebugMode) return null;
    return ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: _testDeviceIds,
    );
  }

  static Future<bool> isPrivacyOptionsFormRequired() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  }

  static Future<void> showPrivacyOptionsForm() {
    return ConsentForm.showPrivacyOptionsForm((_) {});
  }
}

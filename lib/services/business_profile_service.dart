import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/business_profile.dart';

/// Local, on-device-only issuer identity — same single-user, no-account
/// privacy model as [InvoiceService] and the rest of the app. A single
/// record, not a list: this app has exactly one business/issuer per
/// install.
class BusinessProfileService {
  static const _prefsKey = 'business_profile_v1';

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<BusinessProfile> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return const BusinessProfile();
      return BusinessProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const BusinessProfile();
    }
  }

  Future<void> save(BusinessProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(profile.toJson()));
    } catch (_) {
      // Best-effort persistence only.
    }
    changes.value++;
  }
}

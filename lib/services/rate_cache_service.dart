import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/rate_snapshot.dart';

/// Persists the last successfully fetched [RateSnapshot] per (provider, base)
/// pair so the app can keep showing real, previously-fetched rates when
/// offline — clearly marked as cached, never invented.
class RateCacheService {
  static String _key(String provider, String base) =>
      'rate_cache_${provider}_$base';

  Future<void> save(String provider, RateSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(provider, snapshot.base),
      jsonEncode(snapshot.toJson()),
    );
  }

  Future<RateSnapshot?> load(String provider, String base) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(provider, base));
    if (raw == null) return null;
    try {
      return RateSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt cache entry — treat as absent rather than crashing.
      return null;
    }
  }
}

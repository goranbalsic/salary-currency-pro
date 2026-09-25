import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin, failure-tolerant wrapper over [SharedPreferences].
///
/// Every key the app owns starts with [prefix] so backups can export and
/// restore exactly the app's data. Reads never throw: a corrupted value is
/// treated as missing, logged in debug builds, and left for the next write
/// to replace.
class Store {
  Store(this._prefs);

  static const prefix = 'bilans.';

  final SharedPreferences _prefs;

  static Future<Store> open() async => Store(await SharedPreferences.getInstance());

  String _k(String key) => '$prefix$key';

  String? getString(String key) {
    try {
      return _prefs.getString(_k(key));
    } catch (_) {
      return null;
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(_k(key));
    } catch (_) {
      return null;
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(_k(key));
    } catch (_) {
      return null;
    }
  }

  Future<void> setString(String key, String value) => _guard(() => _prefs.setString(_k(key), value));
  Future<void> setBool(String key, bool value) => _guard(() => _prefs.setBool(_k(key), value));
  Future<void> setInt(String key, int value) => _guard(() => _prefs.setInt(_k(key), value));
  Future<void> remove(String key) => _guard(() => _prefs.remove(_k(key)));

  /// Decoded JSON for [key], or null when missing or unreadable.
  Object? readJson(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (e) {
      debugPrint('Store: unreadable JSON under $key ($e)');
      return null;
    }
  }

  Future<void> writeJson(String key, Object? value) => setString(key, jsonEncode(value));

  /// Every app-owned key and its raw value, for backups.
  Map<String, Object?> exportAll() {
    final out = <String, Object?>{};
    for (final k in _prefs.getKeys()) {
      if (!k.startsWith(prefix)) continue;
      out[k.substring(prefix.length)] = _prefs.get(k);
    }
    return out;
  }

  /// Replaces all app-owned data with [data] (as produced by [exportAll]).
  Future<void> importAll(Map<String, Object?> data) async {
    await clearAll();
    for (final e in data.entries) {
      final v = e.value;
      final key = _k(e.key);
      if (v is String) {
        await _prefs.setString(key, v);
      } else if (v is bool) {
        await _prefs.setBool(key, v);
      } else if (v is int) {
        await _prefs.setInt(key, v);
      } else if (v is double) {
        await _prefs.setDouble(key, v);
      } else if (v is List && v.every((x) => x is String)) {
        await _prefs.setStringList(key, v.cast<String>());
      }
    }
  }

  Future<void> clearAll() async {
    for (final k in _prefs.getKeys().toList()) {
      if (k.startsWith(prefix)) await _prefs.remove(k);
    }
  }

  static Future<void> _guard(Future<bool> Function() op) async {
    try {
      await op();
    } catch (e) {
      debugPrint('Store: write failed ($e)');
    }
  }
}

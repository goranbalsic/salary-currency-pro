import 'dart:convert';

import '../../../core/storage/store.dart';

/// Export / import of all app data as one JSON document.
///
/// Purchase state and cached exchange rates are device-specific and never
/// travel in a backup: restoring someone else's file cannot grant Pro, and
/// old rates cannot overwrite fresher ones.
abstract final class Backup {
  static const format = 'bilans-backup';
  static const version = 1;
  static const _deviceOnly = {'pro.v1', 'pro.dev.simulated', 'fx.nbs.v1', 'fx.ecb.v1'};

  static String encode(Store store, {DateTime? now}) {
    final data = Map.of(store.exportAll())..removeWhere((k, _) => _deviceOnly.contains(k));
    return const JsonEncoder.withIndent(' ').convert({
      'format': format,
      'version': version,
      'exportedAt': (now ?? DateTime.now()).toIso8601String(),
      'data': data,
    });
  }

  /// The data map of a valid backup, or null when [text] is not one.
  static Map<String, Object?>? decode(String text) {
    try {
      final raw = jsonDecode(text);
      if (raw is! Map || raw['format'] != format) return null;
      final v = raw['version'];
      if (v is! int || v < 1 || v > version) return null;
      final data = raw['data'];
      if (data is! Map) return null;
      return data.cast<String, Object?>();
    } catch (_) {
      return null;
    }
  }

  /// Replaces app data with [data], keeping this device's own keys.
  static Future<void> restore(Store store, Map<String, Object?> data) async {
    final current = store.exportAll();
    final keep = {
      for (final k in _deviceOnly)
        if (current.containsKey(k)) k: current[k],
    };
    final incoming = Map.of(data)..removeWhere((k, _) => _deviceOnly.contains(k));
    await store.importAll({...incoming, ...keep});
  }

  /// Deletes all app data except this device's own keys.
  static Future<void> wipe(Store store) async {
    final current = store.exportAll();
    final keep = {
      for (final k in _deviceOnly)
        if (current.containsKey(k)) k: current[k],
    };
    await store.importAll(keep);
  }

  static String fileName(DateTime now) => 'bilans-backup-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.json';
}

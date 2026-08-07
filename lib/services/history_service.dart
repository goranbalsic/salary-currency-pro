import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_entry.dart';

/// Local, on-device-only log of recent successful calculations. Never
/// synced or uploaded — see the privacy note surfaced in Settings. Backed
/// by a single shared_preferences JSON array, newest-first, capped so it
/// can't grow unbounded.
class HistoryService {
  static const _prefsKey = 'activity_history_v1';
  static const maxEntries = 50;

  /// Bumped on every successful `add`/`clear` so tabs kept alive in the
  /// IndexedStack (Home, Tools) can refresh their "recently used" sections
  /// immediately instead of only on their next initState.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<HistoryEntry>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupt or unparseable local data degrades to an empty list rather
      // than crashing Home/Tools.
      return [];
    }
  }

  /// The most recent entry for a given tool, or null if that tool has
  /// never successfully completed a calculation yet.
  Future<HistoryEntry?> latestForTool(String toolId) async {
    final all = await loadAll();
    for (final entry in all) {
      if (entry.toolId == toolId) return entry;
    }
    return null;
  }

  /// Records a new entry at the front of the log. If the most recent entry
  /// is already the same tool with an identical summary, its timestamp is
  /// refreshed in place instead of appending a duplicate — this keeps
  /// repeated Calculate taps on unchanged inputs from flooding the log.
  Future<void> add({
    required String toolId,
    required String title,
    required String summary,
    String? countryId,
    String? currencyCode,
    String? inputLabel,
    String? inputValue,
  }) async {
    final all = await loadAll();
    final now = DateTime.now();

    final entry = HistoryEntry(
      id: all.isNotEmpty && all.first.toolId == toolId && all.first.summary == summary
          ? all.first.id
          : '${now.microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      toolId: toolId,
      timestamp: now,
      title: title,
      summary: summary,
      countryId: countryId,
      currencyCode: currencyCode,
      inputLabel: inputLabel,
      inputValue: inputValue,
    );

    if (all.isNotEmpty && all.first.toolId == toolId && all.first.summary == summary) {
      all[0] = entry;
    } else {
      all.insert(0, entry);
    }

    await _save(all.take(maxEntries).toList());
    changes.value++;
  }

  Future<void> clear() async {
    await _save(const []);
    changes.value++;
  }

  Future<void> _save(List<HistoryEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

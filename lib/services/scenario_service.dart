import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scenario.dart';

/// Thrown by [ScenarioService.add] when a non-Pro user has already saved
/// [ScenarioService.freeLimit] scenarios — callers should catch this and
/// route to the paywall rather than silently dropping the save.
class ScenarioLimitReachedException implements Exception {}

/// Local, on-device-only store of user-named saved scenarios. Never synced
/// or uploaded, same as [HistoryService] — but every save here is
/// intentional (no dedup, no recency-based eviction).
class ScenarioService {
  static const _prefsKey = 'saved_scenarios_v1';
  static const freeLimit = 3;

  /// Bumped on every successful add/rename/delete/clear so screens showing
  /// scenario lists/counts (Home, Tools, My Scenarios) can refresh live —
  /// same pattern as [HistoryService.changes].
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<Scenario>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupt or unparseable local data degrades to an empty list rather
      // than crashing any screen that lists scenarios.
      return [];
    }
  }

  Future<List<Scenario>> loadForTool(String toolId) async {
    final all = await loadAll();
    return all.where((s) => s.toolId == toolId).toList();
  }

  /// Saves a new scenario at the front of the list. Throws
  /// [ScenarioLimitReachedException] if [isPro] is false and the free
  /// limit is already reached — the caller is expected to route to the
  /// paywall rather than treat this as a generic failure.
  Future<Scenario> add({
    required String toolId,
    required String name,
    required String summary,
    required Map<String, dynamic> inputs,
    String? countryId,
    String? currencyCode,
    required bool isPro,
  }) async {
    final all = await loadAll();
    if (!isPro && all.length >= freeLimit) {
      throw ScenarioLimitReachedException();
    }

    final scenario = Scenario(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      toolId: toolId,
      name: name,
      createdAt: DateTime.now(),
      countryId: countryId,
      currencyCode: currencyCode,
      summary: summary,
      inputs: inputs,
    );
    all.insert(0, scenario);
    await _save(all);
    changes.value++;
    return scenario;
  }

  Future<void> rename(String id, String newName) async {
    final all = await loadAll();
    final index = all.indexWhere((s) => s.id == id);
    if (index == -1) return;
    all[index] = Scenario(
      id: all[index].id,
      schemaVersion: all[index].schemaVersion,
      toolId: all[index].toolId,
      name: newName,
      createdAt: all[index].createdAt,
      countryId: all[index].countryId,
      currencyCode: all[index].currencyCode,
      summary: all[index].summary,
      inputs: all[index].inputs,
    );
    await _save(all);
    changes.value++;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((s) => s.id == id);
    await _save(all);
    changes.value++;
  }

  Future<void> clear() async {
    await _save(const []);
    changes.value++;
  }

  /// Overwrites the entire stored list — used by one-off data migrations
  /// (e.g. `BgEuroMigrationService`) that need to rewrite several scenarios
  /// at once. Callers are responsible for preserving every scenario they
  /// don't intend to change.
  Future<void> replaceAll(List<Scenario> scenarios) async {
    await _save(scenarios);
    changes.value++;
  }

  Future<void> _save(List<Scenario> scenarios) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(scenarios.map((s) => s.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

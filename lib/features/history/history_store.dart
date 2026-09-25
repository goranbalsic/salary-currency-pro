import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../core/storage/store.dart';

/// Tools whose inputs can be saved and restored.
enum ToolId { payroll, loan, deposit, vat, margin, breakEven, investment, fx }

/// One saved calculation: which tool, when, and the inputs to restore it.
class SavedCalc {
  const SavedCalc({required this.id, required this.tool, required this.at, required this.inputs, this.name = '', this.pinned = false});

  final String id;
  final ToolId tool;
  final DateTime at;
  final Map<String, Object?> inputs;
  final String name;

  /// Explicitly saved by the person (vs. automatically recorded as recent).
  final bool pinned;

  String get fingerprint => '${tool.name}:${jsonEncode(inputs)}';

  SavedCalc copyWith({String? name, bool? pinned, DateTime? at}) =>
      SavedCalc(id: id, tool: tool, at: at ?? this.at, inputs: inputs, name: name ?? this.name, pinned: pinned ?? this.pinned);

  Map<String, Object?> toJson() => {
        'id': id,
        'tool': tool.name,
        'at': at.toIso8601String(),
        'inputs': inputs,
        'name': name,
        'pinned': pinned,
      };

  static SavedCalc? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final tool = ToolId.values.where((t) => t.name == raw['tool']).firstOrNull;
    final at = raw['at'] is String ? DateTime.tryParse(raw['at'] as String) : null;
    final inputs = raw['inputs'];
    final id = raw['id'];
    if (tool == null || at == null || inputs is! Map || id is! String) return null;
    return SavedCalc(
      id: id,
      tool: tool,
      at: at,
      inputs: inputs.cast<String, Object?>(),
      name: raw['name'] is String ? raw['name'] as String : '',
      pinned: raw['pinned'] == true,
    );
  }
}

/// Recent (automatic, capped) and saved (explicit) calculations.
class HistoryStore extends ChangeNotifier {
  HistoryStore(this._store) {
    _load();
  }

  final Store _store;
  static const _key = 'history.v1';
  static const maxRecent = 20;

  final List<SavedCalc> _items = [];
  final _random = math.Random();

  List<SavedCalc> get recent => _items.where((e) => !e.pinned).toList();
  List<SavedCalc> get saved => _items.where((e) => e.pinned).toList();
  List<SavedCalc> get all => List.unmodifiable(_items);
  int get savedCount => _items.where((e) => e.pinned).length;

  void _load() {
    _items.clear();
    final raw = _store.readJson(_key);
    if (raw is List) {
      for (final e in raw) {
        final item = SavedCalc.tryFromJson(e);
        if (item != null) _items.add(item);
      }
    }
    _items.sort((a, b) => b.at.compareTo(a.at));
  }

  Future<void> _save() => _store.writeJson(_key, [for (final e in _items) e.toJson()]);

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 20)}';

  /// Records a calculation as recent. Identical inputs move to the top
  /// instead of duplicating.
  Future<void> recordRecent(ToolId tool, Map<String, Object?> inputs) async {
    final entry = SavedCalc(id: _newId(), tool: tool, at: DateTime.now(), inputs: inputs);
    final existing = _items.indexWhere((e) => !e.pinned && e.fingerprint == entry.fingerprint);
    if (existing >= 0) {
      _items[existing] = _items[existing].copyWith(at: entry.at);
    } else {
      _items.add(entry);
    }
    _items.sort((a, b) => b.at.compareTo(a.at));
    final recents = _items.where((e) => !e.pinned).toList();
    if (recents.length > maxRecent) {
      final drop = recents.sublist(maxRecent).map((e) => e.id).toSet();
      _items.removeWhere((e) => drop.contains(e.id));
    }
    notifyListeners();
    await _save();
  }

  Future<SavedCalc> saveNamed(ToolId tool, Map<String, Object?> inputs, String name) async {
    final entry = SavedCalc(id: _newId(), tool: tool, at: DateTime.now(), inputs: inputs, name: name.trim(), pinned: true);
    _items.insert(0, entry);
    notifyListeners();
    await _save();
    return entry;
  }

  Future<void> rename(String id, String name) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(name: name.trim());
    notifyListeners();
    await _save();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> clearRecent() async {
    _items.removeWhere((e) => !e.pinned);
    notifyListeners();
    await _save();
  }

  void reload() {
    _load();
    notifyListeners();
  }
}

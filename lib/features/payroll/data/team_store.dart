import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../core/storage/store.dart';
import '../domain/payroll_engine.dart';
import '../domain/payroll_models.dart';

/// One person on the payroll plan.
class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.system,
    required this.mode,
    required this.amount,
    this.role = '',
    this.options = const PayrollOptions(),
  });

  final String id;
  final String name;
  final String role;
  final PayrollSystem system;

  /// Whether [amount] is gross, net or total cost.
  final PayrollInputMode mode;
  final double amount;
  final PayrollOptions options;

  PayrollResult compute([PayrollEngine engine = const PayrollEngine()]) {
    try {
      return engine.compute(system, mode, amount, options);
    } on PayrollSolveException {
      return engine.fromGross(system, 0, options);
    }
  }

  TeamMember copyWith({String? name, String? role, PayrollSystem? system, PayrollInputMode? mode, double? amount, PayrollOptions? options}) => TeamMember(
    id: id,
    name: name ?? this.name,
    role: role ?? this.role,
    system: system ?? this.system,
    mode: mode ?? this.mode,
    amount: amount ?? this.amount,
    options: options ?? this.options,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'system': system.name,
    'mode': mode.name,
    'amount': amount,
    'options': options.toJson(),
  };

  static TeamMember? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final system = PayrollSystem.byName(raw['system'] as String?);
    final mode = PayrollInputMode.values.where((m) => m.name == raw['mode']).firstOrNull;
    final amount = raw['amount'];
    final id = raw['id'];
    if (system == null || mode == null || amount is! num || !amount.isFinite || id is! String) return null;
    return TeamMember(
      id: id,
      name: raw['name'] is String ? raw['name'] as String : '',
      role: raw['role'] is String ? raw['role'] as String : '',
      system: system,
      mode: mode,
      amount: amount.toDouble(),
      options: raw['options'] is Map ? PayrollOptions.fromJson((raw['options'] as Map).cast<String, Object?>()) : const PayrollOptions(),
    );
  }
}

class TeamStore extends ChangeNotifier {
  TeamStore(this._store) {
    _load();
  }

  final Store _store;
  static const _key = 'team.v1';
  final List<TeamMember> _members = [];
  final _random = math.Random();

  List<TeamMember> get members => List.unmodifiable(_members);

  void _load() {
    _members.clear();
    final raw = _store.readJson(_key);
    if (raw is List) {
      for (final e in raw) {
        final m = TeamMember.tryFromJson(e);
        if (m != null) _members.add(m);
      }
    }
  }

  String newId() => '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 20)}';

  Future<void> upsert(TeamMember m) async {
    final i = _members.indexWhere((e) => e.id == m.id);
    if (i >= 0) {
      _members[i] = m;
    } else {
      _members.add(m);
    }
    notifyListeners();
    await _store.writeJson(_key, [for (final e in _members) e.toJson()]);
  }

  Future<void> remove(String id) async {
    _members.removeWhere((e) => e.id == id);
    notifyListeners();
    await _store.writeJson(_key, [for (final e in _members) e.toJson()]);
  }

  void reload() {
    _load();
    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../app/bootstrap.dart';
import 'history_store.dart';

/// Shared behaviour for the stand-alone calculators: inputs survive
/// closing the screen, and a finished calculation is recorded as recent
/// once the person pauses typing.
mixin CalcState<T extends StatefulWidget> on State<T> {
  ToolId get toolId;
  String get storeKey;
  Timer? _recordTimer;
  HistoryStore? _history;
  Map<String, Object?>? _pending;

  /// Inputs to start from: the ones passed in (restoring a saved
  /// calculation), else the last-used ones, else null.
  Map<String, Object?>? initialInputs(Map<String, Object?>? passed) {
    if (passed != null) return passed;
    final raw = context.read<AppServices>().store.readJson(storeKey);
    return raw is Map ? raw.cast<String, Object?>() : null;
  }

  /// Persists [inputs]; records them as recent when [complete].
  void persistInputs(Map<String, Object?> inputs, {required bool complete}) {
    unawaited(context.read<AppServices>().store.writeJson(storeKey, inputs));
    _recordTimer?.cancel();
    _pending = null;
    if (!complete) return;
    _history = context.read<HistoryStore>();
    _pending = inputs;
    _recordTimer = Timer(const Duration(milliseconds: 1500), _flushRecent);
  }

  void _flushRecent() {
    final inputs = _pending;
    _pending = null;
    if (inputs != null) unawaited(_history?.recordRecent(toolId, inputs));
  }

  @override
  void dispose() {
    // Leaving right after typing still counts as a finished calculation.
    // Recorded after this frame: listeners may not rebuild mid-teardown.
    if (_recordTimer?.isActive ?? false) {
      _recordTimer!.cancel();
      scheduleMicrotask(_flushRecent);
    }
    super.dispose();
  }
}

double? readDouble(Map<String, Object?>? m, String key) {
  final v = m?[key];
  return v is num && v.isFinite ? v.toDouble() : null;
}

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
    if (!complete) return;
    _recordTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) unawaited(context.read<HistoryStore>().recordRecent(toolId, inputs));
    });
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    super.dispose();
  }
}

double? readDouble(Map<String, Object?>? m, String key) {
  final v = m?[key];
  return v is num && v.isFinite ? v.toDouble() : null;
}

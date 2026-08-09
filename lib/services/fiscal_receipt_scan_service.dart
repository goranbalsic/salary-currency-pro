import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/receipt_scan/receipt_adapter_registry.dart';
import '../models/fiscal_receipt_scan.dart';

/// Local, on-device-only queue of scanned fiscal-receipt QR payloads. Same
/// privacy model as [ExpenseService]/`HistoryService`: never synced or
/// uploaded, degrades to an empty list on corrupt data rather than
/// crashing, capped so it can't grow unbounded on a device kept for years.
/// Classification happens once, at scan/manual-entry time, via
/// [ReceiptAdapterRegistry] — never re-derived from the raw payload later,
/// so a stored record accurately reflects what the adapters found then.
class FiscalReceiptScanService {
  static const _prefsKey = 'fiscal_receipt_scans_v1';
  static const maxEntries = 500;

  /// Bumped on every successful record/delete/link so the scan-entry and
  /// queue screens can refresh live — same pattern as
  /// [ExpenseService.changes].
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  final ReceiptAdapterRegistry _registry;

  FiscalReceiptScanService({ReceiptAdapterRegistry? registry})
      : _registry = registry ?? ReceiptAdapterRegistry();

  Future<List<FiscalReceiptScan>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      final scans = decoded
          .map((e) => FiscalReceiptScan.fromJson(e as Map<String, dynamic>))
          .toList();
      scans.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
      return scans;
    } catch (_) {
      return [];
    }
  }

  Future<FiscalReceiptScan?> find(String id) async {
    final all = await loadAll();
    for (final s in all) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Classifies [rawPayload] locally and stores a new scan record — the
  /// single entry point for both the camera scanner and the manual-entry
  /// fallback, so both paths get identical classification and persistence.
  Future<FiscalReceiptScan> recordScan(String rawPayload) async {
    final classification = _registry.classify(rawPayload);
    final all = await loadAll();
    final scan = FiscalReceiptScan(
      id: '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 31)}',
      rawPayload: rawPayload,
      scannedAt: DateTime.now(),
      outcome: classification.outcome,
      countryId: classification.countryId,
    );
    all.insert(0, scan);
    await _save(all.take(maxEntries).toList());
    changes.value++;
    return scan;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((s) => s.id == id);
    await _save(all);
    changes.value++;
  }

  /// Re-inserts a previously-deleted [scan] exactly as it was — the undo
  /// half of [delete], mirroring [ExpenseService.restore]. A no-op if a scan
  /// with the same id already exists (e.g. undo tapped twice).
  Future<void> restore(FiscalReceiptScan scan) async {
    final all = await loadAll();
    if (all.any((s) => s.id == scan.id)) return;
    all.insert(0, scan);
    await _save(all);
    changes.value++;
  }

  /// Marks [id] as having a manual expense created from it — additive,
  /// leaves every other field untouched. A no-op if [id] no longer exists.
  Future<void> linkExpense({required String id, required String expenseId}) async {
    final all = await loadAll();
    final index = all.indexWhere((s) => s.id == id);
    if (index == -1) return;
    all[index] = all[index].copyWith(
      status: ScanQueueStatus.expenseCreated,
      linkedExpenseId: expenseId,
    );
    await _save(all);
    changes.value++;
  }

  Future<void> _save(List<FiscalReceiptScan> scans) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(scans.map((s) => s.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

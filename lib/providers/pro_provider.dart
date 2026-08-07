import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsIsProKey = 'is_pro_subscriber';

/// Whether the user has an active Pro subscription (removes ads). The
/// store (via [PurchaseService]) is the real source of truth; this is a
/// local cache so the app doesn't need to re-verify with the store on
/// every screen build. [PurchaseService] updates this provider whenever
/// the purchase stream reports a change.
class ProProvider extends ChangeNotifier {
  bool _isPro = false;
  bool get isPro => _isPro;

  ProProvider() {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getBool(_prefsIsProKey) ?? false;
      if (cached != _isPro) {
        _isPro = cached;
        notifyListeners();
      }
    } catch (_) {
      // Default to non-Pro if unavailable — never fail open on a paid gate.
    }
  }

  Future<void> setPro(bool value) async {
    if (value == _isPro) return;
    _isPro = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsIsProKey, value);
    } catch (_) {
      // Best-effort persistence only.
    }
  }
}

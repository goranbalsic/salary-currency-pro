import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The single currency pair shown on the "pinned currency pair" home-screen
/// widget (PROMPT-003 Stage B item 8). Deliberately separate from
/// [CurrencyConverterProvider], which resets to EUR/RSD every time the
/// Converter screen opens rather than remembering a choice — this service
/// is the first place in the app that persists a currency pair across
/// sessions.
class PinnedPairService {
  static const _fromKey = 'widget_pinned_pair_from';
  static const _toKey = 'widget_pinned_pair_to';
  static const defaultFrom = 'EUR';
  static const defaultTo = 'RSD';

  /// Bumped whenever the pinned pair changes, so both Settings and
  /// [HomeWidgetService] can react.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<(String from, String to)> loadPair() async {
    final prefs = await SharedPreferences.getInstance();
    final from = prefs.getString(_fromKey) ?? defaultFrom;
    final to = prefs.getString(_toKey) ?? defaultTo;
    return (from, to);
  }

  Future<void> setPair(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fromKey, from);
    await prefs.setString(_toKey, to);
    changes.value++;
  }
}

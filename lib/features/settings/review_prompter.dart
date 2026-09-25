import 'package:in_app_review/in_app_review.dart';

import '../../core/storage/store.dart';

/// Asks Google Play for its in-app review card after a moment of success —
/// an invoice issued or paid, a calculation saved — once the person has
/// used Bilans on a few different days. Never more than [maxAsks] times,
/// and not again within [cooldown]; Play decides whether the card appears
/// and rate-limits it on its side as well.
class ReviewPrompter {
  ReviewPrompter(this._store, {Future<void> Function()? request, DateTime Function()? clock}) : _request = request ?? _askPlay, _clock = clock ?? DateTime.now;

  static const storeKey = 'review.v1';

  /// Different days the app was opened before the first ask.
  static const minDays = 3;

  /// Successes needed before each ask.
  static const minWins = 2;
  static const cooldown = Duration(days: 120);
  static const maxAsks = 3;

  final Store _store;
  final Future<void> Function() _request;
  final DateTime Function() _clock;

  Map<String, Object?> get _state => switch (_store.readJson(storeKey)) {
    final Map<String, Object?> m => m,
    _ => const {},
  };

  int _int(String key) => switch (_state[key]) {
    final int v => v,
    _ => 0,
  };

  int get daysUsed => _int('days');
  int get wins => _int('wins');
  int get asks => _int('asks');

  static String _day(DateTime d) => '${d.year}-${d.month}-${d.day}';

  /// Counts the day; call once per app start.
  Future<void> recordOpen() async {
    final state = _state;
    final today = _day(_clock());
    if (state['lastDay'] == today) return;
    await _store.writeJson(storeKey, {...state, 'lastDay': today, 'days': daysUsed + 1});
  }

  /// Records a success and, when the person has clearly found the app
  /// useful, asks Play for the review card. Returns whether it asked.
  Future<bool> recordWin() async {
    final state = {..._state, 'wins': wins + 1};
    final lastAsked = switch (state['lastAsked']) {
      final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      _ => null,
    };
    final now = _clock();
    final ready = daysUsed >= minDays && wins + 1 >= minWins && asks < maxAsks && (lastAsked == null || now.difference(lastAsked) >= cooldown);
    if (!ready) {
      await _store.writeJson(storeKey, state);
      return false;
    }
    await _store.writeJson(storeKey, {...state, 'wins': 0, 'asks': asks + 1, 'lastAsked': now.millisecondsSinceEpoch});
    try {
      await _request();
    } catch (_) {
      // Play unavailable or the card refused: nothing to tell the person.
    }
    return true;
  }

  static Future<void> _askPlay() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) await review.requestReview();
  }
}

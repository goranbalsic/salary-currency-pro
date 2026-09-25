import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/storage/store.dart';
import '../domain/rates.dart';
import 'rate_api.dart';

enum RatesStatus { idle, loading, ok, offline }

/// Holds the latest NBS and ECB rate lists. Cached lists are shown
/// immediately; a refresh replaces a source only when it succeeds, so a
/// flaky connection never wipes good data.
class RatesController extends ChangeNotifier {
  RatesController(this._store, this._api) {
    _book = RateBook(
      nbs: RateTable.fromJson(_store.readJson(_nbsKey)),
      ecb: RateTable.fromJson(_store.readJson(_ecbKey)),
    );
  }

  final Store _store;
  final RateApi _api;
  static const _nbsKey = 'fx.nbs.v1';
  static const _ecbKey = 'fx.ecb.v1';
  static const minRefreshInterval = Duration(minutes: 20);

  late RateBook _book;
  RatesStatus _status = RatesStatus.idle;
  DateTime? _lastAttempt;
  Future<void>? _inFlight;
  final Map<String, List<RatePoint>> _historyCache = {};
  final Map<String, RatePoint> _datedCache = {};

  RateBook get book => _book;
  RatesStatus get status => _status;
  bool get hasData => !_book.isEmpty;

  /// Most recent successful fetch across both sources.
  DateTime? get lastFetched {
    final a = _book.nbs?.fetchedAt;
    final b = _book.ecb?.fetchedAt;
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  /// Refreshes unless a refresh ran very recently. Never throws.
  Future<void> refresh({bool force = false}) {
    final now = DateTime.now();
    if (!force && _lastAttempt != null && now.difference(_lastAttempt!) < minRefreshInterval && hasData) {
      return Future.value();
    }
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  Future<void> _doRefresh() async {
    _lastAttempt = DateTime.now();
    _status = RatesStatus.loading;
    notifyListeners();
    var anyOk = false;
    final results = await Future.wait([
      _api.fetchNbs().then<RateTable?>((t) => t, onError: (_) => null),
      _api.fetchEcb().then<RateTable?>((t) => t, onError: (_) => null),
    ]);
    final nbs = results[0];
    final ecb = results[1];
    if (nbs != null) {
      anyOk = true;
      await _store.writeJson(_nbsKey, nbs.toJson());
    }
    if (ecb != null) {
      anyOk = true;
      await _store.writeJson(_ecbKey, ecb.toJson());
    }
    _book = RateBook(nbs: nbs ?? _book.nbs, ecb: ecb ?? _book.ecb);
    _status = anyOk ? RatesStatus.ok : RatesStatus.offline;
    notifyListeners();
  }

  /// Daily history for a pair's base currency series. Throws
  /// [RateFetchException] when offline and nothing is cached.
  Future<List<RatePoint>> history(RateSource source, String code, int days) async {
    final key = '${source.name}:$code:$days:${_ymd(DateTime.now())}';
    final cached = _historyCache[key];
    if (cached != null) return cached;
    final to = DateTime.now();
    final from = DateTime(to.year, to.month, to.day - days);
    final points = await _api.history(source, code, from, to);
    if (points.length < 2) throw const RateFetchException('not enough history');
    _historyCache[key] = points;
    return points;
  }

  /// NBS middle rate valid on [date] (used for invoice counter-values).
  /// Dates in the future are not published yet and return null.
  Future<RatePoint?> nbsRateOn(String code, DateTime date) async {
    final today = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    if (d.isAfter(DateTime(today.year, today.month, today.day))) return null;
    if (code == 'RSD') return RatePoint(d, 1);
    final key = '$code:${_ymd(d)}';
    final hit = _datedCache[key];
    if (hit != null) return hit;
    final point = await _api.fetchNbsOn(code, d);
    _datedCache[key] = point;
    return point;
  }

  static String _ymd(DateTime d) => '${d.year}-${d.month}-${d.day}';

  void reload() {
    _book = RateBook(
      nbs: RateTable.fromJson(_store.readJson(_nbsKey)),
      ecb: RateTable.fromJson(_store.readJson(_ecbKey)),
    );
    notifyListeners();
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Thin abstraction over `flutter_local_notifications` — exists so
/// [NotificationService] (lib/services/notification_service.dart) can be
/// unit-tested with a fake scheduler that records calls instead of
/// touching a real platform channel, the same pattern this app already
/// uses for [RateProviderApi]/`ScenarioService` fakes in tests.
abstract class NotificationScheduler {
  Future<void> initialize();

  /// Requests OS notification permission (Android 13+ runtime permission;
  /// iOS alert/badge/sound). Returns false only on an explicit user
  /// denial — platforms that don't need a prompt report true.
  Future<bool> requestPermission();

  /// Repeats every day at [hour]:[minute] (device local time) until
  /// [cancel]led — used for the expense-log nudge.
  Future<void> scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
  });

  /// Repeats on [day] of every month at 09:00 local time — used for the
  /// Serbian paušal 15th-of-month reminder. [day] is clamped the same way
  /// `RecurringTransaction`'s monthly frequency is, so a hypothetical day
  /// > 28 can never silently skip a short month.
  Future<void> scheduleMonthlyOnDay({
    required int id,
    required String title,
    required String body,
    required int day,
  });

  /// Fires once at [dateTime] — used for a specific invoice's due-date
  /// reminder. A no-op (never scheduled) if [dateTime] is already in the
  /// past, since this app never fabricates a "reminder" for a moment that
  /// already happened.
  Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  });

  /// Fires immediately — used for the budget-threshold alert, which is
  /// event-triggered (crossing 80%/100% right now), not scheduled ahead.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  });

  Future<void> cancel(int id);
}

class FlutterLocalNotificationScheduler implements NotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  FlutterLocalNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Expense, budget, invoice, and paušal reminders you turned on in Settings';

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    // Falls back to UTC if the device's local zone can't be resolved —
    // reminders still fire, just not necessarily at the intended local
    // clock time on that rare device; never a crash.
    try {
      tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    } catch (_) {
      // Keep whatever default `timezone` already set.
    }
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted = await android?.requestNotificationsPermission();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }

  @override
  Future<void> scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(20, 0),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> scheduleMonthlyOnDay({
    required int id,
    required String title,
    required String body,
    required int day,
  }) async {
    await initialize();
    final now = tz.TZDateTime.now(tz.local);
    var target = _clampedMonthDate(now.year, now.month, day, 9, 0);
    if (target.isBefore(now)) {
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      target = _clampedMonthDate(nextYear, nextMonth, day, 9, 0);
    }
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: target,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  tz.TZDateTime _clampedMonthDate(int year, int month, int day, int hour, int minute) {
    final lastDayOfMonth = tz.TZDateTime(tz.local, year, month + 1, 0).day;
    final clampedDay = day > lastDayOfMonth ? lastDayOfMonth : day;
    return tz.TZDateTime(tz.local, year, month, clampedDay, hour, minute);
  }

  @override
  Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await initialize();
    final scheduled = tz.TZDateTime.from(dateTime, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    await _plugin.show(id: id, title: title, body: body, notificationDetails: _details);
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id: id);
  }
}

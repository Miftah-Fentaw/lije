import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/features/during_pregnancy/models/week_registry.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Local pregnancy & baby reminders.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _ready = false;

  static const weeklyId = 100;
  static const trimester2Id = 201;
  static const trimester3Id = 202;
  static const edd14Id = 301;
  static const edd7Id = 302;
  static const edd1Id = 303;
  static const edd0Id = 304;
  static const babyWeek1Id = 501;
  static const babyMonth1Id = 502;
  static const babyMonth2Id = 503;
  static const babyMonth6Id = 504;
  static const babyMonth12Id = 505;

  static Future<void> init() async {
    if (_ready) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    _ready = true;
  }

  /// Safe post-launch setup: permissions + rescheduling must not block app open.
  static Future<void> startup(AppState state) async {
    try {
      await init();
      await requestPermissions();
      await rescheduleAll(state);
    } catch (_) {
      // Keep the app usable even if notifications fail on this device.
    }
  }

  static Future<void> requestPermissions() async {
    if (!_ready) await init();
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  static Future<void> rescheduleAll(AppState state) async {
    if (!_ready) await init();
    try {
      await cancelAll();
      if (!state.notificationsEnabled) return;

      final lang = langNotifier.value;

      if (state.hasPregnancyData &&
          state.pregnancyRemindersEnabled &&
          state.lnmp != null &&
          state.edd != null) {
        await _scheduleWeeklyPregnancy(state, lang);
        await _scheduleTrimesterMilestones(state, lang);
        await _scheduleEddReminders(state, lang);
      }

      if (state.childBirthDate != null) {
        await _scheduleBabyReminders(state.childBirthDate!, lang);
      }
    } catch (_) {
      // Exact alarms or timezone issues should not crash the app.
    }
  }

  static Future<void> cancelAll() async {
    if (!_ready) return;
    for (final id in [
      weeklyId,
      trimester2Id,
      trimester3Id,
      edd14Id,
      edd7Id,
      edd1Id,
      edd0Id,
      babyWeek1Id,
      babyMonth1Id,
      babyMonth2Id,
      babyMonth6Id,
      babyMonth12Id,
    ]) {
      await _plugin.cancel(id);
    }
  }

  static Future<void> setEnabled(bool enabled, AppState state) async {
    await state.setNotificationsEnabled(enabled);
    if (enabled) {
      await requestPermissions();
      await rescheduleAll(state);
    } else {
      await cancelAll();
    }
  }

  static Future<void> enablePregnancyReminders(AppState state) async {
    if (!state.notificationsEnabled) {
      await state.setNotificationsEnabled(true);
    }
    await state.setPregnancyRemindersEnabled(true);
    await rescheduleAll(state);
  }

  static Future<void> disablePregnancyReminders(AppState state) async {
    await state.setPregnancyRemindersEnabled(false);
    await rescheduleAll(state);
  }

  static List<ScheduledReminderInfo> plannedReminders(AppState state) {
    final lang = langNotifier.value;
    final list = <ScheduledReminderInfo>[];
    if (!state.notificationsEnabled) return list;

    if (state.hasPregnancyData && state.pregnancyRemindersEnabled) {
      list.add(ScheduledReminderInfo(
        LS.get(lang, 'reminderWeeklyTitle'),
        LS.get(lang, 'reminderWeeklyDesc'),
        Icons.calendar_today_rounded,
      ));
      if (state.edd != null) {
        for (final days in [14, 7, 1, 0]) {
          final d = state.edd!.subtract(Duration(days: days));
          if (!d.isBefore(DateTime.now())) {
            list.add(ScheduledReminderInfo(
              days == 0
                  ? LS.get(lang, 'reminderDueTodayTitle')
                  : LS.get(lang, 'reminderDueSoonTitle')
                      .replaceAll('{days}', '$days'),
              _fmt(d),
              Icons.event_rounded,
            ));
          }
        }
      }
    }

    if (state.childBirthDate != null) {
      final b = state.childBirthDate!;
      for (final entry in [
        (7, 'reminderBabyWeekTitle'),
        (30, 'reminderBabyMonth1Title'),
        (60, 'reminderBabyMonth2Title'),
        (180, 'reminderBabyMonth6Title'),
        (365, 'reminderBabyYear1Title'),
      ]) {
        final d = b.add(Duration(days: entry.$1));
        if (!d.isBefore(DateTime.now())) {
          list.add(ScheduledReminderInfo(
            LS.get(lang, entry.$2),
            _fmt(d),
            Icons.child_care_rounded,
          ));
        }
      }
    }

    return list;
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  static Future<void> _zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    const modes = [
      AndroidScheduleMode.exactAllowWhileIdle,
      AndroidScheduleMode.inexactAllowWhileIdle,
    ];
    for (final mode in modes) {
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: matchDateTimeComponents,
        );
        return;
      } catch (_) {
        if (mode == modes.last) rethrow;
      }
    }
  }

  static Future<void> _scheduleWeeklyPregnancy(
      AppState state, AppLang lang) async {
    final wd = WeekRegistry.forWeek(state.gaWeeks);
    final tip = wd.tip[lang] ?? wd.tip[AppLang.english]!;
    final summary = tip.split('.').first.trim();
    await _zonedSchedule(
      id: weeklyId,
      title: LS.get(lang, 'reminderWeeklyTitle'),
      body: '${LS.get(lang, 'weeksLabel')} ${state.gaWeeks}: $summary.',
      scheduledDate: _nextSundayAt(9),
      details: NotificationDetails(
        android: AndroidNotificationDetails(
          'pregnancy_weekly',
          LS.get(lang, 'notificationsSetting'),
          channelDescription: LS.get(lang, 'notificationsDesc'),
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> _scheduleTrimesterMilestones(
      AppState state, AppLang lang) async {
    final lnmp = state.lnmp!;
    await _scheduleOneShot(
      trimester2Id,
      lnmp.add(const Duration(days: 14 * 7)),
      LS.get(lang, 'reminderTrimester2Title'),
      LS.get(lang, 'reminderTrimester2Desc'),
      'pregnancy_milestones',
      lang,
    );
    await _scheduleOneShot(
      trimester3Id,
      lnmp.add(const Duration(days: 27 * 7)),
      LS.get(lang, 'reminderTrimester3Title'),
      LS.get(lang, 'reminderTrimester3Desc'),
      'pregnancy_milestones',
      lang,
    );
  }

  static Future<void> _scheduleEddReminders(
      AppState state, AppLang lang) async {
    final edd = state.edd!;
    final items = [
      (edd14Id, 14, 'reminderDueSoonDesc'),
      (edd7Id, 7, 'reminderDueSoonDesc'),
      (edd1Id, 1, 'reminderDueSoonDesc'),
      (edd0Id, 0, 'reminderDueTodayDesc'),
    ];
    for (final item in items) {
      final when = edd.subtract(Duration(days: item.$2));
      final title = item.$2 == 0
          ? LS.get(lang, 'reminderDueTodayTitle')
          : LS.get(lang, 'reminderDueSoonTitle')
              .replaceAll('{days}', '${item.$2}');
      await _scheduleOneShot(
        item.$1,
        when,
        title,
        LS.get(lang, item.$3),
        'pregnancy_edd',
        lang,
      );
    }
  }

  static Future<void> _scheduleBabyReminders(
      DateTime birth, AppLang lang) async {
    final items = [
      (babyWeek1Id, 7, 'reminderBabyWeekTitle', 'reminderBabyWeekDesc'),
      (babyMonth1Id, 30, 'reminderBabyMonth1Title', 'reminderBabyMonth1Desc'),
      (babyMonth2Id, 60, 'reminderBabyMonth2Title', 'reminderBabyMonth2Desc'),
      (babyMonth6Id, 180, 'reminderBabyMonth6Title', 'reminderBabyMonth6Desc'),
      (babyMonth12Id, 365, 'reminderBabyYear1Title', 'reminderBabyYear1Desc'),
    ];
    for (final item in items) {
      await _scheduleOneShot(
        item.$1,
        birth.add(Duration(days: item.$2)),
        LS.get(lang, item.$3),
        LS.get(lang, item.$4),
        'baby_care',
        lang,
      );
    }
  }

  static Future<void> _scheduleOneShot(
    int id,
    DateTime date,
    String title,
    String body,
    String channelId,
    AppLang lang,
  ) async {
    final scheduled = _at9am(date);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      details: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          LS.get(lang, 'notificationsSetting'),
          channelDescription: LS.get(lang, 'notificationsDesc'),
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  static tz.TZDateTime _at9am(DateTime d) {
    final local = tz.TZDateTime(tz.local, d.year, d.month, d.day, 9);
    return local.isBefore(tz.TZDateTime.now(tz.local))
        ? local.add(const Duration(days: 1))
        : local;
  }

  static tz.TZDateTime _nextSundayAt(int hour) {
    var next = tz.TZDateTime.now(tz.local);
    while (next.weekday != DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    next = tz.TZDateTime(tz.local, next.year, next.month, next.day, hour);
    if (next.isBefore(tz.TZDateTime.now(tz.local))) {
      next = next.add(const Duration(days: 7));
    }
    return next;
  }
}

class ScheduledReminderInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  const ScheduledReminderInfo(this.title, this.subtitle, this.icon);
}

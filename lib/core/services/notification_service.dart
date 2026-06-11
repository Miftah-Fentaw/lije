import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
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

  /// Weekly pregnancy-tip notifications use ids `weeklyBaseId + week`
  /// for week = 1..maxPregnancyWeeks.
  static const weeklyBaseId = 1000;
  static const maxPregnancyWeeks = 40;

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

  /// Id used by android_alarm_manager_plus for the daily reschedule alarm.
  /// `rescheduleOnReboot: true` makes the plugin re-arm this alarm (and run
  /// [_backgroundRescheduleCallback] again) automatically after the device
  /// restarts, which in turn re-schedules every flutter_local_notifications
  /// alarm above.
  static const rebootAlarmId = 9001;

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
  ///
  /// Runs on every app start, including the first launch after a reinstall —
  /// [AppState.load] reads any pregnancy/baby data still present in
  /// SharedPreferences and [rescheduleAll] re-creates every OS-level alarm
  /// from that data (the alarms themselves do not survive an uninstall, but
  /// the data does if the user restores from the same SharedPreferences
  /// store / app backup).
  static Future<void> startup(AppState state) async {
    try {
      await init();
      await requestPermissions();
      await rescheduleAll(state);
      await _registerBackgroundReschedule();
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

  /// Registers a recurring background alarm (via android_alarm_manager_plus)
  /// that re-runs [rescheduleAll]. Because it is registered with
  /// `rescheduleOnReboot: true`, Android automatically re-arms it after the
  /// device reboots, which re-schedules all pregnancy/baby notifications even
  /// if they were lost on restart.
  static Future<void> _registerBackgroundReschedule() async {
    try {
      await AndroidAlarmManager.initialize();
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        rebootAlarmId,
        backgroundRescheduleCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    } catch (_) {
      // android_alarm_manager_plus is Android-only; ignore on other platforms.
    }
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
        await _scheduleWeeklyPregnancyTips(state, lang);
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
      for (var week = 1; week <= maxPregnancyWeeks; week++) weeklyBaseId + week,
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

  /// Schedules one tip notification per gestational week (1..[maxPregnancyWeeks]),
  /// each firing on the day that week begins (LNMP + week*7 days). Past dates
  /// are skipped automatically by [_scheduleOneShot].
  static Future<void> _scheduleWeeklyPregnancyTips(
      AppState state, AppLang lang) async {
    final lnmp = state.lnmp!;
    for (var week = 1; week <= maxPregnancyWeeks; week++) {
      final wd = WeekRegistry.forWeek(week);
      final tip = wd.tip[lang] ?? wd.tip[AppLang.english]!;
      final summary = tip.split('.').first.trim();
      final date = lnmp.add(Duration(days: week * 7));
      await _scheduleOneShot(
        weeklyBaseId + week,
        date,
        LS.get(lang, 'reminderWeeklyTitle'),
        '${LS.get(lang, 'weeksLabel')} $week: $summary.',
        'pregnancy_weekly',
        lang,
      );
    }
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
}

/// Entry point for the recurring background alarm registered by
/// [NotificationService._registerBackgroundReschedule].
///
/// android_alarm_manager_plus runs this in its own background isolate, so it
/// re-initializes the Flutter bindings, reloads [AppState] from
/// SharedPreferences, and re-schedules every notification. Because the alarm
/// is registered with `rescheduleOnReboot: true`, this also runs again after
/// a device restart, restoring all pregnancy/baby notifications.
@pragma('vm:entry-point')
void backgroundRescheduleCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  await NotificationService.rescheduleAll(state);
}

class ScheduledReminderInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  const ScheduledReminderInfo(this.title, this.subtitle, this.icon);
}

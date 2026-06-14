import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/services/notification_content.dart';
import 'package:lije/core/widgets/notification_permission_dialog.dart';
import 'package:lije/features/auth/services/auth_storage.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Local pregnancy, baby & discover daily reminders.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _ready = false;

  /// Daily pregnancy notifications: id = [pregnancyDailyBase] + gestational day.
  static const pregnancyDailyBase = 10000;
  static const maxPregnancyDays = 281;

  /// Daily discover tip: id = [discoverDailyBase] + offset from today (0..89).
  static const discoverDailyBase = 13000;
  static const discoverHorizonDays = 90;

  /// Daily baby notifications: id = [babyDailyBase] + days since birth.
  static const babyDailyBase = 14000;
  static const maxBabyDays = 730;

  static const rebootAlarmId = 9001;
  static const previewNotificationId = 88888;

  static const _channels = [
    'pregnancy_daily',
    'baby_daily',
    'discover_daily',
  ];

  static const _morningHour = 9;
  static const _tipHour = 10;
  static const _tipMinute = 30;

  static Future<void> init() async {
    if (_ready) return;
    tz_data.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // Fall back to UTC if the device timezone cannot be resolved.
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    await _createAndroidChannels();
    _ready = true;
  }

  static Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    final lang = langNotifier.value;
    final channelName = LS.get(lang, 'notificationsSetting');
    final channelDesc = LS.get(lang, 'notificationsDesc');

    for (final id in _channels) {
      await androidPlugin.createNotificationChannel(
        AndroidNotificationChannel(
          id,
          channelName,
          description: channelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
    }
  }

  static NotificationDetails _details(String channelId, AppLang lang) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        LS.get(lang, 'notificationsSetting'),
        channelDescription: LS.get(lang, 'notificationsDesc'),
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher',
        showWhen: true,
        ticker: LS.get(lang, 'notificationsSetting'),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> startup(AppState state) async {
    await init();
    try {
      await rescheduleAll(state);
      await _registerBackgroundReschedule();
    } catch (_) {
      // Scheduling may fail before permissions are granted; prompt handles that.
    }
  }

  /// Returns `true` when notifications are allowed on this device.
  /// Returns `null` on platforms that do not support local notifications.
  static Future<bool?> areNotificationsEnabled() async {
    if (!_ready) await init();
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      return androidPlugin.areNotificationsEnabled();
    }
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final settings = await iosPlugin.checkPermissions();
      return settings?.isEnabled;
    }
    return null;
  }

  static bool get _isMobilePlatform {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Shows an in-app explanation, then the OS permission sheet.
  /// Call once the UI is visible (e.g. after splash / on MainShell).
  static Future<void> maybePromptForPermissions(
    BuildContext context,
    AppState state,
  ) async {
    if (!_isMobilePlatform) return;
    if (!context.mounted) return;

    await init();

    final enabled = await areNotificationsEnabled();
    if (enabled == true) return;
    if (!context.mounted) return;

    final lang = langNotifier.value;
    final allow = await showNotificationPermissionDialog(context, lang);
    if (!allow || !context.mounted) return;

    await requestPermissions();
    await rescheduleAll(state);
  }

  static Future<void> requestPermissions() async {
    if (!_ready) await init();
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

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
      final userName = (await AuthStorage.loadUser())?.name;
      _cachedUserName = userName;
      final today = _dateOnly(DateTime.now());

      final inPregnancy = state.hasPregnancyData &&
          state.pregnancyRemindersEnabled &&
          state.lnmp != null &&
          state.edd != null &&
          !today.isAfter(state.edd!);

      final afterBirth = state.childBirthDate != null &&
          !today.isBefore(state.childBirthDate!);

      if (inPregnancy) {
        await _scheduleDailyPregnancy(state, lang, userName, today);
      }

      if (afterBirth) {
        await _scheduleDailyBaby(state.childBirthDate!, lang, userName, today);
      }

      await _scheduleDailyDiscover(
        lang,
        userName,
        today,
        pregnancyPhase: inPregnancy,
        babyPhase: afterBirth && !inPregnancy,
      );
    } catch (_) {
      // Exact alarms or timezone issues should not crash the app.
    }
  }

  static Future<void> cancelAll() async {
    if (!_ready) await init();
    await _plugin.cancelAll();
  }

  static Future<void> setEnabled(bool enabled, AppState state) async {
    await state.setNotificationsEnabled(enabled);
    if (enabled) {
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
    return upcomingNotifications(state)
        .map((n) => ScheduledReminderInfo(n.title, n.subtitle, n.icon))
        .toList();
  }

  /// Real upcoming notifications with actual title, body, and fire time.
  static List<UpcomingNotificationInfo> upcomingNotifications(
    AppState state,
  ) {
    final lang = langNotifier.value;
    final list = <UpcomingNotificationInfo>[];
    if (!state.notificationsEnabled) return list;

    final today = _dateOnly(DateTime.now());
    final userName = _cachedUserName;

    final inPregnancy = state.hasPregnancyData &&
        state.pregnancyRemindersEnabled &&
        state.lnmp != null &&
        state.edd != null &&
        !today.isAfter(state.edd!);

    final afterBirth = state.childBirthDate != null &&
        !today.isBefore(state.childBirthDate!);

    if (inPregnancy) {
      final lnmp = state.lnmp!;
      final gaDay = today.difference(lnmp).inDays.clamp(0, maxPregnancyDays - 1);
      final content = NotificationContent.pregnancyDay(gaDay, lang, userName);
      list.add(UpcomingNotificationInfo(
        title: content.title,
        body: content.body,
        subtitle: _formatScheduleTime(today, _morningHour, 0, lang),
        icon: Icons.pregnant_woman_rounded,
        scheduledAt: _localDateTime(today, _morningHour, 0),
      ));
    }

    if (afterBirth) {
      final birth = state.childBirthDate!;
      final daysSinceBirth = today.difference(birth).inDays;
      final content =
          NotificationContent.babyDay(daysSinceBirth, lang, userName);
      list.add(UpcomingNotificationInfo(
        title: content.title,
        body: content.body,
        subtitle: _formatScheduleTime(today, _morningHour, 0, lang),
        icon: Icons.child_care_rounded,
        scheduledAt: _localDateTime(today, _morningHour, 0),
      ));
    }

    final absoluteDay = today.difference(DateTime(2024)).inDays;
    final discover = NotificationContent.discoverTip(
      absoluteDay,
      lang,
      userName,
      pregnancyPhase: inPregnancy,
      babyPhase: afterBirth && !inPregnancy,
    );
    list.add(UpcomingNotificationInfo(
      title: discover.title,
      body: discover.body,
      subtitle: _formatScheduleTime(today, _tipHour, _tipMinute, lang),
      icon: Icons.lightbulb_outline_rounded,
      scheduledAt: _localDateTime(today, _tipHour, _tipMinute),
    ));

    return list;
  }

  static String? _cachedUserName;

  static Future<void> refreshDisplayCache() async {
    await _refreshUserName();
  }

  static Future<void> _refreshUserName() async {
    _cachedUserName = (await AuthStorage.loadUser())?.name;
  }

  /// Fires a real OS notification immediately using today's actual content.
  /// Only for preview — scheduled reminders remain unchanged.
  static Future<bool> showPreviewNotification(AppState state) async {
    if (!_isMobilePlatform) return false;
    if (!_ready) await init();

    var enabled = await areNotificationsEnabled();
    if (enabled != true) {
      await requestPermissions();
      enabled = await areNotificationsEnabled();
      if (enabled != true) return false;
    }

    await _refreshUserName();
    final upcoming = upcomingNotifications(state);
    if (upcoming.isEmpty) return false;

    final preview = upcoming.first;
    final channelId = _channelForPreview(state);
    final lang = langNotifier.value;

    await _plugin.show(
      previewNotificationId,
      preview.title,
      preview.body,
      _details(channelId, lang),
    );
    return true;
  }

  static String _channelForPreview(AppState state) {
    final today = _dateOnly(DateTime.now());
    final inPregnancy = state.hasPregnancyData &&
        state.pregnancyRemindersEnabled &&
        state.lnmp != null &&
        state.edd != null &&
        !today.isAfter(state.edd!);
    if (inPregnancy) return 'pregnancy_daily';

    final afterBirth = state.childBirthDate != null &&
        !today.isBefore(state.childBirthDate!);
    if (afterBirth) return 'baby_daily';

    return 'discover_daily';
  }

  static DateTime _localDateTime(DateTime day, int hour, int minute) {
    final scheduled = _atTime(day, hour, minute);
    return DateTime(
      scheduled.year,
      scheduled.month,
      scheduled.day,
      scheduled.hour,
      scheduled.minute,
    );
  }

  static String _formatScheduleTime(
    DateTime day,
    int hour,
    int minute,
    AppLang lang,
  ) {
    final at = _localDateTime(day, hour, minute);
    final now = DateTime.now();
    final time =
        '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
    if (at.isBefore(now)) {
      return lang == AppLang.amharic
          ? 'ነገ $time'
          : lang == AppLang.oromic
              ? 'Boru $time'
              : 'Tomorrow $time';
    }
    return lang == AppLang.amharic
        ? 'ዛሬ $time'
        : lang == AppLang.oromic
            ? 'Har\'a $time'
            : 'Today $time';
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static Future<void> _scheduleDailyPregnancy(
    AppState state,
    AppLang lang,
    String? userName,
    DateTime today,
  ) async {
    final lnmp = state.lnmp!;
    final end = state.edd!.isBefore(lnmp.add(const Duration(days: maxPregnancyDays)))
        ? state.edd!
        : lnmp.add(const Duration(days: maxPregnancyDays - 1));

    var cursor = today.isBefore(lnmp) ? lnmp : today;
    while (!cursor.isAfter(end)) {
      final gaDay = cursor.difference(lnmp).inDays;
      if (gaDay >= 0 && gaDay < maxPregnancyDays) {
        final content =
            NotificationContent.pregnancyDay(gaDay, lang, userName);
        await _scheduleOneShot(
          pregnancyDailyBase + gaDay,
          cursor,
          _morningHour,
          content.title,
          content.body,
          'pregnancy_daily',
          lang,
        );
      }
      cursor = cursor.add(const Duration(days: 1));
    }
  }

  static Future<void> _scheduleDailyBaby(
    DateTime birth,
    AppLang lang,
    String? userName,
    DateTime today,
  ) async {
    final start = today.isBefore(birth) ? birth : today;
    final end = birth.add(const Duration(days: maxBabyDays - 1));

    var cursor = start;
    while (!cursor.isAfter(end)) {
      final daysSinceBirth = cursor.difference(birth).inDays;
      if (daysSinceBirth >= 0 && daysSinceBirth < maxBabyDays) {
        final content =
            NotificationContent.babyDay(daysSinceBirth, lang, userName);
        await _scheduleOneShot(
          babyDailyBase + daysSinceBirth,
          cursor,
          _morningHour,
          content.title,
          content.body,
          'baby_daily',
          lang,
        );
      }
      cursor = cursor.add(const Duration(days: 1));
    }
  }

  static Future<void> _scheduleDailyDiscover(
    AppLang lang,
    String? userName,
    DateTime today, {
    required bool pregnancyPhase,
    required bool babyPhase,
  }) async {
    for (var offset = 0; offset < discoverHorizonDays; offset++) {
      final date = today.add(Duration(days: offset));
      final absoluteDay = date.difference(DateTime(2024)).inDays;
      final content = NotificationContent.discoverTip(
        absoluteDay,
        lang,
        userName,
        pregnancyPhase: pregnancyPhase,
        babyPhase: babyPhase,
      );
      await _scheduleOneShot(
        discoverDailyBase + offset,
        date,
        _tipHour,
        content.title,
        content.body,
        'discover_daily',
        lang,
        minute: _tipMinute,
      );
    }
  }

  static Future<void> _zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
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
        );
        return;
      } catch (_) {
        if (mode == modes.last) rethrow;
      }
    }
  }

  static Future<void> _scheduleOneShot(
    int id,
    DateTime date,
    int hour,
    String title,
    String body,
    String channelId,
    AppLang lang, {
    int minute = 0,
  }) async {
    final scheduled = _atTime(date, hour, minute);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      details: _details(channelId, lang),
    );
  }

  static tz.TZDateTime _atTime(DateTime d, int hour, int minute) {
    final local = tz.TZDateTime(tz.local, d.year, d.month, d.day, hour, minute);
    return local.isBefore(tz.TZDateTime.now(tz.local))
        ? local.add(const Duration(days: 1))
        : local;
  }
}

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

class UpcomingNotificationInfo {
  final String title;
  final String body;
  final String subtitle;
  final IconData icon;
  final DateTime scheduledAt;
  const UpcomingNotificationInfo({
    required this.title,
    required this.body,
    required this.subtitle,
    required this.icon,
    required this.scheduledAt,
  });
}

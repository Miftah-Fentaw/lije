import 'package:shared_preferences/shared_preferences.dart';

/// Persists pregnancy and child data locally.
class PregnancyStorage {
  static const _lnmpKey = 'lnmp_ms';
  static const _eddKey = 'edd_ms';
  static const _gaWeeksKey = 'ga_weeks';
  static const _gaDaysKey = 'ga_days';
  static const _hasPregnancyKey = 'has_pregnancy';
  static const _birthKey = 'birth_ms';
  static const _todosKey = 'completed_todos';
  static const _symptomsKey = 'logged_symptoms';
  static const _notificationsKey = 'notifications_enabled';
  static const _pregRemindersKey = 'pregnancy_reminders_enabled';

  static Future<Map<String, dynamic>> load() async {
    final p = await SharedPreferences.getInstance();
    return {
      'lnmpMs': p.getInt(_lnmpKey),
      'eddMs': p.getInt(_eddKey),
      'gaWeeks': p.getInt(_gaWeeksKey) ?? 0,
      'gaDays': p.getInt(_gaDaysKey) ?? 0,
      'hasPregnancy': p.getBool(_hasPregnancyKey) ?? false,
      'birthMs': p.getInt(_birthKey),
      'notificationsEnabled': p.getBool(_notificationsKey),
      'pregnancyRemindersEnabled': p.getBool(_pregRemindersKey),
      'todos': p.getStringList(_todosKey) ?? <String>[],
      'symptoms': p.getStringList(_symptomsKey) ?? <String>[],
    };
  }

  static Future<void> save({
    int? lnmpMs,
    int? eddMs,
    required int gaWeeks,
    required int gaDays,
    required bool hasPregnancy,
    int? birthMs,
    required bool notificationsEnabled,
    required bool pregnancyRemindersEnabled,
    required Set<String> completedTodos,
    required Set<String> loggedSymptoms,
  }) async {
    final p = await SharedPreferences.getInstance();
    if (lnmpMs != null) {
      await p.setInt(_lnmpKey, lnmpMs);
    } else {
      await p.remove(_lnmpKey);
    }
    if (eddMs != null) {
      await p.setInt(_eddKey, eddMs);
    } else {
      await p.remove(_eddKey);
    }
    await p.setInt(_gaWeeksKey, gaWeeks);
    await p.setInt(_gaDaysKey, gaDays);
    await p.setBool(_hasPregnancyKey, hasPregnancy);
    if (birthMs != null) {
      await p.setInt(_birthKey, birthMs);
    } else {
      await p.remove(_birthKey);
    }
    await p.setBool(_notificationsKey, notificationsEnabled);
    await p.setBool(_pregRemindersKey, pregnancyRemindersEnabled);
    await p.setStringList(_todosKey, completedTodos.toList());
    await p.setStringList(_symptomsKey, loggedSymptoms.toList());
  }
}

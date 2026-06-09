import 'package:flutter/material.dart';
import 'package:lije/features/home/services/pregnancy_storage.dart';

class AppState extends ChangeNotifier {
  DateTime? _lnmp;
  DateTime? _edd;
  int _gaWeeks = 0;
  int _gaDays = 0;
  bool _hasPregnancyData = false;
  DateTime? _childBirthDate;
  bool _notificationsEnabled = true;
  bool _pregnancyRemindersEnabled = false;
  final Set<String> _completedTodos = {};
  final Set<String> _loggedSymptoms = {};

  DateTime? get lnmp => _lnmp;
  DateTime? get edd => _edd;
  int get gaWeeks => _gaWeeks;
  int get gaDays => _gaDays;
  bool get hasPregnancyData => _hasPregnancyData;
  DateTime? get childBirthDate => _childBirthDate;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get pregnancyRemindersEnabled => _pregnancyRemindersEnabled;

  int get trimester => _gaWeeks < 14 ? 1 : (_gaWeeks < 27 ? 2 : 3);

  double get progress => _hasPregnancyData
      ? ((_gaWeeks * 7 + _gaDays) / 280.0).clamp(0.0, 1.0)
      : 0;

  bool isTodoDone(int week, int index) =>
      _completedTodos.contains('w${week}_$index');

  bool isSymptomLogged(String key) => _loggedSymptoms.contains(key);

  Future<void> load() async {
    final data = await PregnancyStorage.load();
    _lnmp = _fromMs(data['lnmpMs'] as int?);
    _edd = _fromMs(data['eddMs'] as int?);
    _gaWeeks = data['gaWeeks'] as int;
    _gaDays = data['gaDays'] as int;
    _hasPregnancyData = data['hasPregnancy'] as bool;
    _childBirthDate = _fromMs(data['birthMs'] as int?);
    _notificationsEnabled = data['notificationsEnabled'] as bool? ?? true;
    _pregnancyRemindersEnabled =
        data['pregnancyRemindersEnabled'] as bool? ?? false;
    _completedTodos
      ..clear()
      ..addAll((data['todos'] as List<String>?) ?? []);
    _loggedSymptoms
      ..clear()
      ..addAll((data['symptoms'] as List<String>?) ?? []);
    if (_hasPregnancyData && _lnmp != null) {
      _refreshGaFromLnmp();
    }
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setPregnancyRemindersEnabled(bool value) async {
    _pregnancyRemindersEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> applyPregnancyResult({
    required DateTime lnmp,
    required DateTime edd,
    required int gaWeeks,
    required int gaDays,
  }) async {
    _lnmp = _dateOnly(lnmp);
    _edd = _dateOnly(edd);
    _gaWeeks = gaWeeks;
    _gaDays = gaDays;
    _hasPregnancyData = true;
    notifyListeners();
    await _persist();
  }

  Future<void> setPregnancyStart(DateTime start) async {
    _lnmp = _dateOnly(start);
    _edd = _lnmp!.add(const Duration(days: 280));
    _refreshGaFromLnmp();
    _hasPregnancyData = true;
    notifyListeners();
    await _persist();
  }

  Future<void> setChildBirthDate(DateTime date) async {
    _childBirthDate = _dateOnly(date);
    notifyListeners();
    await _persist();
  }

  Future<void> toggleTodo(int week, int index) async {
    final key = 'w${week}_$index';
    if (_completedTodos.contains(key)) {
      _completedTodos.remove(key);
    } else {
      _completedTodos.add(key);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> toggleSymptom(String key) async {
    if (_loggedSymptoms.contains(key)) {
      _loggedSymptoms.remove(key);
    } else {
      _loggedSymptoms.add(key);
    }
    notifyListeners();
    await _persist();
  }

  void refreshGa() {
    if (_lnmp == null) return;
    _refreshGaFromLnmp();
    notifyListeners();
    _persist();
  }

  void _refreshGaFromLnmp() {
    final diff = DateTime.now().difference(_lnmp!).inDays;
    _gaWeeks = (diff ~/ 7).clamp(0, 42);
    _gaDays = diff % 7;
  }

  Future<void> _persist() => PregnancyStorage.save(
        lnmpMs: _lnmp?.millisecondsSinceEpoch,
        eddMs: _edd?.millisecondsSinceEpoch,
        gaWeeks: _gaWeeks,
        gaDays: _gaDays,
        hasPregnancy: _hasPregnancyData,
        birthMs: _childBirthDate?.millisecondsSinceEpoch,
        notificationsEnabled: _notificationsEnabled,
        pregnancyRemindersEnabled: _pregnancyRemindersEnabled,
        completedTodos: _completedTodos,
        loggedSymptoms: _loggedSymptoms,
      );

  static DateTime? _fromMs(int? ms) =>
      ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

final AppState appState = AppState();

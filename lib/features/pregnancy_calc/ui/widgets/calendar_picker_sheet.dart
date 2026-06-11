import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/features/pregnancy_calc/services/calculator_constants.dart';
import 'package:lije/features/pregnancy_calc/services/ethiopian_calendar.dart';

class CalendarPickerSheet extends StatefulWidget {
  final DateTime initialDate;
  const CalendarPickerSheet({super.key, required this.initialDate});

  @override
  State<CalendarPickerSheet> createState() => CalendarPickerSheetState();
}

class CalendarPickerSheetState extends State<CalendarPickerSheet>
    with TickerProviderStateMixin {
  bool _isEthiopian = false;
  late DateTime _gregFocusMonth;
  DateTime? _gregSelected;
  late int _etYear, _etMonth;
  int? _etDay;

  late AnimationController _sheetAnim;
  late AnimationController _calendarSwapAnim;
  late AnimationController _monthChangeAnim;
  late Animation<Offset> _sheetSlide;
  late Animation<double> _sheetFade;
  bool _slideForward = true;

  @override
  void initState() {
    super.initState();
    _gregSelected = widget.initialDate;
    _gregFocusMonth =
        DateTime(widget.initialDate.year, widget.initialDate.month);
    final et = EthiopianCalendar.fromGregorian(widget.initialDate);
    _etYear = et.$1;
    _etMonth = et.$2;
    _etDay = et.$3;

    _sheetAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _sheetSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _sheetAnim, curve: Curves.easeOutCubic));
    _sheetFade = CurvedAnimation(parent: _sheetAnim, curve: Curves.easeOut);

    _calendarSwapAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _monthChangeAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _sheetAnim.forward();
  }

  @override
  void dispose() {
    _sheetAnim.dispose();
    _calendarSwapAnim.dispose();
    _monthChangeAnim.dispose();
    super.dispose();
  }

  DateTime? get _selectedGregorian {
    if (_isEthiopian) {
      if (_etDay == null) return null;
      return EthiopianCalendar.toGregorian(_etYear, _etMonth, _etDay!);
    }
    return _gregSelected;
  }

  void _toggleCalendar(bool etMode) async {
    if (_isEthiopian == etMode) return;
    await _calendarSwapAnim.forward();
    setState(() {
      _isEthiopian = etMode;
      if (!etMode && _etDay != null) {
        final greg = EthiopianCalendar.toGregorian(_etYear, _etMonth, _etDay!);
        _gregSelected = greg;
        _gregFocusMonth = DateTime(greg.year, greg.month);
      } else if (etMode && _gregSelected != null) {
        final et = EthiopianCalendar.fromGregorian(_gregSelected!);
        _etYear = et.$1;
        _etMonth = et.$2;
        _etDay = et.$3;
      }
    });
    _calendarSwapAnim.reverse();
  }

  void _changeMonth(bool forward) {
    setState(() {
      _slideForward = forward;
      if (_isEthiopian) {
        if (forward) {
          if (_etMonth == 13) {
            _etMonth = 1;
            _etYear++;
          } else {
            _etMonth++;
          }
        } else {
          if (_etMonth == 1) {
            _etMonth = 13;
            _etYear--;
          } else {
            _etMonth--;
          }
        }
        _etDay = null;
      } else {
        _gregFocusMonth = DateTime(
            _gregFocusMonth.year, _gregFocusMonth.month + (forward ? 1 : -1));
      }
    });
    _monthChangeAnim.forward(from: 0);
  }

  String s(String key) => LS.get(langNotifier.value, key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _sheetFade,
      child: SlideTransition(
        position: _sheetSlide,
        child: ValueListenableBuilder<AppLang>(
          valueListenable: langNotifier,
          builder: (context, _, __) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.90),
              decoration: const BoxDecoration(
                color: BC.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 14),
                Center(
                    child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [BC.gradStart, BC.gradEnd]),
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
                const SizedBox(height: 20),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [BC.gradStart, BC.gradEnd]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: BC.primary.withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: const Text('📅', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(s('selectDate'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: BC.textDark,
                                letterSpacing: -0.4))),
                    // Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: BC.grayBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: BC.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        _toggleBtn(s('gregorian'), !_isEthiopian,
                            () => _toggleCalendar(false)),
                        _toggleBtn(s('ethiopian'), _isEthiopian,
                            () => _toggleCalendar(true)),
                      ]),
                    ),
                  ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          BC.primaryPale,
                          BC.primaryFrost.withValues(alpha: 0.5),
                          BC.primaryPale,
                        ]),
                        borderRadius: BorderRadius.circular(1),
                      )),
                ),
                Expanded(
                    child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.08, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOut)),
                      child: child,
                    ),
                  ),
                  child: SingleChildScrollView(
                    key: ValueKey(_isEthiopian),
                    child: _isEthiopian
                        ? _buildEthiopianCalendar()
                        : _buildGregorianCalendar(),
                  ),
                )),
                // Action buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
                  child: Row(children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: BC.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(s('cancel'),
                          style: const TextStyle(
                              color: BC.textMid, fontWeight: FontWeight.w600)),
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _selectedGregorian == null
                              ? null
                              : () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pop(context, _selectedGregorian);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BC.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: BC.border,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: Text(s('ok'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15)),
                        )),
                  ]),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(colors: [BC.gradStart, BC.gradEnd])
              : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: BC.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Text(label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: active ? BC.white : BC.textLight)),
      ),
    );
  }

  Widget _buildGregorianCalendar() {
    final today = DateTime.now();
    final firstDay = DateTime(_gregFocusMonth.year, _gregFocusMonth.month, 1);
    final lastDay =
        DateTime(_gregFocusMonth.year, _gregFocusMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _monthNavRow(
            '${monthNames[_gregFocusMonth.month - 1]} ${_gregFocusMonth.year}'),
        const SizedBox(height: 18),
        _weekdayHeaders(['S', 'M', 'T', 'W', 'T', 'F', 'S']),
        const SizedBox(height: 10),
        _buildCalendarGrid(
          startWeekday: startWeekday,
          totalDays: lastDay.day,
          cellBuilder: (day) {
            final date =
                DateTime(_gregFocusMonth.year, _gregFocusMonth.month, day);
            final isToday = date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
            final isSelected = _gregSelected != null &&
                date.year == _gregSelected!.year &&
                date.month == _gregSelected!.month &&
                date.day == _gregSelected!.day;
            final isFuture = date.isAfter(today);
            return _dayCell(
                day: day,
                isToday: isToday,
                isSelected: isSelected,
                isFuture: isFuture,
                selectedColor: BC.primary,
                todayColor: BC.primaryFrost,
                todayTextColor: BC.primary,
                onTap: isFuture
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        setState(() => _gregSelected = date);
                      });
          },
        ),
        if (_gregSelected != null) ...[
          const SizedBox(height: 14),
          _selectedDisplay(
              icon: '🌍',
              label: _fmtDate(_gregSelected!),
              bg: BC.primaryFrost,
              textColor: BC.primary),
        ],
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _buildEthiopianCalendar() {
    final todayEt = EthiopianCalendar.fromGregorian(DateTime.now());
    final daysInMonth = EthiopianCalendar.daysInMonth(_etYear, _etMonth);
    final firstGreg = EthiopianCalendar.toGregorian(_etYear, _etMonth, 1);
    final startWeekday = firstGreg.weekday % 7;
    final isAmharic = langNotifier.value == AppLang.amharic;
    final months =
        isAmharic ? EthiopianCalendar.monthsAm : EthiopianCalendar.monthsEn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _monthNavRow('${months[_etMonth - 1]} $_etYear'),
        const SizedBox(height: 18),
        _weekdayHeaders(['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            fontSize: 9),
        const SizedBox(height: 10),
        _buildCalendarGrid(
          startWeekday: startWeekday,
          totalDays: daysInMonth,
          cellBuilder: (day) {
            final isToday = _etYear == todayEt.$1 &&
                _etMonth == todayEt.$2 &&
                day == todayEt.$3;
            final isSelected = _etDay == day;
            final thisGreg =
                EthiopianCalendar.toGregorian(_etYear, _etMonth, day);
            final isFuture = thisGreg.isAfter(DateTime.now());
            return _dayCell(
                day: day,
                isToday: isToday,
                isSelected: isSelected,
                isFuture: isFuture,
                selectedColor: BC.lavender,
                todayColor: BC.lavenderLight,
                todayTextColor: BC.lavender,
                onTap: isFuture
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        setState(() => _etDay = day);
                      });
          },
        ),
        if (_etDay != null) ...[
          const SizedBox(height: 14),
          _selectedDisplay(
              icon: '🇪🇹',
              label: '${months[_etMonth - 1]} $_etDay $_etYear',
              bg: BC.lavenderLight,
              textColor: BC.lavender),
        ],
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _monthNavRow(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [BC.primaryFrost, Color(0xFFDCEEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BC.primaryPale),
      ),
      child: Row(children: [
        _navBtn(Icons.chevron_left_rounded, () => _changeMonth(false)),
        Expanded(
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(_slideForward ? 0.3 : -0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: Text(title,
              key: ValueKey(title),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BC.primaryDeep,
                  letterSpacing: -0.2)),
        )),
        _navBtn(Icons.chevron_right_rounded, () => _changeMonth(true)),
      ]),
    );
  }

  Widget _weekdayHeaders(List<String> days, {double fontSize = 11}) {
    return Row(
        children: days
            .map((d) => Expanded(
                    child: Center(
                  child: Text(d,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: BC.textMid)),
                )))
            .toList());
  }

  Widget _buildCalendarGrid({
    required int startWeekday,
    required int totalDays,
    required Widget Function(int day) cellBuilder,
  }) {
    final total = startWeekday + totalDays;
    final rows = (total / 7).ceil();
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (row) {
          return Row(
              children: List.generate(7, (col) {
            final idx = row * 7 + col;
            if (idx < startWeekday || idx >= startWeekday + totalDays) {
              return const Expanded(child: SizedBox(height: 44));
            }
            return Expanded(child: cellBuilder(idx - startWeekday + 1));
          }));
        }));
  }

  Widget _dayCell({
    required int day,
    required bool isToday,
    required bool isSelected,
    required bool isFuture,
    required Color selectedColor,
    required Color todayColor,
    required Color todayTextColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 180 + (day * 12).clamp(0, 280)),
        builder: (_, v, child) => Opacity(opacity: v, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? selectedColor
                : isToday
                    ? todayColor
                    : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: selectedColor.withValues(alpha: 0.40),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ]
                : [],
          ),
          child: Center(
              child: Text('$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isFuture
                            ? BC.border
                            : isToday
                                ? todayTextColor
                                : BC.textDark,
                  ))),
        ),
      ),
    );
  }

  Widget _selectedDisplay(
      {required String icon,
      required String label,
      required Color bg,
      required Color textColor}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(
              offset: Offset(0, (1 - v) * 10), child: child)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [bg, bg.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withValues(alpha: 0.25)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 0.3))),
        ]),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BC.border),
          boxShadow: [
            BoxShadow(
                color: BC.primary.withValues(alpha: 0.08), blurRadius: 4)
          ],
        ),
        child: Icon(icon, size: 20, color: BC.primaryDeep),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

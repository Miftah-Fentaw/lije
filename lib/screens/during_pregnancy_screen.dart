import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lije/models/models.dart';
import 'package:lije/screens/screens.dart' show LijeLogo;

// ─────────────────────────────────────────────────────────────────────────────
// LOCAL DESIGN TOKENS  (mapped to app theme)
// ─────────────────────────────────────────────────────────────────────────────
abstract class _B {
  static const navy = C.darkBlue;
  static const deep = C.darkBlue;
  static const mid = C.darkBlue;
  static const bright = C.darkBlue;
  static const vivid = C.darkBlue;
  static const soft = C.lightBlue;
  static const pale = C.lightBlue;
  static const frost = C.lightBlue;

  static const textDark = C.darkBlue;
  static const textMid = C.darkBlue;
  static const textLight = C.textLight;

  static const success = C.success;
  static const successBg = C.successBg;
  static const warn = C.warn;
  static const warnBg = C.warnBg;
  static const purple = C.purple;
  static const purpleBg = C.purpleBg;

  static const border = C.lightBlue;

  static const List<Color> headerGrad = [C.darkBlue, C.darkBlue];
  static const List<Color> heroGrad = [C.darkBlue, C.darkBlue];
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCALIZED STRINGS  (week screen only; uses shared AppLang)
// ─────────────────────────────────────────────────────────────────────────────
class _S {
  static String t(AppLang l, String k) =>
      (_db[l] ?? _db[AppLang.english]!)[k] ?? _db[AppLang.english]![k] ?? k;

  static final Map<AppLang, Map<String, String>> _db = {
    AppLang.english: {
      'screenTitle': 'My Pregnancy',
      'setStart': 'Set Start Date',
      'startDate': 'Pregnancy Start Date',
      'startDesc':
          'Enter the first day of your pregnancy. We\'ll track your baby\'s growth week by week.',
      'startBtn': 'Start Tracking',
      'edit': 'Edit',
      'week': 'Week',
      'days': 'Days',
      'progress': 'Progress',
      'dueDate': 'Due Date',
      'trimester': 'Trimester',
      'trim1': '1st Trimester',
      'trim2': '2nd Trimester',
      'trim3': '3rd Trimester',
      'tabWeek': 'This Week',
      'tabTimeline': 'Timeline',
      'tabChecklist': 'Checklist',
      'babyDev': "Baby's Development",
      'momTip': 'Tips for You',
      'warning': 'Watch For',
      'nutrition': 'Nutrition',
      'appointments': 'Appointments',
      'checklist': "This Week's Tasks",
      'length': 'Length',
      'weight': 'Weight',
      'size': 'Size of',
      'milestone': 'Milestone',
      'selectDate': 'Select Date',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'gregorian': 'Gregorian',
      'ethiopian': 'Ethiopian',
      'month': 'Month',
      'year': 'Year',
      'day': 'Day',
      'symptoms': "Today's Symptoms",
      'tapSymptom': 'Tap to log a symptom',
      'nausea': 'Nausea',
      'fatigue': 'Fatigue',
      'swelling': 'Swelling',
      'backPain': 'Back Pain',
      'heartburn': 'Heartburn',
      'breathless': 'Breathless',
      'weekBrowse': 'Browse Weeks',
      'daysLeft': 'days left',
    },
    AppLang.amharic: {
      'screenTitle': 'ማህፀኔ',
      'setStart': 'የጀመሪያ ቀን ያስፍሩ',
      'startDate': 'የእርግዝና መጀመሪያ ቀን',
      'startDesc': 'እርግዝናዎ የጀመረበትን ቀን ያስፍሩ። ሳምንት በሳምንት እንከታተላለን።',
      'startBtn': 'መከታተል ጀምሩ',
      'edit': 'ያርትዑ',
      'week': 'ሳምንት',
      'days': 'ቀናት',
      'progress': 'ሂደት',
      'dueDate': 'የወሊድ ቀን',
      'trimester': 'ትሪሜስተር',
      'trim1': '1ኛ ትሪሜስተር',
      'trim2': '2ኛ ትሪሜስተር',
      'trim3': '3ኛ ትሪሜስተር',
      'tabWeek': 'ይህ ሳምንት',
      'tabTimeline': 'ሁሉም',
      'tabChecklist': 'ዝርዝር',
      'babyDev': 'የሕፃን እድገት',
      'momTip': 'ምክር',
      'warning': 'ምልክቶች',
      'nutrition': 'አመጋገብ',
      'appointments': 'ቀጠሮዎች',
      'checklist': 'የዚህ ሳምንት ተግባሮች',
      'length': 'ርዝመት',
      'weight': 'ክብደት',
      'size': 'ያህል',
      'milestone': 'ምዕራፍ',
      'selectDate': 'ቀን ይምረጡ',
      'confirm': 'አረጋግጥ',
      'cancel': 'ሰርዝ',
      'gregorian': 'ጎርጎርሳዊ',
      'ethiopian': 'ኢትዮጵያዊ',
      'month': 'ወር',
      'year': 'ዓ.ም',
      'day': 'ቀን',
      'symptoms': 'ዛሬ ምልክቶች',
      'tapSymptom': 'ምልክት ለማስፈር ይጫኑ',
      'nausea': 'ማቅለሽ',
      'fatigue': 'ድካም',
      'swelling': 'ማበጥ',
      'backPain': 'ጀርባ ምታት',
      'heartburn': 'ቃጠሎ',
      'breathless': 'ትንፋሽ',
      'weekBrowse': 'ሳምንት ዳስስ',
      'daysLeft': 'ቀናት ቀርቷቸዋሉ',
    },
    AppLang.oromic: {
      'screenTitle': 'Ulfaa Koo',
      'setStart': 'Guyyaa Jalqabaa Galchi',
      'startDate': 'Guyyaa Ulfaan Jalqabe',
      'startDesc':
          'Guyyaa ulfaan itti jalqabe galchi. Torbaan torbaan ni hordofna.',
      'startBtn': 'Hordoffii Jalqabi',
      'edit': 'Gulaali',
      'week': 'Torban',
      'days': 'Guyyoota',
      'progress': 'Guddinni',
      'dueDate': "Guyyaa Da'umsaa",
      'trimester': 'Gilgaala',
      'trim1': 'Gilgaala 1ffaa',
      'trim2': 'Gilgaala 2ffaa',
      'trim3': 'Gilgaala 3ffaa',
      'tabWeek': 'Torban Kana',
      'tabTimeline': 'Hunda',
      'tabChecklist': 'Tarreeffama',
      'babyDev': "Guddina Daa'immaa",
      'momTip': 'Gorsa',
      'warning': 'Mallattoo',
      'nutrition': 'Nyaata',
      'appointments': 'Beellama',
      'checklist': 'Hojiiwwan Torbanaa',
      'length': 'Dheerina',
      'weight': 'Ulfina',
      'size': 'Hangana',
      'milestone': "Milkaa'ina",
      'selectDate': 'Guyyaa Filadhu',
      'confirm': 'Mirkaneessi',
      'cancel': 'Haquu',
      'gregorian': 'Gregorian',
      'ethiopian': 'Itoophiyaa',
      'month': "Ji'a",
      'year': 'Waggaa',
      'day': 'Guyyaa',
      'symptoms': "Mallattoo Har'aa",
      'tapSymptom': 'Mallattoo galchuuf tuqi',
      'nausea': 'Dhukkubbii Garaa',
      'fatigue': 'Dadhabina',
      'swelling': 'Boburuu',
      'backPain': 'Dhukkubbii Dugdaa',
      'heartburn': 'Onnaee Gubaa',
      'breathless': 'Hafuura Gabaabaa',
      'weekBrowse': 'Torban Daaqi',
      'daysLeft': 'guyyoota hafe',
      
    },
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// BUBBLE PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _BubblePainter extends CustomPainter {
  final double t;
  _BubblePainter(this.t);
  @override
  void paint(Canvas c, Size s) {
    final pts = [
      [.08, .10, 55.0, .06],
      [.88, .07, 70.0, .04],
      [.25, .82, 48.0, .07],
      [.72, .58, 90.0, .03],
      [.52, .18, 38.0, .08],
      [.13, .65, 62.0, .05],
    ];
    for (int i = 0; i < pts.length; i++) {
      final p = pts[i];
      final dx = math.cos(t * math.pi * 2 + i) * 7.0;
      final dy = math.sin(t * math.pi * 2 + i * .75) * 12.0;
      c.drawCircle(
        Offset(
            s.width * (p[0] as double) + dx, s.height * (p[1] as double) + dy),
        p[2] as double,
        Paint()..color = _B.soft.withOpacity(p[3] as double),
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter o) => o.t != t;
}

// ─────────────────────────────────────────────────────────────────────────────
// DATE PICKER DIALOG  (Gregorian + Ethiopian toggle)
// ─────────────────────────────────────────────────────────────────────────────
class _PickerDialog extends StatefulWidget {
  final DateTime? initial;
  final AppLang lang;
  const _PickerDialog({this.initial, required this.lang});
  @override
  State<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends State<_PickerDialog>
    with TickerProviderStateMixin {
  bool _eth = false;
  late int gy, gm, gd, ey, em, ed;
  late AnimationController _inCtrl, _shimCtrl;
  late Animation<double> _fade, _shimA;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final d =
        widget.initial ?? DateTime.now().subtract(const Duration(days: 60));
    gy = d.year;
    gm = d.month;
    gd = d.day;
    final e = EthCal.fromGregorian(d);
    ey = e['y']!;
    em = e['m']!;
    ed = e['d']!;
    _inCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480))
      ..forward();
    _shimCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _fade = CurvedAnimation(parent: _inCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, .18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _inCtrl, curve: Curves.easeOutCubic));
    _shimA = CurvedAnimation(parent: _shimCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _inCtrl.dispose();
    _shimCtrl.dispose();
    super.dispose();
  }

  String _t(String k) => _S.t(widget.lang, k);
  int get _maxGDay => DateTime(gy, gm + 1, 0).day;

  void _ethToGreg() {
    final days = EthCal.daysInMonth(ey, em);
    ed = ed.clamp(1, days);
    final g = EthCal.toGregorian(ey, em, ed);
    gy = g.year;
    gm = g.month;
    gd = g.day;
  }

  void _gregToEth() {
    gd = gd.clamp(1, _maxGDay);
    final e = EthCal.fromGregorian(DateTime(gy, gm, gd));
    ey = e['y']!;
    em = e['m']!;
    ed = e['d']!;
  }

  DateTime get _result => _eth
      ? EthCal.toGregorian(ey, em, ed.clamp(1, EthCal.daysInMonth(ey, em)))
      : DateTime(gy, gm, gd.clamp(1, _maxGDay));

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: _B.navy.withOpacity(.25),
                      blurRadius: 40,
                      offset: const Offset(0, 16))
                ],
              ),
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                _dialogHeader(),
                _dialogToggle(),
                _dialogBody(), 
                _dialogActions(),
              ])),
            ),
          ),
        ),
      );

  Widget _dialogHeader() {
    const mNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final ethMonths =
        widget.lang == AppLang.amharic ? EthCal.monthsAm : EthCal.monthsEn;
    final label =
        _eth ? '$ed ${ethMonths[em - 1]} $ey' : '$gd ${mNames[gm - 1]} $gy';
    return AnimatedBuilder(
      animation: _shimA,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.lerp(_B.navy, _B.deep, _shimA.value * .3)!,
            Color.lerp(_B.deep, _B.mid, _shimA.value * .4)!,
            Color.lerp(_B.mid, _B.vivid, _shimA.value * .5)!,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('🗓️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(_t('selectDate'),
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 10),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: Text(label,
                  key: ValueKey(label),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.4))),
        ]),
      ),
    );
  }

  Widget _dialogToggle() => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
              color: _B.frost,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _B.border)),
          child: LayoutBuilder(builder: (_, c) {
            final half = c.maxWidth / 2;
            return Stack(children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                left: _eth ? half : 0,
                top: 0,
                bottom: 0,
                width: half,
                child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(colors: [_B.deep, _B.vivid]),
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                              color: _B.mid.withOpacity(.35), blurRadius: 8)
                        ])),
              ),
              Row(children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (_eth) setState(() => _eth = false);
                        },
                        child: Center(
                            child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                    color: !_eth ? Colors.white : _B.deep,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                child: Text(_t('gregorian')))))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (!_eth)
                            setState(() {
                              _eth = true;
                              _gregToEth();
                            });
                        },
                        child: Center(
                            child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                    color: _eth ? Colors.white : _B.deep,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                child: Text(_t('ethiopian')))))),
              ]),
            ]);
          }),
        ),
      );

  Widget _dialogBody() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, a) =>
            FadeTransition(opacity: a, child: child),
        child: _eth
            ? _ethPicker(key: const ValueKey('e'))
            : _gregPicker(key: const ValueKey('g')),
      );

  Widget _gregPicker({Key? key}) {
    const mNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
      child: Column(children: [
        _pickerLabel(_t('month')),
        const SizedBox(height: 8),
        _monthGrid(
            count: 12,
            nameOf: (i) => mNames[i],
            selected: gm - 1,
            onPick: (i) => setState(() {
                  gm = i + 1;
                  if (gd > _maxGDay) gd = _maxGDay;
                  _gregToEth();
                }),
            cols: 4),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _spinner(
                  _t('year'),
                  gy,
                  DateTime.now().year - 2,
                  DateTime.now().year,
                  (v) => setState(() {
                        gy = v;
                        _gregToEth();
                      }))),
          const SizedBox(width: 10),
          Expanded(
              child: _spinner(
                  _t('day'),
                  gd,
                  1,
                  _maxGDay,
                  (v) => setState(() {
                        gd = v;
                        _gregToEth();
                      }))),
        ]),
        const SizedBox(height: 6),
      ]),
    );
  }

  Widget _ethPicker({Key? key}) {
    final names =
        widget.lang == AppLang.amharic ? EthCal.monthsAm : EthCal.monthsEn;
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
      child: Column(children: [
        _pickerLabel(_t('month')),
        const SizedBox(height: 8),
        _monthGrid(
            count: 13,
            nameOf: (i) => names[i],
            selected: em - 1,
            onPick: (i) => setState(() {
                  em = i + 1;
                  ed = ed.clamp(1, EthCal.daysInMonth(ey, em));
                  _ethToGreg();
                }),
            cols: 4),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _spinner(
                  _t('year'),
                  ey,
                  DateTime.now().year - 4,
                  DateTime.now().year,
                  (v) => setState(() {
                        ey = v;
                        _ethToGreg();
                      }))),
          const SizedBox(width: 10),
          Expanded(
              child: _spinner(
                  _t('day'),
                  ed,
                  1,
                  EthCal.daysInMonth(ey, em),
                  (v) => setState(() {
                        ed = v;
                        _ethToGreg();
                      }))),
        ]),
        const SizedBox(height: 6),
      ]),
    );
  }

  Widget _pickerLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: _B.deep,
                letterSpacing: 1.4)),
      );

  Widget _monthGrid(
          {required int count,
          required String Function(int) nameOf,
          required int selected,
          required void Function(int) onPick,
          required int cols}) =>
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: count == 13 ? 2.1 : 2.4),
        itemCount: count,
        itemBuilder: (_, i) {
          final sel = selected == i;
          return GestureDetector(
            onTap: () {
              onPick(i);
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                gradient: sel
                    ? const LinearGradient(colors: [_B.deep, _B.vivid])
                    : null,
                color: sel ? null : _B.frost,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: sel ? _B.vivid : _B.border.withOpacity(.7)),
                boxShadow: sel
                    ? [BoxShadow(color: _B.mid.withOpacity(.3), blurRadius: 6)]
                    : null,
              ),
              child: Center(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(nameOf(i),
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: sel ? Colors.white : _B.deep))))),
            ),
          );
        },
      );

  Widget _spinner(
          String label, int val, int min, int max, ValueChanged<int> cb) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
            color: _B.frost,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _B.border)),
        child: Column(children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _B.mid,
                  letterSpacing: 1.1)),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _spinBtn(Icons.remove_rounded, () {
              if (val > min) cb(val - 1);
            }),
            Expanded(
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (c, a) =>
                        ScaleTransition(scale: a, child: c),
                    child: Text('$val',
                        key: ValueKey(val),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _B.deep)))),
            _spinBtn(Icons.add_rounded, () {
              if (val < max) cb(val + 1);
            }),
          ]),
        ]),
      );

  Widget _spinBtn(IconData icon, VoidCallback tap) => GestureDetector(
        onTap: tap,
        child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_B.deep, _B.vivid]),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(color: _B.mid.withOpacity(.3), blurRadius: 5)
                ]),
            child: Icon(icon, color: Colors.white, size: 14)),
      );

  Widget _dialogActions() => Padding(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 22),
        child: Row(children: [
          Expanded(
              child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: _B.frost,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _B.border)),
                child: Center(
                    child: Text(_t('cancel'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: _B.deep)))),
          )),
          const SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => Navigator.pop(context, _result),
                child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_B.navy, _B.deep, _B.mid, _B.vivid]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: _B.mid.withOpacity(.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6))
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 17),
                          const SizedBox(width: 7),
                          Text(_t('confirm'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 14)),
                        ])),
              )),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DURING PREGNANCY SCREEN  —  main widget
// ─────────────────────────────────────────────────────────────────────────────
class DuringPregnancyScreen extends StatefulWidget {
  const DuringPregnancyScreen({super.key});
  @override
  State<DuringPregnancyScreen> createState() => _DPSState();
}

class _DPSState extends State<DuringPregnancyScreen>
    with TickerProviderStateMixin {
  DateTime? _start;
  DateTime? _edd;
  int _weeks = 1, _days = 0;
  bool _hasDate = false;
  int _weekIdx = 0, _tab = 0;

  late AnimationController _bubCtrl, _fadeCtrl, _slideCtrl, _pulseCtrl;
  late Animation<double> _fade, _pulse;
  late Animation<Offset> _slide;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() => _tab = _tabCtrl.index));
    _bubCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 9))
          ..repeat();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, .06), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 1.0, end: 1.055)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bubCtrl.dispose();
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  AppLang get _lang => langNotifier.value;
  String _t(String k) => _S.t(_lang, k);

  void _calc() {
    if (_start == null) return;
    final diff = DateTime.now().difference(_start!).inDays;
    _weeks = (diff ~/ 7).clamp(1, 40);
    _days = diff % 7;
    _edd = _start!.add(const Duration(days: 266));
    _weekIdx = WeekRegistry.idxForWeek(_weeks);
  }

  Future<void> _pickDate() async {
    final r = await showDialog<DateTime>(
      context: context,
      barrierColor: _B.navy.withOpacity(.50),
      builder: (_) => _PickerDialog(initial: _start, lang: _lang),
    );
    if (r != null) {
      setState(() {
        _start = r;
        _hasDate = true;
        _calc();
      });
      _fadeCtrl.reset();
      _slideCtrl.reset();
      _fadeCtrl.forward();
      _slideCtrl.forward();
      HapticFeedback.mediumImpact();
    }
  }

  int get _trimester => _weeks < 14
      ? 1
      : _weeks < 27
          ? 2
          : 3;
  String get _trimLabel =>
      [_t('trim1'), _t('trim2'), _t('trim3')][_trimester - 1];
  double get _progress => ((_weeks * 7 + _days) / 266.0).clamp(0.0, 1.0);
  int get _daysLeft =>
      _edd != null ? _edd!.difference(DateTime.now()).inDays.clamp(0, 999) : 0;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<AppLang>(
        valueListenable: langNotifier,
        builder: (_, __, ___) => Scaffold(
          backgroundColor: C.bgPage,
          body: Stack(children: [
            // Animated background bubbles
            Positioned.fill(
                child: AnimatedBuilder(
                    animation: _bubCtrl,
                    builder: (_, __) =>
                        CustomPaint(painter: _BubblePainter(_bubCtrl.value)))),
            SafeArea(
                child: Column(children: [
              _topBar(),
              Expanded(child: _hasDate ? _mainContent() : _heroSetup()),
            ])),
          ]),
        ),
      );

  // ── TOP BAR ────────────────────────────────────────────────────────────────
  Widget _topBar() => Container(
        decoration: BoxDecoration(
          color: _B.navy,
          boxShadow: [
            BoxShadow(
                color: _B.navy.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 14, 14),
              child: Row(children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints()),
                const LijeLogo(size: 36),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(_t('screenTitle'),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      if (_hasDate)
                        Text('$_trimLabel  •  ${_t('week')} $_weeks+$_days',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white60),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                    ])),
                if (_hasDate)
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(11)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.edit_calendar_rounded,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(_t('edit'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
              ]),
            )),
      );

  // ── HERO SETUP (no date yet) ───────────────────────────────────────────────
  Widget _heroSetup() => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(children: [
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) =>
                Transform.scale(scale: _pulse.value, child: child),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                    colors: [_B.pale, _B.soft, _B.vivid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                      color: _B.mid.withOpacity(.28),
                      blurRadius: 45,
                      offset: const Offset(0, 18))
                ],
              ),
              child: const Center(
                  child: Text('🤰', style: TextStyle(fontSize: 76))),
            ),
          ),
          const SizedBox(height: 28),
          Text(_t('setStart'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _B.navy,
                  height: 1.2,
                  letterSpacing: -.4)),
          const SizedBox(height: 10),
          Text(_t('startDesc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: _B.textMid, height: 1.65)),
          const SizedBox(height: 24),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _heroPill('👶', _t('babyDev')),
                _heroPill('💡', _t('momTip')),
                _heroPill('✅', _t('tabChecklist')),
                _heroPill('🥗', _t('nutrition')),
                _heroPill('🗓️', _t('appointments')),
                _heroPill('⚠️', _t('warning')),
              ]),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: _B.heroGrad),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: _B.mid.withOpacity(.45),
                      blurRadius: 26,
                      offset: const Offset(0, 10))
                ],
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white, size: 19),
                const SizedBox(width: 10),
                Flexible(
                    child: Text(_t('startBtn'),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white))),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white60, size: 17),
              ]),
            ),
          ),
        ]),
      );

  Widget _heroPill(String emoji, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: _B.border),
          boxShadow: [BoxShadow(color: _B.mid.withOpacity(.06), blurRadius: 7)],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _B.textDark)),
        ]),
      );

  // ── MAIN CONTENT (date set) ────────────────────────────────────────────────
  Widget _mainContent() {
    final wd = WeekRegistry.data[_weekIdx];
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(children: [
          _tabBar(),
          Expanded(
              child: TabBarView(controller: _tabCtrl, children: [
            _thisWeekTab(wd),
            _timelineTab(),
            _checklistTab(wd),
          ])),
        ]),
      ),
    );
  }

  Widget _tabBar() => Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: _B.border),
          boxShadow: [
            BoxShadow(
                color: _B.mid.withOpacity(.07),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: TabBar(
          controller: _tabCtrl,
          labelColor: Colors.white,
          unselectedLabelColor: _B.textMid,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [_B.deep, _B.mid, _B.vivid]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: _B.mid.withOpacity(.38), blurRadius: 7)
              ]),
          labelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          unselectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: _t('tabWeek')),
            Tab(text: _t('tabTimeline')),
            Tab(text: _t('tabChecklist'))
          ],
        ),
      );

  // ── THIS WEEK TAB ──────────────────────────────────────────────────────────
  Widget _thisWeekTab(WeekData wd) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        physics: const BouncingScrollPhysics(),
        children: [
          _progressCard(wd),
          const SizedBox(height: 13),
          _weekScrubber(),
          const SizedBox(height: 13),
          _devCard(wd),
          const SizedBox(height: 11),
          _tipCard(wd),
          const SizedBox(height: 11),
          _warnCard(wd),
          const SizedBox(height: 11),
          _symptomsCard(),
        ],
      );

  // ── PROGRESS CARD ──────────────────────────────────────────────────────────
  Widget _progressCard(WeekData wd) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _B.navy,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _B.pale),
          boxShadow: [
            BoxShadow(
                color: _B.navy.withOpacity(.12),
                blurRadius: 16,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text('⭐ $_trimLabel',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                  const SizedBox(height: 9),
                  Text(wd.title[_lang] ?? wd.title[AppLang.english]!,
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -.2),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  const SizedBox(height: 4),
                  Text('${_t('week')} $_weeks + $_days ${_t('days')}',
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  if (_edd != null) ...[
                    const SizedBox(height: 3),
                    Text(
                        '${_t('dueDate')}: ${_edd!.day}/${_edd!.month}/${_edd!.year}  ·  $_daysLeft ${_t('daysLeft')}',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ])),
            const SizedBox(width: 10),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.18),
                  border: Border.all(
                      color: Colors.white.withOpacity(.28), width: 2)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(wd.emoji, style: const TextStyle(fontSize: 28)),
                    Text('W$_weeks',
                        style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_t('progress'),
                style: const TextStyle(fontSize: 10, color: Colors.white60)),
            Text('${(_progress * 100).round()}%  (${_t('week')} $_weeks / 38)',
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ]),
          const SizedBox(height: 7),
          LayoutBuilder(
              builder: (_, c) => Stack(children: [
                    Container(
                        height: 8,
                        width: c.maxWidth,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius: BorderRadius.circular(8))),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        height: 8,
                        width: c.maxWidth * _progress,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFCAF0F8)]),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(.55),
                                  blurRadius: 6)
                            ])),
                  ])),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _progStat('📏', _t('length'), wd.length),
            Container(
                width: 1, height: 32, color: Colors.white.withOpacity(.2)),
            _progStat('⚖️', _t('weight'), wd.weight),
            Container(
                width: 1, height: 32, color: Colors.white.withOpacity(.2)),
            _progStat(wd.emoji, _t('size'), wd.fruit),
          ]),
        ]),
      );

  Widget _progStat(String e, String l, String v) => Flexible(
          child: Column(children: [
        Text(e, style: const TextStyle(fontSize: 19)),
        const SizedBox(height: 2),
        Text(l,
            style: const TextStyle(fontSize: 8, color: Colors.white54),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
        Text(v,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center),
      ]));

  // ── WEEK SCRUBBER ──────────────────────────────────────────────────────────
  Widget _weekScrubber() => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _B.border),
            boxShadow: [
              BoxShadow(color: _B.mid.withOpacity(.05), blurRadius: 9)
            ]),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
                child: Text(_t('weekBrowse'),
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _B.textDark),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1)),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_B.deep, _B.vivid]),
                    borderRadius: BorderRadius.circular(9)),
                child: Text('W${WeekRegistry.data[_weekIdx].week}',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 9),
          SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: WeekRegistry.data.length,
                itemBuilder: (_, i) {
                  final w = WeekRegistry.data[i];
                  final sel = i == _weekIdx;
                  final cur = _weeks >= w.week &&
                      (i == WeekRegistry.data.length - 1 ||
                          _weeks < WeekRegistry.data[i + 1].week);
                  return GestureDetector(
                    onTap: () {
                      setState(() => _weekIdx = i);
                      HapticFeedback.selectionClick();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 7),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: sel
                            ? const LinearGradient(colors: [_B.deep, _B.vivid])
                            : null,
                        color: sel
                            ? null
                            : cur
                                ? const Color(0xFFD0F0FF)
                                : _B.frost,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                            color: sel
                                ? _B.vivid
                                : cur
                                    ? _B.vivid.withOpacity(.4)
                                    : _B.border),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                    color: _B.mid.withOpacity(.32),
                                    blurRadius: 7)
                              ]
                            : null,
                      ),
                      child: Text('W${w.week}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: sel
                                  ? Colors.white
                                  : cur
                                      ? _B.deep
                                      : _B.textMid)),
                    ),
                  );
                },
              )),
        ]),
      );

  // ── DEV CARD ───────────────────────────────────────────────────────────────
  Widget _devCard(WeekData wd) => _card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7)]),
                borderRadius: BorderRadius.circular(13)),
            child: Text(wd.emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 11),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_t('babyDev'),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _B.textDark),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Text('${_t('week')} ${wd.week} · ${wd.fruit}',
                    style: const TextStyle(fontSize: 10, color: _B.textMid),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ])),
          _tag(wd.milestone),
        ]),
        const SizedBox(height: 11),
        Divider(color: _B.border.withOpacity(.6), height: 1),
        const SizedBox(height: 11),
        Text(wd.dev[_lang] ?? wd.dev[AppLang.english]!,
            style:
                const TextStyle(fontSize: 13, color: _B.textMid, height: 1.65),
            overflow: TextOverflow.ellipsis,
            maxLines: 6),
        const SizedBox(height: 13),
        Row(children: [
          Expanded(child: _miniStat('📏', _t('length'), wd.length)),
          const SizedBox(width: 7),
          Expanded(child: _miniStat('⚖️', _t('weight'), wd.weight)),
          const SizedBox(width: 7),
          Expanded(child: _miniStat(wd.emoji, _t('size'), wd.size)),
        ]),
      ]));

  // ── TIP CARD ───────────────────────────────────────────────────────────────
  Widget _tipCard(WeekData wd) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Colors.white]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _B.bright.withOpacity(.22)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                      color: _B.bright.withOpacity(.12),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text('💡  Tip',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0369A1))),
                ),
                const SizedBox(height: 9),
                Text(wd.tip[_lang] ?? wd.tip[AppLang.english]!,
                    style: const TextStyle(
                        fontSize: 12.5, color: _B.textDark, height: 1.6),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5),
              ])),
          const SizedBox(width: 8),
          const Text('🌿', style: TextStyle(fontSize: 36)),
        ]),
      );

  // ── WARN CARD ──────────────────────────────────────────────────────────────
  Widget _warnCard(WeekData wd) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _B.warnBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _B.warn.withOpacity(.30)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                      color: _B.warn.withOpacity(.12),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text('⚠️  Watch For',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFD97706))),
                ),
                const SizedBox(height: 9),
                Text(wd.warn[_lang] ?? wd.warn[AppLang.english]!,
                    style: const TextStyle(
                        fontSize: 12.5, color: _B.textDark, height: 1.6),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5),
              ])),
          const SizedBox(width: 8),
          const Text('⚠️', style: TextStyle(fontSize: 34)),
        ]),
      );

  // ── SYMPTOMS CARD ──────────────────────────────────────────────────────────
  Widget _symptomsCard() {
    final symptoms = [
      ('🤢', _t('nausea')),
      ('😴', _t('fatigue')),
      ('💧', _t('swelling')),
      ('🔙', _t('backPain')),
      ('💓', _t('heartburn')),
      ('😮‍💨', _t('breathless')),
    ];
    return _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFBAE6FD), Color(0xFF38BDF8)]),
              borderRadius: BorderRadius.circular(11)),
          child: const Text('📊', style: TextStyle(fontSize: 19)),
        ),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_t('symptoms'),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _B.textDark),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
          Text(_t('tapSymptom'),
              style: const TextStyle(fontSize: 10, color: _B.textMid),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ])),
      ]),
      const SizedBox(height: 11),
      Wrap(
          spacing: 7,
          runSpacing: 7,
          children:
              symptoms.map((s) => _SymChip(emoji: s.$1, label: s.$2)).toList()),
    ]));
  }

  // ── TIMELINE TAB ───────────────────────────────────────────────────────────
  Widget _timelineTab() => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        physics: const BouncingScrollPhysics(),
        itemCount: WeekRegistry.data.length,
        itemBuilder: (_, i) {
          final w = WeekRegistry.data[i];
          final done = _weeks > w.week;
          final cur = i == WeekRegistry.idxForWeek(_weeks);
          final future = _weeks < w.week;
          final dot = done
              ? _B.bright
              : cur
                  ? _B.mid
                  : _B.border;
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 42,
                child: Column(children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: cur
                          ? const LinearGradient(colors: [_B.deep, _B.vivid])
                          : null,
                      color: cur ? null : dot.withOpacity(done ? .14 : .09),
                      border: Border.all(color: dot, width: cur ? 2.5 : 1.5),
                      boxShadow: cur
                          ? [
                              BoxShadow(
                                  color: _B.mid.withOpacity(.38), blurRadius: 9)
                            ]
                          : null,
                    ),
                    child: Center(
                        child: done
                            ? Icon(Icons.check_rounded,
                                size: 13, color: _B.bright)
                            : cur
                                ? const Text('🤰',
                                    style: TextStyle(fontSize: 12))
                                : Text('${w.week}',
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: dot))),
                  ),
                  if (i < WeekRegistry.data.length - 1)
                    Container(
                        width: 2, height: 50, color: dot.withOpacity(.22)),
                ])),
            const SizedBox(width: 9),
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() => _weekIdx = i);
                _tabCtrl.animateTo(0);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: cur
                      ? const LinearGradient(
                          colors: [Color(0xFFE0F7FF), Color(0xFFF0FBFF)])
                      : null,
                  color: cur ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: cur ? _B.border : _B.border.withOpacity(.5)),
                  boxShadow: cur
                      ? [
                          BoxShadow(
                              color: _B.mid.withOpacity(.09), blurRadius: 9)
                        ]
                      : null,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(w.emoji, style: const TextStyle(fontSize: 17)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(w.title[_lang] ?? w.title[AppLang.english]!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          future ? _B.textLight : _B.textDark)),
                              Text(
                                  '${_t('week')} ${w.week} · ${w.fruit} · ${w.weight}',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color:
                                          future ? _B.textLight : _B.textMid),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            ])),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: dot.withOpacity(.12),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(w.milestone,
                              style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  color: dot),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                      ]),
                      if (!future) ...[
                        const SizedBox(height: 5),
                        Builder(builder: (_) {
                          final full = w.dev[_lang] ?? w.dev[AppLang.english]!;
                          final snippet = full.length > 80
                              ? '${full.substring(0, 80)}…'
                              : full;
                          return Text(snippet,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: _B.textMid,
                                  height: 1.45),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis);
                        }),
                      ],
                    ]),
              ),
            )),
          ]);
        },
      );

  // ── CHECKLIST TAB ──────────────────────────────────────────────────────────
  Widget _checklistTab(WeekData wd) {
    final todos = wd.todos[_lang] ?? wd.todos[AppLang.english]!;
    final nutri = wd.nutrition[_lang] ?? wd.nutrition[AppLang.english]!;
    final appts = wd.appts[_lang] ?? wd.appts[AppLang.english]!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      physics: const BouncingScrollPhysics(),
      children: [
        _weekScrubber(),
        const SizedBox(height: 13),
        // Header banner
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: _B.heroGrad),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: _B.navy.withOpacity(.28),
                  blurRadius: 16,
                  offset: const Offset(0, 7))
            ],
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(11)),
              child: Text(wd.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 11),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(_t('checklist'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  Text('${_t('week')} ${wd.week} · ${wd.milestone}',
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white60),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                ])),
          ]),
        ),
        const SizedBox(height: 11),
        ...todos
            .asMap()
            .entries
            .map((e) => _CheckItem(text: e.value, idx: e.key)),
        const SizedBox(height: 14),
        // Nutrition
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _B.soft.withOpacity(.45)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFB2EBF2), Color(0xFF80DEEA)]),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text('🥗', style: TextStyle(fontSize: 19)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_t('nutrition'),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _B.textDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text('${_t('week')} ${wd.week}',
                        style: const TextStyle(fontSize: 10, color: _B.textMid),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ])),
            ]),
            const SizedBox(height: 11),
            ...nutri.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                                gradient:
                                    LinearGradient(colors: [_B.deep, _B.vivid]),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 9)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(tip,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: _B.textDark,
                                    height: 1.45))),
                      ]),
                )),
          ]),
        ),
        const SizedBox(height: 11),
        // Appointments
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _B.purpleBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _B.purple.withOpacity(.18)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: _B.purple.withOpacity(.11),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text('🗓️', style: TextStyle(fontSize: 19)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_t('appointments'),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _B.textDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text('${_t('week')} ${wd.week}',
                        style: const TextStyle(fontSize: 10, color: _B.textMid),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ])),
            ]),
            const SizedBox(height: 11),
            ...appts.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: _B.purple)),
                        const SizedBox(width: 9),
                        Expanded(
                            child: Text(a,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: _B.textMid,
                                    height: 1.4))),
                      ]),
                )),
          ]),
        ),
      ],
    );
  }

  // ── HELPER WIDGETS ─────────────────────────────────────────────────────────
  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _B.border),
          boxShadow: [
            BoxShadow(
                color: _B.mid.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: child,
      );

  Widget _tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_B.deep, _B.vivid]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: _B.mid.withOpacity(.28), blurRadius: 5)],
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 8, color: Colors.white, fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      );

  Widget _miniStat(String e, String l, String v) => Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
        decoration: BoxDecoration(
            color: _B.frost,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: _B.border.withOpacity(.7))),
        child: Column(children: [
          Text(e, style: const TextStyle(fontSize: 17)),
          const SizedBox(height: 2),
          Text(l,
              style: const TextStyle(fontSize: 8, color: _B.textMid),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
          Text(v,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _B.textDark),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// SYMPTOM CHIP
// ─────────────────────────────────────────────────────────────────────────────
class _SymChip extends StatefulWidget {
  final String emoji, label;
  const _SymChip({required this.emoji, required this.label});
  @override
  State<_SymChip> createState() => _SymChipState();
}

class _SymChipState extends State<_SymChip>
    with SingleTickerProviderStateMixin {
  bool _on = false;
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 160));
    _s = Tween<double>(begin: 1, end: .93)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) => GestureDetector(
        onTapDown: (_) => _c.forward(),
        onTapCancel: () => _c.reverse(),
        onTapUp: (_) {
          _c.reverse();
          setState(() => _on = !_on);
          HapticFeedback.selectionClick();
        },
        child: ScaleTransition(
          scale: _s,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              gradient: _on
                  ? const LinearGradient(colors: [_B.deep, _B.vivid])
                  : null,
              color: _on ? null : _B.frost,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: _on ? _B.vivid : _B.border),
              boxShadow: _on
                  ? [BoxShadow(color: _B.mid.withOpacity(.28), blurRadius: 7)]
                  : null,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _on ? Colors.white : _B.textMid)),
            ]),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// CHECKLIST ITEM
// ─────────────────────────────────────────────────────────────────────────────
class _CheckItem extends StatefulWidget {
  final String text;
  final int idx;
  const _CheckItem({required this.text, required this.idx});
  @override
  State<_CheckItem> createState() => _CheckItemState();
}

class _CheckItemState extends State<_CheckItem>
    with SingleTickerProviderStateMixin {
  bool _done = false;
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 160));
    _s = Tween<double>(begin: 1, end: .97)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) => GestureDetector(
        onTapDown: (_) => _c.forward(),
        onTapCancel: () => _c.reverse(),
        onTapUp: (_) {
          _c.reverse();
          setState(() => _done = !_done);
          HapticFeedback.lightImpact();
        },
        child: ScaleTransition(
          scale: _s,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 210),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _done ? const Color(0xFFE0F7FF) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: _done ? _B.vivid.withOpacity(.38) : _B.border),
              boxShadow: [
                BoxShadow(
                    color: _B.mid.withOpacity(_done ? .07 : .03), blurRadius: 7)
              ],
            ),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: _done
                      ? const LinearGradient(colors: [_B.deep, _B.vivid])
                      : null,
                  color: _done ? null : Colors.transparent,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: _done ? _B.vivid : _B.border, width: 2),
                  boxShadow: _done
                      ? [
                          BoxShadow(
                              color: _B.mid.withOpacity(.32), blurRadius: 5)
                        ]
                      : null,
                ),
                child: _done
                    ? const Icon(Icons.check_rounded,
                        size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 11),
              Expanded(
                  child: Text(widget.text,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: _done ? _B.textLight : _B.textDark,
                          decoration: _done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none))),
              if (_done)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(colors: [_B.deep, _B.vivid]),
                      borderRadius: BorderRadius.circular(7)),
                  child: const Text('✓',
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w800)),
                ),
            ]),
          ),
        ),
      );
}

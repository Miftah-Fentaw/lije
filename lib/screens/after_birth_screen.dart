import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import 'widgets/feature_app_bar.dart';

// ============================================================
// INTERNAL COLOR PALETTE  (mapped to app theme)
// ============================================================
abstract class _C {
  static const Color navy = C.darkBlue;
  static const Color navyLight = C.darkBlue;
  static const Color accent = C.darkBlue;
  static const Color accentLight = C.lightBlue;
  static const Color skyBlue = C.darkBlue;
  static const Color skyLight = C.lightBlue;
  static const Color white = C.white;
  static const Color grayLight = C.bgPage;
  static const Color grayBorder = C.lightBlue;
  static const Color textDark = C.darkBlue;
  static const Color textMedium = C.darkBlue;
  static const Color cardGlass = C.white;
  static const Color bluePrimary = C.darkBlue;
  static const Color blueDeep = C.darkBlue;
  static const Color blueVibrant = C.darkBlue;
  static const Color blueSoft = C.lightBlue;
  static const Color bluePale = C.lightBlue;
  static const Color blueGlass = C.lightBlue;
}

// ============================================================
// LOCALIZATION
// ============================================================
class _L {
  static String t(AppLang l, String key) =>
      _strings[l]?[key] ?? _strings[AppLang.english]![key] ?? key;

  static final Map<AppLang, Map<String, String>> _strings = {
    AppLang.english: {
      'title': 'After Birth',
      'editDate': 'Edit Date',
      'trackJourney': "Track Your Baby's Journey",
      'trackDesc':
          "Enter your baby's birth date to get personalized milestone updates, health tips, and development insights from birth to 5 years.",
      'enterBirthDate': "Enter Baby's Birth Date",
      'brainDev': 'Brain Development',
      'feedingGuide': 'Feeding Guide',
      'vaccination': 'Vaccination',
      'growthTracking': 'Growth Tracking',
      'milestones': 'Milestones',
      'healthTips': 'Health Tips',
      'daysOld': 'days old',
      'monthOld': 'month old',
      'monthsOld': 'months old',
      'yrOld': 'year old',
      'yrsOld': 'years old',
      'yr': 'yr',
      'mo': 'mo',
      'myChild': 'My Child',
      'born': 'Born',
      'growthJourney': 'Growth Journey',
      'yearsReached': '5 years reached! 🎉',
      'stage': 'Stage',
      'month': 'Month',
      'milestoneCount': 'Milestones',
      'birth': 'Birth',
      'whatToExpect': 'What to expect',
      'current': 'Current',
      'rightNow': 'Right Now',
      'devAreas': 'Development Areas',
      'vaccinations': 'Vaccinations',
      'atThisStage': 'At this stage',
      'noVaccines': 'No scheduled vaccinations for this period.',
      'nutritionFeeding': 'Nutrition & Feeding',
      'guidanceStage': 'Guidance for this stage',
      'comingUpNext': 'Coming Up Next',
      'calendarType': 'Calendar Type',
      'gregorian': 'Gregorian',
      'ethiopian': 'Ethiopian (G.C.)',
      'selectDate': 'Select Birth Date',
      'confirm': 'Confirm Date',
      'cancel': 'Cancel',
      'year': 'Year',
      'day': 'Day',
    },
    AppLang.amharic: {
      'title': 'ከወሊድ በኋላ',
      'editDate': 'ቀን ያርትዑ',
      'trackJourney': 'የልጅዎን ጉዞ ይከታተሉ',
      'trackDesc':
          'የልጅዎን የልደት ቀን ያስፍሩ ለግል ምዕራፍ ዝምናዎች፣ የጤና ምክሮች፣ እና ከወሊድ እስከ 5 ዓመት ያለ እድገት ዝርዝሮችን ለማግኘት።',
      'enterBirthDate': 'የልጅ የልደት ቀን ያስፍሩ',
      'brainDev': 'አንጎል እድገት',
      'feedingGuide': 'አመጋገብ መመሪያ',
      'vaccination': 'ክትባቶች',
      'growthTracking': 'እድገት ክትትል',
      'milestones': 'ምዕራፎች',
      'healthTips': 'የጤና ምክሮች',
      'daysOld': 'ቀን',
      'monthOld': 'ወር',
      'monthsOld': 'ወሮች',
      'yrOld': 'ዓመት',
      'yrsOld': 'ዓመታት',
      'yr': 'ዓ',
      'mo': 'ወ',
      'myChild': 'ልጄ',
      'born': 'የተወለደ',
      'growthJourney': 'የእድገት ጉዞ',
      'yearsReached': '5 ዓመት ደርሷል! 🎉',
      'stage': 'ደረጃ',
      'month': 'ወር',
      'milestoneCount': 'ምዕራፎች',
      'birth': 'ወሊድ',
      'whatToExpect': 'የሚጠበቀው',
      'current': 'አሁን',
      'rightNow': 'አሁን',
      'devAreas': 'የእድገት ዘርፎች',
      'vaccinations': 'ክትባቶች',
      'atThisStage': 'በዚህ ደረጃ',
      'noVaccines': 'ለዚህ ጊዜ የተቀጠሩ ክትባቶች የሉም።',
      'nutritionFeeding': 'አመጋገብ',
      'guidanceStage': 'ለዚህ ደረጃ መመሪያ',
      'comingUpNext': 'ቀጣይ ምዕራፎች',
      'calendarType': 'የቀን አቆጣጠር',
      'gregorian': 'ጎርጎርሳዊ',
      'ethiopian': 'ኢትዮጵያዊ',
      'selectDate': 'የልደት ቀን ይምረጡ',
      'confirm': 'ቀኑን ያረጋግጡ',
      'cancel': 'ሰርዝ',
      'year': 'ዓመት',
      'day': 'ቀን',
    },
    AppLang.oromic: {
      'title': "Booda Da'umsaa",
      'editDate': 'Guyyaa Gulaali',
      'trackJourney': "Adeemsa Daa'ima Kee Hordofi",
      'trackDesc':
          "Guyyaa dhalootaa daa'ima kee galchi odeeffannoo milkaa'ina, gorsa fayyaa fi guddina dhalootaa hanga waggaa 5tti argachuuf.",
      'enterBirthDate': "Guyyaa Dhalootaa Daa'immaa Galchi",
      'brainDev': 'Guddina Sammuu',
      'feedingGuide': 'Qajeelcha Nyaachisuu',
      'vaccination': 'Talaallii',
      'growthTracking': 'Hordoffii Guddina',
      'milestones': "Milkaa'ina",
      'healthTips': 'Gorsa Fayyaa',
      'daysOld': 'guyyaa',
      'monthOld': "ji'a",
      'monthsOld': "ji'oota",
      'yrOld': 'waggaa',
      'yrsOld': 'waggaawwan',
      'yr': 'w',
      'mo': 'j',
      'myChild': "Daa'ima Koo",
      'born': 'Dhalate',
      'growthJourney': 'Adeemsa Guddina',
      'yearsReached': 'Waggaa 5 gahuu! 🎉',
      'stage': 'Sadarkaa',
      'month': "Ji'a",
      'milestoneCount': "Milkaa'ina",
      'birth': 'Dhalootaa',
      'whatToExpect': 'Maal eeguun barbaachisa',
      'current': 'Ammayyuu',
      'rightNow': 'Amma',
      'devAreas': 'Naannolee Guddina',
      'vaccinations': 'Talaallii',
      'atThisStage': 'Sadarkaa kana',
      'noVaccines': 'Talaalliin karoorfame sadarkaa kanaa hin jiru.',
      'nutritionFeeding': 'Nyaata fi Nyaachisuu',
      'guidanceStage': 'Qajeelfama sadarkaa kanaa',
      'comingUpNext': 'Itti Aanu',
      'calendarType': 'Ayyaana Guyyaa',
      'gregorian': 'Gregorian',
      'ethiopian': 'Itoophiyaa',
      'selectDate': 'Guyyaa Dhalootaa Filadhu',
      'confirm': 'Guyyaa Mirkaneessi',
      'cancel': 'Haquu',
      'year': 'Waggaa',
      'day': 'Guyyaa',
    },
  };
}

// ============================================================
// ETHIOPIAN CALENDAR CONVERTER
// ============================================================
class _EthCal {
  static const List<String> monthNamesEn = [
    'Meskerem',
    'Tikimit',
    'Hidar',
    'Tahisas',
    'Tir',
    'Yekatit',
    'Megabit',
    'Miyazia',
    'Ginbot',
    'Sene',
    'Hamle',
    'Nehase',
    'Pagume'
  ];
  static const List<String> monthNamesAm = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ'
  ];

  static Map<String, int> fromGregorian(DateTime g) {
    int gy = g.year, gm = g.month, gd = g.day;
    int a = (14 - gm) ~/ 12;
    int y = gy + 4800 - a;
    int m = gm + 12 * a - 3;
    int jdn = gd +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
    int r = (jdn - 1723856) % 1461;
    int n = r % 365 + 365 * (r ~/ 1460);
    int eYear = 4 * ((jdn - 1723856) ~/ 1461) + r ~/ 365 - r ~/ 1460;
    int eMonth = n ~/ 30 + 1;
    int eDay = n % 30 + 1;
    if (eMonth > 13) {
      eMonth = 13;
      eDay = n - 360 + 1;
    }
    return {'year': eYear, 'month': eMonth, 'day': eDay};
  }

  static DateTime toGregorian(int eYear, int eMonth, int eDay) {
    int jdn =
        1723856 + 365 * eYear + eYear ~/ 4 + 30 * (eMonth - 1) + eDay - 31;
    int a = jdn + 32044;
    int b = (4 * a + 3) ~/ 146097;
    int c = a - (146097 * b) ~/ 4;
    int d = (4 * c + 3) ~/ 1461;
    int e = c - (1461 * d) ~/ 4;
    int mm = (5 * e + 2) ~/ 153;
    int day = e - (153 * mm + 2) ~/ 5 + 1;
    int month = mm + 3 - 12 * (mm ~/ 10);
    int year = 100 * b + d - 4800 + mm ~/ 10;
    return DateTime(year, month, day);
  }

  static int daysInMonth(int eYear, int eMonth) {
    if (eMonth == 13) return (eYear % 4 == 3) ? 6 : 5;
    return 30;
  }
}

// ============================================================
// BEAUTIFUL CALENDAR PICKER DIALOG
// ============================================================
class _DatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final AppLang lang;
  const _DatePickerDialog({this.initialDate, required this.lang});

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog>
    with TickerProviderStateMixin {
  bool _useEthiopian = false;
  late int _gYear, _gMonth, _gDay;
  late int _eYear, _eMonth, _eDay;
  late AnimationController _entryAnim;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDate ?? DateTime.now();
    _gYear = d.year;
    _gMonth = d.month;
    _gDay = d.day;
    final eth = _EthCal.fromGregorian(d);
    _eYear = eth['year']!;
    _eMonth = eth['month']!;
    _eDay = eth['day']!;
    _entryAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _entryFade = CurvedAnimation(parent: _entryAnim, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutCubic));
    _entryAnim.forward();
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    super.dispose();
  }

  String _t(String k) => _L.t(widget.lang, k);
  int get _gDaysInMonth => DateTime(_gYear, _gMonth + 1, 0).day;

  void _syncEthFromGregorian() {
    final g = DateTime(_gYear, _gMonth, _gDay.clamp(1, _gDaysInMonth));
    final eth = _EthCal.fromGregorian(g);
    _eYear = eth['year']!;
    _eMonth = eth['month']!;
    _eDay = eth['day']!;
  }

  void _syncGregorianFromEth() {
    final eDays = _EthCal.daysInMonth(_eYear, _eMonth);
    _eDay = _eDay.clamp(1, eDays);
    final g = _EthCal.toGregorian(_eYear, _eMonth, _eDay);
    _gYear = g.year;
    _gMonth = g.month;
    _gDay = g.day;
  }

  DateTime get _confirmedDate {
    if (_useEthiopian) {
      final eDays = _EthCal.daysInMonth(_eYear, _eMonth);
      return _EthCal.toGregorian(_eYear, _eMonth, _eDay.clamp(1, eDays));
    }
    return DateTime(_gYear, _gMonth, _gDay.clamp(1, _gDaysInMonth));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entryFade,
      child: SlideTransition(
        position: _entrySlide,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F7FF), Color(0xFFF0FBFF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: _C.blueDeep.withOpacity(0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildCalSwitch(),
                  _buildPickerBody(),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String displayDate;
    if (_useEthiopian) {
      final mName = widget.lang == AppLang.amharic
          ? _EthCal.monthNamesAm[_eMonth - 1]
          : _EthCal.monthNamesEn[_eMonth - 1];
      displayDate = '$_eDay $mName $_eYear';
    } else {
      const months = [
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
      displayDate = '$_gDay ${months[_gMonth - 1]} $_gYear';
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.bluePrimary, _C.blueDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🗓️', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _t('selectDate'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              displayDate,
              key: ValueKey(displayDate),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalSwitch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _C.bluePale,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _C.blueSoft.withOpacity(0.5)),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final half = constraints.maxWidth / 2;
          return Stack(children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              left: _useEthiopian ? half : 0,
              top: 0,
              bottom: 0,
              width: half,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_C.bluePrimary, _C.blueVibrant]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: _C.bluePrimary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
              ),
            ),
            Row(children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (_useEthiopian)
                    setState(() {
                      _useEthiopian = false;
                      _syncEthFromGregorian();
                    });
                },
                child: Center(
                    child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: !_useEthiopian ? Colors.white : _C.blueDeep,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  child: Text(_t('gregorian'), overflow: TextOverflow.ellipsis),
                )),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (!_useEthiopian)
                    setState(() {
                      _useEthiopian = true;
                      _syncEthFromGregorian();
                    });
                },
                child: Center(
                    child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _useEthiopian ? Colors.white : _C.blueDeep,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  child: Text(_t('ethiopian'), overflow: TextOverflow.ellipsis),
                )),
              )),
            ]),
          ]);
        }),
      ),
    );
  }

  Widget _buildPickerBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      child: _useEthiopian
          ? _buildEthPicker(key: const ValueKey('eth'))
          : _buildGregPicker(key: const ValueKey('greg')),
    );
  }

  Widget _buildGregPicker({Key? key}) {
    final now = DateTime.now();
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _sectionLabel('Month'),
        const SizedBox(height: 8),
        _monthGrid(
          count: 12,
          nameOf: (i) => [
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
          ][i],
          selected: _gMonth - 1,
          onSelect: (i) => setState(() {
            _gMonth = i + 1;
            if (_gDay > DateTime(_gYear, _gMonth + 1, 0).day)
              _gDay = DateTime(_gYear, _gMonth + 1, 0).day;
            _syncEthFromGregorian();
          }),
          crossCount: 4,
          aspectRatio: 2.2,
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: _spinner(
                  label: _t('year'),
                  value: _gYear,
                  min: now.year - 6,
                  max: now.year,
                  onChanged: (v) => setState(() {
                        _gYear = v;
                        _syncEthFromGregorian();
                      }))),
          const SizedBox(width: 12),
          Expanded(
              child: _spinner(
                  label: _t('day'),
                  value: _gDay,
                  min: 1,
                  max: _gDaysInMonth,
                  onChanged: (v) => setState(() {
                        _gDay = v;
                        _syncEthFromGregorian();
                      }))),
        ]),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _buildEthPicker({Key? key}) {
    final names = widget.lang == AppLang.amharic
        ? _EthCal.monthNamesAm
        : _EthCal.monthNamesEn;
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _sectionLabel(widget.lang == AppLang.amharic ? 'ወር' : 'Month'),
        const SizedBox(height: 8),
        _monthGrid(
          count: 13,
          nameOf: (i) => names[i],
          selected: _eMonth - 1,
          onSelect: (i) => setState(() {
            _eMonth = i + 1;
            _eDay = _eDay.clamp(1, _EthCal.daysInMonth(_eYear, _eMonth));
            _syncGregorianFromEth();
          }),
          crossCount: 4,
          aspectRatio: 2.0,
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: _spinner(
                  label: _t('year'),
                  value: _eYear,
                  min: DateTime.now().year - 14,
                  max: DateTime.now().year,
                  onChanged: (v) => setState(() {
                        _eYear = v;
                        _syncGregorianFromEth();
                      }))),
          const SizedBox(width: 12),
          Expanded(
              child: _spinner(
                  label: _t('day'),
                  value: _eDay,
                  min: 1,
                  max: _EthCal.daysInMonth(_eYear, _eMonth),
                  onChanged: (v) => setState(() {
                        _eDay = v;
                        _syncGregorianFromEth();
                      }))),
        ]),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _sectionLabel(String label) => Align(
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _C.blueDeep,
                letterSpacing: 1.2)),
      );

  Widget _monthGrid({
    required int count,
    required String Function(int) nameOf,
    required int selected,
    required void Function(int) onSelect,
    required int crossCount,
    required double aspectRatio,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: aspectRatio,
      ),
      itemCount: count,
      itemBuilder: (_, i) {
        final sel = selected == i;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: sel
                  ? const LinearGradient(
                      colors: [_C.bluePrimary, _C.blueVibrant])
                  : null,
              color: sel ? null : _C.bluePale,
              borderRadius: BorderRadius.circular(10),
              boxShadow: sel
                  ? [
                      BoxShadow(
                          color: _C.bluePrimary.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ]
                  : null,
            ),
            child: Center(
                child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(nameOf(i),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: sel ? Colors.white : _C.blueDeep)),
              ),
            )),
          ),
        );
      },
    );
  }

  Widget _spinner({
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: _C.bluePale,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.blueSoft.withOpacity(0.6)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _C.blueDeep,
                letterSpacing: 0.8),
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _spinBtn(Icons.remove_rounded, () {
            if (value > min) onChanged(value - 1);
          }),
          Expanded(
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text('$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _C.blueDeep)),
          )),
          _spinBtn(Icons.add_rounded, () {
            if (value < max) onChanged(value + 1);
          }),
        ]),
      ]),
    );
  }

  Widget _spinBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(colors: [_C.bluePrimary, _C.blueVibrant]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: _C.bluePrimary.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _C.bluePale,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.blueSoft),
            ),
            child: Center(
                child: Text(_t('cancel'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: _C.blueDeep),
                    overflow: TextOverflow.ellipsis)),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, _confirmedDate),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_C.blueDeep, _C.bluePrimary, _C.blueVibrant]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: _C.bluePrimary.withOpacity(0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 5))
                  ],
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Flexible(
                      child: Text(_t('confirm'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis)),
                ]),
              ),
            )),
      ]),
    );
  }
}

// ============================================================
// BUBBLE PAINTER
// ============================================================
class _BubblePainter extends CustomPainter {
  final double animValue;
  _BubblePainter(this.animValue);
  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      [0.1, 0.2, 60.0, 0.06],
      [0.85, 0.1, 80.0, 0.04],
      [0.3, 0.8, 50.0, 0.05],
      [0.7, 0.6, 100.0, 0.03],
      [0.5, 0.15, 40.0, 0.07],
      [0.15, 0.65, 70.0, 0.04],
      [0.9, 0.75, 55.0, 0.06],
    ];
    for (int i = 0; i < bubbles.length; i++) {
      final b = bubbles[i];
      final dy = math.sin(animValue * 2 * math.pi + i * 0.8) * 15;
      canvas.drawCircle(
        Offset(
            size.width * (b[0] as double), size.height * (b[1] as double) + dy),
        b[2] as double,
        Paint()..color = _C.blueSoft.withOpacity(b[3] as double),
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => old.animValue != animValue;
}

// ============================================================
// DATA MODELS
// ============================================================
class _DevArea {
  final String emoji, title, detail;
  final Color bgColor;
  const _DevArea(
      {required this.emoji,
      required this.title,
      required this.detail,
      required this.bgColor});
}

class _Stage {
  final String key, name, ageRange, emoji, alertEmoji;
  final int minMonth, maxMonth;
  final List<String> milestones, vaccinations;
  final List<_DevArea> devAreas;
  const _Stage({
    required this.key,
    required this.name,
    required this.ageRange,
    required this.emoji,
    required this.alertEmoji,
    required this.minMonth,
    required this.maxMonth,
    required this.milestones,
    required this.vaccinations,
    required this.devAreas,
  });
}

// ============================================================
// STAGE LOCALIZATIONS  (English / Amharic / oromic)
// ============================================================
class _SL {
  // ─── names ──────────────────────────────────────────────────
  static String name(AppLang l, String k) =>
      (_names[l] ?? _names[AppLang.english]!)[k] ?? k;
  static final _names = <AppLang, Map<String, String>>{
    AppLang.english: {
      'newborn': 'Newborn',
      'earlyInfant': 'Early Infant',
      'discovering': 'Discovering',
      'explorer': 'Explorer',
      'almostToddler': 'Almost Toddler',
      'firstToddler': 'First Toddler',
      'curiousToddler': 'Curious Toddler',
      'theTwos': 'The Twos',
      'preschooler': 'Preschooler',
      'preK': 'Pre-Kindergarten',
      'kindergartener': 'Kindergartener',
    },
    AppLang.amharic: {
      'newborn': 'አዲስ ወለድ',
      'earlyInfant': 'ትናንሽ ሕፃን',
      'discovering': 'አሳሽ',
      'explorer': 'ዳሳሽ',
      'almostToddler': 'ሊሄድ የቃ',
      'firstToddler': 'መጀመሪያ ሕፃን',
      'curiousToddler': 'የጉጉ ሕፃን',
      'theTwos': 'ሁለት ዓመቶቹ',
      'preschooler': 'ቅድመ ትምህርት',
      'preK': 'ቅደ-ቅ.ት.ቤት',
      'kindergartener': 'መዋዕለ ሕፃናት',
    },
    AppLang.oromic: {
      'newborn': "Daa'ima Haaraa",
      'earlyInfant': "Daa'ima Xiqqaa",
      'discovering': 'Argannoo',
      'explorer': 'Qorannoo',
      'almostToddler': 'Deemuu Jalqabe',
      'firstToddler': "Daa'ima Jalqabaa",
      'curiousToddler': "Daa'ima Ho'aa",
      'theTwos': 'Waggaa Lama',
      'preschooler': 'Dura Mana Barumsaa',
      'preK': 'Dura Kindergaartii',
      'kindergartener': 'Kindergaartii',
    },
  };

  // ─── descriptions ────────────────────────────────────────────
  static String desc(AppLang l, String k) =>
      (_descs[l] ?? _descs[AppLang.english]!)[k] ?? k;
  static final _descs = <AppLang, Map<String, String>>{
    AppLang.english: {
      'newborn':
          'Your newborn is adapting to life outside the womb. Sleeps 14–17 hours a day, feeds every 2–3 hours, and responds to your voice and touch.',
      'earlyInfant':
          'Your baby is becoming more alert and interactive. Smiles appear around 6 weeks — a magical moment! Head control is developing.',
      'discovering':
          'Your baby is full of curiosity! They can hold their head steady, roll from tummy to back, and reach for objects.',
      'explorer':
          'A major leap! Your baby may start solid foods, sit without support, and begin crawling.',
      'almostToddler':
          'Your baby is close to their first birthday! Pulling to stand, cruising along furniture, and possibly taking first steps.',
      'firstToddler':
          'Happy first birthday! 🎂 Your baby is now a toddler, walking independently and exploring everything.',
      'curiousToddler':
          'Your toddler is a question machine! Running, jumping, and climbing are favorites.',
      'theTwos':
          "The terrific twos! Your child's personality is shining. Toilet training typically begins around this time.",
      'preschooler':
          'Your child is blossoming into a social being. Sentences are complex and questions are endless.',
      'preK':
          'Your child is almost ready for kindergarten! Most children can count to 10+, write their name, and tell detailed stories.',
      'kindergartener':
          'Five years old — what a journey! Your child is ready for formal schooling.',
    },
    AppLang.amharic: {
      'newborn':
          'አዲስ ወለድዎ ከማህፀን ውጭ ለሕይወት እየተላመደ ነው። ቀን 14–17 ሰዓት ይተኛሉ፣ ለድምፅዎ ምላሽ ይሰጣሉ።',
      'earlyInfant': 'ልጅዎ የበለጠ ንቁ እና ተሳታፊ እየሆነ ነው። ፈገግታ በ6 ሳምንት ዙሪያ ይታያሉ።',
      'discovering': 'ልጅዎ አሁን ሙሉ ጉጉት አለው! ጭንቅላቱን ቀጥ አድርጎ ሊይዝ ይችሉ።',
      'explorer': 'ትልቅ ዝላይ! ጠጣር ምግቦችን ሊጀምር፣ ያለ ድጋፍ ሊቀመጥ ይችሉ።',
      'almostToddler': 'ልጅዎ የመጀመሪያ ልደቱ አቅራቢያ ነው! የመጀመሪያ እርምጃዎቻቸውን ሊወስዱ ይችሉ።',
      'firstToddler': 'እንኳን ደስ አለዎ! 🎂 ልጅዎ አሁን ቶዳለር ሲሆን ብቻቸውን ይሄዳሉ።',
      'curiousToddler': 'ቶዳለርዎ ጥያቄ ማሽን ነው! መሮጥ፣ መዝለል ዋና ስራቸው ነው።',
      'theTwos': 'አስደናቂ ሁለቶቹ! የልጅዎ ስብዕና ያበራሉ። የሽንት ቤት ሥልጠና ይጀምራሉ።',
      'preschooler': 'ልጅዎ ማህበራዊ ፍጡር እየሆኑ ናቸው። ዓረፍተ ነገሮቹ ውስብስብ ሆኑ።',
      'preK': 'ልጅዎ ለኪንደርጋርተን ሊዘጋጁ ናቸው! ብዛት ልጆች እስከ 10+ ሊቆጥሩ ይችሉ።',
      'kindergartener': 'አምስት ዓመት — ምን ያህል ጉዞ! ልጅዎ ለመደበኛ ትምህርት ዝግጁ ናቸው።',
    },
    AppLang.oromic: {
      'newborn':
          "Daa'imni kee haaraan jireenya gadameessa alaatti hordofaa jira. Sa'aatii 14–17 hirribaa.",
      'earlyInfant':
          "Daa'imni kee ammayyuu hojjataafi hirmaataafi jira. Yeeyyiin torbaan 6tti mul'ata.",
      'discovering':
          "Daa'imni kee amma aayiraali guutuu qaba! Mataa qabataa qabaachuu danda'u.",
      'explorer': "Guddina guddaa! Daa'imni kee nyaata cimaa jalqabuu danda'a.",
      'almostToddler':
          "Daa'imni kee guyyaa dhalootaa jalqabaa isaa dhiyaatee jira!",
      'firstToddler':
          "Guyyaa dhalootaa jalqabaa nagaan baga gahe! 🎂 Bilisaan deema.",
      'curiousToddler':
          "Ijoollee kee maashinii gaaffii! Fiiguun, utaaluun fi ol-bahuun jaalatamaa.",
      'theTwos': '"Lama waggaa bareedaa"! Amalli daa\'immaa kee mul\'ata.',
      'preschooler':
          "Daa'imni kee hawaasa ta'aa jira. Murtoon amma xaxamaa dha.",
      'preK': "Daa'imni kee kindergaartii dura qophii dha!",
      'kindergartener':
          "Waggaa shan — imala akkam! Daa'imni kee barumsaa qophaawaa dha.",
    },
  };

  // ─── alerts ─────────────────────────────────────────────────
  static String alert(AppLang l, String k) =>
      (_alerts[l] ?? _alerts[AppLang.english]!)[k] ?? k;
  static final _alerts = <AppLang, Map<String, String>>{
    AppLang.english: {
      'newborn':
          '🌙 Your newborn needs feeding every 2–3 hours. Watch for hunger cues: rooting, lip smacking. Ensure tummy time for a few minutes daily.',
      'earlyInfant':
          "😊 Watch for your baby's first social smile around 6 weeks. Talk, sing, and make eye contact frequently.",
      'discovering':
          '🎈 Your baby may start rolling — ensure safe sleep (always on back). Begin short play sessions with colorful toys.',
      'explorer':
          '🥄 Time to introduce solid foods! Start with single-ingredient purees. Introduce one new food every 3–5 days.',
      'almostToddler':
          '🚶 Baby-proof your home! Cover electrical outlets, secure heavy furniture. First steps may arrive any time.',
      'firstToddler':
          '🎉 First birthday! Your toddler should have 5+ words by 15 months. Establish a regular sleep routine.',
      'curiousToddler':
          '🗣️ By 24 months your child should say 50+ words. If not, talk to your pediatrician.',
      'theTwos':
          '🎭 Toilet training signs: staying dry 2+ hours, showing interest. Start gently — never punish accidents.',
      'preschooler':
          '🎒 Prepare for preschool. Your 3-year-old should be able to play with other children and follow 3-step instructions.',
      'preK':
          '📚 Kindergarten prep: practice counting, identifying letters, and using scissors.',
      'kindergartener':
          '🌟 Your child has reached 5 years — a monumental achievement! They are ready for kindergarten.',
    },
    AppLang.amharic: {
      'newborn':
          '🌙 አዲስ ወለድዎ በ2–3 ሰዓት መመገብ ይፈልጋሉ። የራብ ምልክቶች ይፈልጉ። ዕለት ዕለት ሆድ ጊዜ ይስጡ።',
      'earlyInfant': '😊 የልጅዎን የመጀመሪያ ፈገግታ ይፈልጉ (6 ሳምንት)። ብዙ ጊዜ ይናገሩ፣ ዘፈን ዘምሩ።',
      'discovering': '🎈 ልጅዎ ሊሽከረከር ይችሉ — ደህንነቱ ያረጋግጡ። ቀለማማ ዕቃዎች ያቅርቡ።',
      'explorer': '🥄 ጠጣር ምግቦችን ለመጀመር ጊዜ ደርሷል! ነጠላ ንጥረ ነገር ፑሬ ይጀምሩ።',
      'almostToddler': '🚶 ቤትዎን ለሕፃናት ደህንነቱ ያረጋግጡ! የኤሌክትሪክ ቁጥቋጦዎችን ይሸፍኑ።',
      'firstToddler': '🎉 የመጀመሪያ ልደት! ቶዳለርዎ እስከ 15 ወር 5+ ቃሎች ሊኖሩ ይገባሉ።',
      'curiousToddler': '🗣️ በ24 ወር ልጅዎ 50+ ቃሎችን ሊናገሩ ይገባሉ። ካልሆነ ሐኪምዎን ያናግሩ።',
      'theTwos': '🎭 የሽንት ቤት ሥልጠና ዝግጁነት: ለ2+ ሰዓት ደረቅ ሆኖ መቆየት።',
      'preschooler': '🎒 ቅድመ ትምህርት ቤት ካለ ያዘጋጁ። ወጥ ያለ የምሽት ዑደት ይመሥርቱ።',
      'preK': '📚 ኪንደርጋርተን ዝግጅት: ዕቃዎችን መቁጠር ይለማመዱ።',
      'kindergartener': '🌟 ልጅዎ 5 ዓመት ደርሷል — ታላቅ ስኬት! ለኪንደርጋርተን ዝግጁ ናቸው።',
    },
    AppLang.oromic: {
      'newborn':
          "🌙 Daa'imni kee sa'aatii 2–3tti nyaachifamuu barbaada. Guyyaa guyyaa yeroo garaa gadi-buusu kenni.",
      'earlyInfant':
          "😊 Yeeyyii hawaasaa jalqabaa (torbaan 6) hordofi. Yeroo baay'ee haasawuu fi sirbi.",
      'discovering':
          "🎈 Daa'imni kee garagaluuf jalqabuu danda'a — hirribaa nagaa mirkaneessi.",
      'explorer':
          "🥄 Nyaata cimaa seensisuu yeroon isaa dhufeera! Puree tokko-tokko jalqabi.",
      'almostToddler':
          "🚶 Mana kee daa'imniif nagaa taasisi! Tarkaanfii jalqabaa yeroo kamiiyyuu dhufa.",
      'firstToddler':
          "🎉 Guyyaa dhalootaa jalqabaa! Ijoollee kee hanga ji'a 15tti jecha 5+ qabaachuu qaba.",
      'curiousToddler':
          "🗣️ Ji'a 24tti, daa'imni kee jecha 50+ dubbachuu qabu. Yoo dhabe, dokitara gaafadhu.",
      'theTwos':
          "🎭 Mallattoo qophii leenjii mana fincaanii: sa'aatii 2+ gogaa ta'ee turu.",
      'preschooler': "🎒 Mana barumsaa dura qopheessi yoo jiraate.",
      'preK': "📚 Qophii kindergaartii: meeshaa lakkoofsuu leenjisi.",
      'kindergartener': "🌟 Daa'imni kee waggaa 5 gahuu — milkaa'ina guddaa!",
    },
  };

  // ─── nutrition ───────────────────────────────────────────────
  static String nutrition(AppLang l, String k) =>
      (_nutr[l] ?? _nutr[AppLang.english]!)[k] ?? k;
  static final _nutr = <AppLang, Map<String, String>>{
    AppLang.english: {
      'newborn':
          'Exclusive breastfeeding is recommended. Newborns feed 8–12 times in 24 hours. Colostrum provides essential antibodies.',
      'earlyInfant':
          'Continue exclusive breastfeeding or formula (60–90ml per feed). No water, juice, or solids needed yet.',
      'discovering':
          'Exclusive breast milk or formula. Around 6 months, watch for readiness signs for solids.',
      'explorer':
          'Continue breast milk or formula. Introduce pureed vegetables, fruits, and grains.',
      'almostToddler':
          'Expand to mashed and finger foods: soft fruits, cooked vegetables. Introduce a sippy cup.',
      'firstToddler':
          "Transition to whole cow's milk (16–24 oz/day). Offer 3 meals and 2 healthy snacks.",
      'curiousToddler':
          'Offer a colorful plate at every meal. Ensure calcium, iron, and zinc intake.',
      'theTwos':
          '3 meals and 1–2 snacks daily. Toddlers need 700mg calcium/day.',
      'preschooler':
          'Focus on whole grains, fruits, vegetables, and lean proteins. Family meals together support healthy habits.',
      'preK':
          'Encourage child to help with simple food prep — washing vegetables, stirring.',
      'kindergartener':
          'Nutritious breakfast daily supports learning. Pack balanced lunches with protein, whole grain, fruit.',
    },
    AppLang.amharic: {
      'newborn': 'የጡት ጡት ብቻ ይመከራሉ። አዲስ ወለዶች በ24 ሰዓት 8–12 ጊዜ ይመገባሉ።',
      'earlyInfant': 'የጡት ጡት ወይም ወተት ቀጥሉ (60–90ml ለ2–3 ሰዓት)።',
      'discovering': 'ለጡት ጡት ወይም ወተት ብቻ ቀጥሉ። ወደ 6 ወር ዝግጁነት ምልክቶች ይፈልጉ።',
      'explorer': 'ዋና ምንጭ ሆኖ ቀጥሉ። የፑሬ አትክልቶች እና ፍራፍሬ ያስተዋውቁ።',
      'almostToddler': 'ለስላሳ ፍራፍሬ እና ትናንሽ ፓስታ ያቅርቡ። ሲፒ ኩባያ ወሃ ያስተዋውቁ።',
      'firstToddler': 'ወደ ሙሉ የላም ወተት ይቀያይሩ (16–24 oz/ቀን)። 3 ምግቦች ያቅርቡ።',
      'curiousToddler': 'ቀለማማ ሳህን በእያንዳንዱ ምግብ ያቅርቡ። ካልሲየም ያረጋግጡ።',
      'theTwos': 'ዕለት ዕለት 3 ምግቦች። 700mg ካልሲየም/ቀን ያስፈልጋሉ።',
      'preschooler': 'ሙሉ እህሎች፣ ፍራፍሬ ያቅርቡ። የቤተሰብ ምግቦች ጤናማ ልማዶችን ይደግፋሉ።',
      'preK': 'ልጅዎን ምግብ ዝግጅት ያሳትፉ — አትክልቶች ማጠብ፣ ማደባለቅ።',
      'kindergartener': 'ዕለታዊ ቁርስ ትምህርትን ይደግፋሉ። ፕሮቲን፣ ሙሉ እህሎች ያቅርቡ።',
    },
    AppLang.oromic: {
      'newborn':
          "Harma hoosisuu qofaa gorfama. Daa'imman haaraan sa'aatii 24tti 8–12 nyaachifamu.",
      'earlyInfant':
          "Harma hoosisuu yookin juurii (ml 60–90 sa'aatii 2–3tti) itti fufi.",
      'discovering':
          "Harma hoosisuu yookin juurii qofaa itti fufi. Ji'a 6tti mallattoo qophii eeggadhu.",
      'explorer':
          "Madda ijoo ta'ee harma hoosisuu itti fufi. Puree kuduraa fi fuduraa seensi.",
      'almostToddler':
          "Fuduraa laafaa fi kuduraa bilchaate dhiheessi. Kooppii sippii bishaaniitiin seensi.",
      'firstToddler':
          "Juurii irraa harma loonii guutuu (oz 16–24/guyyaa) jijjiiri.",
      'curiousToddler':
          "Plate bifa qabu nyaata hunda dhiheessi. Calcium, biroo mirkaneessi.",
      'theTwos':
          "Guyyaa guyyaa nyaata 3 fi snack 1–2 dhiheessi. Calcium 700mg/guyyaa.",
      'preschooler':
          "Meeshaa guutuu, fuduraa, kuduraa dhiheessi. Nyaata maatii fayyaa jajjabeessa.",
      'preK': "Daa'ima kee qophii nyaata salphaa keessatti hirmaachisi.",
      'kindergartener': "Qoroo sooratamaa ta'e guyyaa guyyaa barumsaa cimsa.",
    },
  };

  // ─── milestones ──────────────────────────────────────────────
  static List<String> milestones(AppLang l, String k) =>
      (_ms[l] ?? _ms[AppLang.english]!)[k] ?? _ms[AppLang.english]![k] ?? [];
  static final _ms = <AppLang, Map<String, List<String>>>{
    AppLang.english: {
      'newborn': [
        'Responds to loud sounds',
        'Focuses on faces',
        'Brings hands to face',
        'Moves arms and legs'
      ],
      'earlyInfant': [
        'First social smile',
        'Follows objects with eyes',
        'Lifts head during tummy time',
        'Coos and makes sounds'
      ],
      'discovering': [
        'Holds head steady',
        'Rolls tummy to back',
        'Reaches and grabs objects',
        'Laughs and squeals'
      ],
      'explorer': [
        'Sits without support',
        'Begins crawling',
        'Picks up objects',
        'Responds to own name'
      ],
      'almostToddler': [
        'Pulls to stand',
        'First words: "mama", "dada"',
        'Waves bye-bye',
        'Plays peek-a-boo'
      ],
      'firstToddler': [
        'Walks independently',
        '5–20 words by 18 months',
        'Feeds self',
        'Stacks 2–4 blocks'
      ],
      'curiousToddler': [
        'Runs and kicks a ball',
        '50+ words, 2-word phrases',
        'Pretend play',
        'Follows 2-step instructions'
      ],
      'theTwos': [
        '3–4 word sentences',
        'Knows name and age',
        'Plays alongside others',
        'Toilet training readiness'
      ],
      'preschooler': [
        'Speaks in full sentences',
        'Draws recognizable people',
        'Hops on one foot',
        'Dresses with minimal help'
      ],
      'preK': [
        'Counts 10+ objects',
        'Writes own name',
        'Tells detailed stories',
        'Uses scissors'
      ],
      'kindergartener': [
        'Ready for kindergarten',
        'Reads simple words',
        'Counts to 100+',
        'Shows empathy'
      ],
    },
    AppLang.amharic: {
      'newborn': ['ጮኸ ድምፆች ምላሽ', 'ቅርፆቻቸው ይፈልጋሉ', 'እጆቻቸውን ያቀርባሉ', 'ሲነቁ ይንቀሳቀሳሉ'],
      'earlyInfant': ['የመጀመሪያ ፈገግታ', 'ዕቃዎችን ይከተሉ', 'ጭንቅላት ያነሳሉ', 'ቡትቡት ያሰሙ'],
      'discovering': ['ጭንቅላትን ቀጥ ይያዛሉ', 'ሽከረከሩ', 'ዕቃዎችን ዳስሱ', 'ጩኸት ያሰሙ'],
      'explorer': ['ያለ ድጋፍ ቀምጡ', 'ሊሳቡ ጀምሩ', 'ዕቃዎችን ያነሳሉ', 'ስምን ምላሽ'],
      'almostToddler': ['ለመቆም ጎትቱ', '"ማ", "ዳ" ቃሎች', 'ደህና ሁን ሰናበቱ', 'ጨዋታ ይወዳሉ'],
      'firstToddler': ['ብቻቸውን ሄዱ', '5–20 ቃሎች', 'ብቻቸውን ምገቡ', 'ብሎኮች ደረደሩ'],
      'curiousToddler': ['ሮጡ፣ ኳስ ምቱ', '50+ ቃሎች', 'ምናብ ጨዋታ', 'መመሪያ ይከተሉ'],
      'theTwos': [
        '3–4 ቃል ዓረፍተ ነገሮች',
        'ስማቸውን ያውቁ',
        'ከሌሎች ጋር ይጫወቱ',
        'ሽንት ቤት ዝግጁ'
      ],
      'preschooler': ['ሙሉ ዓረፍተ ነገሮች', 'ሰዎችን ሳሉ', 'አንድ እግር ዘሉ', 'ለብሱ'],
      'preK': ['10+ ቆጥሩ', 'ስማቸውን ጻፉ', 'ታሪኮች ናገሩ', 'መቀስ ተጠቀሙ'],
      'kindergartener': ['ለኪንደርጋርተን ዝግጁ', 'ቃሎችን ቆጥሩ', 'እስከ 100 ቆጥሩ', 'ሐዘነ ያሳዩ'],
    },
    AppLang.oromic: {
      'newborn': [
        "Sagalee ol-dhagahamu deebii kenna",
        "Fuula xiyyeeffata",
        "Harka fuula fiduu",
        "Harka miila socho'siisa"
      ],
      'earlyInfant': [
        "Yeeyyii hawaasaa jalqabaa",
        "Meeshaalee ijaan hordofuu",
        "Mataa kaasuu",
        "Sagalee laafaa"
      ],
      'discovering': [
        "Mataa qabataa",
        "Gurraachaa garagaluu",
        "Meeshaalee qabaachuu",
        "Gammachuudhaan kolfuu"
      ],
      'explorer': [
        "Utubaa malee taa'uu",
        "Harka miila jalqabuu",
        "Meeshaalee qubaan fudhachuu",
        "Maqaa isaaniif deebii"
      ],
      'almostToddler': [
        "Dhaabbachuuf garagaluu",
        "Jecha jalqabaa",
        "Nagaatti garagaluu",
        "Taphatuu"
      ],
      'firstToddler': [
        "Bilisaan deemuu",
        "Hanga ji'a 18tti jecha 5–20",
        "Of-nyaachisuu",
        "Dulluu erguudhaan diriirsu"
      ],
      'curiousToddler': [
        "Fiiguu fi kubbaa dhiibuu",
        "Jecha 50+, murtoo lama",
        "Taphi of-fakkeessuu",
        "Qaajeelfama hordofuu"
      ],
      'theTwos': [
        "Murtoo jecha 3–4",
        "Maqaa fi umrii beekuu",
        "Ijoollee biroo waliin",
        "Qophii mana fincaanii"
      ],
      'preschooler': [
        "Murtoo guutuu dubbachuu",
        "Namtolleewwan kaasuu",
        "Luka tokko utaaluu",
        "Uffachuu"
      ],
      'preK': [
        "Meeshaalee 10+ lakkoofsuu",
        "Maqaa isaanii barreessuu",
        "Seenaa dubbachuu",
        "Maqasaa fayyadamuu"
      ],
      'kindergartener': [
        "Kindergaartii dhaaf qophaawaa",
        "Jecha salphaa dubbisuu",
        "Lakkoofsa 100",
        "Waliigaltee agarsiisu"
      ],
    },
  };

  // ─── vaccines ────────────────────────────────────────────────
  static List<String> vaccines(AppLang l, String k) =>
      (_vax[l] ?? _vax[AppLang.english]!)[k] ?? _vax[AppLang.english]![k] ?? [];
  static final _vax = <AppLang, Map<String, List<String>>>{
    AppLang.english: {
      'newborn': [
        'Hepatitis B — 1st dose at birth',
        'BCG — TB vaccine',
        'OPV — Birth dose'
      ],
      'earlyInfant': [
        'DTaP — 1st dose (2 months)',
        'IPV — 1st dose',
        'Hib — 1st dose',
        'PCV13 — 1st dose',
        'Rotavirus — 1st dose'
      ],
      'discovering': [
        'DTaP — 2nd dose (4 months)',
        'IPV — 2nd dose',
        'Hib — 2nd dose',
        'PCV13 — 2nd dose',
        'Rotavirus — 2nd dose',
        'DTaP — 3rd (6 months)',
        'Influenza — 1st (6 months)'
      ],
      'explorer': [
        'Influenza — annual flu vaccine',
        'Check with doctor for catch-up vaccines'
      ],
      'almostToddler': [
        'MMR — 1st dose (12 months)',
        'Varicella — 1st dose',
        'Hepatitis A — 1st dose',
        'PCV13 — 4th dose'
      ],
      'firstToddler': [
        'DTaP — 4th dose (15–18 months)',
        'Hib — final dose',
        'Hepatitis A — 2nd dose',
        'Annual influenza vaccine'
      ],
      'curiousToddler': [
        'MMR — 2nd dose may be given',
        'Check catch-up immunizations'
      ],
      'theTwos': [
        'Annual influenza vaccine',
        'Hepatitis A (complete series)',
        'Discuss catch-up doses'
      ],
      'preschooler': [
        'DTaP — 5th dose (4–6 years)',
        'IPV — 4th dose',
        'MMR — 2nd dose',
        'Varicella — 2nd dose',
        'Annual flu'
      ],
      'preK': [
        'All 4–6 year boosters (DTaP, IPV, MMR, Varicella)',
        'Annual influenza vaccine',
        'Consult pediatrician'
      ],
      'kindergartener': [
        'Ensure all school-entry vaccines complete',
        'Annual influenza vaccine',
        'Consult pediatrician'
      ],
    },
    AppLang.amharic: {
      'newborn': ['ሄፓቲቲስ ቢ — 1ኛ', 'ቢሲጂ', 'ፖሊዮ — ወሊድ'],
      'earlyInfant': [
        'DTaP — 1ኛ (2 ወር)',
        'IPV — 1ኛ',
        'Hib — 1ኛ',
        'PCV13 — 1ኛ',
        'ሮታቫይረስ — 1ኛ'
      ],
      'discovering': [
        'DTaP — 2ኛ (4 ወር)',
        'IPV — 2ኛ',
        'Hib — 2ኛ',
        'PCV13 — 2ኛ',
        'ሮታቫይረስ — 2ኛ',
        'DTaP — 3ኛ',
        'ኢንፍሉዌንዛ — 1ኛ'
      ],
      'explorer': ['ኢንፍሉዌንዛ — ዓመታዊ', 'ሐኪምዎን ያናግሩ'],
      'almostToddler': [
        'MMR — 1ኛ (12 ወር)',
        'ቫሪሴላ — 1ኛ',
        'ሄፓቲቲስ ኤ — 1ኛ',
        'PCV13 — 4ኛ'
      ],
      'firstToddler': [
        'DTaP — 4ኛ (15–18 ወር)',
        'Hib — የመጨረሻ',
        'ሄፓቲቲስ ኤ — 2ኛ',
        'ዓመታዊ ኢንፍሉዌንዛ'
      ],
      'curiousToddler': ['MMR — 2ኛ', 'ሐኪምዎን ያናግሩ'],
      'theTwos': ['ዓመታዊ ኢንፍሉዌንዛ', 'ሄፓቲቲስ ኤ', 'ሐኪምዎን ያናግሩ'],
      'preschooler': [
        'DTaP — 5ኛ',
        'IPV — 4ኛ',
        'MMR — 2ኛ',
        'ቫሪሴላ — 2ኛ',
        'ዓመታዊ ኢንፍሉዌንዛ'
      ],
      'preK': ['ሁሉም 4–6 ዓመት ቦስቶቾ', 'ዓመታዊ ኢንፍሉዌንዛ', 'ሐኪምዎን ያናግሩ'],
      'kindergartener': ['ሁሉም ክትባቶች ሙሉ', 'ዓመታዊ ኢንፍሉዌንዛ', 'ሐኪምዎን ያናግሩ'],
    },
    AppLang.oromic: {
      'newborn': ["Hepatitis B — fudhannaa 1ffaa", "BCG", "OPV — Dhalootaa"],
      'earlyInfant': [
        "DTaP — 1ffaa (ji'a 2)",
        "IPV — 1ffaa",
        "Hib — 1ffaa",
        "PCV13 — 1ffaa",
        "Rotavirus — 1ffaa"
      ],
      'discovering': [
        "DTaP — 2ffaa (ji'a 4)",
        "IPV — 2ffaa",
        "Hib — 2ffaa",
        "PCV13 — 2ffaa",
        "Rotavirus — 2ffaa",
        "DTaP — 3ffaa",
        "Influenza — 1ffaa"
      ],
      'explorer': [
        "Influenza — talaallii waggaa waggaa",
        "Dokitara waliin mirkaneessi"
      ],
      'almostToddler': [
        "MMR — 1ffaa (ji'a 12)",
        "Varicella — 1ffaa",
        "Hepatitis A — 1ffaa",
        "PCV13 — 4ffaa"
      ],
      'firstToddler': [
        "DTaP — 4ffaa (ji'a 15–18)",
        "Hib — dhumaa",
        "Hepatitis A — 2ffaa",
        "Influenza waggaa"
      ],
      'curiousToddler': ["MMR — 2ffaa", "Dokitara waliin mirkaneessi"],
      'theTwos': [
        "Influenza waggaa",
        "Hepatitis A guutuu",
        "Dokitara daa'immaa"
      ],
      'preschooler': [
        "DTaP — 5ffaa (waggaa 4–6)",
        "IPV — 4ffaa",
        "MMR — 2ffaa",
        "Varicella — 2ffaa",
        "Influenza waggaa"
      ],
      'preK': [
        "Hunda booster waggaa 4–6",
        "Influenza waggaa",
        "Dokitara daa'immaa"
      ],
      'kindergartener': [
        "Talaallii seensa mirkaneessi",
        "Influenza waggaa",
        "Dokitara kee gaafadhu"
      ],
    },
  };

  // ─── dev-area titles & details ───────────────────────────────
  static List<String> devTitles(AppLang l, String k) =>
      (_dt[l] ?? _dt[AppLang.english]!)[k] ?? _dt[AppLang.english]![k] ?? [];
  static List<String> devDetails(AppLang l, String k) =>
      (_dd[l] ?? _dd[AppLang.english]!)[k] ?? _dd[AppLang.english]![k] ?? [];

  static final _dt = <AppLang, Map<String, List<String>>>{
    AppLang.english: {
      'newborn': ['Vision', 'Hearing', 'Motor', 'Bonding'],
      'earlyInfant': ['Social', 'Language', 'Motor', 'Cognitive'],
      'discovering': ['Motor', 'Social', 'Sensory', 'Language'],
      'explorer': ['Motor', 'Feeding', 'Emotions', 'Language'],
      'almostToddler': ['Motor', 'Language', 'Cognitive', 'Social'],
      'firstToddler': ['Walking', 'Language', 'Play', 'Emotions'],
      'curiousToddler': [
        'Gross Motor',
        'Fine Motor',
        'Pretend Play',
        'Language'
      ],
      'theTwos': ['Motor', 'Drawing', 'Social', 'Thinking'],
      'preschooler': ['Active Play', 'Pre-Writing', 'Friends', 'Curiosity'],
      'preK': ['Numbers', 'Literacy', 'Self-Care', 'World'],
      'kindergartener': ['Reading', 'Science', 'Empathy', 'Focus'],
    },
    AppLang.amharic: {
      'newborn': ['ዕይታ', 'ሰሚ', 'ሞተር', 'ቅርበት'],
      'earlyInfant': ['ማህበራዊ', 'ቋንቋ', 'ሞተር', 'ማወቅ'],
      'discovering': ['ሞተር', 'ማህበራዊ', 'ስሜት', 'ቋንቋ'],
      'explorer': ['ሞተር', 'ምግብ', 'ስሜት', 'ቋንቋ'],
      'almostToddler': ['ሞተር', 'ቋንቋ', 'ማወቅ', 'ማህበራዊ'],
      'firstToddler': ['መሄድ', 'ቋንቋ', 'ጨዋታ', 'ስሜቶች'],
      'curiousToddler': ['ትልቅ ሞተር', 'ትናንሽ ሞተር', 'ምናብ', 'ቋንቋ'],
      'theTwos': ['ሞተር', 'ስዕል', 'ማህበራዊ', 'አስተሳሰብ'],
      'preschooler': ['ንቁ ጨዋታ', 'ቅድመ-ጽሁፍ', 'ጓደኞች', 'ጉጉት'],
      'preK': ['ቁጥሮች', 'ጽሁፍ', 'ራስ-ክብካቤ', 'ዓለም'],
      'kindergartener': ['ማንበብ', 'ሳይንስ', 'ሐዘነ', 'ትኩረት'],
    },
    AppLang.oromic: {
      'newborn': ["Mul'achuu", "Dhagahuu", "Motor", "Hidha"],
      'earlyInfant': ["Hawaasaa", "Afaan", "Motor", "Xiinxaluu"],
      'discovering': ["Motor", "Hawaasaa", "Xinsammuu", "Afaan"],
      'explorer': ["Motor", "Nyaachisuu", "Miira", "Afaan"],
      'almostToddler': ["Motor", "Afaan", "Xiinxaluu", "Hawaasaa"],
      'firstToddler': ["Deemuu", "Afaan", "Taphataa", "Miirota"],
      'curiousToddler': [
        "Motor Guddaa",
        "Motor Xiqqaa",
        "Taphi Of-fakkeessuu",
        "Afaan"
      ],
      'theTwos': ["Motor", "Kaasuu", "Hawaasaa", "Yaaduu"],
      'preschooler': ["Taphi Ho'aa", "Dura-Barreessuu", "Hiriyoota", "Gaaffii"],
      'preK': ["Lakkoofsa", "Dubbisuu", "Of-Kunuunsu", "Addunyaa"],
      'kindergartener': [
        "Dubbisuu",
        "Saayinsii",
        "Waliigaltee",
        "Xiyyeeffannaa"
      ],
    },
  };

  static final _dd = <AppLang, Map<String, List<String>>>{
    AppLang.english: {
      'newborn': [
        'Focuses 8–12 inches, prefers high contrast',
        'Startles to sounds, calms to familiar voices',
        'Tight fists, rooting reflex',
        'Skin-to-skin builds security'
      ],
      'earlyInfant': [
        'First smiles, responds to familiar faces',
        'Cooing, gurgling, reacts to your voice',
        'Lifts head, tracks objects',
        'Recognizes familiar faces and voices'
      ],
      'discovering': [
        'Reaches, grabs, rolls tummy to back',
        'Laughs aloud, recognizes parents',
        'Explores objects with mouth',
        'Babbles, responds to own name'
      ],
      'explorer': [
        'Sits alone, may crawl, pincer grip',
        'First solid foods, self-feeding begins',
        'Stranger anxiety starts',
        'Babbles "baba", "mama" sounds'
      ],
      'almostToddler': [
        'Stands with support, first steps',
        'First words, understands "no"',
        'Object permanence, cause & effect',
        'Points at objects, shares interests'
      ],
      'firstToddler': [
        'Independent walking, climbing with help',
        'Growing vocabulary',
        'Imitative play, simple puzzles',
        'Tantrums begin, affectionate'
      ],
      'curiousToddler': [
        'Runs, climbs, kicks ball',
        'Scribbles, turns pages, stacks blocks',
        'Imaginative play, copies adults',
        '50+ words, 2-word phrases'
      ],
      'theTwos': [
        'Pedals tricycle, runs well',
        'Draws circles and lines',
        'Parallel play, takes turns',
        'Sorts shapes and colors'
      ],
      'preschooler': [
        'Hops, skips, climbs confidently',
        'Copies letters, draws pictures',
        'Best friends appear, cooperative play',
        'Asks "why" constantly'
      ],
      'preK': [
        'Counts 10+, basic addition',
        'Recognizes letters, writes name',
        'Dresses independently',
        'Knows address and community roles'
      ],
      'kindergartener': [
        'Recognizes sight words',
        'Asks "how" and "why"',
        "Understands others' feelings",
        'Sits for 10–15 min tasks'
      ],
    },
    AppLang.amharic: {
      'newborn': ['8–12 ኢንቺ ፈልጓሉ', 'ጮኸ ሲሰሙ ይደነጋጋሉ', 'ጡጫ ጥቅጥቅ', 'ቆዳ-ለ-ቆዳ ፀጥታ'],
      'earlyInfant': ['ፈገግታዎቹ', 'ቡትቡት ድምፆች', 'ጭንቅላት ያነሳሉ', 'ታወቁ ፊቶች ያውቃሉ'],
      'discovering': ['ዕቃዎች ያዙ', 'ጩህ ሳቁ', 'አፍ ይዳስሳሉ', 'ቡትቡት'],
      'explorer': ['ብቻቸውን ቀምጡ', 'ጠጣር ምግቦች', 'ባዌ ጭንቀት', '"ቡ", "ማ"'],
      'almostToddler': ['ቆሙ', 'ቃሎቹ', 'ዕቃዎች ሲደበቁ ያውቃሉ', 'ዕቃዎች ያቁሟሉ'],
      'firstToddler': ['ብቻቸውን ሄዱ', 'ቃላቱ ያድጋሉ', 'ምናብ ጨዋታ', 'ቅሬታ ይጀምሩ'],
      'curiousToddler': ['ሮጡ፣ ወጡ', 'ሾሩ', 'ምናብ ጨዋታ', '50+ ቃሎች'],
      'theTwos': ['ሶስት ጎማ ጋሉ', 'ክበቦች ሳሉ', 'ትይዩ ጨዋታ', 'ቅርፆች ደረደሩ'],
      'preschooler': ['ዘሉ፣ ዝለሉ', 'ፊደሎች ቀዱ', 'ጓደኞች ያሉ', '"ለምን?" ጠይቁ'],
      'preK': ['10+ ቆጥሩ', 'ፊደሎች ያውቃሉ', 'ብቻቸውን ለብሱ', 'አድራሻ ያውቃሉ'],
      'kindergartener': ['ቃሎች ያዩ', '"ለምን?" ጠይቁ', 'ሌሎች ስሜቶች ይረዳሉ', '10–15 ደቂቃ'],
    },
    AppLang.oromic: {
      'newborn': [
        "Km 8–12 xiyyeeffata",
        "Sagalee irkifata",
        "Harkoonni cufamaa",
        "Qunnamtiin gogaa-gogaatti"
      ],
      'earlyInfant': [
        "Yeeyyii jalqabaa",
        "Sagalee laafaa",
        "Mataa kaasa",
        "Fuula beekamoo"
      ],
      'discovering': [
        "Gaafattu, qabatti",
        "Ol kolfa",
        "Meeshaalee afaan",
        "Babbles"
      ],
      'explorer': [
        "Kophaa taa'a",
        "Nyaata cimaa",
        "Sodaan namaa",
        "'baba', 'haadha'"
      ],
      'almostToddler': [
        "Utubaa qabatee",
        "Jecha jalqabaa",
        "Meeshaaleen dhokatan",
        "Meeshaalee quba"
      ],
      'firstToddler': [
        "Bilisaan deemuu",
        "Jechootni guddata",
        "Taphi of-fakkeessuu",
        "Dallansuu jalqaba"
      ],
      'curiousToddler': [
        "Fiiga, ol baha",
        "Kaasa, fuula garagalcha",
        "Taphi of-fakkeessuu",
        "Jecha 50+"
      ],
      'theTwos': [
        "Baasikiliiti qabaa",
        "Geengoo fi sarara kaasa",
        "Tapha walcinaa",
        "Sararaa fi bifa"
      ],
      'preschooler': [
        "Utaala, tataapha",
        "Qubee haqata",
        "Hiriyaa jaallatu",
        "'Maaliif' gaafata"
      ],
      'preK': [
        "Lakkoofsa 10+",
        "Qubee beeka",
        "Kophaa uffata",
        "Teessuma beeka"
      ],
      'kindergartener': [
        "Jecha mul'ata",
        "'Akkamitti' gaafata",
        "Miira namaatii",
        "Daqiiqaa 10–15"
      ],
    },
  };
}

// ============================================================
// STAGE DEFINITIONS
// ============================================================
const List<_Stage> _allStages = [
  _Stage(
      key: 'newborn',
      name: 'Newborn',
      ageRange: 'Birth – 1 Month',
      emoji: '🐣',
      alertEmoji: '🌙',
      minMonth: 0,
      maxMonth: 0,
      milestones: [
        'Responds to loud sounds',
        'Focuses on faces',
        'Brings hands to face',
        'Moves arms and legs'
      ],
      vaccinations: [
        'Hepatitis B — 1st dose',
        'BCG',
        'OPV — Birth dose'
      ],
      devAreas: [
        _DevArea(
            emoji: '👁️',
            title: 'Vision',
            detail: 'Focuses 8–12 inches',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '👂',
            title: 'Hearing',
            detail: 'Startles to sounds',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '💪',
            title: 'Motor',
            detail: 'Tight fists, rooting reflex',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '❤️',
            title: 'Bonding',
            detail: 'Skin-to-skin contact',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'earlyInfant',
      name: 'Early Infant',
      ageRange: '1 – 3 Months',
      emoji: '🌱',
      alertEmoji: '😊',
      minMonth: 1,
      maxMonth: 2,
      milestones: [
        'First social smile',
        'Follows objects with eyes',
        'Lifts head during tummy time',
        'Coos and makes sounds'
      ],
      vaccinations: [
        'DTaP — 1st dose',
        'IPV — 1st dose',
        'Hib — 1st dose',
        'PCV13 — 1st dose',
        'Rotavirus — 1st dose'
      ],
      devAreas: [
        _DevArea(
            emoji: '😄',
            title: 'Social',
            detail: 'First smiles',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🗣️',
            title: 'Language',
            detail: 'Cooing, gurgling',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🏋️',
            title: 'Motor',
            detail: 'Lifts head',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🧠',
            title: 'Cognitive',
            detail: 'Recognizes faces',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'discovering',
      name: 'Discovering',
      ageRange: '3 – 6 Months',
      emoji: '🌻',
      alertEmoji: '🎈',
      minMonth: 3,
      maxMonth: 5,
      milestones: [
        'Holds head steady',
        'Rolls tummy to back',
        'Reaches and grabs',
        'Laughs and squeals'
      ],
      vaccinations: [
        'DTaP — 2nd & 3rd dose',
        'IPV — 2nd dose',
        'Hib — 2nd dose',
        'PCV13 — 2nd dose',
        'Influenza — 1st'
      ],
      devAreas: [
        _DevArea(
            emoji: '🤲',
            title: 'Motor',
            detail: 'Reaches, grabs, rolls',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '😂',
            title: 'Social',
            detail: 'Laughs aloud',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '👅',
            title: 'Sensory',
            detail: 'Explores with mouth',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '👶',
            title: 'Language',
            detail: 'Babbles',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'explorer',
      name: 'Explorer',
      ageRange: '6 – 9 Months',
      emoji: '🐥',
      alertEmoji: '🥄',
      minMonth: 6,
      maxMonth: 8,
      milestones: [
        'Sits without support',
        'Begins crawling',
        'Picks up objects',
        'Responds to own name'
      ],
      vaccinations: [
        'Influenza — annual',
        'Check catch-up vaccines'
      ],
      devAreas: [
        _DevArea(
            emoji: '🧲',
            title: 'Motor',
            detail: 'Sits alone, may crawl',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🍎',
            title: 'Feeding',
            detail: 'First solid foods',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🎭',
            title: 'Emotions',
            detail: 'Stranger anxiety',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🎵',
            title: 'Language',
            detail: 'Babbles "baba"',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'almostToddler',
      name: 'Almost Toddler',
      ageRange: '9 – 12 Months',
      emoji: '🚀',
      alertEmoji: '🚶',
      minMonth: 9,
      maxMonth: 11,
      milestones: [
        'Pulls to stand',
        'First words "mama" "dada"',
        'Waves bye-bye',
        'Plays peek-a-boo'
      ],
      vaccinations: [
        'MMR — 1st dose',
        'Varicella — 1st dose',
        'Hepatitis A — 1st dose',
        'PCV13 — 4th dose'
      ],
      devAreas: [
        _DevArea(
            emoji: '🦵',
            title: 'Motor',
            detail: 'Stands with support',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '💬',
            title: 'Language',
            detail: 'First words',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🧩',
            title: 'Cognitive',
            detail: 'Object permanence',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🤗',
            title: 'Social',
            detail: 'Points at objects',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'firstToddler',
      name: 'First Toddler',
      ageRange: '12 – 18 Months',
      emoji: '🦋',
      alertEmoji: '🎉',
      minMonth: 12,
      maxMonth: 17,
      milestones: [
        'Walks independently',
        '5–20 words by 18 months',
        'Feeds self',
        'Stacks blocks'
      ],
      vaccinations: [
        'DTaP — 4th dose',
        'Hib — final dose',
        'Hepatitis A — 2nd dose',
        'Annual flu'
      ],
      devAreas: [
        _DevArea(
            emoji: '🚶',
            title: 'Walking',
            detail: 'Independent walking',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '📖',
            title: 'Language',
            detail: 'Growing vocabulary',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🎨',
            title: 'Play',
            detail: 'Imitative play',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '😤',
            title: 'Emotions',
            detail: 'Tantrums begin',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'curiousToddler',
      name: 'Curious Toddler',
      ageRange: '18 – 24 Months',
      emoji: '🔍',
      alertEmoji: '🗣️',
      minMonth: 18,
      maxMonth: 23,
      milestones: [
        'Runs and kicks a ball',
        '50+ words, 2-word phrases',
        'Pretend play',
        'Follows 2-step instructions'
      ],
      vaccinations: [
        'MMR — 2nd dose',
        'Check catch-up immunizations'
      ],
      devAreas: [
        _DevArea(
            emoji: '🏃',
            title: 'Gross Motor',
            detail: 'Runs, climbs, kicks',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '✏️',
            title: 'Fine Motor',
            detail: 'Scribbles, stacks',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🧸',
            title: 'Pretend Play',
            detail: 'Imaginative play',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '💬',
            title: 'Language',
            detail: '50+ words',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'theTwos',
      name: 'The Twos',
      ageRange: '2 – 3 Years',
      emoji: '🌈',
      alertEmoji: '🎭',
      minMonth: 24,
      maxMonth: 35,
      milestones: [
        '3–4 word sentences',
        'Knows name and age',
        'Plays alongside others',
        'Toilet training readiness'
      ],
      vaccinations: [
        'Annual influenza',
        'Hepatitis A complete',
        'Catch-up doses'
      ],
      devAreas: [
        _DevArea(
            emoji: '🚴',
            title: 'Motor',
            detail: 'Pedals tricycle',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🎨',
            title: 'Drawing',
            detail: 'Draws circles',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🤝',
            title: 'Social',
            detail: 'Parallel play',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '💡',
            title: 'Thinking',
            detail: 'Sorts shapes/colors',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'preschooler',
      name: 'Preschooler',
      ageRange: '3 – 4 Years',
      emoji: '🏫',
      alertEmoji: '🎒',
      minMonth: 36,
      maxMonth: 47,
      milestones: [
        'Speaks in full sentences',
        'Draws recognizable people',
        'Hops on one foot',
        'Dresses with minimal help'
      ],
      vaccinations: [
        'DTaP — 5th dose',
        'IPV — 4th dose',
        'MMR — 2nd dose',
        'Varicella — 2nd dose',
        'Annual flu'
      ],
      devAreas: [
        _DevArea(
            emoji: '🏃',
            title: 'Active Play',
            detail: 'Hops, skips, climbs',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '📝',
            title: 'Pre-Writing',
            detail: 'Copies letters',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '👥',
            title: 'Friends',
            detail: 'Cooperative play',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '❓',
            title: 'Curiosity',
            detail: 'Asks "why" constantly',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'preK',
      name: 'Pre-Kindergarten',
      ageRange: '4 – 5 Years',
      emoji: '⭐',
      alertEmoji: '📚',
      minMonth: 48,
      maxMonth: 59,
      milestones: [
        'Counts 10+ objects',
        'Writes own name',
        'Tells detailed stories',
        'Uses scissors'
      ],
      vaccinations: [
        'All 4–6 year boosters',
        'Annual flu',
        'Consult pediatrician'
      ],
      devAreas: [
        _DevArea(
            emoji: '🔢',
            title: 'Numbers',
            detail: 'Counts 10+',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '📖',
            title: 'Literacy',
            detail: 'Recognizes letters',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🏅',
            title: 'Self-Care',
            detail: 'Dresses independently',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🌍',
            title: 'World',
            detail: 'Knows address',
            bgColor: _C.bluePale),
      ]),
  _Stage(
      key: 'kindergartener',
      name: 'Kindergartener',
      ageRange: '5 Years',
      emoji: '🎓',
      alertEmoji: '🌟',
      minMonth: 60,
      maxMonth: 999,
      milestones: [
        'Ready for kindergarten',
        'Reads simple words',
        'Counts to 100+',
        'Shows empathy'
      ],
      vaccinations: [
        'All school-entry vaccines complete',
        'Annual flu',
        'Consult pediatrician'
      ],
      devAreas: [
        _DevArea(
            emoji: '📚',
            title: 'Reading',
            detail: 'Recognizes sight words',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🔬',
            title: 'Science',
            detail: 'Asks "how" and "why"',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🤝',
            title: 'Empathy',
            detail: 'Understands others',
            bgColor: _C.bluePale),
        _DevArea(
            emoji: '🎯',
            title: 'Focus',
            detail: 'Sits 10–15 min tasks',
            bgColor: _C.bluePale),
      ]),
];

// ============================================================
// MAIN SCREEN
// ============================================================
class AfterBirthScreen extends StatefulWidget {
  final DateTime? childBirthDate;
  const AfterBirthScreen({super.key, this.childBirthDate});

  @override
  State<AfterBirthScreen> createState() => _AfterBirthScreenState();
}

class _AfterBirthScreenState extends State<AfterBirthScreen>
    with TickerProviderStateMixin {
  DateTime? _birthDate;
  bool _dateEntered = false;

  late AnimationController _fadeCtrl,
      _slideCtrl,
      _bubbleCtrl,
      _heroCtrl,
      _pulseCtrl;
  late Animation<double> _fadeAnim, _heroScale, _pulseAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _birthDate = widget.childBirthDate;
    _dateEntered = _birthDate != null;

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _bubbleCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _heroCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _heroScale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.elasticOut));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _heroCtrl.forward();
    if (_dateEntered) {
      _fadeCtrl.forward();
      _slideCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _bubbleCtrl.dispose();
    _heroCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  AppLang get _lang => langNotifier.value;
  String _t(String k) => _L.t(_lang, k);

  int get _ageInDays =>
      _birthDate == null ? 0 : DateTime.now().difference(_birthDate!).inDays;

  int get _ageInMonths {
    if (_birthDate == null) return 0;
    final now = DateTime.now();
    int m =
        (now.year - _birthDate!.year) * 12 + (now.month - _birthDate!.month);
    if (now.day < _birthDate!.day) m--;
    return m.clamp(0, 999);
  }

  String get _ageLabel {
    final m = _ageInMonths;
    if (m < 1) return '$_ageInDays ${_t('daysOld')}';
    if (m < 12) return '$m ${m > 1 ? _t('monthsOld') : _t('monthOld')}';
    final y = m ~/ 12;
    final rem = m % 12;
    if (rem == 0) return '$y ${y > 1 ? _t('yrsOld') : _t('yrOld')}';
    return '$y ${_t('yr')} $rem ${_t('mo')}';
  }

  _Stage get _currentStage {
    final m = _ageInMonths;
    for (final s in _allStages)
      if (m >= s.minMonth && m <= s.maxMonth) return s;
    return m > 60 ? _allStages.last : _allStages.first;
  }

  Future<void> _pickDate() async {
    final result = await showDialog<DateTime>(
      context: context,
      barrierColor: _C.blueDeep.withOpacity(0.5),
      builder: (_) => _DatePickerDialog(initialDate: _birthDate, lang: _lang),
    );
    if (result != null) {
      setState(() {
        _birthDate = result;
        _dateEntered = true;
      });
      _fadeCtrl.reset();
      _slideCtrl.reset();
      _fadeCtrl.forward();
      _slideCtrl.forward();
      HapticFeedback.lightImpact();
    }
  }

  // ── BUILD ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Scaffold(
        backgroundColor: C.bgPage,
        body: Stack(children: [
          Positioned.fill(
              child: AnimatedBuilder(
            animation: _bubbleCtrl,
            builder: (_, __) =>
                CustomPaint(painter: _BubblePainter(_bubbleCtrl.value)),
          )),
          SafeArea(
              child: Column(children: [
            FeatureAppBar(
              title: _t('title'),
              trailing: _dateEntered
                  ? [
                      FeatureGlassIconBtn(
                        onTap: _pickDate,
                        child: const Icon(Icons.edit_calendar_outlined,
                            color: C.darkBlue, size: 18),
                      ),
                    ]
                  : null,
            ),
            Expanded(child: _dateEntered ? _buildMainContent() : _buildHero()),
          ])),
        ]),
      ),
    );
  }

  // ── HERO (no date) ────────────────────────────────────────
  Widget _buildHero() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [
        const SizedBox(height: 30),
        ScaleTransition(
          scale: _heroScale,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB3E5FC),
                  Color(0xFF81D4FA),
                  Color(0xFF4FC3F7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: _C.bluePrimary.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 15)),
                BoxShadow(
                    color: _C.blueVibrant.withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 5),
              ],
            ),
            child:
                const Center(child: Text('👶', style: TextStyle(fontSize: 85))),
          ),
        ),
        const SizedBox(height: 28),
        Text(_t('trackJourney'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: _C.blueDeep,
                height: 1.2,
                letterSpacing: -0.3)),
        const SizedBox(height: 14),
        Text(_t('trackDesc'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, color: _C.textMedium, height: 1.65)),
        const SizedBox(height: 28),
        Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _pill('🧠', _t('brainDev'), const Color(0xFFE3F2FD)),
              _pill('🍼', _t('feedingGuide'), const Color(0xFFE0F7FA)),
              _pill('💉', _t('vaccination'), const Color(0xFFE8EAF6)),
              _pill('📏', _t('growthTracking'), const Color(0xFFF3E5F5)),
              _pill('🎯', _t('milestones'), const Color(0xFFE8F5E9)),
              _pill('❤️', _t('healthTips'), const Color(0xFFFCE4EC)),
            ]),
        const SizedBox(height: 36),
        GestureDetector(
          onTap: _pickDate,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) => Transform.scale(
                scale: _pulseAnim.value * 0.98 + 0.02, child: child),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_C.blueDeep, _C.bluePrimary, _C.blueVibrant]),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: _C.bluePrimary.withOpacity(0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10)),
                  BoxShadow(
                      color: _C.blueVibrant.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 2),
                ],
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.cake_outlined, color: _C.white, size: 22),
                const SizedBox(width: 12),
                Flexible(
                    child: Text(_t('enterBirthDate'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _C.white,
                            letterSpacing: 0.3),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white70, size: 18),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ]),
    );
  }

  Widget _pill(String emoji, String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _C.blueSoft.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 7),
        Flexible(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _C.blueDeep),
                overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  // ── MAIN CONTENT ──────────────────────────────────────────
  Widget _buildMainContent() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildAgeCard(),
            const SizedBox(height: 14),
            _buildMilestoneCard(),
            const SizedBox(height: 14),
            _buildAlertCard(),
            const SizedBox(height: 14),
            _buildDevAreas(),
            const SizedBox(height: 14),
            _buildVaxCard(),
            const SizedBox(height: 14),
            _buildNutritionCard(),
            const SizedBox(height: 14),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  // ── AGE PROGRESS CARD ─────────────────────────────────────
  Widget _buildAgeCard() {
    final months = _ageInMonths;
    final stage = _currentStage;
    final progress = (months / 60).clamp(0.0, 1.0);
    final yearsComplete = months ~/ 12;
    final bd = _birthDate!;
    final bdStr = '${bd.day}/${bd.month}/${bd.year}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0077B6), Color(0xFF0096C7), Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
              color: _C.blueDeep.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 10)),
          BoxShadow(
              color: _C.blueVibrant.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 2),
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
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Text('⭐ ${_SL.name(_lang, stage.key)}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 12),
                Text(_t('myChild'),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                Text(_ageLabel,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(children: [
                  const Icon(Icons.cake_outlined,
                      size: 12, color: Colors.white60),
                  const SizedBox(width: 5),
                  Flexible(
                      child: Text('${_t('born')}: $bdStr',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                          overflow: TextOverflow.ellipsis)),
                ]),
              ])),
          const SizedBox(width: 8),
          Text(stage.emoji, style: const TextStyle(fontSize: 60)),
        ]),
        const SizedBox(height: 20),
        // Progress bar
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
                child: Text(_t('growthJourney'),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text(
                months < 60
                    ? '${months}${_t('mo')} / 5${_t('yr')}'
                    : _t('yearsReached'),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis),
          ]),
          const SizedBox(height: 10),
          LayoutBuilder(
              builder: (ctx, c) => Stack(children: [
                    Container(
                        height: 12,
                        width: c.maxWidth,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10))),
                    Container(
                        height: 12,
                        width: c.maxWidth * progress,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFCAF0F8)]),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 6)
                            ])),
                  ])),
          const SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final label = i == 0 ? _t('birth') : '$i${_t('yr')}';
                return Flexible(
                    child: Text(label,
                        style: TextStyle(
                            fontSize: 10,
                            color: i <= yearsComplete
                                ? Colors.white
                                : Colors.white38,
                            fontWeight: i <= yearsComplete
                                ? FontWeight.bold
                                : FontWeight.normal),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis));
              })),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
              child: _stat('📅', _t('stage'),
                  _SL.name(_lang, stage.key).split(' ').first)),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(child: _stat('📆', _t('month'), '${months}${_t('mo')}')),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
              child: _stat(
                  '🎯', _t('milestoneCount'), '${stage.milestones.length}')),
        ]),
      ]),
    );
  }

  Widget _stat(String emoji, String label, String value) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 3),
      Text(label,
          style: const TextStyle(
              fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center),
      Text(value,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center),
    ]);
  }

  // ── MILESTONE CARD ────────────────────────────────────────
  Widget _buildMilestoneCard() {
    final stage = _currentStage;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _C.cardGlass,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.blueSoft.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(stage.emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_SL.name(_lang, stage.key),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _C.blueDeep),
                    overflow: TextOverflow.ellipsis),
                Text(stage.ageRange,
                    style: const TextStyle(
                        fontSize: 12,
                        color: _C.textMedium,
                        fontWeight: FontWeight.w500)),
              ])),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [_C.bluePrimary, _C.blueVibrant]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: _C.bluePrimary.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Text(_t('current'),
                style: const TextStyle(
                    fontSize: 10,
                    color: _C.white,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
            height: 1,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [_C.blueSoft, Colors.transparent]))),
        const SizedBox(height: 14),
        _secLabel(_t('whatToExpect')),
        const SizedBox(height: 8),
        Text(_SL.desc(_lang, stage.key),
            style: const TextStyle(
                fontSize: 13, color: _C.textMedium, height: 1.65)),
        const SizedBox(height: 14),
        _secLabel(_t('milestoneCount')),
        const SizedBox(height: 10),
        ..._SL.milestones(_lang, stage.key).map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [_C.bluePrimary, _C.blueVibrant]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 11),
                ),
                const SizedBox(width: 9),
                Expanded(
                    child: Text(m,
                        style: const TextStyle(
                            fontSize: 13, color: _C.textDark, height: 1.5))),
              ]),
            )),
      ]),
    );
  }

  Widget _secLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: _C.blueDeep,
          letterSpacing: 0.2));

  // ── ALERT CARD ────────────────────────────────────────────
  Widget _buildAlertCard() {
    final stage = _currentStage;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F6FF), Color(0xFFEEFAFF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.blueSoft.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
                color: _C.bluePrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('🔔', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(_t('rightNow'),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _C.blueDeep)),
            ]),
          ),
          const SizedBox(height: 10),
          Text(_SL.alert(_lang, stage.key),
              style: const TextStyle(
                  fontSize: 13, color: _C.textDark, height: 1.6)),
        ])),
        const SizedBox(width: 10),
        Text(stage.alertEmoji, style: const TextStyle(fontSize: 40)),
      ]),
    );
  }

  // ── DEV AREAS ─────────────────────────────────────────────
  Widget _buildDevAreas() {
    final stage = _currentStage;
    final titles = _SL.devTitles(_lang, stage.key);
    final details = _SL.devDetails(_lang, stage.key);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(_t('devAreas'),
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark))),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.25,
        children: List.generate(stage.devAreas.length, (i) {
          final a = stage.devAreas[i];
          return _devCard(_DevArea(
            emoji: a.emoji,
            title: i < titles.length ? titles[i] : a.title,
            detail: i < details.length ? details[i] : a.detail,
            bgColor: a.bgColor,
          ));
        }),
      ),
    ]);
  }

  Widget _devCard(_DevArea a) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: a.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.blueSoft.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(a.emoji, style: const TextStyle(fontSize: 28)),
        const Spacer(),
        Text(a.title,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, color: _C.blueDeep),
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 3),
        Text(a.detail,
            style: const TextStyle(
                fontSize: 11, color: _C.textMedium, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  // ── VACCINATION CARD ──────────────────────────────────────
  Widget _buildVaxCard() {
    final vax = _SL.vaccines(_lang, _currentStage.key);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.cardGlass,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.blueSoft.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7)]),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Text('💉', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_t('vaccinations'),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _C.textDark),
                    overflow: TextOverflow.ellipsis),
                Text(_t('atThisStage'),
                    style: const TextStyle(fontSize: 12, color: _C.textMedium)),
              ])),
        ]),
        const SizedBox(height: 14),
        if (vax.isEmpty)
          Text(_t('noVaccines'),
              style: const TextStyle(fontSize: 13, color: _C.textMedium))
        else
          ...vax.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [_C.bluePrimary, _C.blueVibrant]),
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(v,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: _C.textDark,
                                  height: 1.4))),
                    ]),
              )),
      ]),
    );
  }

  // ── NUTRITION CARD ────────────────────────────────────────
  Widget _buildNutritionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.blueSoft.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: _C.bluePrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFB2EBF2), Color(0xFF80DEEA)]),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Text('🥗', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_t('nutritionFeeding'),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _C.textDark),
                    overflow: TextOverflow.ellipsis),
                Text(_t('guidanceStage'),
                    style: const TextStyle(fontSize: 12, color: _C.textMedium)),
              ])),
        ]),
        const SizedBox(height: 14),
        Text(_SL.nutrition(_lang, _currentStage.key),
            style: const TextStyle(
                fontSize: 13, color: _C.textDark, height: 1.65)),
      ]),
    );
  }

  // ── UPCOMING TIMELINE ─────────────────────────────────────
  Widget _buildTimeline() {
    final months = _ageInMonths;
    final upcoming =
        _allStages.where((s) => s.minMonth > months).take(3).toList();
    if (upcoming.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(_t('comingUpNext'),
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark))),
      ...upcoming.asMap().entries.map((e) {
        final i = e.key;
        final stage = e.value;
        final isFirst = i == 0;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 44,
              child: Column(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isFirst
                        ? const LinearGradient(
                            colors: [_C.bluePrimary, _C.blueVibrant])
                        : null,
                    color: isFirst ? null : _C.bluePale,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isFirst ? _C.blueVibrant : _C.grayBorder,
                        width: 2),
                    boxShadow: isFirst
                        ? [
                            BoxShadow(
                                color: _C.bluePrimary.withOpacity(0.35),
                                blurRadius: 10)
                          ]
                        : null,
                  ),
                  child: Center(
                      child: Text(stage.emoji,
                          style: const TextStyle(fontSize: 20))),
                ),
                if (i < upcoming.length - 1)
                  Container(
                      width: 2,
                      height: 56,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [_C.blueSoft, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter))),
              ])),
          const SizedBox(width: 13),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isFirst
                  ? const LinearGradient(
                      colors: [Color(0xFFE3F6FF), Color(0xFFF0FBFF)])
                  : null,
              color: isFirst ? null : _C.cardGlass,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color:
                      isFirst ? _C.blueSoft : _C.grayBorder.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                    color: _C.bluePrimary.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(_SL.name(_lang, stage.key),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isFirst ? _C.blueDeep : _C.textDark),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                Text(stage.ageRange,
                    style: const TextStyle(
                        fontSize: 11,
                        color: _C.textMedium,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis),
              ]),
              const SizedBox(height: 5),
              Text(_SL.milestones(_lang, stage.key).take(2).join(' • '),
                  style: const TextStyle(
                      fontSize: 12, color: _C.textMedium, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ]),
          )),
        ]);
      }),
    ]);
  }
}

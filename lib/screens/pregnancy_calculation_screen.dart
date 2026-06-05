import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────────────────────
// COLOR PALETTE  (light-blue theme)
// ─────────────────────────────────────────────────────────────────────────────
class BC {
  // Primary blues
  static const Color primary = Color(0xFF1A6FD8);
  static const Color primaryLight = Color(0xFF3D8EF0);
  static const Color primaryDeep = Color(0xFF0D4FA0);
  static const Color primaryFrost = Color(0xFFE8F2FF);
  static const Color primaryPale = Color(0xFFCFE3FF);

  // Gradients
  static const Color gradStart = Color(0xFF1565C0);
  static const Color gradMid = Color(0xFF1E88E5);
  static const Color gradEnd = Color(0xFF42A5F5);
  static const Color gradLightEnd = Color(0xFF90CAF9);

  // Accents
  static const Color coral = Color(0xFFFF6B6B);
  static const Color coralLight = Color(0xFFFFEEEE);
  static const Color lavender = Color(0xFF7C6FCD);
  static const Color lavenderLight = Color(0xFFF0EEFF);
  static const Color mint = Color(0xFF26A69A);
  static const Color mintLight = Color(0xFFE0F7F4);
  static const Color gold = Color(0xFFF59E0B);
  static const Color goldLight = Color(0xFFFFF8E1);
  static const Color notify = Color(0xFF0288D1);
  static const Color notifyLight = Color(0xFFE1F5FE);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF4F8FF);
  static const Color grayBg = Color(0xFFF0F4FF);
  static const Color border = Color(0xFFCDD8EE);
  static const Color borderLight = Color(0xFFE3EAF8);
  static const Color textDark = Color(0xFF0D1B3E);
  static const Color textMid = Color(0xFF4A5E85);
  static const Color textLight = Color(0xFF8CA0C4);

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);
}

// ─────────────────────────────────────────────────────────────────────────────
// ETHIOPIAN CALENDAR UTILITIES
// ─────────────────────────────────────────────────────────────────────────────
class EthiopianCalendar {
  static const List<String> monthsEn = [
    'Meskerem',
    'Tikmt',
    'Hidar',
    'Tahsas',
    'Ter',
    'Yekatit',
    'Megabit',
    'Miyazya',
    'Ginbot',
    'Sene',
    'Hamle',
    'Nehase',
    'Pagume',
  ];
  static const List<String> monthsAm = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ጉንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  static String toEthiopian(DateTime date,
      {bool amharic = false, bool oromic = false}) {
    final jdn = _gregorianToJDN(date.year, date.month, date.day);
    final r = jdn - 1724221;
    int etYear = ((r / 365.25).floor()) + 1;
    int base = _ethYearToJDN(etYear);
    if (jdn < base) etYear--;
    base = _ethYearToJDN(etYear);
    final dayInYear = jdn - base;
    final etMonth = math.min((dayInYear ~/ 30) + 1, 13);
    final etDay = dayInYear - 30 * (etMonth - 1) + 1;
    final months = amharic ? monthsAm : monthsEn;
    final mName = (etMonth >= 1 && etMonth <= 13) ? months[etMonth - 1] : '?';
    return '$etDay $mName $etYear';
  }

  static DateTime toGregorian(int etYear, int etMonth, int etDay) {
    final jdn = _ethYearToJDN(etYear) + 30 * (etMonth - 1) + etDay - 1;
    return _jdnToGregorian(jdn);
  }

  static bool isLeapYear(int etYear) => etYear % 4 == 3;

  static int daysInMonth(int etYear, int etMonth) {
    if (etMonth == 13) return isLeapYear(etYear) ? 6 : 5;
    return 30;
  }

  static int _gregorianToJDN(int y, int m, int d) {
    final a = (14 - m) ~/ 12;
    final yy = y + 4800 - a;
    final mm = m + 12 * a - 3;
    return d +
        (153 * mm + 2) ~/ 5 +
        365 * yy +
        yy ~/ 4 -
        yy ~/ 100 +
        yy ~/ 400 -
        32045;
  }

  static int _ethYearToJDN(int etYear) =>
      1724221 + 365 * (etYear - 1) + (etYear - 1) ~/ 4;

  static DateTime _jdnToGregorian(int jdn) {
    final a = jdn + 32044;
    final b = (4 * a + 3) ~/ 146097;
    final c = a - (146097 * b) ~/ 4;
    final d2 = (4 * c + 3) ~/ 1461;
    final e = c - (1461 * d2) ~/ 4;
    final m2 = (5 * e + 2) ~/ 153;
    final day = e - (153 * m2 + 2) ~/ 5 + 1;
    final month = m2 + 3 - 12 * (m2 ~/ 10);
    final year = 100 * b + d2 - 4800 + m2 ~/ 10;
    return DateTime(year, month, day);
  }

  static (int year, int month, int day) fromGregorian(DateTime date) {
    final jdn = _gregorianToJDN(date.year, date.month, date.day);
    final r = jdn - 1724221;
    int etYear = ((r / 365.25).floor()) + 1;
    int base = _ethYearToJDN(etYear);
    if (jdn < base) etYear--;
    base = _ethYearToJDN(etYear);
    final dayInYear = jdn - base;
    final etMonth = math.min((dayInYear ~/ 30) + 1, 13);
    final etDay = dayInYear - 30 * (etMonth - 1) + 1;
    return (etYear, etMonth, etDay);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREGNANCY RESULT & CALCULATOR
// ─────────────────────────────────────────────────────────────────────────────
class PregnancyResult {
  final DateTime edd;
  final DateTime lnmpEstimate;
  final int gaWeeks;
  final int gaDays;
  final int daysToEdd;
  final int trimester;
  final double progressPercent;

  PregnancyResult({
    required this.edd,
    required this.lnmpEstimate,
    required this.gaWeeks,
    required this.gaDays,
    required this.daysToEdd,
    required this.trimester,
    required this.progressPercent,
  });
}

class PregnancyCalculator {
  static DateTime _addMonths(DateTime d, int m) {
    int month = d.month + m;
    int year = d.year + (month - 1) ~/ 12;
    month = ((month - 1) % 12) + 1;
    final day = math.min(d.day, DateTime(year, month + 1, 0).day);
    return DateTime(year, month, day);
  }

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  static PregnancyResult? fromLNMP(DateTime lnmp) {
    final today = _today();
    if (lnmp.isAfter(today)) return null;
    final edd = _addMonths(lnmp, 9).add(const Duration(days: 7));
    return _build(edd, lnmp, today);
  }

  static PregnancyResult? fromUltrasound(
      DateTime scanDate, int gaWeeksAtScan, int gaDaysAtScan) {
    final today = _today();
    if (scanDate.isAfter(today)) return null;
    if (gaWeeksAtScan < 1 || gaWeeksAtScan > 39) return null;
    final gaAtScanDays = gaWeeksAtScan * 7 + gaDaysAtScan;
    final lnmpEst = scanDate.subtract(Duration(days: gaAtScanDays));
    final edd = lnmpEst.add(const Duration(days: 280));
    return _build(edd, lnmpEst, today);
  }

  static PregnancyResult? fromIVF(DateTime transferDate, int embryoAgeDays) {
    final today = _today();
    if (transferDate.isAfter(today)) return null;
    final edd = transferDate.add(Duration(days: 38 * 7 - embryoAgeDays));
    final lnmpEst = transferDate.subtract(Duration(days: 14 + embryoAgeDays));
    return _build(edd, lnmpEst, today);
  }

  static PregnancyResult _build(DateTime edd, DateTime lnmp, DateTime today) {
    final daysPreg = today.difference(lnmp).inDays;
    final gaW = daysPreg ~/ 7;
    final gaD = daysPreg % 7;
    final daysLeft = edd.difference(today).inDays;
    final tri = gaW < 14
        ? 1
        : gaW < 27
            ? 2
            : 3;
    final pct = (daysPreg / 280.0).clamp(0.0, 1.0);
    return PregnancyResult(
      edd: edd,
      lnmpEstimate: lnmp,
      gaWeeks: gaW,
      gaDays: gaD,
      daysToEdd: daysLeft,
      trimester: tri,
      progressPercent: pct,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BUBBLE PAINTER  (blue tones)
// ─────────────────────────────────────────────────────────────────────────────
class _BubblePainter extends CustomPainter {
  final double animValue;
  _BubblePainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      _Bubble(0.12, 0.08, 60, BC.primaryFrost.withOpacity(0.55)),
      _Bubble(0.85, 0.14, 90, BC.primaryPale.withOpacity(0.30)),
      _Bubble(0.05, 0.55, 45, BC.primaryFrost.withOpacity(0.70)),
      _Bubble(0.92, 0.62, 70, BC.primaryPale.withOpacity(0.35)),
      _Bubble(0.45, 0.88, 55, BC.primaryFrost.withOpacity(0.40)),
      _Bubble(0.70, 0.35, 40, BC.lavender.withOpacity(0.08)),
      _Bubble(0.25, 0.30, 35, BC.mint.withOpacity(0.08)),
    ];
    for (final b in bubbles) {
      final dx = math.sin(animValue * 2 * math.pi + b.phase) * 8;
      final dy = math.cos(animValue * 2 * math.pi + b.phase) * 6;
      canvas.drawCircle(
        Offset(size.width * b.x + dx, size.height * b.y + dy),
        b.r,
        Paint()
          ..color = b.color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => old.animValue != animValue;
}

class _Bubble {
  final double x, y, r, phase;
  final Color color;
  _Bubble(this.x, this.y, this.r, this.color) : phase = x * 6.28;
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class PregnancyCalculationScreen extends StatefulWidget {
  const PregnancyCalculationScreen({super.key});

  @override
  State<PregnancyCalculationScreen> createState() =>
      _PregnancyCalculationScreenState();
}

class _PregnancyCalculationScreenState extends State<PregnancyCalculationScreen>
    with TickerProviderStateMixin {
  int _method = 0;

  DateTime? _lnmpDate;
  DateTime? _usDate;
  final _usWeeksCtrl = TextEditingController();
  final _usDaysCtrl = TextEditingController();
  DateTime? _ivfDate;
  int _embryoDay = 5;

  PregnancyResult? _result;
  String? _errorMsg;
  bool _showResult = false;
  bool _showFormula = false;
  bool _notifySet = false;

  late AnimationController _bgAnim;
  late AnimationController _headerAnim;
  late AnimationController _resultAnim;
  late AnimationController _methodAnim;
  late AnimationController _btnAnim;
  late AnimationController _pulseAnim;

  late Animation<double> _headerScale;
  late Animation<double> _headerFade;
  late Animation<double> _resultFade;
  late Animation<Offset> _resultSlide;
  late Animation<double> _btnScale;
  late Animation<double> _pulseScale;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    _bgAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();

    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _headerScale = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _headerAnim, curve: Curves.elasticOut));
    _headerFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut));

    _methodAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _resultAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _resultFade = CurvedAnimation(parent: _resultAnim, curve: Curves.easeOut);
    _resultSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _resultAnim, curve: Curves.easeOutBack));

    _btnAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _btnScale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _btnAnim, curve: Curves.easeInOut));

    _pulseAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _pulseAnim, curve: Curves.easeInOut));

    _headerAnim.forward();
    Future.delayed(
        const Duration(milliseconds: 300), () => _methodAnim.forward());
  }

  @override
  void dispose() {
    _bgAnim.dispose();
    _headerAnim.dispose();
    _resultAnim.dispose();
    _methodAnim.dispose();
    _btnAnim.dispose();
    _pulseAnim.dispose();
    _usWeeksCtrl.dispose();
    _usDaysCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  AppLang get lang => langNotifier.value;
  String s(String key) => LS.get(lang, key);

  Future<DateTime?> _showCalendarPicker(DateTime? initial) async {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _CalendarPickerSheet(initialDate: initial ?? DateTime.now()),
    );
  }

  void _calculate() {
    setState(() => _errorMsg = null);
    HapticFeedback.lightImpact();
    PregnancyResult? res;

    if (_method == 0) {
      if (_lnmpDate == null) {
        setState(() => _errorMsg = s('selectDate'));
        return;
      }
      res = PregnancyCalculator.fromLNMP(_lnmpDate!);
      if (res == null) {
        setState(() => _errorMsg = s('dateFutureError'));
        return;
      }
    } else if (_method == 1) {
      if (_usDate == null || _usWeeksCtrl.text.isEmpty) {
        setState(() => _errorMsg = s('fillAllFields'));
        return;
      }
      final w = int.tryParse(_usWeeksCtrl.text) ?? 0;
      final d = int.tryParse(_usDaysCtrl.text) ?? 0;
      if (w < 1 || w > 39) {
        setState(() => _errorMsg = s('weeksRangeError'));
        return;
      }
      if (d < 0 || d > 6) {
        setState(() => _errorMsg = s('daysRangeError'));
        return;
      }
      res = PregnancyCalculator.fromUltrasound(_usDate!, w, d);
      if (res == null) {
        setState(() => _errorMsg = s('scanFutureError'));
        return;
      }
    } else {
      if (_ivfDate == null) {
        setState(() => _errorMsg = s('selectTransferDate'));
        return;
      }
      res = PregnancyCalculator.fromIVF(_ivfDate!, _embryoDay);
      if (res == null) {
        setState(() => _errorMsg = s('transferFutureError'));
        return;
      }
    }

    setState(() {
      _result = res;
      _showResult = true;
      _notifySet = false;
    });
    HapticFeedback.mediumImpact();
    _resultAnim.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic);
      }
    });
  }

  void _reset() {
    HapticFeedback.lightImpact();
    setState(() {
      _showResult = false;
      _result = null;
      _errorMsg = null;
      _lnmpDate = null;
      _usDate = null;
      _ivfDate = null;
      _notifySet = false;
      _usWeeksCtrl.clear();
      _usDaysCtrl.clear();
    });
    _resultAnim.reset();
    _scrollCtrl.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void _toggleNotify() {
    HapticFeedback.mediumImpact();
    setState(() => _notifySet = !_notifySet);
    if (_notifySet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Text('🔔', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Flexible(
                child: Text(
              s('reminderSet'),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            )),
          ]),
          backgroundColor: BC.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Listen to langNotifier so UI rebuilds on language change
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: BC.offWhite,
          body: Stack(children: [
            // Animated background
            Positioned.fill(
                child: AnimatedBuilder(
              animation: _bgAnim,
              builder: (_, __) =>
                  CustomPaint(painter: _BubblePainter(_bgAnim.value)),
            )),
            // Gradient top wash
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 320,
              child: Container(
                  decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFCCE5FF), Color(0x00CCE5FF)],
                ),
              )),
            ),
            SafeArea(
                child: Column(children: [
              _buildAppBar(),
              Expanded(
                  child: CustomScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildMethodSelector()),
                  SliverToBoxAdapter(child: _buildInputPanel()),
                  if (_errorMsg != null)
                    SliverToBoxAdapter(child: _buildError()),
                  SliverToBoxAdapter(child: _buildCalcButton()),
                  SliverToBoxAdapter(child: _buildFormulaCard()),
                  if (_showResult && _result != null)
                    SliverToBoxAdapter(child: _buildResultCard()),
                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              )),
            ])),
          ]),
        );
      },
    );
  }

  // ── APP BAR ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        // Back button
        _GlassBtn(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: BC.primaryDeep, size: 18),
        ),
        const SizedBox(width: 10),
        // ── LOGO added here ──────────────────────────────────────────────────
        _AppLogo(size: 34),
        const SizedBox(width: 8),
        // Title – flexible so it never overflows
        Expanded(
            child: Text(
          s('pregnancyCalcTitle'),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BC.textDark,
              letterSpacing: -0.3),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )),
        const SizedBox(width: 8),
        // Language indicator (read-only, set from home screen)
        ValueListenableBuilder<AppLang>(
          valueListenable: langNotifier,
          builder: (_, lang, __) {
            const flags = {
              AppLang.english: '🌍',
              AppLang.amharic: '🇪🇹',
              AppLang.oromic: '🌿'
            };
            const labels = {
              AppLang.english: 'EN',
              AppLang.amharic: 'አማ',
              AppLang.oromic: 'OR'
            };
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: BC.primaryFrost,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BC.border),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(flags[lang]!, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 3),
                Text(labels[lang]!,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: BC.primaryDeep)),
              ]),
            );
          },
        ),
      ]),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: ScaleTransition(
        scale: _headerScale,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BC.gradStart, BC.gradMid, BC.gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: BC.primaryDeep.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10)),
                BoxShadow(
                    color: BC.primary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s('findDueDate'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(s('gregorianEthiopian'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              )),
              const SizedBox(width: 12),
              _AnimatedBabyIcon(),
            ]),
          ),
        ),
      ),
    );
  }

  // ── METHOD SELECTOR ────────────────────────────────────────────────────────
  Widget _buildMethodSelector() {
    final methods = [
      ('🩸', s('lastPeriod'), BC.coral, BC.coralLight),
      ('📋', s('ultrasound'), BC.primary, BC.primaryFrost),
      ('💉', s('ivfTransfer'), BC.lavender, BC.lavenderLight),
    ];
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(parent: _methodAnim, curve: Curves.easeOut)),
      child: FadeTransition(
        opacity: _methodAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(s('chooseMethod'),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: BC.textMid,
                      letterSpacing: 0.2)),
            ),
            Row(
                children: List.generate(3, (index) {
              final isActive = _method == index;
              return Expanded(
                  child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _method = index;
                    _showResult = false;
                    _errorMsg = null;
                    _resultAnim.reset();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  transform: isActive
                      ? (Matrix4.identity()..scale(1.03))
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: isActive ? methods[index].$4 : BC.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? methods[index].$3.withOpacity(0.6)
                          : BC.border,
                      width: isActive ? 2 : 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                                color: methods[index].$3.withOpacity(0.22),
                                blurRadius: 12,
                                offset: const Offset(0, 4))
                          ]
                        : [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4)
                          ],
                  ),
                  child: Column(children: [
                    Text(methods[index].$1,
                        style: TextStyle(fontSize: isActive ? 24 : 20)),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        methods[index].$2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isActive ? methods[index].$3 : BC.textLight,
                            letterSpacing: 0.1),
                      ),
                    ),
                  ]),
                ),
              ));
            })),
          ]),
        ),
      ),
    );
  }

  // ── INPUT PANEL ────────────────────────────────────────────────────────────
  Widget _buildInputPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                    .animate(anim),
            child: child,
          ),
        ),
        child: _GlassCard(
          key: ValueKey(_method),
          child: _method == 0
              ? _lnmpPanel()
              : _method == 1
                  ? _usPanel()
                  : _ivfPanel(),
        ),
      ),
    );
  }

  Widget _lnmpPanel() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _infoBox('🩸', s('lnmpDesc'), BC.coral, BC.coralLight),
        const SizedBox(height: 18),
        _fieldLabel(s('firstDayPeriod')),
        const SizedBox(height: 8),
        _datePicker(_lnmpDate, (d) => setState(() => _lnmpDate = d),
            () => setState(() => _lnmpDate = null)),
      ]);

  Widget _usPanel() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _infoBox('📋', s('usDesc'), BC.primary, BC.primaryFrost),
        const SizedBox(height: 18),
        _fieldLabel(s('usDate')),
        const SizedBox(height: 8),
        _datePicker(_usDate, (d) => setState(() => _usDate = d),
            () => setState(() => _usDate = null)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              flex: 2,
              child: _numberField(_usWeeksCtrl, s('babyAgeWeeks'), max: 39)),
          const SizedBox(width: 12),
          Expanded(child: _numberField(_usDaysCtrl, s('extraDays'), max: 6)),
        ]),
      ]);

  Widget _ivfPanel() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _infoBox('💉', s('ivfDesc'), BC.lavender, BC.lavenderLight),
        const SizedBox(height: 18),
        _fieldLabel(s('ivfDate')),
        const SizedBox(height: 8),
        _datePicker(_ivfDate, (d) => setState(() => _ivfDate = d),
            () => setState(() => _ivfDate = null)),
        const SizedBox(height: 16),
        _fieldLabel(s('embryoAge')),
        const SizedBox(height: 10),
        Row(children: [
          _embryoChip(3, s('day3Embryo')),
          const SizedBox(width: 10),
          _embryoChip(5, s('day5Embryo')),
        ]),
      ]);

  Widget _embryoChip(int day, String label) {
    final isActive = _embryoDay == day;
    return Expanded(
        child: GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _embryoDay = day);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isActive ? BC.primaryFrost : BC.grayBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isActive ? BC.primary : BC.border,
              width: isActive ? 2 : 1),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? BC.primary : BC.textLight)),
      ),
    ));
  }

  Widget _infoBox(String icon, String text, Color accent, Color bg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12,
                    color: accent.withOpacity(0.85),
                    height: 1.55,
                    fontWeight: FontWeight.w500))),
      ]),
    );
  }

  Widget _fieldLabel(String label) => Text(label,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: BC.textDark,
          letterSpacing: 0.1));

  Widget _datePicker(
      DateTime? value, Function(DateTime) onSelect, VoidCallback onClear) {
    return GestureDetector(
      onTap: () async {
        final d = await _showCalendarPicker(value);
        if (d != null) onSelect(d);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: value != null ? BC.primaryFrost : BC.grayBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value != null ? BC.primary.withOpacity(0.4) : BC.border,
            width: value != null ? 1.5 : 1,
          ),
        ),
        child: Row(children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              value != null
                  ? Icons.check_circle_rounded
                  : Icons.calendar_month_rounded,
              key: ValueKey(value != null),
              size: 20,
              color: value != null ? BC.primary : BC.textLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            value != null ? _fmtDate(value) : s('selectDate'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 14,
                fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                color: value != null ? BC.primaryDeep : BC.textLight),
          )),
          if (value != null)
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: BC.textLight.withOpacity(0.15),
                    shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: BC.textLight),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _numberField(TextEditingController ctrl, String label,
      {int max = 39}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: BC.textDark)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: max == 6 ? '0–6' : s('exampleWeeks'),
          hintStyle: const TextStyle(fontSize: 13, color: BC.textLight),
          filled: true,
          fillColor: BC.grayBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BC.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BC.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: BC.primary, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
    ]);
  }

  // ── ERROR ──────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
                offset: Offset(0, (1 - v) * 10), child: child)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BC.errorLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BC.error.withOpacity(0.2)),
          ),
          child: Row(children: [
            const Text('⚠️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
                child: Text(_errorMsg!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: BC.error,
                        fontWeight: FontWeight.w500))),
          ]),
        ),
      ),
    );
  }

  // ── CALCULATE BUTTON ───────────────────────────────────────────────────────
  Widget _buildCalcButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ScaleTransition(
        scale: _showResult ? const AlwaysStoppedAnimation(1.0) : _pulseScale,
        child: ScaleTransition(
          scale: _btnScale,
          child: GestureDetector(
            onTapDown: (_) => _btnAnim.forward(),
            onTapUp: (_) {
              _btnAnim.reverse();
              _showResult ? _reset() : _calculate();
            },
            onTapCancel: () => _btnAnim.reverse(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _showResult
                      ? [BC.textLight, BC.textMid]
                      : [BC.gradStart, BC.gradEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: _showResult
                    ? []
                    : [
                        BoxShadow(
                            color: BC.primary.withOpacity(0.40),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
              ),
              child: Center(
                  child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _showResult
                      ? '🔄  ${s('calculateAgain')}'
                      : '✨  ${s('calculate')}',
                  key: ValueKey(_showResult),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  // ── FORMULA CARD ───────────────────────────────────────────────────────────
  Widget _buildFormulaCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => setState(() => _showFormula = !_showFormula),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BC.primaryFrost,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BC.primaryPale),
          ),
          child: Column(children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: BC.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('🔬', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(s('howCalcWorks'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BC.primaryDeep))),
              AnimatedRotation(
                turns: _showFormula ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: BC.primary, size: 22),
              ),
            ]),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(children: [
                const SizedBox(height: 12),
                _formulaLine('1.', s('calcRule1')),
                _formulaLine('2.', s('calcRule2')),
                _formulaLine('3.', s('calcRule3')),
              ]),
              crossFadeState: _showFormula
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _formulaLine(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
              color: BC.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6)),
          child: Center(
              child: Text(num,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: BC.primary))),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: BC.textMid, height: 1.5))),
      ]),
    );
  }

  // ── RESULT CARD ────────────────────────────────────────────────────────────
  Widget _buildResultCard() {
    final r = _result!;
    final isAmharic = lang == AppLang.amharic;
    final isOromic = lang == AppLang.oromic;
    final etDate = EthiopianCalendar.toEthiopian(r.edd,
        amharic: isAmharic, oromic: isOromic);
    final isOverdue = r.daysToEdd < 0;
    final isToday = r.daysToEdd == 0;

    String daysText;
    Color daysColor;
    if (isToday) {
      daysText = s('todayIsDueDate');
      daysColor = BC.mint;
    } else if (isOverdue) {
      daysText = '${r.daysToEdd.abs()} ${s('daysOverdue')}';
      daysColor = BC.error;
    } else {
      daysText = '${r.daysToEdd} ${s('daysRemaining')}';
      daysColor = BC.gold;
    }

    return FadeTransition(
      opacity: _resultFade,
      child: SlideTransition(
        position: _resultSlide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: BC.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: BC.borderLight),
              boxShadow: [
                BoxShadow(
                    color: BC.primary.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BC.gradStart, BC.gradEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
                ),
                child: Row(children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16)),
                    child: const Center(
                        child: Text('💝', style: TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(s('expectedDueDate'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 3),
                        Text(s('basedOnInfo'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white70)),
                      ])),
                ]),
              ),

              // EDD highlight
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [BC.primaryFrost, Color(0xFFDCEEFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: BC.primaryPale),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(s('dueDateEdd'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: BC.textMid,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(_fmtDate(r.edd),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: BC.primaryDeep,
                                    letterSpacing: -0.5)),
                          ])),
                      const SizedBox(width: 8),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('🇪🇹', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 2),
                            Text(etDate,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: BC.lavender)),
                          ]),
                    ],
                  ),
                ),
              ),

              // Stats grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: _statCard(
                            '👶',
                            s('babyAgeToday'),
                            '${r.gaWeeks}w + ${r.gaDays}d',
                            BC.primaryFrost,
                            BC.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statCard(
                      isToday
                          ? '🎉'
                          : isOverdue
                              ? '⚠️'
                              : '⏳',
                      s('daysUntilDue'),
                      daysText,
                      isOverdue
                          ? BC.errorLight
                          : isToday
                              ? BC.mintLight
                              : BC.goldLight,
                      daysColor,
                    )),
                  ]),
                  const SizedBox(height: 12),
                  _resultRow(
                    s('trimester'),
                    [
                      '',
                      s('firstTrimester'),
                      s('secondTrimester'),
                      s('thirdTrimester'),
                    ][r.trimester],
                    BC.lavender,
                  ),
                  const SizedBox(height: 20),
                  _buildProgressBar(r),
                  const SizedBox(height: 16),
                  _buildTrimesterTimeline(r.trimester),
                  const SizedBox(height: 16),
                  _buildNotifyCard(r),
                  const SizedBox(height: 16),
                  _buildTipBox(r),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _statCard(
      String icon, String label, String value, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        Text(label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 10,
                color: BC.textLight,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: textColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      ]),
    );
  }

  Widget _resultRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: BC.grayBg, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 12, color: BC.textMid))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8)),
          child: Text(value,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ),
      ]),
    );
  }

  Widget _buildProgressBar(PregnancyResult r) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
            child: Text(s('pregnancyProgress'),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: BC.textDark),
                overflow: TextOverflow.ellipsis,
                maxLines: 1)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              color: BC.primaryFrost, borderRadius: BorderRadius.circular(20)),
          child: Text('${(r.progressPercent * 100).round()}%',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: BC.primary)),
        ),
      ]),
      const SizedBox(height: 10),
      Stack(children: [
        Container(
            height: 10,
            decoration: BoxDecoration(
                color: BC.borderLight, borderRadius: BorderRadius.circular(8))),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: r.progressPercent),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (_, val, __) => FractionallySizedBox(
            widthFactor: val,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [BC.gradStart, BC.gradLightEnd]),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: BC.primary.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
            ),
          ),
        ),
      ]),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(s('week1'),
            style: const TextStyle(fontSize: 10, color: BC.textLight)),
        Text(s('week40'),
            style: const TextStyle(fontSize: 10, color: BC.textLight)),
      ]),
    ]);
  }

  Widget _buildTrimesterTimeline(int current) {
    final chips = [
      (s('firstTrimester'), s('weeksRange1'), 1, BC.coral),
      (s('secondTrimester'), s('weeksRange2'), 2, BC.primary),
      (s('thirdTrimester'), s('weeksRange3'), 3, BC.lavender),
    ];
    return Row(
        children: chips.map((chip) {
      final isActive = chip.$3 == current;
      return Expanded(
          child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: chip.$3 < 3 ? 8 : 0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? chip.$4.withOpacity(0.12) : BC.grayBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isActive ? chip.$4.withOpacity(0.4) : BC.borderLight),
        ),
        child: Column(children: [
          Text(isActive ? '✅' : '⬜', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            chip.$1
                .replaceFirst('Trimester', '')
                .replaceFirst('Gilgaala', '')
                .trim(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isActive ? chip.$4 : BC.textLight),
          ),
          Text(chip.$2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 8,
                  color: isActive ? chip.$4.withOpacity(0.7) : BC.textLight)),
        ]),
      ));
    }).toList());
  }

  // ── NOTIFY ME CARD ─────────────────────────────────────────────────────────
  Widget _buildNotifyCard(PregnancyResult r) {
    return GestureDetector(
      onTap: _toggleNotify,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _notifySet ? BC.notifyLight : BC.grayBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _notifySet ? BC.notify.withOpacity(0.5) : BC.border,
            width: _notifySet ? 2 : 1,
          ),
          boxShadow: _notifySet
              ? [
                  BoxShadow(
                      color: BC.notify.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _notifySet ? BC.notify : BC.border,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
                child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _notifySet ? '🔔' : '🔕',
                key: ValueKey(_notifySet),
                style: const TextStyle(fontSize: 22),
              ),
            )),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  _notifySet ? s('reminderActive') : s('notifyMe'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _notifySet ? BC.notify : BC.textDark),
                ),
                const SizedBox(height: 3),
                Text(
                  _notifySet ? s('notifyOnDesc') : s('notifyOffDesc'),
                  style: TextStyle(
                      fontSize: 11,
                      color:
                          _notifySet ? BC.notify.withOpacity(0.8) : BC.textMid,
                      height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ])),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _notifySet
                ? Container(
                    key: const ValueKey('on'),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: BC.notify,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(s('onLabel'),
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  )
                : Container(
                    key: const ValueKey('off'),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: BC.border,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(s('offLabel'),
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: BC.textLight)),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildTipBox(PregnancyResult r) {
    final isOverdue = r.daysToEdd < 0;
    final tips = ['', s('tipFirst'), s('tipSecond'), s('tipThird')];
    final tip = isOverdue ? s('tipOverdue') : tips[r.trimester];
    final bg = isOverdue ? BC.errorLight : BC.mintLight;
    final fg = isOverdue ? BC.error : BC.mint;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: fg.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isOverdue ? '⚠️' : '💡', style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(tip,
                style: TextStyle(
                    fontSize: 12,
                    color: fg.withOpacity(0.9),
                    height: 1.55,
                    fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP LOGO WIDGET  (mirrors LijeLogo from screens.dart)
// ─────────────────────────────────────────────────────────────────────────────
class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: BC.primary.withOpacity(0.35), blurRadius: 8)
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'lib/assets/image.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackAppLogo(size: size),
        ),
      ),
    );
  }
}

class _FallbackAppLogo extends StatelessWidget {
  final double size;
  const _FallbackAppLogo({required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [BC.gradStart, BC.gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.favorite_rounded, color: BC.coral, size: size * 0.28),
          Text('LJ',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.22,
                fontWeight: FontWeight.w900,
                height: 1.0,
              )),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BC.borderLight, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: BC.primary.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 4))
          ],
        ),
        child: child,
      );
}

class _GlassBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
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
                  color: BC.primary.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Center(child: child),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED BABY ICON
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedBabyIcon extends StatefulWidget {
  @override
  State<_AnimatedBabyIcon> createState() => _AnimatedBabyIconState();
}

class _AnimatedBabyIconState extends State<_AnimatedBabyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _float = Tween<double>(begin: -4, end: 4)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _glow = Tween<double>(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _float.value),
          child: Stack(alignment: Alignment.center, children: [
            Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(_glow.value),
                        blurRadius: 18,
                        spreadRadius: 4)
                  ],
                )),
            Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15))),
            SizedBox(
                width: 52,
                height: 52,
                child: CustomPaint(painter: _BabyPainter())),
            Positioned(
                top: 4,
                right: 4,
                child: Text('💕',
                    style: TextStyle(fontSize: 10 + _float.value * 0.1))),
          ]),
        ),
      );
}

class _BabyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.white.withOpacity(0.95);
    canvas.drawCircle(
        Offset(s.width * 0.5, s.height * 0.32), s.width * 0.2, paint);
    final body = Path();
    body.moveTo(s.width * 0.5, s.height * 0.50);
    body.cubicTo(s.width * 0.72, s.height * 0.53, s.width * 0.74,
        s.height * 0.76, s.width * 0.5, s.height * 0.79);
    body.cubicTo(s.width * 0.26, s.height * 0.76, s.width * 0.28,
        s.height * 0.53, s.width * 0.5, s.height * 0.50);
    canvas.drawPath(body, paint);
    paint
      ..color = Colors.white.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final leftArm = Path();
    leftArm.moveTo(s.width * 0.36, s.height * 0.52);
    leftArm.quadraticBezierTo(
        s.width * 0.22, s.height * 0.48, s.width * 0.28, s.height * 0.38);
    canvas.drawPath(leftArm, paint);
    final rightArm = Path();
    rightArm.moveTo(s.width * 0.64, s.height * 0.52);
    rightArm.quadraticBezierTo(
        s.width * 0.78, s.height * 0.48, s.width * 0.72, s.height * 0.38);
    canvas.drawPath(rightArm, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// CALENDAR PICKER SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarPickerSheet extends StatefulWidget {
  final DateTime initialDate;
  const _CalendarPickerSheet({required this.initialDate});

  @override
  State<_CalendarPickerSheet> createState() => _CalendarPickerSheetState();
}

class _CalendarPickerSheetState extends State<_CalendarPickerSheet>
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
                              color: BC.primary.withOpacity(0.30),
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
                          BC.primaryFrost.withOpacity(0.5),
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
                      color: BC.primary.withOpacity(0.3),
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
                        color: selectedColor.withOpacity(0.40),
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
          gradient: LinearGradient(colors: [bg, bg.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withOpacity(0.25)),
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
            BoxShadow(color: BC.primary.withOpacity(0.08), blurRadius: 4)
          ],
        ),
        child: Icon(icon, size: 20, color: BC.primaryDeep),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

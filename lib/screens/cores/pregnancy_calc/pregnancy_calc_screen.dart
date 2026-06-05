import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/screens/screens.dart';
import '../../../../models/models.dart';
import 'logic/constants.dart';
import 'logic/ethiopian_calendar.dart';
import 'logic/pregnancy_calculator.dart';
import 'widgets/animated_baby_icon.dart';
import 'widgets/bubble_painter.dart';
import 'widgets/calendar_picker_sheet.dart';
import 'widgets/glass_widgets.dart';

class PregnancyCalculationScreen extends StatefulWidget {
  const PregnancyCalculationScreen({super.key});

  @override
  State<PregnancyCalculationScreen> createState() =>
      PregnancyCalculationScreenState();
}

class PregnancyCalculationScreenState extends State<PregnancyCalculationScreen>
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
          CalendarPickerSheet(initialDate: initial ?? DateTime.now()),
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
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: BC.offWhite,
          body: Stack(children: [
            Positioned.fill(
                child: AnimatedBuilder(
              animation: _bgAnim,
              builder: (_, __) =>
                  CustomPaint(painter: BubblePainter(_bgAnim.value)),
            )),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        GlassBtn(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: BC.primaryDeep, size: 18),
        ),
        const SizedBox(width: 10),
        const LijeLogo(size: 34),
        const SizedBox(width: 8),
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
              const AnimatedBabyIcon(),
            ]),
          ),
        ),
      ),
    );
  }

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
        child: GlassCard(
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

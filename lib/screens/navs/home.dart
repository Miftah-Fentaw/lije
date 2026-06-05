import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../../screens.dart';
import '../after_birth_screen.dart';
import '../during_pregnancy_screen.dart';
import '../pregnancy_calculation_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOME TAB
// ─────────────────────────────────────────────────────────────────────────────
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final AnimationController _entrance, _pulse, _shimmer, _float;
  late final Animation<double> _hFade, _bFade, _pulseAnim;
  late final Animation<Offset> _hSlide, _bSlide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    _hFade = CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
    _hSlide = Tween<Offset>(begin: const Offset(0, -0.18), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic)));
    _bFade = CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut));
    _bSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entrance,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)));
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulse, curve: Curves.easeInOut);
    _shimmer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
    _float = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _shimmer.dispose();
    _float.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext ctx, Widget page) {
    Navigator.of(ctx).push(PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
                begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: slide, child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Column(children: [
        SlideTransition(
            position: _hSlide,
            child: FadeTransition(opacity: _hFade, child: _header(lang))),
        Expanded(
            child: SlideTransition(
                position: _bSlide,
                child: FadeTransition(
                    opacity: _bFade,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _couponCard(lang),
                            const SizedBox(height: 14),
                            _heroBanner(lang),
                            const SizedBox(height: 20),
                            _sectionLabel(LS.get(lang, 'selectSection')),
                            const SizedBox(height: 12),
                            _categoryGrid(context, lang),
                            const SizedBox(height: 20),
                            _pregnancyCard(lang),
                            const SizedBox(height: 16),
                            _doctorCard(lang),
                            const SizedBox(height: 16),
                            _footerBanner(lang),
                          ]),
                    )))),
      ]),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────────
  Widget _header(AppLang lang) => Container(
        decoration: const BoxDecoration(color: C.white, boxShadow: [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2))
        ]),
        child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(children: [
                Row(children: [
                  AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, __) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: C.vivid.withOpacity(
                                          0.14 + _pulseAnim.value * 0.10),
                                      blurRadius: 10 + _pulseAnim.value * 5,
                                      spreadRadius: _pulseAnim.value * 2)
                                ]),
                            child: const LijeLogo(size: 44),
                          )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(LS.get(lang, 'appName'),
                            style: const TextStyle(
                                color: C.navy,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                        Text(LS.get(lang, 'appSubtitle'),
                            style: const TextStyle(
                                fontSize: 10, color: C.textMid),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                      ])),
                  _iconBtn(Icons.notifications_none_rounded, badge: true),
                  const SizedBox(width: 8),
                  _iconBtn(Icons.favorite_border_rounded),
                  const SizedBox(width: 8),
                  _langChooser(lang),
                ]),
                const SizedBox(height: 12),
                _searchBar(lang),
                const SizedBox(height: 10),
              ]),
            )),
      );

  // ── LANGUAGE CHOOSER (Text-only Dropdown) ──────────────────────────────────
  Widget _langChooser(AppLang currentLang) {
    const labels = {
      AppLang.english: 'ENG',
      AppLang.amharic: 'AMH',
      AppLang.oromic: 'ORO'
    };

    return PopupMenuButton<AppLang>(
      onSelected: (AppLang newLang) {
        langNotifier.value = newLang;
        HapticFeedback.selectionClick();
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      itemBuilder: (context) => AppLang.values
          .map((l) => PopupMenuItem<AppLang>(
                value: l,
                height: 38,
                child: Text(
                  labels[l]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: currentLang == l ? FontWeight.w900 : FontWeight.w600,
                    color: currentLang == l ? C.vivid : C.navy,
                  ),
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labels[currentLang]!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: C.navy,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: C.vivid,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(AppLang lang) => Container(
        height: 44,
        decoration: BoxDecoration(
            color: C.frost,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: C.border)),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          const Icon(Icons.search_rounded, color: C.textLight, size: 19),
          const SizedBox(width: 9),
          Expanded(
              child: Text(LS.get(lang, 'searchHint'),
                  style: TextStyle(
                      fontSize: 13, color: C.textLight.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)),
        ]),
      );

  Widget _iconBtn(IconData icon, {bool badge = false}) =>
      Stack(clipBehavior: Clip.none, children: [
        Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: C.frost, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: C.mid, size: 19)),
        if (badge)
          Positioned(
              top: -2,
              right: -2,
              child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: C.coral, shape: BoxShape.circle))),
      ]);

  // ── COUPON CARD ────────────────────────────────────────────────────────────
  Widget _couponCard(AppLang lang) => Container(
        decoration: BoxDecoration(
          color: C.frost,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.pale, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: C.mid.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: IntrinsicHeight(
            child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: C.mid.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(LS.get(lang, 'couponCode'),
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: C.mid)),
                  ),
                  const SizedBox(height: 4),
                  Text(LS.get(lang, 'couponTitle'),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: C.navy),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 2),
                  Text(LS.get(lang, 'couponDesc'),
                      style: const TextStyle(fontSize: 10, color: C.textMid),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
          )),
          CustomPaint(
              size: const Size(1, double.infinity), painter: _DashPainter()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(LS.get(lang, 'couponOff'),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900, color: C.mid)),
              Text(LS.get(lang, 'couponOffLabel'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w700, color: C.navy)),
            ]),
          ),
        ])),
      );

  // ── HERO BANNER ─────────────────────────────────────────────────────────────
  Widget _heroBanner(AppLang lang) => AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Container(
          height: 182,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              C.navy,
              C.soft,
              C.vivid
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: C.soft.withOpacity(0.28 + _pulseAnim.value * 0.08),
                  blurRadius: 18 + _pulseAnim.value * 5,
                  offset: const Offset(0, 8))
            ],
          ),
          child: child,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(clipBehavior: Clip.hardEdge, children: [
            _bubble(top: -18, right: -18, size: 110, opacity: 0.07),
            _bubble(bottom: -18, right: 55, size: 70, opacity: 0.05),
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              width: 85,
              child: AnimatedBuilder(
                  animation: _float,
                  builder: (_, __) => Transform.translate(
                        offset: Offset(
                            0, -5.0 * (0.5 - (_float.value - 0.5).abs()) * 2),
                        child: const Center(
                            child: Text('🤰', style: TextStyle(fontSize: 58))),
                      )),
            ),
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              right: 105,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(LS.get(lang, 'heroBadge'),
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ),
                    const SizedBox(height: 7),
                    Text(LS.get(lang, 'heroTitle'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                    const SizedBox(height: 4),
                    Text(LS.get(lang, 'heroOffer'),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => HapticFeedback.lightImpact(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                                color: C.navy.withOpacity(0.28),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: C.navy),
                              SizedBox(width: 4),
                              Text('OPEN',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: C.navy)),
                            ]),
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      );

  Widget _sectionLabel(String t) => Row(children: [
        Container(
            width: 4,
            height: 17,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [C.navy, C.vivid],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(4),
            )),
        const SizedBox(width: 8),
        Flexible(
            child: Text(t.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: C.textMid,
                    letterSpacing: 1.4),
                overflow: TextOverflow.ellipsis,
                maxLines: 1)),
      ]);

  // ── CATEGORY GRID ──────────────────────────────────────────────────────────
  Widget _categoryGrid(BuildContext ctx, AppLang lang) {
    final cats = [
      _CatData(
          '📅',
          LS.get(lang, 'pregnancyCalc'),
          LS.get(lang, 'pregnancyCalcSub'),
          () => _navigateTo(ctx, const PregnancyCalculationScreen())),
      _CatData(
          '🤰',
          LS.get(lang, 'duringPregnancy'),
          LS.get(lang, 'duringPregnancySub'),
          () => _navigateTo(ctx, const DuringPregnancyScreen())),
      _CatData(
          '👶',
          LS.get(lang, 'afterBirth'),
          LS.get(lang, 'afterBirthSub'),
          () => _navigateTo(ctx, const AfterBirthScreen())),
      _CatData(
          '🩺',
          LS.get(lang, 'talkDoctor'),
          LS.get(lang, 'talkDoctorSub'),
          () => _showComingSoon(ctx, lang)),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: List.generate(
          cats.length,
          (i) => _CatCard(
              cat: cats[i], delay: Duration(milliseconds: i * 60))),
    );
  }

  void _showComingSoon(BuildContext ctx, AppLang lang) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(LS.get(lang, 'comingSoon'),
          style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: C.navy,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── PREGNANCY CARD ──────────────────────────────────────────────────────────
  Widget _pregnancyCard(AppLang lang) {
    final weeks = appState.gaWeeks;
    final days = appState.gaDays;
    final progress = ((weeks * 7 + days) / 280).clamp(0.0, 1.0);
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
                color: C.mid.withOpacity(0.18 + _pulseAnim.value * 0.09),
                blurRadius: 24 + _pulseAnim.value * 6,
                offset: const Offset(0, 8))
          ],
        ),
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF023E8A), Color(0xFF0096C7), Color(0xFF48CAE4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(clipBehavior: Clip.hardEdge, children: [
          _bubble(top: -14, right: -14, size: 100, opacity: 0.07),
          _bubble(bottom: -22, left: 24, size: 70, opacity: 0.05),
          Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                _glowPill('⭐  ${LS.get(lang, 'trimester2')}'),
                                const SizedBox(height: 9),
                                Text(LS.get(lang, 'myPregnancy'),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.72),
                                        fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                                const SizedBox(height: 3),
                                Text(
                                    '$weeks ${LS.get(lang, 'weeksLabel')} + $days ${LS.get(lang, 'daysLabel')}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                              ])),
                          const SizedBox(width: 8),
                          _FloatBabyIcon(pulse: _pulseAnim, float: _float),
                        ]),
                    const SizedBox(height: 13),
                    _babyStats(lang),
                    const SizedBox(height: 13),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(LS.get(lang, 'pregnancyProgress'),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.72)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1)),
                          const SizedBox(width: 8),
                          Text('${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                        ]),
                    const SizedBox(height: 7),
                    _ProgressBar(value: progress),
                    const SizedBox(height: 13),
                    _whiteBtn(
                        label: LS.get(lang, 'updateDetails'), onTap: () {}),
                  ])),
        ]),
      ),
    );
  }

  Widget _glowPill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.20))),
        child: Text(t,
            style: const TextStyle(fontSize: 10, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      );

  Widget _babyStats(AppLang lang) => Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.12))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(child: _stat('📏', LS.get(lang, 'babySize'), '21.5 cm')),
          Container(
              width: 1, height: 32, color: Colors.white.withOpacity(0.15)),
          Expanded(child: _stat('⚖', LS.get(lang, 'babyWeight'), '650 g')),
          Container(
              width: 1, height: 32, color: Colors.white.withOpacity(0.15)),
          Expanded(child: _stat('🥭', LS.get(lang, 'bigAs'), 'Mango')),
        ]),
      );

  Widget _stat(String emoji, String label, String value) => Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(label,
            style:
                TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.72)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
        Text(value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      ]);

  Widget _whiteBtn({required String label, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: C.navy.withOpacity(0.26),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]),
          child: Center(
              child: Text(label,
                  style: const TextStyle(
                      color: C.navy, fontSize: 13, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)),
        ),
      );

  // ── WEEK HIGHLIGHT ──────────────────────────────────────────────────────────
  Widget _weekHighlight(AppLang lang) => _FadeInCard(
        delay: const Duration(milliseconds: 60),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [C.goldLight, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.gold.withOpacity(0.26)),
            boxShadow: [
              BoxShadow(
                  color: C.gold.withOpacity(0.09),
                  blurRadius: 14,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFF5A623), Color(0xFFFFD740)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: C.gold.withOpacity(0.36),
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ]),
              child: const Center(
                  child: Text('🌟', style: TextStyle(fontSize: 21))),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(LS.get(lang, 'weeklyHighlight'),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A4A00)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 3),
                  Text(LS.get(lang, 'weekHighlightText'),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9B6600), height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ])),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD4900A), size: 19),
          ]),
        ),
      );

  // ── TIP CARD ────────────────────────────────────────────────────────────────
  Widget _tipCard(AppLang lang) => AnimatedBuilder(
        animation: _shimmer,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: SweepGradient(
                center: Alignment.topLeft,
                transform: GradientRotation(_shimmer.value * 2 * pi),
                colors: [
                  C.mint.withOpacity(0.50),
                  C.vivid.withOpacity(0.35),
                  C.gold.withOpacity(0.40),
                  C.mint.withOpacity(0.50),
                ]),
          ),
          padding: const EdgeInsets.all(2),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: C.mintLight, borderRadius: BorderRadius.circular(19)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF26C6A2), Color(0xFF00796B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                        color: C.mint.withOpacity(0.36),
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ]),
              child: const Center(
                  child: Text('💡', style: TextStyle(fontSize: 19))),
            ),
            const SizedBox(width: 11),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(LS.get(lang, 'tipTitle'),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0C5C3A)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 4),
                  Text(LS.get(lang, 'tipText'),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF277A4E), height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ])),
          ]),
        ),
      );

  // ── APPOINTMENT CARD ────────────────────────────────────────────────────────
  Widget _appointmentCard(AppLang lang) => _FadeInCard(
        delay: const Duration(milliseconds: 80),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: C.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.cardBorder),
              boxShadow: [
                BoxShadow(
                    color: C.mid.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 4))
              ]),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14)),
              child: const Center(
                  child: Text('📋', style: TextStyle(fontSize: 19))),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(LS.get(lang, 'upcomingAppt'),
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: C.textMid),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 2),
                  Text(LS.get(lang, 'apptDoctor'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: C.textDark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: C.mid),
                    const SizedBox(width: 3),
                    Flexible(
                        child: Text(LS.get(lang, 'apptDate'),
                            style: const TextStyle(
                                fontSize: 11,
                                color: C.mid,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ]),
                ])),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.navy, C.vivid]),
                  borderRadius: BorderRadius.circular(11)),
              child: Text(LS.get(lang, 'viewAll'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      );

  // ── DOCTOR CARD ─────────────────────────────────────────────────────────────
  Widget _doctorCard(AppLang lang) => _FadeInCard(
        delay: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: C.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.cardBorder),
              boxShadow: [
                BoxShadow(
                    color: C.vivid.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 4))
              ]),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFAB47BC).withOpacity(0.35),
                        blurRadius: 9,
                        offset: const Offset(0, 4))
                  ]),
              child: const Center(
                  child: Icon(Icons.medical_services_rounded,
                      color: Colors.white, size: 26)),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Flexible(
                        child: Text(LS.get(lang, 'talkToDoctor'),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: C.textDark),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                    const SizedBox(width: 6),
                    _OnlinePill(label: LS.get(lang, 'onlineLabel')),
                  ]),
                  const SizedBox(height: 4),
                  Text(LS.get(lang, 'doctorDesc'),
                      style: const TextStyle(
                          fontSize: 11, color: C.textMid, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(colors: [C.navy, C.vivid]),
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                                color: C.vivid.withOpacity(0.35),
                                blurRadius: 9,
                                offset: const Offset(0, 3))
                          ]),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.phone_rounded,
                            size: 12, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(LS.get(lang, 'consultNow'),
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ]),
                    ),
                  ),
                ])),
          ]),
        ),
      );

  // ── FOOTER BANNER ────────────────────────────────────────────────────────────
  Widget _footerBanner(AppLang lang) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF023E8A), Color(0xFF0096C7), Color(0xFF48CAE4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: C.mid.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6))
          ],
        ),
        child: Stack(clipBehavior: Clip.hardEdge, children: [
          _bubble(top: -14, right: -14, size: 74, opacity: 0.06),
          _bubble(bottom: -8, left: 20, size: 48, opacity: 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _footerItem('👩', LS.get(lang, 'healthyMother')),
                  Container(width: 1, height: 30, color: Colors.white24),
                  _footerItem('👶', LS.get(lang, 'healthyChild')),
                  Container(width: 1, height: 30, color: Colors.white24),
                  _footerItem('👨‍👩‍👦', LS.get(lang, 'happyFamily')),
                ]),
          ),
        ]),
      );

  Widget _footerItem(String emoji, String label) => Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 21)),
        const SizedBox(height: 5),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
                fontWeight: FontWeight.w600)),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// BUBBLE HELPER
// ─────────────────────────────────────────────────────────────────────────────
Widget _bubble(
        {double? top,
        double? bottom,
        double? left,
        double? right,
        required double size,
        required double opacity}) =>
    Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity))),
    );

// ─────────────────────────────────────────────────────────────────────────────
// DASHED PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 5.0, gapH = 4.0;
    final paint = Paint()
      ..color = C.pale
      ..strokeWidth = 1.5;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY DATA + CARD
// ─────────────────────────────────────────────────────────────────────────────
class _CatData {
  final String emoji, title, sub;
  final VoidCallback onTap;
  const _CatData(this.emoji, this.title, this.sub, this.onTap);
}

class _CatCard extends StatefulWidget {
  final _CatData cat;
  final Duration delay;
  const _CatCard({required this.cat, required this.delay});
  @override
  State<_CatCard> createState() => _CatCardState();
}

class _CatCardState extends State<_CatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade, _scale;
  late final Animation<Offset> _slide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 620));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.82, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.24), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(
            scale: _scale,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) {
                setState(() => _pressed = false);
                HapticFeedback.lightImpact();
                widget.cat.onTap();
              },
              onTapCancel: () => setState(() => _pressed = false),
              child: AnimatedScale(
                scale: _pressed ? 0.94 : 1.0,
                duration: const Duration(milliseconds: 90),
                child: Container(
                  decoration: BoxDecoration(
                    color: C.vivid.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: C.vivid.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                          color: C.vivid.withOpacity(_pressed ? 0.02 : 0.05),
                          blurRadius: _pressed ? 4 : 10,
                          offset: Offset(0, _pressed ? 2 : 4))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.cat.emoji,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(widget.cat.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: C.navy,
                                  height: 1.1)),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// PROGRESS BAR
// ─────────────────────────────────────────────────────────────────────────────
class _ProgressBar extends StatefulWidget {
  final double value;
  const _ProgressBar({required this.value});
  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _a = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _a,
        builder: (_, __) => Container(
          height: 9,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(9)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _a.value.clamp(0.0, 1.0),
            child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF90CAF9), Colors.white]),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.50), blurRadius: 7)
                ])),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// FLOATING BABY ICON
// ─────────────────────────────────────────────────────────────────────────────
class _FloatBabyIcon extends StatelessWidget {
  final Animation<double> pulse, float;
  const _FloatBabyIcon({required this.pulse, required this.float});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([pulse, float]),
        builder: (_, __) => Transform.translate(
          offset: Offset(0, -6.0 * (0.5 - (float.value - 0.5).abs()) * 2),
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
                boxShadow: [
                  BoxShadow(
                      color:
                          Colors.white.withOpacity(0.06 + pulse.value * 0.08),
                      blurRadius: 16 + pulse.value * 8,
                      spreadRadius: pulse.value * 3)
                ]),
            child:
                const Center(child: Text('👶', style: TextStyle(fontSize: 36))),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// ONLINE PILL + PULSING DOT
// ─────────────────────────────────────────────────────────────────────────────
class _OnlinePill extends StatelessWidget {
  final String label;
  const _OnlinePill({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
            color: C.successBg, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _PulsingDot(),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700, color: C.success)),
        ]),
      );
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _s = Tween<double>(begin: 0.7, end: 1.4)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
      scale: _s, child: const Icon(Icons.circle, size: 6, color: C.success));
}

// ─────────────────────────────────────────────────────────────────────────────
// FADE-IN CARD
// ─────────────────────────────────────────────────────────────────────────────
class _FadeInCard extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeInCard({required this.child, this.delay = Duration.zero});
  @override
  State<_FadeInCard> createState() => _FadeInCardState();
}

class _FadeInCardState extends State<_FadeInCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child));
}

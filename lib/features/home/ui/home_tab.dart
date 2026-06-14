import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/core/widgets/feature_app_bar.dart';
import 'package:lije/core/constants/app_assets.dart';
import 'package:lije/core/widgets/lije_logo.dart';
import 'package:lije/features/after_birth/ui/after_birth_screen.dart';
import 'package:lije/features/during_pregnancy/ui/during_pregnancy_screen.dart';
import 'package:lije/features/during_pregnancy/models/week_registry.dart';
import 'package:lije/features/discover/services/discover_search.dart';
import 'package:lije/features/settings/ui/settings_screens.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:lije/features/pregnancy_calc/ui/pregnancy_calc_screen.dart';

// HOME TAB
// ─────────────────────────────────────────────────────────────────────────────
class HomeTab extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;
  const HomeTab({super.key, this.onNavigateToTab});
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
    appState.refreshGa();
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
                            _heroBanner(lang),
                            const SizedBox(height: 20),
                            _sectionLabel(LS.get(lang, 'selectSection')),
                            const SizedBox(height: 12),
                            _categoryGrid(context, lang),
                            const SizedBox(height: 20),
                            ListenableBuilder(
                              listenable: appState,
                              builder: (_, __) => _pregnancyCard(lang, context),
                            ),
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
                  const LijeLogo(size: 44),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(LS.get(lang, 'appName'),
                            style: const TextStyle(
                                color: C.mid,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                        Text(LS.get(lang, 'appSubtitle'),
                            style: const TextStyle(
                                fontSize: 10, color: C.textLight),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                      ])),
                  _iconBtn(Icons.notifications_none_rounded,
                      badge: appState.notificationsEnabled &&
                          appState.pregnancyRemindersEnabled,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RemindersScreen()))),
                  const SizedBox(width: 8),
                  _iconBtn(Icons.explore_rounded, onTap: () {
                    discoverSearchNotifier.value = '';
                    widget.onNavigateToTab?.call(2);
                  }),
                  const SizedBox(width: 8),
                  const FeatureLangChooser(),

                ]),
                const SizedBox(height: 10),
              ]),
            )),
      );

  Widget _iconBtn(IconData icon, {bool badge = false, VoidCallback? onTap}) =>
      Stack(clipBehavior: Clip.none, children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: C.frost, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: C.mid, size: 19),
          ),
        ),
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

  // ── HERO BANNER ─────────────────────────────────────────────────────────────
  Widget _heroBanner(AppLang lang) => Container(
        height: 160,
        decoration: BoxDecoration(
          color: C.darkBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(clipBehavior: Clip.hardEdge, children: [
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Image.asset(
                AppAssets.lijeLogo,
                width: 90,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                    Icons.pregnant_woman_rounded,
                    size: 52,
                    color: Colors.white),
              ),
            ),
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              right: 110,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                          color: C.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6)),
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
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.35),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
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
              color: C.darkBlue,
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
          AppAssets.pregnancy,
          LS.get(lang, 'pregnancyCalc'),
          LS.get(lang, 'pregnancyCalcSub'),
          () => _navigateTo(ctx, const PregnancyCalculationScreen())),
      _CatData(
          AppAssets.mother,
          LS.get(lang, 'duringPregnancy'),
          LS.get(lang, 'duringPregnancySub'),
          () => _navigateTo(ctx, const DuringPregnancyScreen())),
      _CatData(
          AppAssets.afterPreg,
          LS.get(lang, 'afterBirth'),
          LS.get(lang, 'afterBirthSub'),
          () => _navigateTo(ctx, AfterBirthScreen(
              childBirthDate: appState.childBirthDate))),
      _CatData(
          AppAssets.all,
          LS.get(lang, 'talkDoctor'),
          LS.get(lang, 'talkDoctorSub'),
          () => _openDoctorsTab()),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, i) => _CatCard(
        cat: cats[i],
        delay: Duration(milliseconds: i * 70),
      ),
    );
  }

  void _openDoctorsTab() {
    HapticFeedback.lightImpact();
    widget.onNavigateToTab?.call(1);
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
  Widget _pregnancyCard(AppLang lang, BuildContext context) {
    if (!appState.hasPregnancyData) {
      return Container(
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: C.lightBlue),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LS.get(lang, 'myPregnancy'),
                style: const TextStyle(
                    color: C.darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(LS.get(lang, 'pregnancyCalcSub'),
                style: const TextStyle(color: C.textLight, fontSize: 12)),
            const SizedBox(height: 14),
            _flatBtn(
              label: LS.get(lang, 'calculate'),
              onTap: () => _navigateTo(context, const PregnancyCalculationScreen()),
            ),
          ],
        ),
      );
    }

    final weeks = appState.gaWeeks;
    final days = appState.gaDays;
    final progress = appState.progress;
    final wd = WeekRegistry.forWeek(weeks);
    final trimesterLabel = [
      LS.get(lang, 'firstTrimester'),
      LS.get(lang, 'secondTrimester'),
      LS.get(lang, 'thirdTrimester'),
    ][appState.trimester - 1];
    return Container(
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.lightBlue),
        boxShadow: [
          BoxShadow(
              color: C.darkBlue.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
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
                            _flatPill(trimesterLabel),
                            const SizedBox(height: 9),
                            Text(LS.get(lang, 'myPregnancy'),
                                style: const TextStyle(
                                    color: C.textLight,
                                    fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                            const SizedBox(height: 3),
                            Text(
                                '$weeks ${LS.get(lang, 'weeksLabel')} + $days ${LS.get(lang, 'daysLabel')}',
                                style: const TextStyle(
                                    color: C.darkBlue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                          ])),
                      const SizedBox(width: 8),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: C.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(wd.emoji, style: const TextStyle(fontSize: 28))),
                      ),
                    ]),
                const SizedBox(height: 13),
                _babyStats(lang, wd),
                const SizedBox(height: 13),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(LS.get(lang, 'pregnancyProgress'),
                              style: const TextStyle(
                                  fontSize: 11, color: C.textLight),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      const SizedBox(width: 8),
                      Text('${(progress * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: C.darkBlue)),
                    ]),
                const SizedBox(height: 7),
                _ProgressBar(value: progress),
                const SizedBox(height: 13),
                _flatBtn(
                    label: LS.get(lang, 'updateDetails'),
                    onTap: () =>
                        _navigateTo(context, const DuringPregnancyScreen())),
              ])),
    );
  }

  Widget _flatPill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: C.lightBlue,
            borderRadius: BorderRadius.circular(20)),
        child: Text(t,
            style: const TextStyle(
                fontSize: 10, color: C.darkBlue, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      );

  Widget _babyStats(AppLang lang, WeekData wd) => Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: C.lightBlue,
            borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(child: _stat(Icons.straighten_rounded, LS.get(lang, 'babySize'), wd.length)),
          Container(width: 1, height: 32, color: C.darkBlue.withOpacity(0.12)),
          Expanded(child: _stat(Icons.monitor_weight_rounded, LS.get(lang, 'babyWeight'), wd.weight)),
          Container(width: 1, height: 32, color: C.darkBlue.withOpacity(0.12)),
          Expanded(child: _stat(Icons.eco_rounded, LS.get(lang, 'bigAs'), wd.fruit)),
        ]),
      );

  Widget _stat(IconData icon, String label, String value) => Column(children: [
        Icon(icon, size: 18, color: C.darkBlue),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 9, color: C.textLight),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
        Text(value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: C.darkBlue),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      ]);

  Widget _flatBtn({required String label, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: C.darkBlue,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800),
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
            color: C.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.lightBlue),
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: C.lightBlue,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Icon(Icons.star_rounded,
                      size: 20, color: C.darkBlue)),
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
                          color: C.darkBlue),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 3),
                  Text(LS.get(lang, 'weekHighlightText'),
                      style: const TextStyle(
                          fontSize: 11, color: C.textLight, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ])),
            const Icon(Icons.chevron_right_rounded,
                color: C.darkBlue, size: 19),
          ]),
        ),
      );

  // ── TIP CARD ────────────────────────────────────────────────────────────────
  Widget _tipCard(AppLang lang) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: C.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.lightBlue)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: C.lightBlue,
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
                child: Icon(Icons.lightbulb_rounded,
                    size: 18, color: C.darkBlue)),
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
                        color: C.darkBlue),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 4),
                Text(LS.get(lang, 'tipText'),
                    style: const TextStyle(
                        fontSize: 11, color: C.textLight, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ])),
        ]),
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: C.lightBlue,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Icon(Icons.event_note_rounded,
                      size: 18, color: C.darkBlue)),
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
                  color: C.darkBlue,
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
        child: GestureDetector(
          onTap: _openDoctorsTab,
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: C.lightBlue,
                  borderRadius: BorderRadius.circular(14)),
              child: const Center(
                  child: Icon(Icons.medical_services_rounded,
                      color: C.darkBlue, size: 24)),
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
                    onTap: _openDoctorsTab,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                          color: C.darkBlue,
                          borderRadius: BorderRadius.circular(11)),
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
        ),
      );

  // ── FOOTER BANNER ────────────────────────────────────────────────────────────
  Widget _footerBanner(AppLang lang) => Container(
        decoration: BoxDecoration(
          color: C.darkBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _footerItem(Icons.favorite_rounded, LS.get(lang, 'healthyMother')),
                Container(width: 1, height: 30, color: Colors.white24),
                _footerItem(Icons.child_care_rounded, LS.get(lang, 'healthyChild')),
                Container(width: 1, height: 30, color: Colors.white24),
                _footerItem(Icons.family_restroom_rounded, LS.get(lang, 'happyFamily')),
              ]),
        ),
      );

  Widget _footerItem(IconData icon, String label) => Column(children: [
        Icon(icon, size: 21, color: Colors.white),
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
// CATEGORY DATA + CARD
// ─────────────────────────────────────────────────────────────────────────────
class _CatData {
  final String imageAsset;
  final String title, sub;
  final VoidCallback onTap;
  const _CatData(this.imageAsset, this.title, this.sub, this.onTap);
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
                scale: _pressed ? 0.97 : 1.0,
                duration: const Duration(milliseconds: 90),
                child: Container(
                  decoration: BoxDecoration(
                    color: C.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: C.border),
                    boxShadow: [
                      BoxShadow(
                        color: C.darkBlue.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 11,
                        child: Image.asset(
                          widget.cat.imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: C.grayBg,
                            child: const Center(
                              child: Icon(Icons.image_outlined,
                                  color: C.darkBlue, size: 32),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: C.border,
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          color: C.white,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 3,
                                height: 38,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: C.darkBlue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.cat.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: C.darkBlue,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.cat.sub,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: C.textLight,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
              color: C.lightBlue, borderRadius: BorderRadius.circular(9)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _a.value.clamp(0.0, 1.0),
            child: Container(
                decoration: BoxDecoration(
                    color: C.darkBlue,
                    borderRadius: BorderRadius.circular(9))),
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
            child: const Center(
                child: Icon(Icons.child_care_rounded,
                    size: 36, color: Colors.white)),
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

// ─────────────────────────────────────────────────────────────────────────────
// COMING SOON BODY  (used for placeholder sub-screens)
// ─────────────────────────────────────────────────────────────────────────────
class _ComingSoonBody extends StatelessWidget {
  const _ComingSoonBody();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  color: C.frost,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: C.mid.withOpacity(0.15), blurRadius: 22)
                  ]),
              child: const Center(
                  child: Icon(Icons.construction_rounded,
                      size: 40, color: C.mid)),
            ),
            const SizedBox(height: 20),
            Text(LS.get(lang, 'comingSoon'),
                style: const TextStyle(
                    color: C.navy, fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(LS.get(lang, 'comingSoonDesc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: C.textMid, fontSize: 13, height: 1.6)),
          ]),
        ),
      ),
    );
  }
}
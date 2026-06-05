// =============================================================================
// screens.dart  —  Lije App  Main Shell + Home Tab
// Language chooser lives HERE; DuringPregnancyScreen reads langNotifier.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import 'package:lije/screens/during_pregnancy_screen.dart';
import 'package:lije/screens/pregnancy_calculation_screen.dart';
import 'package:lije/screens/navs/discover.dart';
import 'package:lije/screens/navs/doctors.dart';
import 'package:lije/screens/navs/profile.dart';
// ─────────────────────────────────────────────────────────────────────────────
// LIJE LOGO
// ─────────────────────────────────────────────────────────────────────────────
class LijeLogo extends StatelessWidget {
  final double size;
  const LijeLogo({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'lib/assets/lije_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          'lib/assets/image.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackLogo(size: size),
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  final double size;
  const _FallbackLogo({required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: C.lightBlue,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.favorite_rounded, color: C.coral, size: size * 0.28),
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
// MAIN SHELL
// ─────────────────────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  void _onTap(int i) {
    if (_idx == i) return;
    HapticFeedback.selectionClick();
    setState(() => _idx = i);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        body: IndexedStack(index: _idx, children: const [
          HomeTab(),
          DoctorsTab(),
          DiscoverTab(),
          ProfileTab(),
        ]),
        bottomNavigationBar: _BottomNav(
          currentIndex: _idx,
          lang: lang,
          onTap: _onTap,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final AppLang lang;
  final ValueChanged<int> onTap;
  const _BottomNav(
      {required this.currentIndex, required this.lang, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, LS.get(lang, 'home')),
      (
        Icons.groups_rounded,
        Icons.groups_outlined,
        LS.get(lang, 'doctors')
      ),
      (
        Icons.lightbulb_rounded,
        Icons.lightbulb_outline_rounded,
        LS.get(lang, 'discover')
      ),
      (
        Icons.person_rounded,
        Icons.person_outline_rounded,
        LS.get(lang, 'profile')
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = currentIndex == i;
              final color = active ? C.darkBlue : C.textLight;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? items[i].$1 : items[i].$2,
                        size: 24,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$3,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER TAB
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  final String label, emoji;
  const _PlaceholderTab({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Container(
        color: C.bgPage,
        child: SafeArea(
            child: Column(children: [
          Container(
            color: C.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(children: [
              const LijeLogo(size: 38),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: C.navy,
                          fontSize: 19,
                          fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)),
            ]),
          ),
          Expanded(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: C.frost,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: C.mid.withOpacity(0.15),
                              blurRadius: 22,
                              spreadRadius: 4)
                        ],
                      ),
                      child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 42))),
                    ),
                    const SizedBox(height: 22),
                    Text(LS.get(lang, 'comingSoon'),
                        style: const TextStyle(
                            color: C.navy,
                            fontSize: 21,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(LS.get(lang, 'comingSoonDesc'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: C.textMid, fontSize: 13, height: 1.6)),
                  ]),
            ),
          )),
        ])),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN SHELL  (shared by sub-screens)
// ─────────────────────────────────────────────────────────────────────────────
class ScreenShell extends StatelessWidget {
  final String title;
  final Widget body;
  const ScreenShell({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.bgPage,
        body: Column(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: C.headerGrad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              boxShadow: [
                BoxShadow(
                    color: Color(0x330096C7),
                    blurRadius: 12,
                    offset: Offset(0, 4))
              ],
            ),
            child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 14),
                  child: Row(children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20)),
                    const LijeLogo(size: 36),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ]),
                )),
          ),
          Expanded(child: body),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME TAB
// ─────────────────────────────────────────────────────────────────────────────
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final AnimationController _entrance, _pulse, _shimmer, _float, _marquee;
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
    _marquee =
        AnimationController(vsync: this, duration: const Duration(seconds: 22))
          ..repeat();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _shimmer.dispose();
    _float.dispose();
    _marquee.dispose();
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
                            _marqueeBar(lang),
                            const SizedBox(height: 14),
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
                            _weekHighlight(lang),
                            const SizedBox(height: 16),
                            _tipCard(lang),
                            const SizedBox(height: 16),
                            _appointmentCard(lang),
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

  // ── LANGUAGE CHOOSER (dropdown) ───────────────────────────────────────────
  Widget _langChooser(AppLang currentLang) {
    const labels = {
      AppLang.english: 'ENG',
      AppLang.amharic: 'AMH',
      AppLang.oromic: 'ORO',
    };

    return PopupMenuButton<AppLang>(
      onSelected: (AppLang newLang) {
        langNotifier.value = newLang;
        HapticFeedback.selectionClick();
      },
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: C.white,
      elevation: 6,
      shadowColor: Colors.black26,
      itemBuilder: (context) => AppLang.values
          .map((l) => PopupMenuItem<AppLang>(
                value: l,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  labels[l]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: currentLang == l ? C.darkBlue : C.textLight,
                  ),
                ),
              ))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labels[currentLang]!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: C.darkBlue,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF4FC3F7),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(AppLang lang) => Container(
        height: 44,
        decoration: BoxDecoration(
            color: C.lightBlue,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: C.lightBlue)),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          const Icon(Icons.search_rounded, color: C.mid, size: 19),
          const SizedBox(width: 9),
          Expanded(
              child: Text(LS.get(lang, 'searchHint'),
                  style: TextStyle(
                      fontSize: 13, color: C.textLight.withOpacity(0.85)),
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

  // ── MARQUEE ────────────────────────────────────────────────────────────────
  Widget _marqueeBar(AppLang lang) => SizedBox(
        height: 32,
        child: Container(
          decoration: BoxDecoration(
              color: C.frost, borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child: AnimatedBuilder(
              animation: _marquee,
              builder: (_, __) {
                const charW = 6.0;
                final baseText = LS.get(lang, 'marqueeText');
                final segW =
                    (baseText.length * charW).clamp(1.0, double.infinity);
                final totalW = segW * 4;
                final offset = (_marquee.value * totalW) % segW;
                return ClipRect(
                    child: OverflowBox(
                  maxWidth: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                      offset: Offset(-offset, 0),
                      child: Text(baseText * 8,
                          style: const TextStyle(
                              fontSize: 11,
                              color: C.mid,
                              fontWeight: FontWeight.w600),
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          maxLines: 1)),
                ));
              }),
        ),
      );

  Widget _couponCard(AppLang lang) => Container(
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.lightBlue),
        ),
        // ← Remove IntrinsicHeight; use a fixed min-height Row instead
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: C.mid.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        LS.get(lang, 'couponCode'),
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: C.mid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LS.get(lang, 'couponTitle'),
                      style: const TextStyle(
                          fontSize: 16, // ← slightly smaller for Amharic
                          fontWeight: FontWeight.w900,
                          color: C.navy),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      LS.get(lang, 'couponDesc'),
                      style: const TextStyle(fontSize: 10, color: C.textMid),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            CustomPaint(
                size: const Size(1, 64), // ← fixed height instead of infinity
                painter: _DashPainter()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LS.get(lang, 'couponOff'),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: C.mid),
                  ),
                  Text(
                    LS.get(lang, 'couponOffLabel'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: C.navy),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
                'lib/assets/lije_logo.png',
                width: 90,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Text('🤰', style: TextStyle(fontSize: 52)),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
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
          '📅',
          LS.get(lang, 'pregnancyCalc'),
          LS.get(lang, 'pregnancyCalcSub'),
          const [C.darkBlue, C.darkBlue],
          () => _navigateTo(
              ctx,
              ScreenShell(
                  title: LS.get(lang, 'pregnancyCalc').replaceAll('\n', ' '),
                  body: const _ComingSoonBody()))),
      _CatData(
          '🤰',
          LS.get(lang, 'duringPregnancy'),
          LS.get(lang, 'duringPregnancySub'),
          const [C.darkBlue, C.darkBlue],
          () => _navigateTo(ctx, const DuringPregnancyScreen())),
      _CatData(
          '👶',
          LS.get(lang, 'afterBirth'),
          LS.get(lang, 'afterBirthSub'),
          const [C.darkBlue, C.darkBlue],
          () => _navigateTo(
              ctx,
              ScreenShell(
                  title: LS.get(lang, 'afterBirth').replaceAll('\n', ' '),
                  body: const _ComingSoonBody()))),
      _CatData(
          '🩺',
          LS.get(lang, 'talkDoctor'),
          LS.get(lang, 'talkDoctorSub'),
          const [C.darkBlue, C.darkBlue],
          () => _showComingSoon(ctx, lang)),
    ];
    return Column(children: [
      Row(children: [
        Expanded(
            child: SizedBox(
                height: 116,
                child: _CatCard(cat: cats[0], delay: Duration.zero))),
        const SizedBox(width: 12),
        Expanded(
            child: SizedBox(
                height: 116,
                child: _CatCard(
                    cat: cats[1], delay: const Duration(milliseconds: 70)))),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
            child: SizedBox(
                height: 116,
                child: _CatCard(
                    cat: cats[2], delay: const Duration(milliseconds: 140)))),
        const SizedBox(width: 12),
        Expanded(
            child: SizedBox(
                height: 116,
                child: _CatCard(
                    cat: cats[3], delay: const Duration(milliseconds: 210)))),
      ]),
    ]);
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
                            _flatPill('⭐  ${LS.get(lang, 'trimester2')}'),
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
                        child: const Center(
                            child: Text('👶', style: TextStyle(fontSize: 28))),
                      ),
                    ]),
                const SizedBox(height: 13),
                _babyStats(lang),
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
                _flatBtn(label: LS.get(lang, 'updateDetails'), onTap: () {}),
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

  Widget _babyStats(AppLang lang) => Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: C.lightBlue,
            borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(child: _stat('📏', LS.get(lang, 'babySize'), '21.5 cm')),
          Container(width: 1, height: 32, color: C.darkBlue.withOpacity(0.12)),
          Expanded(child: _stat('⚖', LS.get(lang, 'babyWeight'), '650 g')),
          Container(width: 1, height: 32, color: C.darkBlue.withOpacity(0.12)),
          Expanded(child: _stat('🥭', LS.get(lang, 'bigAs'), 'Mango')),
        ]),
      );

  Widget _stat(String emoji, String label, String value) => Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
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
                  child: Text('🌟', style: TextStyle(fontSize: 20))),
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
                child: Text('💡', style: TextStyle(fontSize: 18))),
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
                  child: Text('📋', style: TextStyle(fontSize: 18))),
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
                    onTap: () => HapticFeedback.lightImpact(),
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
                _footerItem('👩', LS.get(lang, 'healthyMother')),
                Container(width: 1, height: 30, color: Colors.white24),
                _footerItem('👶', LS.get(lang, 'healthyChild')),
                Container(width: 1, height: 30, color: Colors.white24),
                _footerItem('👨‍👩‍👦', LS.get(lang, 'happyFamily')),
              ]),
        ),
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
  final List<Color> grad;
  final VoidCallback onTap;
  const _CatData(this.emoji, this.title, this.sub, this.grad, this.onTap);
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
                    color: C.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.lightBlue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.cat.emoji,
                              style: const TextStyle(fontSize: 19)),
                          const SizedBox(height: 5),
                          Text(widget.cat.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: C.darkBlue,
                                  height: 1.2)),
                          const SizedBox(height: 2),
                          Text(widget.cat.sub,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10, color: C.textLight)),
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
                  child: Text('🚧', style: TextStyle(fontSize: 40))),
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

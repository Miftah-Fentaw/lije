import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/models.dart';
import 'screens/navs/home.dart';
import 'screens/navs/doctors.dart';
import 'screens/navs/discover.dart';
import 'screens/navs/profile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LIJE LOGO
// ─────────────────────────────────────────────────────────────────────────────
class LijeLogo extends StatelessWidget {
  final double size;
  const LijeLogo({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: C.vivid.withOpacity(0.4), blurRadius: 10)],
      ),
      child: ClipOval(
        child: Image.asset(
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
          gradient: LinearGradient(
            colors: [C.navy, C.vivid],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
        Icons.people_rounded,
        Icons.people_outline_rounded,
        LS.get(lang, 'doctors')
      ),
      (
        Icons.explore_rounded,
        Icons.explore_outlined,
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4)),
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
              final color = active ? C.vivid : const Color(0xFF94A3B8);
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? items[i].$1 : items[i].$2,
                        size: 26,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: color,
                        ),
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
class PlaceholderTab extends StatelessWidget {
  final String label, emoji;
  const PlaceholderTab({required this.label, required this.emoji});

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


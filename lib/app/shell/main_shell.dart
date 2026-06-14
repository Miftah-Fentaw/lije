import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/services/notification_service.dart';
import 'package:lije/features/auth/services/auth_storage.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/features/discover/ui/discover_tab.dart';
import 'package:lije/features/doctors/ui/doctors_tab.dart';
import 'package:lije/features/home/ui/home_tab.dart';
import 'package:lije/features/settings/ui/settings_tab.dart';
import 'package:lije/core/widgets/lije_logo.dart';

// MAIN SHELL
// ─────────────────────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bootstrap());
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        NotificationService.maybePromptForPermissions(context, appState);
      });
    });
  }

  Future<void> _bootstrap() async {
    final user = await AuthStorage.loadUser();
    if (user?.supabaseId != null) {
      await appState.bindUser(user!.supabaseId);
    }
    await NotificationService.refreshDisplayCache();
    await NotificationService.startup(appState);
  }

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
        body: IndexedStack(index: _idx, children: [
          HomeTab(onNavigateToTab: _onTap),
          const DoctorsTab(),
          const DiscoverTab(),
          const SettingsTab(),
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
        Icons.settings_rounded,
        Icons.settings_outlined,
        LS.get(lang, 'settings')
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
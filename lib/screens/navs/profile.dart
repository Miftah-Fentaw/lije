import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import 'settings_screens.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                LS.get(lang, 'settings'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  children: [
                    _headerCard(lang),
                    const SizedBox(height: 20),
                    _sectionLabel(LS.get(lang, 'settingsGeneral')),
                    _menuCard(context, lang, [
                      _MenuItem(
                        icon: Icons.tune_rounded,
                        title: LS.get(lang, 'settings'),
                        onTap: () => _push(context, const AppSettingsScreen()),
                      ),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        title: LS.get(lang, 'aboutUs'),
                        onTap: () => _push(context, const AboutScreen()),
                      ),
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        title: LS.get(lang, 'helpCenter'),
                        onTap: () => _push(context, const HelpCenterScreen()),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _sectionLabel(LS.get(lang, 'settingsLegal')),
                    _menuCard(context, lang, [
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        title: LS.get(lang, 'privacyPolicy'),
                        onTap: () => launchExternalUrl(
                            context, AppLinks.privacyPolicy, lang),
                        external: true,
                      ),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        title: LS.get(lang, 'termsOfService'),
                        onTap: () => launchExternalUrl(
                            context, AppLinks.termsOfService, lang),
                        external: true,
                      ),
                    ]),
                    const SizedBox(height: 32),
                    Text(
                      '${LS.get(lang, 'appName')} v1.0.0',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: C.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(AppLang lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: C.darkBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: C.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'lib/assets/lije_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.favorite_rounded, color: C.darkBlue),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LS.get(lang, 'appName'),
                  style: const TextStyle(
                    color: C.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  LS.get(lang, 'aboutTagline'),
                  style: TextStyle(
                    color: C.white.withOpacity(0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: C.textLight,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context, AppLang lang, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.lightBlue),
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Divider(
              height: 1,
              indent: 70,
              endIndent: 16,
              color: C.lightBlue,
            );
          }
          final item = items[i ~/ 2];
          return _buildTile(context, item);
        }),
      ),
    );
  }

  Widget _buildTile(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        item.onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: C.lightBlue,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(item.icon, color: C.darkBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              item.external
                  ? Icons.open_in_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: item.external ? 18 : 14,
              color: C.textLight.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool external;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.external = false,
  });
}

// Keep alias so existing imports keep working
typedef ProfileTab = SettingsTab;

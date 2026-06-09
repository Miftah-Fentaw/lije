import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lije/core/services/notification_service.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:lije/core/constants/app_assets.dart';
import 'package:lije/models/models.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  static const _langLabels = {
    AppLang.english: 'ENG',
    AppLang.amharic: 'AMH',
    AppLang.oromic: 'ORO',
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        appBar: _appBar(context, LS.get(lang, 'settings')),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _sectionLabel(LS.get(lang, 'appPreferences')),
            _card(
              children: [
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: LS.get(lang, 'languageSetting'),
                  trailing: PopupMenuButton<AppLang>(
                    onSelected: (l) async {
                      langNotifier.value = l;
                      HapticFeedback.selectionClick();
                      await NotificationService.rescheduleAll(appState);
                    },
                    offset: const Offset(0, 36),
                    color: C.white,
                    itemBuilder: (_) => AppLang.values
                        .map((l) => PopupMenuItem(
                              value: l,
                              child: Text(
                                _langLabels[l]!,
                                style: TextStyle(
                                  fontWeight: lang == l
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: C.darkBlue,
                                ),
                              ),
                            ))
                        .toList(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _langLabels[lang]!,
                          style: const TextStyle(
                            color: C.darkBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: Color(0xFF4FC3F7)),
                      ],
                    ),
                  ),
                ),
                _divider(),
                _NotificationToggle(lang: lang),
                _divider(),
                _SettingsTile(
                  icon: Icons.event_note_rounded,
                  title: LS.get(lang, 'remindersTitle'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RemindersScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionLabel(LS.get(lang, 'settingsGeneral')),
            _card(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: LS.get(lang, 'settingsVersion'),
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(
                      color: C.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  showArrow: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatefulWidget {
  final AppLang lang;
  const _NotificationToggle({required this.lang});

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  @override
  void initState() {
    super.initState();
    appState.addListener(_sync);
  }

  @override
  void dispose() {
    appState.removeListener(_sync);
    super.dispose();
  }

  void _sync() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final enabled = appState.notificationsEnabled;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.lightBlue,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: C.darkBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LS.get(widget.lang, 'notificationsSetting'),
                  style: const TextStyle(
                    color: C.darkBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  LS.get(widget.lang, 'notificationsDesc'),
                  style: const TextStyle(color: C.textLight, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeColor: C.darkBlue,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              await NotificationService.setEnabled(v, appState);
            },
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        appBar: _appBar(context, LS.get(lang, 'aboutUs')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: C.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.lightBlue),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  AppAssets.lijeLogo,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.favorite_rounded, color: C.darkBlue),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                LS.get(lang, 'appName'),
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LS.get(lang, 'aboutTagline'),
                style: const TextStyle(
                  color: C.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _infoCard(
                title: LS.get(lang, 'aboutUs'),
                body: LS.get(lang, 'aboutBody'),
              ),
              const SizedBox(height: 14),
              _infoCard(
                title: LS.get(lang, 'aboutMission'),
                body: LS.get(lang, 'aboutMissionBody'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        final faqs = [
          (LS.get(lang, 'helpFaq1Q'), LS.get(lang, 'helpFaq1A')),
          (LS.get(lang, 'helpFaq2Q'), LS.get(lang, 'helpFaq2A')),
          (LS.get(lang, 'helpFaq3Q'), LS.get(lang, 'helpFaq3A')),
        ];
        return Scaffold(
          backgroundColor: C.bgPage,
          appBar: _appBar(context, LS.get(lang, 'helpCenter')),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(
                LS.get(lang, 'helpTitle'),
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              ...faqs.map((f) => _FaqTile(question: f.$1, answer: f.$2)),
              const SizedBox(height: 20),
              _card(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: C.lightBlue,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.mail_outline_rounded,
                          color: C.darkBlue, size: 20),
                    ),
                    title: Text(
                      LS.get(lang, 'helpContact'),
                      style: const TextStyle(
                        color: C.darkBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'support@lije.app',
                      style: TextStyle(color: C.textLight, fontSize: 13),
                    ),
                    trailing: const Icon(Icons.open_in_new_rounded,
                        size: 18, color: C.textLight),
                    onTap: () => launchExternalUrl(context, AppLinks.supportEmail, lang),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.lightBlue),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _open = !_open);
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        color: C.darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: C.textLight,
                  ),
                ],
              ),
              if (_open) ...[
                const SizedBox(height: 10),
                Text(
                  widget.answer,
                  style: const TextStyle(
                    color: C.textLight,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

AppBar _appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: C.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded,
          color: C.darkBlue, size: 20),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: C.darkBlue,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

Widget _sectionLabel(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
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

Widget _card({required List<Widget> children}) {
  return Container(
    decoration: BoxDecoration(
      color: C.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: C.lightBlue),
    ),
    child: Column(children: children),
  );
}

Widget _divider() => Divider(
      height: 1,
      indent: 70,
      endIndent: 16,
      color: C.lightBlue,
    );

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: Icon(icon, color: C.darkBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: C.textLight.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => ListenableBuilder(
        listenable: appState,
        builder: (_, __) {
          final items = NotificationService.plannedReminders(appState);
          return Scaffold(
            backgroundColor: C.bgPage,
            appBar: _appBar(context, LS.get(lang, 'remindersTitle')),
            body: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: C.textLight.withOpacity(0.6)),
                          const SizedBox(height: 16),
                          Text(LS.get(lang, 'remindersEmpty'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: C.darkBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(LS.get(lang, 'remindersEmptyHint'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: C.textLight, fontSize: 13)),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final r = items[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: C.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: C.lightBlue),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: C.lightBlue,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(r.icon, color: C.darkBlue, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.title,
                                      style: const TextStyle(
                                          color: C.darkBlue,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14)),
                                  Text(r.subtitle,
                                      style: const TextStyle(
                                          color: C.textLight, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

Widget _infoCard({required String title, required String body}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: C.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: C.lightBlue),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: C.darkBlue,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: const TextStyle(
            color: C.textLight,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}

Future<void> launchExternalUrl(
    BuildContext context, String url, AppLang lang) async {
  HapticFeedback.lightImpact();
  final uri = Uri.parse(url);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LS.get(lang, 'urlOpenError')),
        backgroundColor: C.darkBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

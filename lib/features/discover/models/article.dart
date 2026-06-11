import 'package:lije/core/l10n/strings.dart';

enum DiscoverCategory { all, pregnancy, birth, nutrition, babyCare, wellness }

class DiscoverArticle {
  final String id;
  final DiscoverCategory category;
  final String emoji;
  final Map<AppLang, String> title;
  final Map<AppLang, String> summary;
  final Map<AppLang, String> body;
  final int readMinutes;

  const DiscoverArticle({
    required this.id,
    required this.category,
    required this.emoji,
    required this.title,
    required this.summary,
    required this.body,
    this.readMinutes = 3,
  });

  String t(AppLang lang, Map<AppLang, String> field) =>
      field[lang] ?? field[AppLang.english]!;
}

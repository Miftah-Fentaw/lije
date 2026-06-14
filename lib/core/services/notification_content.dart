import 'dart:math';

import 'package:lije/core/l10n/strings.dart';
import 'package:lije/features/discover/models/article.dart';
import 'package:lije/features/discover/services/discover_repository.dart';
import 'package:lije/features/during_pregnancy/models/week_registry.dart';

class DailyNotificationContent {
  final String title;
  final String body;
  const DailyNotificationContent(this.title, this.body);
}

/// Builds personalized daily notification copy for pregnancy, baby, and discover.
class NotificationContent {
  NotificationContent._();

  static String firstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '';
    return fullName.trim().split(RegExp(r'\s+')).first;
  }

  static String _greeting(AppLang lang, String? userName) {
    final name = firstName(userName);
    if (name.isEmpty) return LS.get(lang, 'notifyGreetingGeneric');
    return LS.get(lang, 'notifyGreetingNamed').replaceAll('{name}', name);
  }

  /// Gestational day 0 = LNMP day. Content rotates within each 7-day week.
  static DailyNotificationContent pregnancyDay(
    int gaDay,
    AppLang lang,
    String? userName,
  ) {
    final week = (gaDay ~/ 7 + 1).clamp(1, 40);
    final dayInWeek = gaDay % 7;
    final wd = WeekRegistry.forWeek(week);
    final greet = _greeting(lang, userName);
    final weekLabel = '${LS.get(lang, 'weeksLabel')} $week';

    switch (dayInWeek) {
      case 0:
        return DailyNotificationContent(
          '$greet ${wd.emoji} $weekLabel',
          wd.tip[lang] ?? wd.tip[AppLang.english]!,
        );
      case 1:
        final dev = wd.dev[lang] ?? wd.dev[AppLang.english]!;
        return DailyNotificationContent(
          '$greet $weekLabel · ${wd.fruit}',
          dev.split('.').first.trim(),
        );
      case 2:
        final todos = wd.todos[lang] ?? wd.todos[AppLang.english]!;
        return DailyNotificationContent(
          '$greet ✓ $weekLabel',
          todos[gaDay % todos.length],
        );
      case 3:
        final nutrition =
            wd.nutrition[lang] ?? wd.nutrition[AppLang.english]!;
        return DailyNotificationContent(
          '$greet 🥗 $weekLabel',
          nutrition[gaDay % nutrition.length],
        );
      case 4:
        return DailyNotificationContent(
          '$greet ${wd.emoji} $weekLabel',
          '${wd.milestone} · ${wd.size} · ${wd.weight}',
        );
      case 5:
        return DailyNotificationContent(
          '$greet ⚠️ $weekLabel',
          wd.warn[lang] ?? wd.warn[AppLang.english]!,
        );
      default:
        final title = wd.title[lang] ?? wd.title[AppLang.english]!;
        return DailyNotificationContent(
          '$greet $weekLabel',
          title,
        );
    }
  }

  static DailyNotificationContent babyDay(
    int daysSinceBirth,
    AppLang lang,
    String? userName,
  ) {
    final greet = _greeting(lang, userName);
    final stageKey = _babyStageKey(daysSinceBirth);
    final dayInWeek = daysSinceBirth % 7;

    if (dayInWeek == 0 || dayInWeek == 3) {
      return discoverTip(
        daysSinceBirth,
        lang,
        userName,
        babyPhase: true,
      );
    }

    switch (dayInWeek) {
      case 1:
        return DailyNotificationContent(
          '$greet ${_babyEmoji(stageKey)}',
          _babyAlert(lang, stageKey),
        );
      case 2:
        final milestones = _babyMilestones(stageKey);
        return DailyNotificationContent(
          '$greet 🌟 ${LS.get(lang, 'notifyBabyMilestone')}',
          milestones[daysSinceBirth % milestones.length],
        );
      case 4:
        return DailyNotificationContent(
          '$greet 👶 ${LS.get(lang, 'notifyBabyStage')}',
          _babyDesc(lang, stageKey),
        );
      case 5:
        return DailyNotificationContent(
          '$greet 💉 ${LS.get(lang, 'notifyBabyHealth')}',
          _babyHealthTip(daysSinceBirth, lang),
        );
      default:
        return discoverTip(daysSinceBirth, lang, userName, babyPhase: true);
    }
  }

  static DailyNotificationContent discoverTip(
    int absoluteDay,
    AppLang lang,
    String? userName, {
    bool babyPhase = false,
    bool pregnancyPhase = false,
  }) {
    final greet = _greeting(lang, userName);
    final pool = _articlePool(babyPhase: babyPhase, pregnancyPhase: pregnancyPhase);
    final seed = userName ?? 'lije';
    final index = _shuffledIndex(seed, absoluteDay, pool.length);
    final article = pool[index];
    final title = article.t(lang, article.title);
    final summary = article.t(lang, article.summary);
    return DailyNotificationContent(
      '$greet ${article.emoji} $title',
      summary,
    );
  }

  static List<DiscoverArticle> _articlePool({
    required bool babyPhase,
    required bool pregnancyPhase,
  }) {
    if (babyPhase) {
      return DiscoverData.articles
          .where((a) =>
              a.category == DiscoverCategory.babyCare ||
              a.category == DiscoverCategory.wellness ||
              a.category == DiscoverCategory.nutrition)
          .toList();
    }
    if (pregnancyPhase) {
      return DiscoverData.articles
          .where((a) =>
              a.category == DiscoverCategory.pregnancy ||
              a.category == DiscoverCategory.nutrition ||
              a.category == DiscoverCategory.wellness ||
              a.category == DiscoverCategory.birth)
          .toList();
    }
    return List<DiscoverArticle>.from(DiscoverData.articles);
  }

  static int _shuffledIndex(String seed, int absoluteDay, int count) {
    if (count == 0) return 0;
    final order = List<int>.generate(count, (i) => i);
    order.shuffle(Random(seed.hashCode));
    return order[absoluteDay % count];
  }

  static String _babyStageKey(int days) {
    final months = days ~/ 30;
    if (months < 1) return 'newborn';
    if (months < 3) return 'earlyInfant';
    if (months < 6) return 'discovering';
    if (months < 9) return 'explorer';
    if (months < 12) return 'almostToddler';
    if (months < 18) return 'firstToddler';
    if (months < 24) return 'curiousToddler';
    if (months < 36) return 'theTwos';
    if (months < 48) return 'preschooler';
    if (months < 60) return 'preK';
    return 'kindergartener';
  }

  static String _babyEmoji(String key) => switch (key) {
        'newborn' => '👶',
        'earlyInfant' => '🍼',
        'discovering' => '🔍',
        'explorer' => '🧸',
        'almostToddler' => '🎂',
        'firstToddler' => '🚶',
        'curiousToddler' => '❓',
        'theTwos' => '🌈',
        'preschooler' => '🎨',
        'preK' => '📚',
        _ => '🌟',
      };

  static String _babyAlert(AppLang lang, String key) =>
      (_babyAlerts[lang] ?? _babyAlerts[AppLang.english]!)[key] ??
      _babyAlerts[AppLang.english]![key]!;

  static String _babyDesc(AppLang lang, String key) =>
      (_babyDescs[lang] ?? _babyDescs[AppLang.english]!)[key] ??
      _babyDescs[AppLang.english]![key]!;

  static List<String> _babyMilestones(String key) =>
      _babyMilestoneSnippets[key] ??
      _babyMilestoneSnippets['newborn']!;

  static String _babyHealthTip(int days, AppLang lang) {
    if (days < 42) {
      return lang == AppLang.amharic
          ? 'የጡት ጡት በ demand ይመገቡ — newborn ብዙ ጊዜ ይፈልጋሉ።'
          : lang == AppLang.oromic
              ? "Daa'ima haaraa yeroo baay'ee nyaachisuu barbaada."
              : 'Feed on demand — newborns need frequent feeds and tummy time daily.';
    }
    if (days < 180) {
      return lang == AppLang.amharic
          ? 'የክትትል ጉዞዎችን ይከተሉ — ክትባቶች በጊዜው ይሰጣሉ።'
          : lang == AppLang.oromic
              ? 'Sakatta\'iinsa fayyaa fi talaallii yeroo isaanii hordofaa.'
              : 'Keep up with well-baby visits and vaccinations on schedule.';
    }
    return lang == AppLang.amharic
        ? 'ጠጣር ምግቦች፣ መተኛት እና እድገትን ይከታተሉ።'
        : lang == AppLang.oromic
            ? 'Nyaata cimaa, hirriba fi guddina hordofaa.'
            : 'Track solid foods, safe sleep, and growth milestones.';
  }

  static const _babyMilestoneSnippets = {
    'newborn': [
      'Responds to your voice and touch',
      'Focuses on faces up close',
      'Rooting and startle reflexes are active',
    ],
    'earlyInfant': [
      'First social smile may appear around 6 weeks',
      'Follows objects with eyes',
      'Lifts head during tummy time',
    ],
    'discovering': [
      'Holds head steady',
      'May roll from tummy to back',
      'Reaches for colorful toys',
    ],
    'explorer': [
      'May sit without support',
      'Starting to explore crawling',
      'Solid foods can begin around 6 months',
    ],
    'almostToddler': [
      'Pulling to stand',
      'Cruising along furniture',
      'First steps may be close',
    ],
    'firstToddler': [
      'Walking independently',
      'Saying first words',
      'Exploring everything nearby',
    ],
    'curiousToddler': [
      'Running and climbing',
      '50+ words by 24 months',
      'Pretend play emerging',
    ],
    'theTwos': [
      'Personality shining through',
      'Toilet training may begin',
      'Loves songs and simple games',
    ],
    'preschooler': [
      'Complex sentences',
      'Plays with other children',
      'Endless curious questions',
    ],
    'preK': [
      'Counts and recognizes letters',
      'Tells detailed stories',
      'Getting ready for school',
    ],
    'kindergartener': [
      'Ready for formal schooling',
      'Strong friendships forming',
      'Loves learning new things',
    ],
  };

  static const _babyAlerts = {
    AppLang.english: {
      'newborn':
          'Feed every 2–3 hours. Watch for rooting and lip smacking. Short tummy time daily helps development.',
      'earlyInfant':
          'Talk, sing, and make eye contact often. Watch for that first social smile around 6 weeks.',
      'discovering':
          'Always place baby on their back to sleep. Colorful toys and short play sessions build skills.',
      'explorer':
          'Introduce single-ingredient purees when ready. Baby-proof your home as mobility increases.',
      'almostToddler':
          'Secure furniture and cover outlets. First steps could arrive any day — celebrate each try.',
      'firstToddler':
          'Encourage words and a steady sleep routine. Limit screen time; play together instead.',
      'curiousToddler':
          'By 24 months, 50+ words is typical. If you are worried, talk to your pediatrician.',
      'theTwos':
          'Toilet training works best when child shows interest. Never punish accidents — stay patient.',
      'preschooler':
          'Practice sharing and following simple instructions. A calm bedtime routine still matters.',
      'preK':
          'Practice counting, letters, and scissor skills through play. Kindergarten is approaching.',
      'kindergartener':
          'Five years — what a journey! Celebrate growth and keep regular wellness visits.',
    },
    AppLang.amharic: {
      'newborn':
          'በ2–3 ሰዓት ይመገቡ። የራብ ምልክቶችን ይፈልጉ። ዕለታዊ ሆድ ጊዜ ይስጡ።',
      'earlyInfant':
          'ብዙ ይናገሩ፣ ዘፈን ዘምሩ፣ የዓይን ግ contact ይስጡ። ፈገግታ በ6 ሳምንት ይጠብቁ።',
      'discovering':
          'ለ sleep ሁልጊዜ በጀርባ ይተኛሉ። ቀለማማ ዕቃዎች ያቅርቡ።',
      'explorer':
          'ጠጣር ምግቦችን ነጠላ ንጥረ ነገር ፑሬ ይጀምሩ። ቤትዎን baby-proof ያድርጉ።',
      'almostToddler':
          'እርምጃዎችን ይበረታቱ። ደህንነቱ የተጠበቀ ቦታ ይስጡ።',
      'firstToddler':
          'የምሽት routine ያቀናብሩ። ቃላትን በመጫወት ይሳዱ።',
      'curiousToddler':
          'በ24 ወር 50+ ቃላት ተ طبيعي ናቸው። ስጋት ካለ ሐኪምዎን ያነጋግሩ።',
      'theTwos':
          'የሽንት ቤት ሥልጠና በትዕግስት። accidentsን አያስቀብሉ።',
      'preschooler':
          'መጋራት እና መከተል ይለማመዱ። የምሽት routine ይጠብቁ።',
      'preK':
          'መቁጠር እና ፊደላት በመጫወት ይለማመዱ።',
      'kindergartener':
          '5 ዓመት — ታላቅ ስኬት! wellness visits ይቀጥሉ።',
    },
    AppLang.oromic: {
      'newborn':
          "Sa'aatii 2–3tti nyaachisaa. Mallattoo beela ilaali. Guyyaa guyyaa garaa gadi buusuu kenni.",
      'earlyInfant':
          'Baay\'ee dubbii, faaruu fi ija wal arguu. Yeeyyiin torbaan 6 keessatti eegaa.',
      'discovering':
          'Hirribaaf dugda irratti kaa\'i. Meeshaalee bifa qaban taphachiisi.',
      'explorer':
          'Nyaata cimaa jalqabuu. Mana daa\'imaaf nageenya qabeessa taasisi.',
      'almostToddler':
          'Tarkaanfii jalqabaa booyyaa. Naannoo nageenya qabeessa taasisi.',
      'firstToddler':
          'Tartiiba hirribaa sirreessi. Jechoota taphaan barsiisi.',
      'curiousToddler':
          'Ji\'a 24tti jechoota 50+ barbaachisa. Yaada yoo qabaatte doktora qunnamii.',
      'theTwos':
          'Leenjii mana fincaanii obsaan. Dogoggora hin adabbii.',
      'preschooler':
          'Qooduu fi hordofuu taphaan barsiisi. Tartiiba hirribaa eegaa.',
      'preK':
          'Lakkoofsaa fi qubee taphaan qopheessi.',
      'kindergartener':
          'Waggaa shan — milkaa\'ina guddaa! Sakatta\'iinsa fayyaa itti fufi.',
    },
  };

  static const _babyDescs = {
    AppLang.english: {
      'newborn':
          'Your newborn sleeps 14–17 hours and feeds every 2–3 hours. Skin-to-skin bonding matters most now.',
      'earlyInfant':
          'Baby is more alert each day. Smiles and coos are on the way — keep talking and responding.',
      'discovering':
          'Curiosity is blooming. Head control improves and reaching for toys begins.',
      'explorer':
          'A big leap — sitting, crawling, and first foods may all appear in this stage.',
      'almostToddler':
          'First birthday is near. Pulling up and cruising are major wins to celebrate.',
      'firstToddler':
          'Happy toddler era! Independent steps and new words make every day exciting.',
      'curiousToddler':
          'Energy is endless. Running, climbing, and asking "why?" are daily adventures.',
      'theTwos':
          'Big feelings and big personality. Gentle boundaries and patience go a long way.',
      'preschooler':
          'Social skills and imagination are growing fast. Play is how they learn best.',
      'preK':
          'Almost school-ready. Counting, stories, and curiosity are your superpowers.',
      'kindergartener':
          'Five years of love and growth. Your child is ready for the next big chapter.',
    },
    AppLang.amharic: {
      'newborn': 'አዲስ ወለድ ብዙ ይተኛል እና በተደጋጋሚ ይመገባል። Skin-to-skin bonding አስፈላጊ ነው።',
      'earlyInfant': 'ልጅዎ ተጨማሪ ንቁ እየሆኑ ነው። ፈገግታ እና ድምፅ በመንገድ ላይ ናቸው።',
      'discovering': 'ጉጉት እያደገ ነው። ጭንቅላትን መያዝ እና ዕቃ መጥቀም ይጀምራል።',
      'explorer': 'ትልቅ ዝላይ — መቀመጥ፣ መንሸራተት እና ጠጣር ምግብ።',
      'almostToddler': 'የመጀመሪያ ልደት ቅርብ ነው። መቆም እና መንሸራተት ይከብሩ።',
      'firstToddler': 'የቶዳለር ጊዜ! እርምጃዎች እና አዲስ ቃላት።',
      'curiousToddler': 'ኃይል የማያልቅ። መሮጥ፣ መድረስ እና «ለምን?»',
      'theTwos': 'ትልቅ ስሜቶች። ትዕግስት እና ገደቦች በ tenderness.',
      'preschooler': 'ማህበራዊ እና imagination እየጎለበተ ነው።',
      'preK': 'ለትምህርት ቤት تقریباً ዝግጁ።',
      'kindergartener': '5 ዓመት ፍቅር እና እድገት — ትምህርት ቤት ዝግጁ።',
    },
    AppLang.oromic: {
      'newborn': "Daa'ima haaraan baay'ee ni ciisu, yeroo baay'ee ni nyaata.",
      'earlyInfant': "Daa'imni kee ammayyuu hojjataafi jira.",
      'discovering': 'Ho\'ni guddataa jira.',
      'explorer': 'Guddina guddaa — taa\'uu, lixuun fi nyaata cimaa.',
      'almostToddler': 'Guyyaa dhalootaa jalqabaa dhiyaatee jira.',
      'firstToddler': 'Bilisaan deemuu fi jechoota haaraa.',
      'curiousToddler': 'Humna hin dhufne — fiiguun fi gaaffii.',
      'theTwos': 'Miira guddaa — obsaan buli.',
      'preschooler': 'Afaan hawaasaa fi hayyama guddachaa jira.',
      'preK': 'Barumsaaf qophii dhihaatee jira.',
      'kindergartener': 'Waggaa shan — barumsaaf qophaawaa.',
    },
  };
}

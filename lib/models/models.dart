// =============================================================================
// models.dart  —  Lije Pregnancy & Child Growth App
// Shared enums, state, localization, design tokens
// =============================================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE ENUM + NOTIFIER
// ─────────────────────────────────────────────────────────────────────────────
enum AppLang { english, amharic, oromic }

final ValueNotifier<AppLang> langNotifier =
    ValueNotifier<AppLang>(AppLang.english);

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
abstract class C {
  // ── Core 3-color palette ───────────────────────────────────────────────────
  static const darkBlue = Color(0xFF1B3A6B);
  static const lightBlue = Color(0xFFD6E8F7);
  static const white = Color(0xFFFFFFFF);

  // ── Derived tokens (mapped to core palette) ──────────────────────────────
  static const navy = darkBlue;
  static const deep = darkBlue;
  static const mid = darkBlue;
  static const bright = darkBlue;
  static const vivid = darkBlue;
  static const soft = darkBlue;
  static const pale = lightBlue;
  static const frost = lightBlue;

  // ── Semantic aliases ────────────────────────────────────────────────────────
  static const primary = darkBlue;
  static const primaryDark = darkBlue;
  static const primaryLight = lightBlue;
  static const bgPage = lightBlue;
  static const cardBg = white;
  static const cardBorder = lightBlue;

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const textDark = darkBlue;
  static const textMid = darkBlue;
  static const textLight = Color(0xFF6B8CAE);
  static const textBody = darkBlue;

  // ── Legacy/Semantic mappings ────────────────────────────────────────────────
  static const primaryBg = frost;
  static const primaryBg2 = pale;
  static const offWhite = Color(0xFFF8FAFC); 
  
  // ── Sky family (mapped to core palette) ─────────────────────────────────────
  static const skyDeep = darkBlue;
  static const skyMid = darkBlue;
  static const skyBright = darkBlue;
  static const skyLight = lightBlue;
  static const skyPale = lightBlue;
  static const skyFrost = lightBlue;
  static const skyGlow = lightBlue;

  // ── Semantic colours ─────────────────────────────────────────────────────────
  static const success = Color(0xFF10B981);
  static const successBg = Color(0xFFD1FAE5);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFFEEEE);
  static const warn = Color(0xFFF59E0B);
  static const warnBg = Color(0xFFFEF3C7);

  // ── Accent families ──────────────────────────────────────────────────────────
  static const coral = Color(0xFFF43F5E);
  static const coralLight = Color(0xFFFFF1F2);
  static const coralBg = Color(0xFFFFF1F2);
  static const gold = Color(0xFFF59E0B);
  static const goldLight = Color(0xFFFEF3C7);
  static const mint = Color(0xFF10B981);
  static const mintLight = Color(0xFFECFDF5);
  static const lavender = Color(0xFF8B5CF6);
  static const lavenderLight = Color(0xFFF5F3FF);
  static const purple = Color(0xFF8B5CF6);
  static const purpleBg = Color(0xFFF5F3FF);

  // ── Borders & surfaces ────────────────────────────────────────────────────────
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);
  static const grayBg = Color(0xFFF1F5F9);

  // ── Flat color sets (no gradients) ─────────────────────────────────────────
  static const List<Color> headerGrad = [darkBlue, darkBlue];
  static const List<Color> cardGrad = [darkBlue, darkBlue];
  static const List<Color> navGrad = [darkBlue, darkBlue];
  static const List<Color> heroGrad = [darkBlue, darkBlue];
  
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCALIZATION
// ─────────────────────────────────────────────────────────────────────────────
class LS {
  static String get(AppLang lang, String key) {
    final m = _s[lang] ?? _s[AppLang.english]!;
    return m[key] ?? _s[AppLang.english]![key] ?? key;
  }

  static const Map<AppLang, Map<String, String>> _s = {
    // ── ENGLISH ──────────────────────────────────────────────────────────────
    AppLang.english: {
      // ── App shell ────────────────────────────────────────────────────────────
      'appName': 'LIJE',
      'appSubtitle': 'Pregnancy & Child Growth',
      'home': 'Home',
      'doctors': 'Doctors',
      'findDoctorTitle': 'Find Doctor',
      'bookConsult': 'bookConsult',
      'expYears': 'years exp',
      'doctorBio': 'About Doctor',
      'ratings': 'Ratings',
      'etb': 'ETB',
      'categories': 'Categories',
      'shop': 'Shop',
      'discover': 'Discover',
      'profile': 'Profile',
      'searchHint': 'Search tips, doctors…',
      'selectSection': 'Quick Access',

      // ── Home cards ───────────────────────────────────────────────────────────
      'pregnancyCalc': 'Pregnancy\nCalculator',
      'pregnancyCalcSub': 'Track your due date',
      'duringPregnancy': 'During\nPregnancy',
      'duringPregnancySub': 'Week-by-week guide',
      'afterBirth': 'After\nBirth',
      'afterBirthSub': 'Child growth tracker',
      'talkDoctor': 'Talk to\nDoctor',
      'talkDoctorSub': 'Expert consultations',
      'talkToDoctor': 'Talk to a Doctor',

      // ── Dashboard ────────────────────────────────────────────────────────────
      'myPregnancy': 'My Pregnancy',
      'trimester2': '2nd Trimester',
      'babySize': 'Length',
      'babyWeight': 'Weight',
      'bigAs': 'Size of',
      'updateDetails': 'Update Details',
      'pregnancyProgress': 'Pregnancy Progress',
      'tipTitle': "Today's Tip",
      'tipText':
          'Stay hydrated — drink at least 8 glasses of water daily. Iron-rich foods like lentils, spinach and lean meat support your baby\'s development.',
      'doctorDesc':
          'Get personalised advice from certified Ethiopian obstetricians.',
      'consultNow': 'Consult Now',
      'healthyMother': 'Healthy\nMother',
      'healthyChild': 'Healthy\nChild',
      'happyFamily': 'Happy\nFamily',
      'weeksLabel': 'wks',
      'daysLabel': 'days',
      'onlineLabel': 'Online',
      'weeklyHighlight': 'Week Highlight',
      'weekHighlightText':
          'Your baby can now hear your voice! Talk and sing to strengthen your bond.',
      'upcomingAppt': 'Next Appointment',
      'apptDate': 'Mon, Jun 9 — 10:00 AM',
      'apptDoctor': 'Dr. Selamawit Bekele',
      'viewAll': 'View All',
      'heroBadge': 'LIMITED OFFER',
      'heroTitle': 'Pregnancy\nCare',
      'heroOffer': '75% OFF',
      'couponCode': 'MAMA200',
      'couponTitle': 'COUPON',
      'couponDesc': 'Valid this month; excludes gift cards.',
      'couponOff': '20%',
      'couponOffLabel': 'OFF FIRST\nCONSULT',
      'marqueeText':
          'New week guides!  ·  Talk to a doctor  ·  Track growth  ·  ',
      'categoriesTitle': 'Categories',
      'shopTitle': 'Shop',
      'discoverTitle': 'Discover',
      'discoverSubtitle': 'Tips & guides for pregnancy, birth, and baby care',
      'discoverSearchHint': 'Search tips and articles…',
      'discoverEmpty': 'No articles found. Try another search or category.',
      'minRead': 'min read',
      'profileTitle': 'Profile',
      'comingSoon': 'Coming Soon',
      'comingSoonDesc': 'This section is under development.\nStay tuned!',

      // ── Pregnancy Calculator ──────────────────────────────────────────────────
      'pregnancyCalcTitle': 'Pregnancy Calculator',
      'findDueDate': 'Find Your\nDue Date',
      'gregorianEthiopian': 'Gregorian & Ethiopian Dates',
      'chooseMethod': 'CALCULATION METHOD',
      'lastPeriod': 'Last Period',
      'ultrasound': 'Ultrasound',
      'ivfTransfer': 'IVF Transfer',
      'lnmpDesc':
          'Enter the first day of your last normal menstrual period. We use Naegele\'s rule: add 9 months and 7 days.',
      'usDesc':
          'Enter the date of your ultrasound scan and the gestational age shown on the report.',
      'ivfDesc':
          'Enter the date your embryo was transferred and select the embryo age at transfer.',
      'firstDayPeriod': 'First Day of Last Period',
      'usDate': 'Ultrasound Scan Date',
      'babyAgeWeeks': 'Baby\'s Age (weeks)',
      'extraDays': 'Extra Days',
      'ivfDate': 'Embryo Transfer Date',
      'embryoAge': 'Embryo Age at Transfer',
      'day3Embryo': '🔬  Day 3 Cleavage',
      'day5Embryo': '🧫  Day 5 Blastocyst',
      'selectDate': 'Select a date',
      'calculate': 'Calculate Due Date',
      'calculateAgain': 'Calculate Again',
      'howCalcWorks': 'How the calculation works',
      'calcRule1':
          'Last Period (LNMP): EDD = LNMP + 9 months + 7 days (Naegele\'s rule).',
      'calcRule2':
          'Ultrasound: Back-calculates LNMP from GA at scan, then adds 280 days.',
      'calcRule3':
          'IVF: EDD = Transfer date + (266 days − embryo age); adjusts precisely for Day-3 or Day-5 embryos.',
      'gregorian': 'Gregorian',
      'ethiopian': 'Ethiopian',
      'cancel': 'Cancel',
      'ok': 'Confirm',

      // ── Result card ──────────────────────────────────────────────────────────
      'expectedDueDate': 'Expected Due Date',
      'basedOnInfo': 'Based on information provided',
      'dueDateEdd': 'Due Date (EDD)',
      'babyAgeToday': 'Baby\'s Age Today',
      'daysUntilDue': 'Days Until Due',
      'todayIsDueDate': '🎉 Today is your due date!',
      'daysOverdue': 'days overdue',
      'daysRemaining': 'days remaining',
      'trimester': 'Current Trimester',
      'firstTrimester': '1st Trimester',
      'secondTrimester': '2nd Trimester',
      'thirdTrimester': '3rd Trimester',
      'week1': 'Week 1',
      'week40': 'Week 40',
      'weeksRange1': 'Wks 1–13',
      'weeksRange2': 'Wks 14–26',
      'weeksRange3': 'Wks 27–40',
      'tipFirst':
          '💊 Take folic acid daily. Avoid alcohol, tobacco and raw foods. Attend all scheduled visits.and notify me any progress',
      'tipSecond':
          '🥗 Eat iron-rich foods (lentils, spinach, red meat) to prevent anaemia. Stay active with gentle walking.and notify me any progress',
      'tipThird':
          '🏥 Pack your hospital bag. Learn labour signs. Sleep on your left side for best blood flow.and notify me any progress',
      'tipOverdue':
          '⏰ You are past your due date. Contact your healthcare provider today to discuss next steps.and notify me any progress',
    },

    // ── አማርኛ ─────────────────────────────────────────────────────────────────
    AppLang.amharic: {
      // ── App shell ────────────────────────────────────────────────────────────
      'appName': 'ልጄ',
      'appSubtitle': 'የእርግዝና እና የህፃን እድገት',
      'home': 'ዋና',
      'categories': 'ምድቦች',
      'shop': 'ሱቅ',
      'discover': 'ፈልግ',
      'profile': 'መገለጫ',
      'searchHint': 'ምክር ወይም ዶክተር ይፈልጉ…',
      'selectSection': 'ፈጣን ድረስ',

      // ── Home cards ───────────────────────────────────────────────────────────
      'pregnancyCalc': 'የእርግዝና\nካልኩሌተር',
      'pregnancyCalcSub': 'ቀኑን ይፈልጉ',
      'duringPregnancy': 'በእርግዝና\nወቅት',
      'duringPregnancySub': 'ሳምንታዊ መመሪያ',
      'afterBirth': 'ከወሊድ\nበኋላ',
      'afterBirthSub': 'የህፃን እድገት',
      'talkDoctor': 'ዶክተር\nጠይቁ',
      'talkDoctorSub': 'የባለሙያ ምክር',
      'talkToDoctor': 'ዶክተር ጠይቁ',

      // ── Dashboard ────────────────────────────────────────────────────────────
      'myPregnancy': 'ማህፀኔ',
      'trimester2': '2ኛ ወር',
      'babySize': 'ርዝማኔ',
      'babyWeight': 'ክብደት',
      'bigAs': 'ያህል',
      'updateDetails': 'መረጃ ያዘምኑ',
      'pregnancyProgress': 'ሂደት',
      'tipTitle': 'የዛሬ ምክር',
      'tipText': 'ቢያንስ 8 ብርጭቆ ውሃ ይጠጡ። ምስር፣ ስፒናች እና ስጋ የህፃንዎን እድገት ይደግፋሉ።',
      'doctorDesc': 'ከተረጋገጡ ኢትዮጵያዊ ዶክተሮች ምክር ያግኙ።',
      'consultNow': 'አሁን ይጠይቁ',
      'healthyMother': 'ጤናማ\nእናት',
      'healthyChild': 'ጤናማ\nህፃን',
      'happyFamily': 'ደስተኛ\nቤተሰብ',
      'weeksLabel': 'ሳም',
      'daysLabel': 'ቀን',
      'onlineLabel': 'ይፋ',
      'weeklyHighlight': 'ሳምንታዊ ዜና',
      'weekHighlightText': 'ህፃኑ አሁን ድምፅዎን ሊሰማ ይችሉ ናቸው!',
      'upcomingAppt': 'ሚቀጥለው ቀጠሮ',
      'apptDate': 'ሰኞ ሰኔ 9 — ጠ10:00',
      'apptDoctor': 'ዶ/ር ሰላማዊት በቀለ',
      'viewAll': 'ሁሉ ይዩ',
      'heroBadge': 'ልዩ ቅናሽ',
      'heroTitle': 'የእርግዝና\nእንክብካቤ',
      'heroOffer': '75% ቅናሽ',
      'couponCode': 'MAMA200',
      'couponTitle': 'ኩፖን',
      'couponDesc': 'ይህን ወር ይሰራሉ።',
      'couponOff': '20%',
      'couponOffLabel': 'ቅናሽ\nበ1ኛ',
      'marqueeText': 'አዲስ ሳምንታዊ!  ·  ዶክተር ይጠይቁ  ·  ',
      'categoriesTitle': 'ምድቦች',
      'shopTitle': 'ሱቅ',
      'discoverTitle': 'ፈልግ',
      'discoverSubtitle': 'ለእርግዝና፣ ወሊድ እና የህፃን እንክብካቤ ምክሮች',
      'discoverSearchHint': 'ምክር እና مقالات ይፈልጉ…',
      'discoverEmpty': 'ምንም مقال አልተገኘም። ሌላ ፍለጋ ይሞክሩ።',
      'minRead': 'ደቂቃ',
      'profileTitle': 'መገለጫ',
      'comingSoon': 'በቅርቡ',
      'comingSoonDesc': 'ይህ ክፍል በልማት ላይ ነው።\nጠብቁ!',

      // ── Pregnancy Calculator ──────────────────────────────────────────────────
      'pregnancyCalcTitle': 'የእርግዝና ካልኩሌተር',
      'findDueDate': 'የወሊድ ቀንዎን\nይፈልጉ',
      'gregorianEthiopian': 'ግሪጎሪያን እና ኢትዮጵያ ቀናት',
      'chooseMethod': 'የሚሊ ዘዴ ይምረጡ',
      'lastPeriod': 'ዳሕረኛ ወር አበባ',
      'ultrasound': 'ኡልትራሳውንድ',
      'ivfTransfer': 'IVF ሽግግር',
      'lnmpDesc': 'የወር አበባዎ የመጀመሪያ ቀን ያስገቡ። ናይጌሌ ቀመር ይጠቀምናለን፥ 9 ወር + 7 ቀን።',
      'usDesc': 'የኡልትራሳውንድ ቀን እና በሪፖርቱ ላይ የታየውን የፅንሱ ዕድሜ ያስገቡ።',
      'ivfDesc': 'የፅንሱ ሽግግር ቀን ያስገቡ እና የፅንሱን ዕድሜ ይምረጡ።',
      'firstDayPeriod': 'የወር አበባ የመጀመሪያ ቀን',
      'usDate': 'የኡልትራሳውንድ ቀን',
      'babyAgeWeeks': 'የሕፃን ዕድሜ (ሳምንቶች)',
      'extraDays': 'ተጨማሪ ቀናት',
      'ivfDate': 'የፅንሱ ሽግግር ቀን',
      'embryoAge': 'የፅንሱ ዕድሜ ሲሸጋገሩ',
      'day3Embryo': '🔬  ቀን 3 Cleavage',
      'day5Embryo': '🧫  ቀን 5 Blastocyst',
      'selectDate': 'ቀን ይምረጡ',
      'calculate': 'የወሊድ ቀን አሰሉ',
      'calculateAgain': 'እንደገና አሰሉ',
      'howCalcWorks': 'ቀመሩ እንዴት ይሰራሉ',
      'calcRule1': 'ዳሕረኛ ወር አበባ (LNMP)፥ EDD = LNMP + 9 ወር + 7 ቀን (ናይጌሌ ቀመር)።',
      'calcRule2': 'ኡልትራሳውንድ፥ ስካን ቀን ከፅንሱ ዕድሜ ተቀንሶ LNMP ይሰላሉ ከዚያ 280 ቀን ይጨምሩ።',
      'calcRule3':
          'IVF፥ EDD = ሽግግር ቀን + (266 ቀን − የፅንሱ ዕድሜ)፤ ቀን 3 ወይም ቀን 5 ፅንስ ይስተካከሉ።',
      'gregorian': 'ግሪጎሪያን',
      'ethiopian': 'ኢትዮጵያ',
      'cancel': 'ሰርዝ',
      'ok': 'አረጋግጥ',

      // ── Result card ──────────────────────────────────────────────────────────
      'expectedDueDate': 'የሚጠበቅ የወሊድ ቀን',
      'basedOnInfo': 'በቀረበው መረጃ ላይ ተመስርቶ',
      'dueDateEdd': 'የወሊድ ቀን (EDD)',
      'babyAgeToday': 'የሕፃን ዕድሜ ዛሬ',
      'daysUntilDue': 'እስከ ወሊድ ቀን ቀሪ',
      'todayIsDueDate': '🎉 ዛሬ የወሊድ ቀን ነው!',
      'daysOverdue': 'ቀን ካለፈ',
      'daysRemaining': 'ቀናት ቀሪ',
      'trimester': 'አሁን ያለው ትሪሜስተር',
      'firstTrimester': '1ኛ ትሪሜስተር',
      'secondTrimester': '2ኛ ትሪሜስተር',
      'thirdTrimester': '3ኛ ትሪሜስተር',
      'week1': 'ሳምንት 1',
      'week40': 'ሳምንት 40',
      'weeksRange1': 'ሳም 1–13',
      'weeksRange2': 'ሳም 14–26',
      'weeksRange3': 'ሳም 27–40',
      'tipFirst': '💊 ፎሊክ አሲድ ይዙ። አልኮሆልና ሲጋራ ያስወግዱ። ሁሉ ቀጠሮ ይናዘዙ።',
      'tipSecond': '🥗 ምስር፣ ስፒናች፣ ስጋ ይብሉ። ቀሉ ደምን ይከላከሉ። ቀሉ ምጥ ይሂዱ።',
      'tipThird': '🏥 ሆስፒታሉ ቦርሳ ያዘጋጁ። የወሊድ ምልክቶችን ይወቁ። ግራ ጎን ያርፉ።',
      'tipOverdue': '⏰ የወሊድ ቀን አልፏሉ። ዛሬ ሐኪምዎን ያናግሩ።',
    },

    // ── Afaan Oromoo ─────────────────────────────────────────────────────────
    AppLang.oromic: {
      // ── App shell ────────────────────────────────────────────────────────────
      'appName': 'MUCAA KOO',
      'appSubtitle': 'Ulfaa fi Guddina',
      'home': 'Mana',
      'categories': 'Kutaalee',
      'shop': 'Gabaa',
      'discover': 'Barbaadi',
      'profile': 'Eenyummaa',
      'searchHint': 'Gorsa, doktora barbaadi…',
      'selectSection': 'Karaa Saffisaa',

      // ── Home cards ───────────────────────────────────────────────────────────
      'pregnancyCalc': 'Herrega\nUlfaa',
      'pregnancyCalcSub': 'Guyyaa baruu',
      'duringPregnancy': 'Yeroo\nUlfaa',
      'duringPregnancySub': 'Qajeelfama torb.',
      'afterBirth': "Da'umsa\nBooda",
      'afterBirthSub': "Guddina daa'ima",
      'talkDoctor': 'Doktora\nGaafadhu',
      'talkDoctorSub': 'Gorsa ogummaa',
      'talkToDoctor': 'Doktora Gaafadhu',

      // ── Dashboard ────────────────────────────────────────────────────────────
      'myPregnancy': 'Ulfaa Koo',
      'trimester2': 'Gilgaala 2ffaa',
      'babySize': 'Dheerinaa',
      'babyWeight': 'Ulfaatina',
      'bigAs': 'Hangana',
      'updateDetails': 'Haaromsi',
      'pregnancyProgress': 'Giddugala',
      'tipTitle': "Gorsa Har'aa",
      'tipText': 'Bishaan glaasii 8 gudeedhu. Miseensaa fi atara nyaadhu.',
      'doctorDesc': 'Gorsa dooktoroota Itoophiyaa irraa argadhu.',
      'consultNow': 'Amma Gaafadhu',
      'healthyMother': 'Haadha\nFayyaa',
      'healthyChild': "Daa'ima\nFayyaa",
      'happyFamily': 'Maatii\nKodaabaa',
      'weeksLabel': 'torb',
      'daysLabel': 'guyyaa',
      'onlineLabel': 'Jiru',
      'weeklyHighlight': 'Oduu Torbanii',
      'weekHighlightText': "Daa'imni kee sagalee kee dhagahuu dandaa!",
      'upcomingAppt': 'Beellama',
      'apptDate': 'Wiixata Wax 9 — 10:00',
      'apptDoctor': 'Dr. Selamawit Bekele',
      'viewAll': 'Hunda',
      'heroBadge': 'DHUMA GUYYAA',
      'heroTitle': 'Kunuunsa\nUlfaa',
      'heroOffer': '75% HIRISA',
      'couponCode': 'MAMA200',
      'couponTitle': 'KUUPOONII',
      'couponDesc': "Ji'a kana hojjeta.",
      'couponOff': '20%',
      'couponOffLabel': 'HIRISA\n1FFAA',
      'marqueeText': 'Qajeelfama haaraa!  ·  Doktora gaafadhu  ·  ',
      'categoriesTitle': 'Kutaalee',
      'shopTitle': 'Gabaa',
      'discoverTitle': 'Barbaadi',
      'discoverSubtitle': 'Gorsa fi qajeelfama ulfaa, dhalootaa fi daa\'imaaf',
      'discoverSearchHint': 'Gorsa fi barruu barbaadi…',
      'discoverEmpty': 'Barruun hin argamne. Barbaacha biraa yaali.',
      'minRead': 'daq',
      'profileTitle': 'Eenyummaa',
      'comingSoon': 'Itti Aanee',
      'comingSoonDesc': 'Kutaan kun hojjetamaa jira.\nEegi!',

      // ── Pregnancy Calculator ──────────────────────────────────────────────────
      'pregnancyCalcTitle': 'Herrega Ulfaa',
      'findDueDate': 'Guyyaa Dhalootaa\nKee Barbaadi',
      'gregorianEthiopian': 'Guyyaalee Gregorian fi Itoophiyaa',
      'chooseMethod': 'MALA FILUU',
      'lastPeriod': 'Turba Darbee',
      'ultrasound': 'Sonoograafii',
      'ivfTransfer': 'IVF Jijjiiruu',
      'lnmpDesc':
          'Guyyaa jalqabaa turba darbe galchi. Seeraa Naegele itti fayyadamna: Ji\'a 9 + guyyaa 7.',
      'usDesc':
          'Guyyaa sonoograafii fi umurii ulfaa gabaasaa irratti argame galchi.',
      'ivfDesc': 'Guyyaa embryoo jijjiiruu galchi fi umurii embryoo filaa.',
      'firstDayPeriod': 'Guyyaa Jalqabaa Turba Darbe',
      'usDate': 'Guyyaa Sonoograafii',
      'babyAgeWeeks': "Umurii Daa'ima (torbaan)",
      'extraDays': 'Guyyaalee dabalataa',
      'ivfDate': 'Guyyaa Jijjiiruu Embryoo',
      'embryoAge': 'Umurii Embryoo Yeroo Jijjiiramu',
      'day3Embryo': '🔬  Guyyaa 3 Cleavage',
      'day5Embryo': '🧫  Guyyaa 5 Blastocyst',
      'selectDate': 'Guyyaa filadhu',
      'calculate': 'Guyyaa Dhalootaa Herreegi',
      'calculateAgain': 'Ammas Herreegi',
      'howCalcWorks': 'Herreegni akkam hojjeta',
      'calcRule1':
          'Turba Darbee (LNMP): EDD = LNMP + Ji\'aa 9 + Guyyaa 7 (Seeraa Naegele).',
      'calcRule2':
          'Sonoograafii: LNMP yeroo iskaanii irraa duubatti herreegamee guyyaa 280 dabalama.',
      'calcRule3':
          'IVF: EDD = Guyyaa jijjiiruu + (Guyyaa 266 − umurii embryoo); Guyyaa 3 ykn 5 sirreeffama.',
      'gregorian': 'Gregorian',
      'ethiopian': 'Itoophiyaa',
      'cancel': 'Haqi',
      'ok': 'Mirkaneessi',

      // ── Result card ──────────────────────────────────────────────────────────
      'expectedDueDate': 'Guyyaa Dhalootaa Eegamu',
      'basedOnInfo': 'Odeeffannoo irratti hundaa\'uun',
      'dueDateEdd': 'Guyyaa Dhalootaa (EDD)',
      'babyAgeToday': "Umurii Daa'ima Har'aa",
      'daysUntilDue': 'Guyyaalee Hafan',
      'todayIsDueDate': '🎉 Guyyaan dhalootaa har\'a dha!',
      'daysOverdue': 'guyyaa darbe',
      'daysRemaining': 'guyyaa hafan',
      'trimester': 'Gilgaala Ammaa',
      'firstTrimester': 'Gilgaala 1ffaa',
      'secondTrimester': 'Gilgaala 2ffaa',
      'thirdTrimester': 'Gilgaala 3ffaa',
      'week1': 'Torban 1',
      'week40': 'Torban 40',
      'weeksRange1': 'Torb 1–13',
      'weeksRange2': 'Torb 14–26',
      'weeksRange3': 'Torb 27–40',
      'tipFirst':
          '💊 Folic acid guyyaa guyyaa dhugi. Alkoolii fi sigaaraa irraa fagaadhu. Beellamiiwwan hunda hordofi.',
      'tipSecond':
          '🥗 Nyaata biroo (adamsii, spinach, foon) nyaadhu. Deemsa salphaa godhi.',
      'tipThird':
          '🏥 Saantoo hospitaalaa guuti. Mallattoo dhalootaa beeki. Gama bitaa ciisi.',
      'tipOverdue':
          '⏰ Guyyaan dhalootaa darbee jira. Dokitara kee har\'a qunnamti.',
      'personalInfo': 'Personal Information',
      'settings': 'Settings',
      'support': 'Support & Feedback',
      'logout': 'Logout',
      'editProfile': 'Edit Profile',
      'myRecords': 'My Records',
      'reminders': 'Reminders',
      'privacy': 'Privacy Policy',
      'helpCenter': 'Help Center',
      'findDoctor': 'Find a Specialist',
      'expYears': 'years exp',
      'etb': 'ETB',
      'bookConsult': 'Book Consultation',
      'doctorBio': 'About Doctor',
      'ratings': 'Ratings',
    },
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// APP STATE
// ─────────────────────────────────────────────────────────────────────────────
class AppState extends ChangeNotifier {
  int _gaWeeks = 24;
  int _gaDays = 3;

  int get gaWeeks => _gaWeeks;
  int get gaDays => _gaDays;

  void setPregnancyData({required int gaWeeks, required int gaDays}) {
    _gaWeeks = gaWeeks;
    _gaDays = gaDays;
    notifyListeners();
  }
}

final AppState appState = AppState();

// ─────────────────────────────────────────────────────────────────────────────
// ETHIOPIAN CALENDAR CONVERTER
// ─────────────────────────────────────────────────────────────────────────────
class EthCal {
  static const List<String> monthsEn = [
    'Meskerem',
    'Tikimit',
    'Hidar',
    'Tahisas',
    'Tir',
    'Yekatit',
    'Megabit',
    'Miyazia',
    'Ginbot',
    'Sene',
    'Hamle',
    'Nehase',
    'Pagume',
  ];
  static const List<String> monthsAm = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  static Map<String, int> fromGregorian(DateTime g) {
    int a = (14 - g.month) ~/ 12;
    int y = g.year + 4800 - a;
    int m = g.month + 12 * a - 3;
    int jdn = g.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
    int r = (jdn - 1723856) % 1461;
    int n = r % 365 + 365 * (r ~/ 1460);
    int eY = 4 * ((jdn - 1723856) ~/ 1461) + r ~/ 365 - r ~/ 1460;
    int eM = n ~/ 30 + 1;
    int eD = n % 30 + 1;
    if (eM > 13) {
      eM = 13;
      eD = n - 360 + 1;
    }
    return {'y': eY, 'm': eM, 'd': eD};
  }

  static DateTime toGregorian(int eY, int eM, int eD) {
    int jdn = 1723856 + 365 * eY + eY ~/ 4 + 30 * (eM - 1) + eD - 31;
    int a = jdn + 32044;
    int b = (4 * a + 3) ~/ 146097;
    int c = a - (146097 * b) ~/ 4;
    int d = (4 * c + 3) ~/ 1461;
    int e = c - (1461 * d) ~/ 4;
    int mm = (5 * e + 2) ~/ 153;
    int day = e - (153 * mm + 2) ~/ 5 + 1;
    int month = mm + 3 - 12 * (mm ~/ 10);
    int year = 100 * b + d - 4800 + mm ~/ 10;
    return DateTime(year, month, day);
  }

  static int daysInMonth(int eY, int eM) =>
      eM == 13 ? (eY % 4 == 3 ? 6 : 5) : 30;
}

// ─────────────────────────────────────────────────────────────────────────────
// WEEK DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────
class WeekData {
  final int week;
  final String emoji, fruit, size, weight, length, milestone;
  final Map<AppLang, String> title, dev, tip, warn;
  final Map<AppLang, List<String>> todos, nutrition, appts;

  const WeekData({
    required this.week,
    required this.emoji,
    required this.fruit,
    required this.size,
    required this.weight,
    required this.length,
    required this.milestone,
    required this.title,
    required this.dev,
    required this.tip,
    required this.warn,
    required this.todos,
    required this.nutrition,
    required this.appts,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// WEEK REGISTRY  (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────
class WeekRegistry {
  static const List<WeekData> data = [
    WeekData(
      week: 1,
      emoji: '🌱',
      fruit: 'Poppy Seed',
      size: '<0.1mm',
      weight: '<1g',
      length: '<0.1mm',
      milestone: '🌟 Conception',
      title: {
        AppLang.english: 'Your Journey Begins',
        AppLang.amharic: 'ጉዞዎ ይጀምራሉ',
        AppLang.oromic: 'Imala Kee Jalqabaa',
      },
      dev: {
        AppLang.english:
            'A single fertilised cell — your baby\'s genetic blueprint is already complete. The zygote is dividing rapidly and journeying to the uterus.',
        AppLang.amharic:
            'አንድ የተዳቀለ ሕዋስ — የልጅዎ የጄኔቲክ ቀመር ቀድሞ ተወስኗሉ። ዚጎቱ ወደ ማህፀን ይጓዛሉ።',
        AppLang.oromic:
            "Seelaati tokko wal-horaan — karoora jinetikaa daa'immaa kee guutumaan murteeffameera.",
      },
      tip: {
        AppLang.english:
            'Start folic acid (400 mcg/day) immediately. Avoid alcohol and smoking. Rest well.',
        AppLang.amharic: 'ፎሊክ አሲድ (400mcg/ቀን) ወዲያውኑ ይጀምሩ። አልኮሆልና ማጨስ ያስወግዱ።',
        AppLang.oromic:
            'Folic acid (400mcg/guyyaa) hatattamaan jalqabi. Alkoolii fi sigaaraa irraa fagaadhu.',
      },
      warn: {
        AppLang.english:
            'Unusual bleeding or severe abdominal pain? Contact your doctor immediately.',
        AppLang.amharic: 'ያልተለመደ ደም ወይም ሆድ ህመም ካጋጠምዎ ሐኪምዎን ወዲያውኑ ያናግሩ።',
        AppLang.oromic:
            'Dhiigni addaa yookaan dhukkubbiin garaa jabaan si mudate? Hatattamaan dokitara qunnamti.',
      },
      todos: {
        AppLang.english: [
          'Start folic acid 400 mcg/day',
          'Book first prenatal visit',
          'Stop alcohol & smoking',
          'Begin a pregnancy journal'
        ],
        AppLang.amharic: [
          'ፎሊክ አሲድ 400mcg/ቀን ይጀምሩ',
          'የቅድምወሊድ ቀጠሮ ይርሙ',
          'አልኮሆልና ማጨስ ያቁሙ',
          'ማስታወሻ ይጀምሩ'
        ],
        AppLang.oromic: [
          'Folic acid 400mcg/guyyaa jalqabi',
          'Beellama dura dhalootaa qindi',
          'Alkoolii dhaabi',
          'Yaadannoo jalqabi'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Folic acid 400 mcg — brain development',
          'Fresh fruits & vegetables',
          '8 glasses of water daily',
          'Whole grains & lean proteins'
        ],
        AppLang.amharic: [
          'ፎሊክ አሲድ 400mcg — ለአንጎል',
          'ትኩስ ፍራፍሬ እና አትክልቶች',
          'ቢያንስ 8 ብርጭቆ ውሃ/ቀን',
          'ሙሉ እህሎች'
        ],
        AppLang.oromic: [
          'Folic acid 400mcg',
          'Fuduraa fi kuduraa',
          'Bishaan kobboo 8',
          'Buddeena guutuu'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 6–8: First prenatal visit',
          'Week 10–13: Blood work',
          'Week 11–14: Nuchal scan'
        ],
        AppLang.amharic: [
          'ሳምንት 6–8: ቅድምወሊድ ቀጠሮ',
          'ሳምንት 10–13: የደም ምርመራ',
          'ሳምንት 11–14: ኑካል ስካን'
        ],
        AppLang.oromic: [
          'Torban 6–8: Daawwannaa',
          'Torban 10–13: Qormaata dhiigaa',
          'Torban 11–14: Iskaaniin nuchal'
        ],
      },
    ),
    WeekData(
      week: 4,
      emoji: '🌰',
      fruit: 'Poppy Seed',
      size: '1–2mm',
      weight: '<1g',
      length: '1–2mm',
      milestone: '❤️ Implantation',
      title: {
        AppLang.english: 'Baby Implants!',
        AppLang.amharic: 'ፅንሱ ይለጠፋሉ!',
        AppLang.oromic: 'Embryoni Qabata!',
      },
      dev: {
        AppLang.english:
            'The embryo attaches to the uterus wall. The neural tube — future brain and spinal cord — begins forming.',
        AppLang.amharic: 'ፅንሱ ወደ ማህፀን ግድግዳ ይለጠፋሉ። የነርቭ ቱቦ ይጀምራሉ።',
        AppLang.oromic:
            'Embryoni gadameessa keessa of-qabata. Tuubni naarvii ijaaramuu jalqaba.',
      },
      tip: {
        AppLang.english:
            'You may notice a missed period. Pregnancy tests are now reliable. Morning sickness may begin — eat small frequent meals.',
        AppLang.amharic: 'የወር አበባ ማቆም ሊያስተውሉ ይችሉ ናቸው። ፈተናዎች አሁን አስተማማኝ ናቸው።',
        AppLang.oromic:
            "Turba darbe dhaabbate beekuu dandeessa. Dhukkubbiin garaa jalqabuu danda'a.",
      },
      warn: {
        AppLang.english:
            'Light spotting can be normal. Heavy bleeding with cramps needs immediate care.',
        AppLang.amharic: 'ቀላል ደም ሊሆን ይችሉ ናቸው። ከባድ ደም ከህመም ጋር ሐኪም ያስፈልጉ።',
        AppLang.oromic:
            'Dhiiga xiqqaan yeroo qabachuu normaladha. Dhiiga cimaa dhukkubbii waliin yoo argate gargaarsa barbaadhu.',
      },
      todos: {
        AppLang.english: [
          'Take a home pregnancy test',
          'Book prenatal visit',
          'Continue folic acid daily',
          'Avoid cat litter'
        ],
        AppLang.amharic: [
          'የቤት ፈተና ያድርጉ',
          'ቀጠሮ ይርሙ',
          'ፎሊክ አሲድ ቀጥሉ',
          'ድመት ቆሻሻ ያስወግዱ'
        ],
        AppLang.oromic: [
          'Qormaata mana keessaa fudhadhu',
          'Beellama qindi',
          'Folic acid itti fufi',
          "Baayyeen irraa fagaadhu"
        ],
      },
      nutrition: {
        AppLang.english: [
          'Folic acid 400 mcg daily',
          'Fresh fruits & vegetables',
          'At least 8 glasses of water',
          'Avoid raw meat and unpasteurised dairy'
        ],
        AppLang.amharic: [
          'ፎሊክ አሲድ 400mcg/ቀን',
          'ትኩስ ፍራፍሬ',
          'ቢያንስ 8 ብርጭቆ ውሃ',
          'ጥሬ ስጋ ያስወግዱ'
        ],
        AppLang.oromic: [
          'Folic acid 400mcg',
          'Fuduraa fi kuduraa',
          'Xiqqaatii kobboo 8',
          'Foon hin bisinnee irraa fagaadhu'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 6–8: First prenatal visit',
          'Week 10–13: Blood work',
          'Week 11–14: Nuchal scan'
        ],
        AppLang.amharic: [
          'ሳምንት 6–8: ቅድምወሊድ',
          'ሳምንት 10–13: የደም ምርመራ',
          'ሳምንት 11–14: ኑካል ስካን'
        ],
        AppLang.oromic: [
          'Torban 6–8: Daawwannaa',
          'Torban 10–13: Qormaata',
          'Torban 11–14: Iskaaniin nuchal'
        ],
      },
    ),
    WeekData(
      week: 6,
      emoji: '🫘',
      fruit: 'Lentil',
      size: '6mm',
      weight: '<1g',
      length: '6mm',
      milestone: '💓 Heartbeat!',
      title: {
        AppLang.english: 'First Heartbeat!',
        AppLang.amharic: 'የመጀመሪያ ልብ ምት!',
        AppLang.oromic: 'Raafannaa Onnee Jalqabaa!',
      },
      dev: {
        AppLang.english:
            'The heartbeat can be detected at ~110 beats/minute! Head, eyes, ears and tiny limb buds are forming.',
        AppLang.amharic: 'የልብ ምት ሊታይ ይችሉ — 110 ምቶች! ጭንቅላቱ፣ ዓይኖቹ፣ ጆሮዎቹ ይጀምራሉ።',
        AppLang.oromic:
            'Raafannaan onnee daqiiqaa 110! Mataa, ija, gurra fi areeroo xiqqoon ijaaramuu jalqabaa jiru.',
      },
      tip: {
        AppLang.english:
            'Morning sickness is usually at its peak. Try ginger tea or cold lemon water. Keep crackers beside your bed.',
        AppLang.amharic:
            'ጠዋት ማቅለሽ ከፍተኛ ደረጃ ላይ ነው። ዝንጅብል ሻይ ወይም ቀዝቃዛ ሎሚ ውሃ ይሞክሩ።',
        AppLang.oromic:
            'Dhukkubbiin ganama sadarkaa olaanaatti jira. Shaayii zinjibila yaalii.',
      },
      warn: {
        AppLang.english:
            'Severe vomiting where you cannot keep food or liquids down (hyperemesis) needs medical treatment — call today.',
        AppLang.amharic:
            'ምንም ምግብ ወይም ፈሳሽ ማያዝ (hyperemesis) ሐኪም ያስፈልጉ — ዛሬ ይደውሉ።',
        AppLang.oromic:
            "Nyaata tokkollee qabachu dadhabuu (hyperemesis) dokitara barbaachisa — har'a bilbili.",
      },
      todos: {
        AppLang.english: [
          'First prenatal appointment',
          'Book first ultrasound',
          'Start prenatal vitamins',
          'Avoid raw fish & soft cheeses'
        ],
        AppLang.amharic: [
          'ቅድምወሊድ ቀጠሮ ይርሙ',
          'ኡልትራሳውንድ ቀጠሮ',
          'ቅድምወሊድ ቫይታሚን ይጀምሩ',
          'ጥሬ ዓሳ ያስወግዱ'
        ],
        AppLang.oromic: [
          'Beellama jalqabaa qindi',
          'Beellama sonoograafii',
          'Viitiminii jalqabi',
          'Qurxummii hin bisinnee irraa fagaadhu'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Folic acid 400 mcg daily',
          'Fresh fruits & vegetables',
          'Water even when nauseous',
          'Ginger tea for morning sickness'
        ],
        AppLang.amharic: [
          'ፎሊክ አሲድ 400mcg/ቀን',
          'ትኩስ ፍራፍሬ',
          'ቢቅለሽ ምንም ቢሆን ውሃ ይጠጡ',
          'ዝንጅብል ሻይ'
        ],
        AppLang.oromic: [
          'Folic acid 400mcg',
          'Fuduraa fi kuduraa',
          'Dhukkubbii waliin iyyuu bishaan dhugi',
          'Shaayii zinjibila'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 6–8: First prenatal visit',
          'Week 10–13: Blood work',
          'Week 11–14: Nuchal scan'
        ],
        AppLang.amharic: [
          'ሳምንት 6–8: ቅድምወሊድ',
          'ሳምንት 10–13: የደም ምርመራ',
          'ሳምንት 11–14: ኑካል ስካን'
        ],
        AppLang.oromic: [
          'Torban 6–8: Daawwannaa',
          'Torban 10–13: Qormaata dhiigaa',
          'Torban 11–14: Iskaaniin nuchal'
        ],
      },
    ),
    WeekData(
      week: 12,
      emoji: '🍋',
      fruit: 'Lime',
      size: '5.4cm',
      weight: '14g',
      length: '5.4cm',
      milestone: '🎉 End of T1',
      title: {
        AppLang.english: 'First Trimester Done!',
        AppLang.amharic: '1ኛ ትሪሜስተር ተጠናቀቀ!',
        AppLang.oromic: 'Gilgaalli 1ffaa Xumurameera!',
      },
      dev: {
        AppLang.english:
            'All major organs are formed! The risk of miscarriage drops significantly. Fingernails and first wisps of hair appear.',
        AppLang.amharic: 'ዋናዎቹ አካሎች ተፈጥረዋሉ! ከዚህ ሳምንት በኋላ ፈርድ አደጋ ይቀንሳሉ።',
        AppLang.oromic:
            "Qaama guguddaa hundi ijaarameera! Miidhaa yeroo hin gahin dhaluu ni hir'ata.",
      },
      tip: {
        AppLang.english:
            'Nausea often improves after week 12. Your bump may start to show. Share your happy news with family and friends!',
        AppLang.amharic: 'ማቅለሽ ከሳምንት 12 በኋላ ሊሻሻሉ ናቸው። ዜናዎን ይናገሩ!',
        AppLang.oromic:
            "Dhukkubbiin booda torban 12tti fooyya'uu danda'a. Oduu gammachiisaa kee qoodi!",
      },
      warn: {
        AppLang.english:
            'Have you had the nuchal translucency scan? It must be done before week 14 — book urgently if not.',
        AppLang.amharic: 'ኑካል ስካን ካልሰሩ አሁን ይርሙ — ከሳምንት 14 በፊት መሰራት አለበት።',
        AppLang.oromic:
            "Iskaaniin nuchal hin taasifamne yoo ta'e, ammaan dura qindi — torban 14 dura ta'uu qaba.",
      },
      todos: {
        AppLang.english: [
          'Nuchal translucency scan (urgent)',
          'Share your pregnancy news',
          'Plan maternity leave',
          'Choose birth hospital'
        ],
        AppLang.amharic: [
          'ኑካል ስካን (ካልሰሩ አሁን)',
          'ዜናዎን ያሳውቁ',
          'ፈቃድ ያቅዱ',
          'ሆስፒታሉን ይምረጡ'
        ],
        AppLang.oromic: [
          'Iskaaniin nuchal (hatattamaan)',
          'Oduu beeksisi',
          'Boqonnaa karoorfadhu',
          'Hospitaala filaa'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Folic acid 400 mcg daily',
          'Iron: lentils, spinach, red meat',
          'Calcium: milk, yogurt, sesame',
          'Omega-3: oily fish twice a week'
        ],
        AppLang.amharic: [
          'ፎሊክ አሲድ 400mcg/ቀን',
          'ብረት: ምስር፣ ስፒናች',
          'ካልሲየም: ወተት፣ ሰሊጥ',
          'ኦሜጋ-3: ዓሣ ሁለት ጊዜ/ሳምንት'
        ],
        AppLang.oromic: [
          'Folic acid 400mcg',
          'Biroo: adamsii, spinach',
          'Calcium: aannaan, simsim',
          'Omega-3: qurxummii yeroo lama/torban'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 11–14: Nuchal scan — urgent',
          'Week 10–13: Blood work',
          'Checkups every 4 weeks'
        ],
        AppLang.amharic: [
          'ሳምንት 11–14: ኑካል ስካን — አስቸኳይ',
          'ሳምንት 10–13: የደም ምርመራ',
          'ቀጠሮ በ4 ሳምንቶች'
        ],
        AppLang.oromic: [
          'Torban 11–14: Iskaaniin nuchal',
          'Torban 10–13: Qormaata dhiigaa',
          'Beellama torbaan 4'
        ],
      },
    ),
    WeekData(
      week: 20,
      emoji: '🍌',
      fruit: 'Banana',
      size: '16.4cm',
      weight: '300g',
      length: '16.4cm',
      milestone: '📐 Halfway!',
      title: {
        AppLang.english: 'Halfway There! 🎉',
        AppLang.amharic: 'ግማሽ ጉዞ! 🎉',
        AppLang.oromic: 'Gidduugaleessaa! 🎉',
      },
      dev: {
        AppLang.english:
            'Halfway there! Baby is covered in protective vernix. The brain is growing fast. Baby can suck their thumb.',
        AppLang.amharic: 'ወደፊቱ ግማሽ! ልጅዎ ቨርኒክስ ተሸፍኗቸዋሉ። አንጎሉ በፍጥነት ያድጋሉ።',
        AppLang.oromic:
            "Gara jiddugalaa! Daa'imni vernix qabanaa jira. Sammuu saffisaan guddata.",
      },
      tip: {
        AppLang.english:
            'Anatomy scan this week is crucial — do not miss it! Iron-rich foods prevent anaemia.',
        AppLang.amharic: 'ስካን ደረጃ 2 — አትዘንጉ! ብረት ምግቦች ደምን ይከላከላሉ።',
        AppLang.oromic:
            "Iskaaniin anatomy torban kana baay'ee barbaachisaadha — dhiisi!",
      },
      warn: {
        AppLang.english:
            'Placenta previa may be found at this scan. If confirmed, follow your doctor\'s instructions.',
        AppLang.amharic: 'ፕላሴንታ ዝቅተኛ ቦታ ሊታይ ይችሉ ናቸው። ሐኪምዎ ምክርን ይከተሉ።',
        AppLang.oromic:
            "Placenta previa iskaaniin argamuu danda'a. Yoo mirkanaaye, dokitara gorsa hordofi.",
      },
      todos: {
        AppLang.english: [
          'Anatomy scan — do not skip',
          'Start iron supplements if advised',
          'Daily Kegel exercises',
          "Set up baby's sleeping space"
        ],
        AppLang.amharic: [
          'ስካን ደረጃ 2 — ማስቀረት የለም',
          'ብረት ሱፕሊሜንቶች',
          'ኬጌል ቸኮሌቶች',
          'የሕፃን የእንቅልፍ ቦታ'
        ],
        AppLang.oromic: [
          "Iskaaniin anatomy — hin hanqaatin",
          'Suppleemantii biroo jalqabi',
          'Leenjii kegel guyyaa guyyaa',
          "Bakka hirribaa daa'immaa"
        ],
      },
      nutrition: {
        AppLang.english: [
          'Iron: lentils, spinach, red meat',
          'Calcium: milk, yogurt',
          'Omega-3: oily fish twice a week',
          'Vitamin D or daily sunlight'
        ],
        AppLang.amharic: [
          'ብረት: ምስር፣ ስፒናች',
          'ካልሲየም: ወተት',
          'ኦሜጋ-3: ዓሣ',
          'ቪታሚን D'
        ],
        AppLang.oromic: [
          'Biroo: adamsii, spinach',
          'Calcium: aannaan',
          'Omega-3: qurxummii',
          'Viitiminii D'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 18–20: Anatomy scan',
          'Week 24–28: Glucose test',
          'Checkups every 4 weeks'
        ],
        AppLang.amharic: [
          'ሳምንት 18–20: ስካን ደረጃ 2',
          'ሳምንት 24–28: የግሉኮስ ፈተና',
          'ቀጠሮ በ4 ሳምንቶች'
        ],
        AppLang.oromic: [
          'Torban 18–20: Iskaaniin anatomy',
          'Torban 24–28: Qormaata glukoosii',
          'Beellama torbaan 4'
        ],
      },
    ),
    WeekData(
      week: 28,
      emoji: '🍆',
      fruit: 'Eggplant',
      size: '25cm',
      weight: '1kg',
      length: '25cm',
      milestone: '👁️ Eyes Open',
      title: {
        AppLang.english: 'Third Trimester! 🌟',
        AppLang.amharic: 'ሦስተኛ ትሪሜስተር! 🌟',
        AppLang.oromic: 'Gilgaala 3ffaa! 🌟',
      },
      dev: {
        AppLang.english:
            "Baby's eyes can now open and close! Brain activity is increasing fast. Baby can dream — REM sleep is established.",
        AppLang.amharic: 'ዓይኖቹ አሁን ሊከፈቱ ይችሉ ናቸው! የአንጎል እንቅስቃሴ ይጨምራሉ።',
        AppLang.oromic:
            "Ijni daa'immaa banuuf cufuuf danda'a! Hojiin sammuu saffisaan dabalaa jira.",
      },
      tip: {
        AppLang.english:
            'Sleep on your left side to improve blood flow to baby — use a pregnancy pillow. Do daily pelvic floor exercises.',
        AppLang.amharic: 'ደምን ወደ ሕፃኑ ለማሻሻል ግራ ጎን ያርፉ — ቅድምወሊድ ትራስ ይጠቀሙ።',
        AppLang.oromic: "Dhiiga daa'imatti guddifuu gama bitaa irra ciisuu.",
      },
      warn: {
        AppLang.english:
            'Preeclampsia signs — severe headache, vision changes, sudden face or hand swelling — need urgent care.',
        AppLang.amharic:
            'ቅድሚያ-ኤክላምፕሲያ ምልክቶች — ከባድ ራስ ምታት፣ ፊት ማበጥ — ፈጣን ሐኪም ያስፈልጉ።',
        AppLang.oromic:
            'Mallattoo preeclampsia — mataa dhukkubbii jabaa, fuulaa boburuu — kunuunsa hatattamaa barbaadhu.',
      },
      todos: {
        AppLang.english: [
          'Rh shot if Rh-negative',
          'Start packing hospital bag',
          'Install infant car seat',
          'Tdap vaccine'
        ],
        AppLang.amharic: [
          'Rh አሉታዊ ከሆኑ ክትባት',
          'የሆስፒታሉ ቦርሳ ያዘጋጁ',
          'የሕፃን የመኪና ወንበር ይጫኑ',
          'Tdap ክትባት'
        ],
        AppLang.oromic: [
          'Obboleettii Rh',
          'Saantoo hospitaalaa guutuu jalqabi',
          "Teessoo konkolaataa fe'i",
          'Talaallii Tdap'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Small frequent meals for heartburn',
          'Protein-rich foods for brain growth',
          'Fibre: fruits, vegetables, grains',
          'Limit caffeine to <200mg/day'
        ],
        AppLang.amharic: [
          'ትናንሽ ብዙ ምግቦች ለቃጠሎ',
          'ፕሮቲን ምግቦች',
          'ፋይበር: ፍራፍሬ',
          'ካፌይን < 200mg/ቀን'
        ],
        AppLang.oromic: [
          'Nyaata xiqqaa irra irra baayee',
          'Protein sammuu guddisuu',
          'Fiber: fuduraa, kuduraa',
          'Caffeine < 200mg/guyyaa'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 28: Rh injection',
          'Week 28–36: Checkups every 2 weeks',
          'Week 35–37: Group B Strep test'
        ],
        AppLang.amharic: [
          'ሳምንት 28: Rh ክትባት',
          'ሳምንት 28–36: ቀጠሮ በ2 ሳምንቶች',
          'ሳምንት 35–37: Group B Strep'
        ],
        AppLang.oromic: [
          'Torban 28: Obboleettii Rh',
          'Torban 28–36: Beellama torbaan 2',
          'Torban 35–37: Qormaata Group B Strep'
        ],
      },
    ),
    WeekData(
      week: 36,
      emoji: '🍈',
      fruit: 'Honeydew',
      size: '35cm',
      weight: '2.6kg',
      length: '35cm',
      milestone: '🔄 Head Down',
      title: {
        AppLang.english: 'Almost There! ✨',
        AppLang.amharic: 'ሞሉ ደርሰዋሉ! ✨',
        AppLang.oromic: 'Dhihaatee Jira! ✨',
      },
      dev: {
        AppLang.english:
            "Baby should be head-down, preparing for birth! Lungs are nearly mature. Skull bones stay flexible for a safe delivery.",
        AppLang.amharic: 'ልጅዎ ጭንቅላቱ ወደ ታች ሊሆን አለበት! ሳምቦ ሊደርሱ ናቸው።',
        AppLang.oromic:
            "Daa'imni mataan gara gaditti qophaa'uu qaba! Samboonni guutuuman guddata.",
      },
      tip: {
        AppLang.english:
            'Weekly appointments begin now. Finish packing your hospital bag. Rest as much as possible.',
        AppLang.amharic: 'ሳምንታዊ ቀጠሮዎች ይጀምራሉ። ቦርሳዎን ሙሉ ይርሙ። ያርፉ።',
        AppLang.oromic:
            'Beellamiiwwan torbaan torbaan jalqabaa jiru. Saantoo hospitaalaa guuti.',
      },
      warn: {
        AppLang.english:
            'Know labor signs: contractions every 5 minutes, water breaking, or bloody show. Go to hospital immediately.',
        AppLang.amharic: 'የወሊድ ምልክቶችን ይወቁ: ሙቅ ሙቅ ጠቅሶ፣ ውሃ ሲፈስ። ወዲያውኑ ሆስፒታሉ ይሂዱ።',
        AppLang.oromic:
            'Mallattoo dhalootaa beeki: ciminni daqiiqaa 5, bishaani cabuu. Hatattamaan hospitaala deemi.',
      },
      todos: {
        AppLang.english: [
          'Group B Strep test',
          'Hospital bag fully packed',
          'Give birth plan to hospital',
          'Practice labour breathing'
        ],
        AppLang.amharic: [
          'Group B Strep ፈተና',
          'ቦርሳ 100% ይርሙ',
          'ዕቅዱን ለሆስፒታሉ ስጡ',
          'የወሊድ ቴክኒኮች ይለማመዱ'
        ],
        AppLang.oromic: [
          'Qormaata Group B Strep',
          'Saantoo 100% guutuu',
          'Karoora dhalootaa kenni',
          'Ciminaa fi boqonnaaf leenjicha'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Small frequent meals for comfort',
          'High-protein foods for final growth',
          'Plenty of fibre for constipation',
          'Stay hydrated — 8–10 glasses daily'
        ],
        AppLang.amharic: [
          'ትናንሽ ብዙ ምግቦች',
          'ፕሮቲን ምግቦች',
          'ፋይበር',
          '8–10 ብርጭቆ ውሃ/ቀን'
        ],
        AppLang.oromic: [
          'Nyaata xiqqaa irra irra baayee',
          'Protein guddina dhumaa',
          'Fiber xiqqeessuu',
          'Bishaan kobboo 8–10/guyyaa'
        ],
      },
      appts: {
        AppLang.english: [
          'Week 35–37: Group B Strep test',
          'Week 36+: Weekly appointments',
          'Week 40+: Induction discussion'
        ],
        AppLang.amharic: [
          'ሳምንት 35–37: Group B Strep',
          'ሳምንት 36+: ሳምንታዊ ቀጠሮ',
          'ሳምንት 40+: ኢንዳክሽን'
        ],
        AppLang.oromic: [
          'Torban 35–37: Qormaata Group B Strep',
          'Torban 36+: Beellama torbaan',
          'Torban 40+: Marii induction'
        ],
      },
    ),
    WeekData(
      week: 40,
      emoji: '🎃',
      fruit: 'Pumpkin',
      size: '40+cm',
      weight: '3.4kg',
      length: '40+cm',
      milestone: '🎉 Due Date!',
      title: {
        AppLang.english: 'Due Date Week! 🎊',
        AppLang.amharic: 'የወሊድ ቀን! 🎊',
        AppLang.oromic: 'Torban Guyyaa Dhalootaa! 🎊',
      },
      dev: {
        AppLang.english:
            "Your baby is fully developed and ready to meet you! All systems are go for delivery.",
        AppLang.amharic: 'ልጅዎ ሙሉ ተፈጥረዋሉ። ሁሉም ስርዓቶቹ ለወሊድ ዝግጁ ናቸው።',
        AppLang.oromic:
            "Daa'imni kee guutuuman guddatee si bira ga'uuf qophaa'eera!",
      },
      tip: {
        AppLang.english:
            "Only 5% of babies arrive exactly on due date — stay calm! Walking can encourage labour.",
        AppLang.amharic: '5% ልጆች ብቻ ናቸው ሙሉ ቀናቸው ላይ የሚወለዱ — ጸጥ ይበሉ!',
        AppLang.oromic:
            "Daa'imman 5% qofatu guyyaa sana sirriitti dhalata — nagaan ta'i!",
      },
      warn: {
        AppLang.english:
            'After 41 weeks your doctor may recommend induction. Go to hospital if: green/brown waters break, or baby movements decrease.',
        AppLang.amharic:
            'ከ41 ሳምንት ኢንዳክሽን ሊዘዙ ይችሉ ናቸው። ቀለም ያለው ውሃ ሲፈስ ወዲያውኑ ሆስፒታሉ ሂዱ።',
        AppLang.oromic:
            "Torban 41 booda induction gorsuu danda'a. Hatattamaan hospitaala yoo bishaani gogaa-magaala bahe.",
      },
      todos: {
        AppLang.english: [
          'Final prenatal appointment',
          'All baby gear ready',
          'Newborn essentials stocked',
          'Know exact route to hospital'
        ],
        AppLang.amharic: [
          'የመጨረሻ ቅድምወሊድ ቀጠሮ',
          'ሁሉም ዕቃዎቹ ዝግጁ',
          'አዲስ ልደት ዕቃዎች ዝግጁ',
          'ወደ ሆስፒታሉ መንገድ ያወቁ'
        ],
        AppLang.oromic: [
          "Beellama dura dhalootaa dhumaa",
          "Meeshaa daa'immaa hundi",
          "Barbaachisaalee daa'ima haaraa",
          'Karaa hospitaala beeki'
        ],
      },
      nutrition: {
        AppLang.english: [
          'Light, easy-to-digest meals only',
          'Stay very well hydrated',
          'Dates may help prepare the cervix',
          'Avoid heavy or spicy foods'
        ],
        AppLang.amharic: [
          'ቀላል ምግቦች ብቻ',
          'ጥሩ ውሃ ጠጡ',
          'ቴምር ለወሊድ ሊያዘጋጁ ይችሉ ናቸው',
          'ከባድ ምግቦች ያስወግዱ'
        ],
        AppLang.oromic: [
          'Nyaata salphaa qofa',
          'Bishaan gahaa dhugi',
          'Timirri dhalootaaf gargaara',
          'Nyaata ulfaa irraa fagaadhu'
        ],
      },
      appts: {
        AppLang.english: [
          'Final prenatal this week',
          'Weekly appointments continue',
          'Week 41+: Induction discussion'
        ],
        AppLang.amharic: [
          'የቅርቢ ወሊድ ቀጠሮ',
          'ሳምንታዊ ቀጠሮ ይቀጥላሉ',
          'ሳምንት 41+: ኢንዳክሽን'
        ],
        AppLang.oromic: [
          'Beellama dura dhalootaa torban kana',
          'Beellamiiwwan itti fufuu',
          'Torban 41+: Marii induction'
        ],
      },
    ),
  ];

  static WeekData forWeek(int w) {
    WeekData r = data.first;
    for (final d in data) {
      if (w >= d.week) r = d;
    }
    return r;
  }

  static int idxForWeek(int w) {
    int i = 0;
    for (int j = 0; j < data.length; j++) {
      if (w >= data[j].week) i = j;
    }
    return i;
  }
}

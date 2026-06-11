import 'package:lije/core/l10n/strings.dart';

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

import 'models.dart';

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

class DiscoverData {
  static String categoryLabel(AppLang lang, DiscoverCategory cat) {
    const labels = {
      DiscoverCategory.all: {
        AppLang.english: 'All',
        AppLang.amharic: 'ሁሉ',
        AppLang.oromic: 'Hunda',
      },
      DiscoverCategory.pregnancy: {
        AppLang.english: 'Pregnancy',
        AppLang.amharic: 'እርግዝና',
        AppLang.oromic: 'Hiyyaassa',
      },
      DiscoverCategory.birth: {
        AppLang.english: 'Birth',
        AppLang.amharic: 'ወሊድ',
        AppLang.oromic: 'Dhaloota',
      },
      DiscoverCategory.nutrition: {
        AppLang.english: 'Nutrition',
        AppLang.amharic: 'ምግብ',
        AppLang.oromic: 'Nyaata',
      },
      DiscoverCategory.babyCare: {
        AppLang.english: 'Baby Care',
        AppLang.amharic: 'የህፃን እንክብካቤ',
        AppLang.oromic: 'Kunuunsa Daa\'ima',
      },
      DiscoverCategory.wellness: {
        AppLang.english: 'Wellness',
        AppLang.amharic: 'ጤንነት',
        AppLang.oromic: 'Fayyaa',
      },
    };
    return labels[cat]?[lang] ?? labels[cat]![AppLang.english]!;
  }

  static const List<DiscoverCategory> filterCategories = [
    DiscoverCategory.all,
    DiscoverCategory.pregnancy,
    DiscoverCategory.birth,
    DiscoverCategory.nutrition,
    DiscoverCategory.babyCare,
    DiscoverCategory.wellness,
  ];

  static const List<DiscoverArticle> articles = [
    DiscoverArticle(
      id: '1',
      category: DiscoverCategory.pregnancy,
      emoji: '🤰',
      readMinutes: 4,
      title: {
        AppLang.english: 'First Trimester Essentials',
        AppLang.amharic: 'የ1ኛ ትሪሜስተር መሰረታዊ ጽሁፎች',
        AppLang.oromic: 'Wantoota Gilgaala 1ffaa',
      },
      summary: {
        AppLang.english:
            'What to expect and how to care for yourself in the first 12 weeks.',
        AppLang.amharic: 'በመጀመሪያ 12 ሳምንታት ምን እንደሚጠበቅ እና እንዴት እንደሚንከባከቡ።',
        AppLang.oromic:
            'Torban 12 jalqabaa keessatti maaltu eegamu fi akkamitti of eegattu.',
      },
      body: {
        AppLang.english:
            'The first trimester brings rapid changes. Start taking folic acid (400 mcg daily) if you have not already. Schedule your first prenatal visit between weeks 8 and 12.\n\nAvoid alcohol, raw meat, unpasteurised milk, and smoking. Rest when tired — fatigue is normal as your body supports early development.\n\nContact your doctor if you have severe abdominal pain, heavy bleeding, or persistent vomiting.',
        AppLang.amharic:
            '1ኛ ትሪሜስተር ፈጣን ለውጦችን ይ bring ያመጣል። ፎሊክ አሲድ (400mcg/ቀን) ወዲያውኑ ይጀምሩ። የመጀመሪያውን የእርግዝና ጥናት በ8–12 ሳምንት ይያዙ።\n\nአልኮሆል፣ ጥሬ ስጋ፣ ያልተ paste ለባለ ወተት እና ሲጋራ ያስወግዱ። ሲደክሙ ይከፍሩ — ሰውነትዎ ፅንሱን ስለሚደግፍ ድካም ተ طبيعي ነው።\n\nከባድ ሆድ ህመም፣ ከባድ ደም ወይም ቀጣይ መማesis ካለ ሐኪምዎን ያነጋግሩ።',
        AppLang.oromic:
            'Gilgaalli 1ffaa jijjiirama saffisaa fidu. Folic acid (400mcg/guyyaa) battalumatti eegalu. Sakatta\'iinsa jalqabaa torban 8–12 keessatti qabachuu.\n\nAlkoolii, foon qulqulluu hin taane, aannan paste hin goone fi sigaara irraa fagaachuu.\n\nDhukkubbii guddaa, dhiiga guddaa ykn gaggeessuu itti fufu yoo qabaatte doktora qunnamuu.',
      },
    ),
    DiscoverArticle(
      id: '2',
      category: DiscoverCategory.nutrition,
      emoji: '💧',
      readMinutes: 3,
      title: {
        AppLang.english: 'Staying Hydrated',
        AppLang.amharic: 'ውሃ መጠጣት',
        AppLang.oromic: 'Bishaan Dhuguu',
      },
      summary: {
        AppLang.english:
            'Why water matters during pregnancy and how much you need daily.',
        AppLang.amharic: 'ውሃ በእርግዝና ወቅት ለምን አስፈላጊ እንደሆነ።',
        AppLang.oromic: 'Bishaan hiyyaassa keessatti maaliif barbaachisaa ta\'e.',
      },
      body: {
        AppLang.english:
            'Aim for 8–10 glasses of water daily. Hydration supports amniotic fluid, blood volume, and reduces constipation and swelling.\n\nCarry a bottle, drink before you feel thirsty, and include soups and fresh fruits. Limit caffeinated drinks.\n\nSigns of dehydration: dark urine, dizziness, or headaches. Increase fluids and rest.',
        AppLang.amharic:
            'ቀንበር 8–10 ብርጭቆ ውሃ ይጠጡ። ውሃ amniotic fluid፣ የደም መጠንን ይደግፋል እና constipationን ይቀንሳል።\n\nቦታል ይዘው ይውጡ፣ ከ thirst በፊት ይጠጡ። ቡናን ይقللو።\n\nDark urine፣ dizziness — dehydration ምልክት።',
        AppLang.oromic:
            'Guyyaa guyyaan bishaan glaasii 8–10 dhuguu. Bishaan dhiiga, daa\'ima fi hanqina fincaanii gargaara.\n\nQaruura fudhachuu, dhigaan dura dhuguu. Kafiiin xiqqeessuu.\n\nUraatiin gurraacha, naasuu — hanqina bishaanii mallattoo.',
      },
    ),
    DiscoverArticle(
      id: '3',
      category: DiscoverCategory.birth,
      emoji: '🏥',
      readMinutes: 5,
      title: {
        AppLang.english: 'Signs of Labour',
        AppLang.amharic: 'የወሊድ ምልክቶች',
        AppLang.oromic: 'Mallattoo Dhalootaa',
      },
      summary: {
        AppLang.english:
            'Learn when contractions mean it is time to go to the hospital.',
        AppLang.amharic: 'ወደ ሆስፒታል መቼ መሄድ እንዳለብዎ ይወቁ።',
        AppLang.oromic: 'Yoom hospitaala deemuu akka qabdu baradhu.',
      },
      body: {
        AppLang.english:
            'True labour contractions become regular, stronger, and closer together. They do not stop when you rest or change position.\n\nOther signs: water breaking, bloody show, lower back pain, and the urge to push.\n\nGo to hospital when contractions are 5 minutes apart for 1 hour, water breaks, or bleeding is heavy. Call your provider for any concerns.',
        AppLang.amharic:
            'እውነተኛ contractions regular፣ ጠንካራ እና ተጠናክረው ይመጣሉ። በ rest አይቆሙም።\n\nውሃ መፈሳት፣ bloody show፣ lower back pain — ምልክቶች።\n\n5 ደቂቃ apart ለ1 ሰዓት፣ ውሃ breaking፣ ከባድ bleeding — ወዲያውኑ ሆስፒታል።',
        AppLang.oromic:
            'Waldhabdee dhugaa tartiiba qaba, cimaa fi walitti dhufu. Yeroo boqattan hin dhaaban.\n\nBishaan dhangala\'uu, dhiiga xiqqaa, dhukkubbii dugdaa — mallattoo.\n\nDaqiiqaa 5n walqabatee sa\'aatii 1, bishaan ykn dhiiga guddaa — battalumatti hospitaala.',
      },
    ),
    DiscoverArticle(
      id: '4',
      category: DiscoverCategory.babyCare,
      emoji: '🍼',
      readMinutes: 4,
      title: {
        AppLang.english: 'Breastfeeding Basics',
        AppLang.amharic: 'የጡት ጡት መሰረታዊ',
        AppLang.oromic: 'Hundee Hawwii Suuta',
      },
      summary: {
        AppLang.english:
            'Getting started with breastfeeding after birth.',
        AppLang.amharic: 'ከወሊድ በኋላ ጡት ጡት መጀመር።',
        AppLang.oromic: 'Dhaloota booda hawwii suuta jalqabuu.',
      },
      body: {
        AppLang.english:
            'Start skin-to-skin contact within the first hour after birth. Feed on demand — usually 8–12 times in 24 hours for newborns.\n\nEnsure a good latch: baby\'s mouth covers most of the areola, chin touches breast, lips flanged outward.\n\nSore nipples often improve with correct positioning. Seek lactation support if pain persists or baby is not gaining weight.',
        AppLang.amharic:
            'በ1 ሰዓት ውስጥ skin-to-skin። በ demand ይመገቡ — newborn 8–12 ጊዜ/24hr።\n\nLatch: mouth areola፣ chin touches breast።\n\n nipple pain positioning ትክክል ከሆነ ይሻሻላል። lactation support ይፈልጉ።',
        AppLang.oromic:
            'Sa\'aatii 1 keessatti gogaa gara gogaa. Akka barbaachisetti nyaachisuu — daa\'ima haaraa 8–12 yeroo/guyyaa.\n\nHawwii suuta sirrii: afni areola haguugu, agaziin tuuta.\n\nDhukkubni naasaa ejjennoo sirriiin ni fooyya\'a.',
      },
    ),
    DiscoverArticle(
      id: '5',
      category: DiscoverCategory.wellness,
      emoji: '💆',
      readMinutes: 4,
      title: {
        AppLang.english: 'Postpartum Recovery',
        AppLang.amharic: 'ከወሊድ በኋላ recovery',
        AppLang.oromic: 'Fayyaa Dhaloota Booda',
      },
      summary: {
        AppLang.english:
            'Physical and emotional healing in the weeks after delivery.',
        AppLang.amharic: 'ከወሊድ በኋላ جسماني እና emotion recovery።',
        AppLang.oromic: 'Wal\'aansa jireenyaa fi sammuu dhaloota booda.',
      },
      body: {
        AppLang.english:
            'Rest as much as possible. Accept help with meals and housework. Bleeding (lochia) is normal for 4–6 weeks — use pads, not tampons.\n\nBaby blues affect many mothers; mood swings in the first two weeks are common. Contact a doctor if sadness lasts beyond 2 weeks or you have thoughts of harming yourself or the baby.\n\nPelvic floor exercises can begin when comfortable. Attend your postnatal check-up.',
        AppLang.amharic:
            'በቸልነት rest። lochia 4–6 weeks normal — pads።\n\nBaby blues ተ طبيعي። sadness >2 weeks — doctor።\n\nPelvic floor exercises። postnatal check-up።',
        AppLang.oromic:
            'Boqonnaa fudhachuu. Dhiiga (lochia) torban 4–6 normal.\n\nBaby blues baay\'eedha. Gaddi torban 2 ol — doktora.\n\nSochii lafee pelvic fi sakatta\'iinsa postnatal.',
      },
    ),
    DiscoverArticle(
      id: '6',
      category: DiscoverCategory.nutrition,
      emoji: '🥗',
      readMinutes: 3,
      title: {
        AppLang.english: 'Iron-Rich Foods',
        AppLang.amharic: 'ብረት-ባህራዊ ምግቦች',
        AppLang.oromic: 'Nyaata Biroo Qabdu',
      },
      summary: {
        AppLang.english:
            'Prevent anaemia with the right foods during pregnancy.',
        AppLang.amharic: 'በእርግዝና anemiaን ለመከላከል ምግቦች።',
        AppLang.oromic: 'Anemia ittisuuf nyaata hiyyaassa keessatti.',
      },
      body: {
        AppLang.english:
            'Include lentils, beans, spinach, lean red meat, eggs, and fortified cereals. Pair iron foods with vitamin C (citrus, tomatoes) to improve absorption.\n\nAvoid tea or coffee with meals — they reduce iron uptake. Your doctor may prescribe iron supplements if levels are low.\n\nSymptoms of anaemia: extreme fatigue, pale skin, shortness of breath.',
        AppLang.amharic:
            'ምስር፣ baakela፣ spinach፣ lean meat፣ eggs። vitamin C ጋር — absorption።\n\nTea/coffee meals ጋር አይደርቁ — iron uptake ይቀንሳል።\n\nAnemia: fatigue፣ pale skin።',
        AppLang.oromic:
            'Adamsii, baakela, spinach, foon, hanqaaquu nyaachuu. Vitamin C waliin — fudhachuu fooyya\'a.\n\nShaayii/kafii nyaata waliin hin dhugamuu.\n\nAnemia: dadhabbina guddaa, gogaa daalacha.',
      },
    ),
    DiscoverArticle(
      id: '7',
      category: DiscoverCategory.babyCare,
      emoji: '😴',
      readMinutes: 3,
      title: {
        AppLang.english: 'Safe Sleep for Baby',
        AppLang.amharic: 'ደህንነቱ የተጠበቀ sleep',
        AppLang.oromic: 'Hirriba Nageenya Daa\'ima',
      },
      summary: {
        AppLang.english:
            'Reduce SIDS risk with simple sleep safety rules.',
        AppLang.amharic: 'SIDS riskን ለመቀነስ sleep rules።',
        AppLang.oromic: 'SIDS hir\'isuu seera hirribaa salphaa.',
      },
      body: {
        AppLang.english:
            'Always place baby on their back to sleep, on a firm flat mattress. Keep the cot free of pillows, blankets, and soft toys.\n\nShare a room but not a bed for the first 6 months. Avoid overheating — room temperature should feel comfortable.\n\nNever sleep on a sofa or armchair with the baby.',
        AppLang.amharic:
            'Back to sleep፣ firm mattress። cot — no pillows/blankets/toys።\n\nRoom share not bed share 6 months። overheating avoid።\n\nSofa/armchair sleep with baby — never።',
        AppLang.oromic:
            'Dugda irratti hirribuu, mattress cimaa. Uffata, pillow fi meeshaa jilbaaf hin kaa\'amuu.\n\nKutaa waliin garuu si\'a waliin hin hirribamuu torban 6.\n\nSofa irratti daa\'ima waliin hin ciisamuu.',
      },
    ),
    DiscoverArticle(
      id: '8',
      category: DiscoverCategory.pregnancy,
      emoji: '📅',
      readMinutes: 4,
      title: {
        AppLang.english: 'Second Trimester Guide',
        AppLang.amharic: '2ኛ ትሪሜስተር መመሪያ',
        AppLang.oromic: 'Qajeelfama Gilgaala 2ffaa',
      },
      summary: {
        AppLang.english:
            'The “golden period” — energy returns and baby grows fast.',
        AppLang.amharic: '«Golden period» — energy ይመለሳል baby fast growth።',
        AppLang.oromic: 'Yeroo «goolden» — humni deebi\'a daa\'imni saffisaan guddata.',
      },
      body: {
        AppLang.english:
            'Many women feel more energetic between weeks 14–26. You may first feel baby movements (quickening) around weeks 18–22.\n\nAn anatomy scan is usually done at 18–20 weeks. Continue iron and calcium-rich foods. Gentle walking and prenatal yoga are safe for most women.\n\nWatch for swelling, vision changes, or severe headaches — report these to your doctor.',
        AppLang.amharic:
            'Weeks 14–26 energy። quickening 18–22። anatomy scan 18–20። iron/calcium። walking/yoga safe።\n\nSwelling, vision changes, severe headache — doctor።',
        AppLang.oromic:
            'Torban 14–26 humni ni deebi\'a. Sochii daa\'imaa 18–22. Sakatta\'iinsa anatomy 18–20.\n\nNyaata biroo fi kalcium itti fufuu. Deemsa salphaa nageenya qaba.\n\nDhiibbaa, jijjiirama argaa, dhukkubbii mataa — gabaasuu.',
      },
    ),
    DiscoverArticle(
      id: '9',
      category: DiscoverCategory.birth,
      emoji: '🎒',
      readMinutes: 3,
      title: {
        AppLang.english: 'Hospital Bag Checklist',
        AppLang.amharic: 'የሆስፒታል ቦርሳ checklist',
        AppLang.oromic: 'Tarree Saantoo Hospitaalaa',
      },
      summary: {
        AppLang.english:
            'What to pack before your due date arrives.',
        AppLang.amharic: 'due date በፊት ምን መዘጋጀት።',
        AppLang.oromic: 'Guyyaa dhalootaa dura maaltu qopheessuu.',
      },
      body: {
        AppLang.english:
            'For you: ID, insurance, comfortable clothes, toiletries, nursing bra, phone charger, snacks.\n\nFor baby: onesies, blanket, nappies, hat, car seat for the ride home.\n\nFor partner: change of clothes, camera, snacks. Keep the bag ready from week 36.',
        AppLang.amharic:
            'For you: ID, insurance, clothes, toiletries, nursing bra, charger, snacks.\n\nBaby: onesies, blanket, nappies, hat, car seat.\n\nPartner: clothes, camera. Week 36 ready።',
        AppLang.oromic:
            'Ofiif: ID, insurance, uffata, meeshaa qulqullina, charger, nyaata.\n\nDaa\'imaaf: uffata, haguuggii, pampars, kophee, car seat.\n\nWeek 36 irraa qophaa\'aa turuu.',
      },
    ),
    DiscoverArticle(
      id: '10',
      category: DiscoverCategory.pregnancy,
      emoji: '🌅',
      readMinutes: 3,
      title: {
        AppLang.english: 'Managing Morning Sickness',
        AppLang.amharic: 'የጥዋት sickness',
        AppLang.oromic: 'Dhukkubbii Ganama Ittisu',
      },
      summary: {
        AppLang.english:
            'Tips to ease nausea in early pregnancy.',
        AppLang.amharic: 'በearly pregnancy nauseaን ለመቀነስ tips።',
        AppLang.oromic: 'Dhukkubbii garaa jalqabaa keessatti salphisuu.',
      },
      body: {
        AppLang.english:
            'Eat small, frequent meals — an empty stomach worsens nausea. Try ginger tea, crackers, or dry toast before getting up.\n\nAvoid strong smells and greasy foods. Stay hydrated with small sips throughout the day.\n\nMost nausea improves by week 14. Contact your doctor if you cannot keep fluids down or lose weight.',
        AppLang.amharic:
            'Small frequent meals። ginger, crackers, dry toast before up።\n\nStrong smells/greasy avoid። small sips hydrate።\n\nWeek 14 improve። cannot keep fluids — doctor።',
        AppLang.oromic:
            'Nyaata xiqqaa irra deddeebi\'ii nyaachuu. Ginger, crackers dura ka\'uu.\n\nFaaya cimaa fi nyaata cophaa irraa fagaachuu.\n\nTorban 14tti ni fooyya\'a. Bishaan yoo hin dhaabanne doktora.',
      },
    ),
    DiscoverArticle(
      id: '11',
      category: DiscoverCategory.wellness,
      emoji: '🧘',
      readMinutes: 3,
      title: {
        AppLang.english: 'Mental Health During Pregnancy',
        AppLang.amharic: 'mental health በእርግዝና',
        AppLang.oromic: 'Fayyaa Sammuu Hiyyaassa Keessatti',
      },
      summary: {
        AppLang.english:
            'It is normal to feel anxious — here is how to cope.',
        AppLang.amharic: 'Anxiety normal — cope how።',
        AppLang.oromic: 'Yaaddoo uumamuu danda\'a — akkamitti ittisu.',
      },
      body: {
        AppLang.english:
            'Hormonal changes can affect mood. Talk openly with your partner, family, or friends. Join a prenatal group if available.\n\nPractice deep breathing, gentle walks, and adequate sleep. Limit stressful news and social media.\n\nSeek professional help if anxiety or low mood interferes with daily life for more than two weeks.',
        AppLang.amharic:
            'Hormonal mood። talk partner/family። prenatal group።\n\nBreathing, walks, sleep። limit stress news።\n\nAnxiety/low mood >2 weeks daily life — professional help።',
        AppLang.oromic:
            'Jijjiiramni hormoonii sammuu dhiibuu danda\'a. Hiriyaa fi maati waliin haasa\'uu.\n\nHafuura fudhachuu, deemsa salphaa, hirriba gahaa.\n\nYaaddoon torban 2 ol jireenya keessatti yoo dhiibee gargaarsa barbaadi.',
      },
    ),
    DiscoverArticle(
      id: '12',
      category: DiscoverCategory.babyCare,
      emoji: '📏',
      readMinutes: 3,
      title: {
        AppLang.english: 'Newborn Growth Milestones',
        AppLang.amharic: 'Newborn growth milestones',
        AppLang.oromic: 'Gantummaa Guddina Daa\'ima Haaraa',
      },
      summary: {
        AppLang.english:
            'What development to expect in the first 3 months.',
        AppLang.amharic: 'በ3 months መጀመሪያ development።',
        AppLang.oromic: 'Ji\'a 3 jalqabaa keessatti guddina maaltu eegamu.',
      },
      body: {
        AppLang.english:
            'Week 1–4: reflexes, brief eye contact, startle response to loud sounds.\n\nMonth 2: social smiles, coos, follows objects with eyes.\n\nMonth 3: holds head up during tummy time, reaches for toys, laughs.\n\nEvery baby develops at their own pace. Attend well-baby visits and discuss concerns with your paediatrician.',
        AppLang.amharic:
            'Week 1–4: reflexes, eye contact, startle።\n\nMonth 2: smiles, coos, follows eyes።\n\nMonth 3: head up tummy time, reaches toys, laughs።\n\nOwn pace — well-baby visits።',
        AppLang.oromic:
            'Torban 1–4: reflex, arguu, sagalee irratti korkoruu.\n\nJi\'a 2: kolfuu, sagalee, ijaan hordofuu.\n\nJi\'a 3: mataa kaasuu, meeshaa qabachuu.\n\nDaa\'imni hundi saffisa ofii — sakatta\'iinsa fayyaa.',
      },
    ),
  ];
}

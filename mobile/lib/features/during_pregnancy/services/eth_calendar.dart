// Ethiopian calendar utilities for during-pregnancy date pickers.

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

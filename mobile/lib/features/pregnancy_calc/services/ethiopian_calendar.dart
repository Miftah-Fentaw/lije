import 'dart:math' as math;

class EthiopianCalendar {
  static const List<String> monthsEn = [
    'Meskerem',
    'Tikmt',
    'Hidar',
    'Tahsas',
    'Ter',
    'Yekatit',
    'Megabit',
    'Miyazya',
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
    'ጉንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  static String toEthiopian(DateTime date,
      {bool amharic = false, bool oromic = false}) {
    final jdn = _gregorianToJDN(date.year, date.month, date.day);
    final r = jdn - 1724221;
    int etYear = ((r / 365.25).floor()) + 1;
    int base = _ethYearToJDN(etYear);
    if (jdn < base) etYear--;
    base = _ethYearToJDN(etYear);
    final dayInYear = jdn - base;
    final etMonth = math.min((dayInYear ~/ 30) + 1, 13);
    final etDay = dayInYear - 30 * (etMonth - 1) + 1;
    final months = amharic ? monthsAm : monthsEn;
    final mName = (etMonth >= 1 && etMonth <= 13) ? months[etMonth - 1] : '?';
    return '$etDay $mName $etYear';
  }

  static DateTime toGregorian(int etYear, int etMonth, int etDay) {
    final jdn = _ethYearToJDN(etYear) + 30 * (etMonth - 1) + etDay - 1;
    return _jdnToGregorian(jdn);
  }

  static bool isLeapYear(int etYear) => etYear % 4 == 3;

  static int daysInMonth(int etYear, int etMonth) {
    if (etMonth == 13) return isLeapYear(etYear) ? 6 : 5;
    return 30;
  }

  static int _gregorianToJDN(int y, int m, int d) {
    final a = (14 - m) ~/ 12;
    final yy = y + 4800 - a;
    final mm = m + 12 * a - 3;
    return d +
        (153 * mm + 2) ~/ 5 +
        365 * yy +
        yy ~/ 4 -
        yy ~/ 100 +
        yy ~/ 400 -
        32045;
  }

  static int _ethYearToJDN(int etYear) =>
      1724221 + 365 * (etYear - 1) + (etYear - 1) ~/ 4;

  static DateTime _jdnToGregorian(int jdn) {
    final a = jdn + 32044;
    final b = (4 * a + 3) ~/ 146097;
    final c = a - (146097 * b) ~/ 4;
    final d2 = (4 * c + 3) ~/ 1461;
    final e = c - (1461 * d2) ~/ 4;
    final m2 = (5 * e + 2) ~/ 153;
    final day = e - (153 * m2 + 2) ~/ 5 + 1;
    final month = m2 + 3 - 12 * (m2 ~/ 10);
    final year = 100 * b + d2 - 4800 + m2 ~/ 10;
    return DateTime(year, month, day);
  }

  static (int year, int month, int day) fromGregorian(DateTime date) {
    final jdn = _gregorianToJDN(date.year, date.month, date.day);
    final r = jdn - 1724221;
    int etYear = ((r / 365.25).floor()) + 1;
    int base = _ethYearToJDN(etYear);
    if (jdn < base) etYear--;
    base = _ethYearToJDN(etYear);
    final dayInYear = jdn - base;
    final etMonth = math.min((dayInYear ~/ 30) + 1, 13);
    final etDay = dayInYear - 30 * (etMonth - 1) + 1;
    return (etYear, etMonth, etDay);
  }
}

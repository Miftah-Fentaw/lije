import 'dart:math' as math;

class PregnancyResult {
  final DateTime edd;
  final DateTime lnmpEstimate;
  final int gaWeeks;
  final int gaDays;
  final int daysToEdd;
  final int trimester;
  final double progressPercent;

  PregnancyResult({
    required this.edd,
    required this.lnmpEstimate,
    required this.gaWeeks,
    required this.gaDays,
    required this.daysToEdd,
    required this.trimester,
    required this.progressPercent,
  });
}

class PregnancyCalculator {
  static DateTime _addMonths(DateTime d, int m) {
    int month = d.month + m;
    int year = d.year + (month - 1) ~/ 12;
    month = ((month - 1) % 12) + 1;
    final day = math.min(d.day, DateTime(year, month + 1, 0).day);
    return DateTime(year, month, day);
  }

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  static PregnancyResult? fromLNMP(DateTime lnmp) {
    final today = _today();
    if (lnmp.isAfter(today)) return null;
    final edd = _addMonths(lnmp, 9).add(const Duration(days: 7));
    return _build(edd, lnmp, today);
  }

  static PregnancyResult? fromUltrasound(
      DateTime scanDate, int gaWeeksAtScan, int gaDaysAtScan) {
    final today = _today();
    if (scanDate.isAfter(today)) return null;
    if (gaWeeksAtScan < 1 || gaWeeksAtScan > 39) return null;
    final gaAtScanDays = gaWeeksAtScan * 7 + gaDaysAtScan;
    final lnmpEst = scanDate.subtract(Duration(days: gaAtScanDays));
    final edd = lnmpEst.add(const Duration(days: 280));
    return _build(edd, lnmpEst, today);
  }

  static PregnancyResult? fromIVF(DateTime transferDate, int embryoAgeDays) {
    final today = _today();
    if (transferDate.isAfter(today)) return null;
    final edd = transferDate.add(Duration(days: 38 * 7 - embryoAgeDays));
    final lnmpEst = transferDate.subtract(Duration(days: 14 + embryoAgeDays));
    return _build(edd, lnmpEst, today);
  }

  static PregnancyResult _build(DateTime edd, DateTime lnmp, DateTime today) {
    final daysPreg = today.difference(lnmp).inDays;
    final gaW = daysPreg ~/ 7;
    final gaD = daysPreg % 7;
    final daysLeft = edd.difference(today).inDays;
    final tri = gaW < 14
        ? 1
        : gaW < 27
            ? 2
            : 3;
    final pct = (daysPreg / 280.0).clamp(0.0, 1.0);
    return PregnancyResult(
      edd: edd,
      lnmpEstimate: lnmp,
      gaWeeks: gaW,
      gaDays: gaD,
      daysToEdd: daysLeft,
      trimester: tri,
      progressPercent: pct,
    );
  }
}

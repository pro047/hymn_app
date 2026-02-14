class HymnDateUtils {
  static int weekOfMonthSundayStart(DateTime date) {
    return monthWeek(date).week;
  }

  static String monthWeekLabel(DateTime date) {
    final info = monthWeek(date);
    return '${info.month}월 ${info.week}주차';
  }

  static int weekCountInMonth(int year, int month) {
    final firstSunday = _firstSundayOfMonth(year, month);
    final lastDay = DateTime(year, month + 1, 0);
    final daysFromFirstSunday = lastDay.difference(firstSunday).inDays;
    return (daysFromFirstSunday ~/ 7) + 1;
  }

  static List<String> weekLabelsInMonth(int year, int month) {
    final count = weekCountInMonth(year, month);
    return List.generate(count, (index) => '$month월 ${index + 1}주차');
  }

  static MonthWeek monthWeek(DateTime date) {
    final year = date.year;
    final month = date.month;
    final firstSunday = _firstSundayOfMonth(year, month);
    if (date.isBefore(firstSunday)) {
      final lastPrevDay = DateTime(year, month, 0);
      final prevMonth = lastPrevDay.month;
      final prevYear = lastPrevDay.year;
      final lastWeek = weekCountInMonth(prevYear, prevMonth);
      return MonthWeek(year: prevYear, month: prevMonth, week: lastWeek);
    }
    final daysFromFirstSunday = date.difference(firstSunday).inDays;
    final week = (daysFromFirstSunday ~/ 7) + 1;
    return MonthWeek(year: year, month: month, week: week);
  }

  static DateTime _firstSundayOfMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final offset = (7 - (firstDay.weekday % 7)) % 7; // Sun=0
    return firstDay.add(Duration(days: offset));
  }
}

class MonthWeek {
  final int year;
  final int month;
  final int week;

  const MonthWeek({
    required this.year,
    required this.month,
    required this.week,
  });

  @override
  bool operator ==(Object other) {
    return other is MonthWeek &&
        other.year == year &&
        other.month == month &&
        other.week == week;
  }

  @override
  int get hashCode => Object.hash(year, month, week);
}

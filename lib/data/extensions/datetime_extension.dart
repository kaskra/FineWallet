extension ExtendedDateTime on DateTime {
  DateTime getFirstDateOfMonth() {
    return DateTime.utc(year, month, 1);
  }

  DateTime getLastDateOfMonth() {
    return (month < 12)
        ? DateTime.utc(year, month + 1, 0)
        : DateTime.utc(year + 1, 1, 0);
  }

  DateTime getFirstOfNextMonth() {
    return getLastDateOfMonth().add(const Duration(days: 1));
  }

  int get remainingDaysInMonth =>
      getLastDateOfMonth().difference(this).inDays.abs() + 1;

  bool isBeforeOrEqual(DateTime date) {
    return isBefore(date) || isAtSameMomentAs(date);
  }

  String getMonthName({bool abbrev = false}) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final monthName = months[(month - 1) % 12];
    return abbrev ? monthName.substring(0, 3) : monthName;
  }

  String getDayName() {
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[(weekday - 1) % 7];
  }
}

DateTime today() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(now.year, now.month, now.day);
}

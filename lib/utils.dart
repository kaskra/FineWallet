/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

// TODO do most of this as an extension for DateTime

int dayInMillis(DateTime time) {
  final DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

int getLastDayOfMonth(DateTime date) {
  return getLastDateOfMonth(date).day;
}

DateTime getFirstDateOfNextMonth(DateTime date) {
  final d = getLastDateOfMonth(date).add(const Duration(days: 1));
  return DateTime.utc(d.year, d.month, 1);
}

int getFirstDateOfMonthInMillis(DateTime date) {
  return dayInMillis(DateTime.utc(date.year, date.month, 1));
}

DateTime getFirstDateOfMonth(DateTime date) {
  return DateTime.utc(date.year, date.month, 1);
}

DateTime getLastDateOfMonth(DateTime date) {
  return (date.month < 12)
      ? DateTime.utc(date.year, date.month + 1, 0, 23, 59, 59)
      : DateTime.utc(date.year + 1, 1, 0, 23, 59, 59);
}

int getLastDateOfMonthInMillis(DateTime date) {
  return getLastDateOfMonth(date).millisecondsSinceEpoch;
}

int getMonthId(DateTime time) {
  return getFirstDateOfMonthInMillis(time);
}

List<double> getListOfMonthDays(DateTime month) {
  final DateTime date = month ?? DateTime.now();

  final int lastDay = getLastDayOfMonth(date);
  final DateTime firstOfMonth = DateTime.utc(date.year, date.month, 1);
  final DateTime lastOfMonth =
      DateTime.utc(date.year, date.month, lastDay, 23, 59, 59);

  final data = <double>[];
  for (var i = firstOfMonth.millisecondsSinceEpoch;
      i < lastOfMonth.millisecondsSinceEpoch;
      i = i + const Duration(days: 1).inMilliseconds) {
    final int day = dayInMillis(DateTime.fromMillisecondsSinceEpoch(i));
    data.add(day.toDouble());
  }
  return data;
}

String getDayName(int day) {
  final days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  return days[(day - 1) % 7];
}

String getMonthName(int month, {bool abbrev = false}) {
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

int getRemainingDaysInMonth(DateTime date) =>
    getLastDayOfMonth(date) - date.day + 1;

List<DateTime> getLastWeekAsDates() {
  final days = <DateTime>[];
  for (var i = 0; i < 7; i++) {
    final DateTime lastDay = DateTime.now().add(Duration(days: -i));
    days.add(lastDay);
  }
  return days;
}

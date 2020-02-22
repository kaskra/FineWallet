/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

// TODO do most of this as an extension for DateTime

int dayInMillis(DateTime time) {
  DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

int getLastDayOfMonth(DateTime date) {
  return getLastDateOfMonth(date).day;
}

DateTime getFirstDateOfNextMonth(DateTime date) {
  DateTime d = getLastDateOfMonth(date).add(Duration(days: 1));
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
      ? new DateTime.utc(date.year, date.month + 1, 0, 23, 59, 59)
      : new DateTime.utc(date.year + 1, 1, 0, 23, 59, 59);
}

int getLastDateOfMonthInMillis(DateTime date) {
  return getLastDateOfMonth(date).millisecondsSinceEpoch;
}

int getMonthId(DateTime time) {
  return getFirstDateOfMonthInMillis(time);
}

List<double> getListOfMonthDays(DateTime month) {
  DateTime date = month ?? DateTime.now();

  int lastDay = getLastDayOfMonth(date);
  DateTime firstOfMonth = DateTime.utc(date.year, date.month, 1);
  DateTime lastOfMonth =
      DateTime.utc(date.year, date.month, lastDay, 23, 59, 59);

  List<double> data = List();
  for (var i = firstOfMonth.millisecondsSinceEpoch;
      i < lastOfMonth.millisecondsSinceEpoch;
      i = i + Duration(days: 1).inMilliseconds) {
    int day = dayInMillis(DateTime.fromMillisecondsSinceEpoch(i));
    data.add(day.toDouble());
  }
  return data;
}

String getDayName(int day) {
  List<String> days = [
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
  List<String> months = [
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
  String monthName = months[(month - 1) % 12];
  return abbrev ? monthName.substring(0, 3) : monthName;
}

int getRemainingDaysInMonth(DateTime date) =>
    getLastDayOfMonth(date) - date.day + 1;

List<DateTime> getLastWeekAsDates() {
  List<DateTime> days = List();
  for (var i = 0; i < 7; i++) {
    DateTime lastDay = DateTime.now().add(Duration(days: -i));
    days.add(lastDay);
  }
  return days;
}

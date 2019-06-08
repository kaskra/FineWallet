/*
 * Developed by Lukas Krauch 08.06.19 11:27.
 * Copyright (c) 2019. All rights reserved.
 *
 */

int dayInMillis(DateTime time) {
  DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

int getLastDayOfMonth(DateTime date) {
  int day = (date.month < 12)
      ? new DateTime(date.year, date.month + 1, 0).day
      : new DateTime(date.year + 1, 1, 0).day;
  return day;
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

List<DateTime> getLastWeekAsDates() {
  List<DateTime> days = List();
  for (var i = 0; i < 7; i++) {
    DateTime lastDay = DateTime.now().add(Duration(days: -i));
    days.add(lastDay);
  }
  return days;
}

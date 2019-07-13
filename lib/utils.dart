/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

int dayInMillis(DateTime time) {
  DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

int getLastDayOfMonth(DateTime date) {
  return getLastDateOfMonth(date).day;
}

DateTime getLastDateOfMonth(DateTime date) {
  return (date.month < 12)
      ? new DateTime(date.year, date.month + 1, 0)
      : new DateTime(date.year + 1, 1, 0);
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

int replayTypeToMillis(int replayType, int transactionDate) {
  switch (replayType) {
    case 0:
      return Duration.millisecondsPerDay;
      break;
    case 1:
      return Duration.millisecondsPerDay * 7;
      break;
    case 2:
      DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(transactionDate);
      DateTime nextMonth = DateTime.utc(currentDate.year, currentDate.month, 1)
          .add(Duration(days: 35));
      int lastOfNextMonth = getLastDayOfMonth(nextMonth);
      int lastOfNextMonthInMillis = dayInMillis(
          DateTime.utc(nextMonth.year, nextMonth.month, lastOfNextMonth));
      DateTime sameDayNextMonth =
          DateTime.utc(nextMonth.year, nextMonth.month, currentDate.day);
      if (dayInMillis(sameDayNextMonth) > lastOfNextMonthInMillis)
        return lastOfNextMonthInMillis - dayInMillis(currentDate);
      return dayInMillis(sameDayNextMonth) - dayInMillis(currentDate);
      break;
    case 3:
      DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(transactionDate);
      DateTime nextYear = DateTime.utc(
          currentDate.year + 1, currentDate.month, currentDate.day);
      int nextYearInt = dayInMillis(nextYear);
      return nextYearInt - transactionDate;
  }
  return -1;
}

int isRecurrencePossible(
    int transactionDate, int replayUntilDate, int replayType) {
  int interval = replayTypeToMillis(replayType, transactionDate);

  if (replayUntilDate == null) return interval;

  if (interval == -1) return -1;

  if (interval <= replayUntilDate - transactionDate) return interval;

  return -1;
}

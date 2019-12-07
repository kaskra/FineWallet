/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/transaction_list.dart';

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

List<int> getAllMonthIds(TransactionList list) {
  List<int> ids = [];

  if (list.isEmpty) return [];

  void addToIdList(int id) {
    if (!ids.contains(id)) {
      ids.add(id);
    }
  }

  DateTime current = DateTime.fromMillisecondsSinceEpoch(list.last.date);
  addToIdList(getMonthId(current));
  DateTime last = DateTime.fromMillisecondsSinceEpoch(list.first.date);
  addToIdList(getMonthId(last));

  while (current.isBefore(last)) {
    int id = getMonthId(current);
    addToIdList(id);
    current = getFirstDateOfNextMonth(current);
  }

  return ids;
}

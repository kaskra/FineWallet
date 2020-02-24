/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

// TODO do most of this as an extension for DateTime

import 'package:FineWallet/data/extensions/datetime_extension.dart';

int dayInMillis(DateTime time) {
  final DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

int getLastDayOfMonth(DateTime date) {
  return getLastDateOfMonth(date).day;
}

DateTime getLastDateOfMonth(DateTime date) {
  return (date.month < 12)
      ? DateTime.utc(date.year, date.month + 1, 0, 23, 59, 59)
      : DateTime.utc(date.year + 1, 1, 0, 23, 59, 59);
}

List<double> getListOfMonthDays(DateTime month) {
  final DateTime date = month ?? today();

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

List<DateTime> getLastWeekAsDates() {
  final days = <DateTime>[];
  for (var i = 0; i < 7; i++) {
    final DateTime lastDay = today().add(Duration(days: -i));
    days.add(lastDay);
  }
  return days;
}

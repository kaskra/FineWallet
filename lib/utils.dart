/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/extensions/datetime_extension.dart';

List<DateTime> getListOfMonthDays(DateTime month) {
  final DateTime date = month ?? today();

  final DateTime lastDay = date.getLastDateOfMonth();
  final DateTime firstOfMonth = date.getFirstDateOfMonth();

  final data = <DateTime>[];
  for (var i = firstOfMonth;
      i.isBeforeOrEqual(lastDay);
      i = i.add(const Duration(days: 1))) {
    data.add(i);
    // TODO decide whether "stairs" or linear
    data.add(i.add(const Duration(hours: 12)));
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

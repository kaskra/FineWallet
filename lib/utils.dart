/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:easy_localization/easy_localization.dart';

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

String tryTranslatePreset(dynamic data) {
  var returnString = "";
  if (data is Subcategory) {
    returnString = data.isPreset ? data.name.tr() : data.name;
  } else if (data is Category) {
    returnString = data.isPreset ? data.name.tr() : data.name;
  } else if (data is String && data.isNotEmpty) {
    returnString = data.tr();
  }
  return returnString;
}

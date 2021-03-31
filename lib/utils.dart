/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<DateTime> pickDate(
    BuildContext context, DateTime initialDate, DateTime firstDate) async {
  final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: DateTime(2050, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Provider.of<ThemeNotifier>(context).isDarkMode
              ? ThemeData.dark().copyWith(
                  colorScheme: darkColorScheme,
                )
              : ThemeData.light().copyWith(
                  colorScheme: colorScheme.copyWith(onSurface: Colors.black),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
          child: child,
        );
      });
  return pickedDate;
}

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

String fillOutRecurrenceName(String res, DateTime date, int id) {
  final args = _switchBetweenRecurrenceDetails(date, id);
  var text = res;

  for (final str in args) {
    text = text.replaceFirst(r"${}", str);
  }

  return text;
}

List<String> _switchBetweenRecurrenceDetails(DateTime date, int id) {
  switch (id) {
    case 3:
      return _weekly(date);
    case 4:
      return _monthlyNthWeekday(date);
    case 5:
      return _monthlyDate(date);
    case 6:
      return _yearlyDate(date);
    default:
      return [];
  }
}

// TODO localized
List<String> _weekly(DateTime date) {
  return [date.getDayName()];
}

List<String> _monthlyNthWeekday(DateTime date) {
  return ["second", date.getDayName()];
}

List<String> _monthlyDate(DateTime date) {
  return ["${date.day}."];
}

List<String> _yearlyDate(DateTime date) {
  return ["${date.day} ${date.getMonthName()}"];
}

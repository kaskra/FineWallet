/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:math';

import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

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
  return firstOfMonth.rangeTo(lastDay - 1.days, by: 1.days).toList();
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

String fillOutRecurrenceName(
    String res, DateTime date, int id, BuildContext context) {
  final args = _switchBetweenRecurrenceDetails(date, id, context);
  var text = res;

  for (final str in args) {
    text = text.replaceFirst(r"${}", str);
  }

  return text;
}

List<String> _switchBetweenRecurrenceDetails(
    DateTime date, int id, BuildContext context) {
  switch (id) {
    case 3:
      return _weekly(date);
    case 4:
      return _monthlyNthWeekday(date);
    case 5:
      return _monthlyLastWeek(date);
    case 6:
      return _monthlyDate(date, context);
    case 7:
      return _yearlyDate(date, context);
    default:
      return [];
  }
}

List<String> _weekly(DateTime date) {
  return [date.getDayName()];
}

List<String> _monthlyNthWeekday(DateTime date) {
  final int numberOfWeek = date.getNumberOfWeekInMonth();
  final String localizedNumberOfWeek = localizeNumberOfWeek(numberOfWeek);

  return [localizedNumberOfWeek, date.getDayName()];
}

List<String> _monthlyLastWeek(DateTime date) {
  return [date.getDayName()];
}

List<String> _monthlyDate(DateTime date, BuildContext context) {
  final DateFormat formatter = DateFormat.d(context.locale.toLanguageTag());
  return [formatter.format(date)];
}

List<String> _yearlyDate(DateTime date, BuildContext context) {
  final DateFormat formatter = DateFormat.MMMMd(context.locale.toLanguageTag());
  return [formatter.format(date)];
}

String localizeNumberOfWeek(int week) {
  switch (week) {
    case 1:
      return LocaleKeys.ordinal_numbers_first.tr();
    case 2:
      return LocaleKeys.ordinal_numbers_second.tr();
    case 3:
      return LocaleKeys.ordinal_numbers_third.tr();
    case 4:
      return LocaleKeys.ordinal_numbers_fourth.tr();
    case 5:
      return LocaleKeys.ordinal_numbers_fifth.tr();
    default:
      return LocaleKeys.ordinal_numbers_last.tr();
  }
}

bool isInLastWeekOfMonth(DateTime date) {
  final DateTime lastDateInMonth = date.getLastDateOfMonth();
  final List<int> lastWeekDates = [
    for (var i = 0; i < 7; i++) lastDateInMonth.day - i
  ];
  return lastWeekDates.contains(date.day);
}

class NiceTicks {
  double _maxTicks;
  double _minPoint;
  double _maxPoint;
  double _tickSpacing;
  double _range;
  double _niceMin;
  double _niceMax;

  double get niceMin => _niceMin;
  double get niceMax => _niceMax;
  double get tickSpacing => _tickSpacing;

  NiceTicks({@required double maxTicks, double minPoint, double maxPoint}) {
    _maxTicks = maxTicks ?? 10;
    _minPoint = minPoint ?? 0;
    _maxPoint = maxPoint ?? 100;
    calculate();
  }

  void calculate() {
    _range = _niceNum(_maxPoint - _minPoint, false);
    _tickSpacing = _niceNum(_range / (_maxTicks - 1), true);
    _niceMin = (_minPoint / _tickSpacing).floorToDouble() * _tickSpacing;
    _niceMax = (_maxPoint / _tickSpacing).ceilToDouble() * _tickSpacing;
  }

  double _niceNum(double range, bool round) {
    double exponent;
    double fraction;
    double niceFraction;

    exponent = log10(range).floorToDouble();
    fraction = range / pow(10, exponent);

    if (round) {
      if (fraction < 1.5) {
        niceFraction = 1;
      } else if (fraction < 3) {
        niceFraction = 2;
      } else if (fraction < 7) {
        niceFraction = 5;
      } else {
        niceFraction = 10;
      }
    } else {
      if (fraction <= 1) {
        niceFraction = 1;
      } else if (fraction <= 2) {
        niceFraction = 2;
      } else if (fraction <= 5) {
        niceFraction = 5;
      } else {
        niceFraction = 10;
      }
    }

    return niceFraction * pow(10, exponent);
  }
}

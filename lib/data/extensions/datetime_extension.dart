import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

extension ExtendedDateTime on DateTime {
  DateTime getFirstDateOfMonth() {
    return DateTime(year, month);
  }

  DateTime getLastDateOfMonth() {
    return (month < 12)
        ? DateTime(year, month + 1, 0, 12)
        : DateTime(year + 1, 1, 0, 12);
  }

  DateTime getFirstOfNextMonth() {
    return getLastDateOfMonth().add(const Duration(days: 1));
  }

  int get remainingDaysInMonth =>
      getLastDateOfMonth().difference(this).inDays.abs() + 1;

  bool isBeforeOrEqual(DateTime date) {
    return isBefore(date) || isAtSameMomentAs(date);
  }

  String getMonthName({bool abbrev = false}) {
    final months = [
      LocaleKeys.january,
      LocaleKeys.february,
      LocaleKeys.march,
      LocaleKeys.april,
      LocaleKeys.may,
      LocaleKeys.june,
      LocaleKeys.july,
      LocaleKeys.august,
      LocaleKeys.september,
      LocaleKeys.october,
      LocaleKeys.november,
      LocaleKeys.december
    ];
    final monthName = months[(month - 1) % 12].tr();
    return abbrev ? monthName.substring(0, 3) : monthName;
  }

  String getDayName() {
    final days = [
      LocaleKeys.monday,
      LocaleKeys.tuesday,
      LocaleKeys.wednesday,
      LocaleKeys.thursday,
      LocaleKeys.friday,
      LocaleKeys.saturday,
      LocaleKeys.sunday
    ];
    return days[(weekday - 1) % 7].tr();
  }

  String toSql() {
    final yearS = convertToFourDigits(year);
    final monthS = convertToTwoDigits(month);
    final dayS = convertToTwoDigits(day);
    return "$yearS-$monthS-$dayS";
  }

  int getNumberOfWeekInMonth() {
    return ((day - 1) / 7).floor() + 1;
  }

  int hourInMonth() {
    final firstOfMonth = getFirstDateOfMonth();
    final diff = difference(firstOfMonth).inHours;
    return diff;
  }
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String convertToTwoDigits(int n) {
  return n < 10 ? "0$n" : "$n";
}

String convertToFourDigits(int n) {
  final int absN = n.abs();
  final String sign = n < 0 ? "-" : "";
  if (absN >= 1000) return "$n";
  if (absN >= 100) return "${sign}0$absN";
  if (absN >= 10) return "${sign}00$absN";
  return "${sign}000$absN";
}

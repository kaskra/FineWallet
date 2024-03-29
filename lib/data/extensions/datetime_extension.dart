import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

extension ExtendedDateTime on DateTime {
  DateTime getFirstDateOfMonth() {
    return DateTime.utc(year, month);
  }

  DateTime getLastDateOfMonth() {
    return (month < 12)
        ? DateTime.utc(year, month + 1, 0)
        : DateTime.utc(year + 1, 1, 0);
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
}

DateTime today() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(now.year, now.month, now.day);
}

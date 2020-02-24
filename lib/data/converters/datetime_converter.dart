import 'package:moor/moor.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    } else {
      return DateTime.parse(fromDb);
    }
  }

  @override
  String mapToSql(DateTime value) {
    if (value != null) {
      final year = _fourDigits(value.year);
      final month = _twoDigits(value.month);
      final day = _twoDigits(value.day);
      return "$year-$month-$day";
    }
    return DateTime.now().toUtc().toIso8601String();
  }

  String _twoDigits(int n) {
    return n < 10 ? "0$n" : "$n";
  }

  String _fourDigits(int n) {
    final int absN = n.abs();
    final String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }
}

import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/utils.dart';

int _replayTypeToMillis(int replayType, int transactionDate) {
  switch (replayType) {
    case 1:
      return Duration.millisecondsPerDay;
      break;
    case 2:
      return Duration.millisecondsPerDay * 7;
      break;
    case 3:
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
    case 4:
      DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(transactionDate);
      DateTime nextYear = DateTime.utc(
          currentDate.year + 1, currentDate.month, currentDate.day);
      int nextYearInt = dayInMillis(nextYear);
      return nextYearInt - transactionDate;
  }
  return -1;
}

List<db_file.Transaction> generateRecurrences(db_file.Transaction tx) {
  List<db_file.Transaction> recurrences = [];

  int currentDate = tx.date;
  int interval = _replayTypeToMillis(tx.recurringType, currentDate);

  while (currentDate + interval <= tx.recurringUntil) {
    interval = _replayTypeToMillis(tx.recurringType, currentDate);
    if (interval != -1) {
      currentDate += interval;

      recurrences.add(tx.copyWith(date: currentDate));
    } else {
      print(
          "ERROR: Recurrence type is not in range. Got value: ${tx.recurringType}");
    }
  }

  return recurrences;
}

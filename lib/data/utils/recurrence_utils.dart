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
      final DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(transactionDate);
      final DateTime nextMonth =
          DateTime.utc(currentDate.year, currentDate.month, 1)
              .add(const Duration(days: 35));
      final int lastOfNextMonth = getLastDayOfMonth(nextMonth);
      final int lastOfNextMonthInMillis = dayInMillis(
          DateTime.utc(nextMonth.year, nextMonth.month, lastOfNextMonth));
      final DateTime sameDayNextMonth =
          DateTime.utc(nextMonth.year, nextMonth.month, currentDate.day);
      if (dayInMillis(sameDayNextMonth) > lastOfNextMonthInMillis) {
        return lastOfNextMonthInMillis - dayInMillis(currentDate);
      }
      return dayInMillis(sameDayNextMonth) - dayInMillis(currentDate);
      break;
    case 4:
      final DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(transactionDate);
      final DateTime nextYear = DateTime.utc(
          currentDate.year + 1, currentDate.month, currentDate.day);
      final int nextYearInt = dayInMillis(nextYear);
      return nextYearInt - transactionDate;
  }
  return -1;
}

/// Generates and returns all recurrences for a [db_file.Transaction].
///
/// Input
/// -----
/// [db_file.Transaction] recurring transaction.
///
/// Return
/// ------
/// list of [db_file.Transaction], each is recurrence of the input transaction.
List<db_file.Transaction> generateRecurrences(db_file.Transaction tx) {
  final List<db_file.Transaction> recurrences = [];

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

/// Checks that the chosen recurrence type is possible for the timespan between
/// first date and second date.
///
/// No check whether first date is before second date!
///
/// Input
/// -----
///
/// - [int] first date as date in milliseconds since epoch
///
/// - [int] second date as date in milliseconds since epoch
///
/// - [int] recurrence type to check <\br>
///
bool isRecurrencePossible(int firstDate, int secondDate, int type) {
  final int difference = (secondDate - firstDate).abs();
  final int neededInterval = _replayTypeToMillis(type, firstDate);
  return difference >= neededInterval;
}

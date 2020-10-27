import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/logger.dart';

/// Given a recurrence type and a transaction date, calculates the
/// duration of the recurrence.
///
Duration _replayTypeToDuration(int replayType, DateTime transactionDate) {
  switch (replayType) {
    case 1:
      return const Duration(days: 1);
      break;
    case 2:
      return const Duration(days: 7);
      break;
    case 3:
      final DateTime someDateNextMonth = transactionDate.getFirstOfNextMonth();
      final DateTime lastOfNextMonth = someDateNextMonth.getLastDateOfMonth();

      final DateTime sameDayNextMonth = DateTime.utc(
        someDateNextMonth.year,
        someDateNextMonth.month,
        transactionDate.day,
      );

      if (someDateNextMonth.isAfter(lastOfNextMonth)) {
        return lastOfNextMonth.difference(transactionDate);
      }
      return sameDayNextMonth.difference(transactionDate);
      break;
    case 4:
      final DateTime nextYear = DateTime.utc(
        transactionDate.year + 1,
        transactionDate.month,
        transactionDate.day,
      );
      return nextYear.difference(transactionDate);
      break;
    default:
      return null;
  }
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

  DateTime currentDate = tx.date;
  Duration interval = _replayTypeToDuration(tx.recurrenceType, currentDate);

  while (currentDate.add(interval).isBeforeOrEqual(tx.until)) {
    interval = _replayTypeToDuration(tx.recurrenceType, currentDate);
    if (interval.inDays != null) {
      currentDate = currentDate.add(interval);

      recurrences.add(tx.copyWith(date: currentDate));
    } else {
      logMsg(
          "ERROR: Recurrence type is not in range. Got value: ${tx.recurrenceType}");
    }
  }

  return recurrences;
}

/// Checks that the chosen recurrence type is possible for the timespan between
/// first date and second date.
///
/// Input
/// -----
///
/// - [int] first date as date
///
/// - [int] second date as date
///
/// - [int] recurrence type to check <\br>
///
bool isRecurrencePossible(DateTime firstDate, DateTime secondDate, int type) {
  final int difference = secondDate.difference(firstDate).inDays.abs();
  final int neededInterval =
      _replayTypeToDuration(type, firstDate).inDays.abs();
  return difference >= neededInterval;
}

import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';

/// Return all missing months between the last recorded month and now.
List<DateTime> getMissingMonths(Month lastRecordedMonth) {
  final List<DateTime> months = [];

  DateTime lastRecordedDate = lastRecordedMonth.firstDate;

  final currentDate = today().getFirstDateOfMonth();

  while (lastRecordedDate.isBefore(currentDate)) {
    lastRecordedDate = lastRecordedDate.getFirstOfNextMonth();
    months.add(lastRecordedDate);
  }

  return months;
}

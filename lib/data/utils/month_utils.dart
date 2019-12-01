import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/utils.dart';

/// Return all missing months between the last recorded month and now.
List getMissingMonths(Month lastRecordedMonth) {
  List<DateTime> months = [];

  DateTime lastRecordedDate =
      DateTime.fromMillisecondsSinceEpoch(lastRecordedMonth.firstDate).toUtc();

  DateTime currentDate =
      DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

  while (lastRecordedDate.isBefore(currentDate)) {
    lastRecordedDate = getFirstDateOfNextMonth(lastRecordedDate);
    months.add(lastRecordedDate);
  }

  return months;
}

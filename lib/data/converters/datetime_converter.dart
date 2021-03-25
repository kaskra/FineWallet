import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:moor/moor.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    } else {
      final date = DateTime.parse(fromDb);
      return date;
    }
  }

  @override
  String mapToSql(DateTime value) {
    if (value != null) {
      return value.toSql();
    }
    final date = today();
    return date.toSql();
  }
}

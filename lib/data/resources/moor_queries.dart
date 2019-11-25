import 'package:FineWallet/utils.dart';
import 'package:intl/intl.dart';

String ofMonth(String table, DateTime dayInMonth) {
  int millis = dayInMillis(dayInMonth);
  return "$table.first_date <= $millis and $table.last_date > $millis ";
}

String ofCategory(String table, int categoryId) {
  return "$table.category_id == $categoryId ";
}

String ofSubCategory(String table, int subcategoryId) {
  return "$table.subcategory_id == $subcategoryId ";
}

String isExpense(String table, int isExp) {
  return "$table.is_expense = $isExp";
}


// -------------------------------------------------------

String nextYear(DateTime date) {
  var formatter = DateFormat('yyyy-MM-dd');

  String dateFormatted = formatter.format(date);

  return "SELECT strftime('%s', (date '$dateFormatted', '+1 year', 'localtime')) * 1000";
}

String nextMonth(DateTime date) {
  var formatter = DateFormat('yyyy-MM-dd');

  String dateFormatted = formatter.format(date);

  return "SELECT strftime('%s', date('$dateFormatted', 'start of month', 'localtime', '+1 month' ,"
      "'+' || "
      "(SELECT MIN(strftime('%d', '$dateFormatted'), "
      "strftime('%d', '$dateFormatted', 'localtime', 'start of month', '+2 month', '-1 day')) - 1) "
      "|| ' day')) * 1000";
}

String nextWeek(DateTime date) {
  var formatter = DateFormat('yyyy-MM-dd');

  String dateFormatted = formatter.format(date);

  return "SELECT strftime('%s', date('$dateFormatted', '+7 day', 'localtime')) * 1000";
}

String nextDay(DateTime date) {
  var formatter = DateFormat('yyyy-MM-dd');

  String dateFormatted = formatter.format(date);

  return "SELECT strftime('%s', date('$dateFormatted', '+1 day', 'localtime')) * 1000";
}

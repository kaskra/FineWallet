import 'dart:collection';

import 'package:FineWallet/data/filters/filter_settings.dart';

/// This abstract class holds the structure for all filter parsers.
/// [E] is an [FilterSettings] and [K] any parsed output type.
abstract class FilterParser<E extends FilterSettings, K> {
  /// Filter settings to be parsed.
  E settings;

  FilterParser(this.settings);

  /// Parses the filter to a certain type [K].
  K parse();
}

/// This class implements the [FilterParser] abstract class and is used to
/// parse [TransactionFilterSettings] to a usable WHERE-clause for Moor.
class TransactionFilterParser
    extends FilterParser<TransactionFilterSettings, String> {
  TransactionFilterParser(TransactionFilterSettings settings) : super(settings);

  /// Parse the input to singular WHERE expressions.
  Queue<String> _getQueueOfArguments({String tableName = ""}) {
    final Queue<String> queue = Queue<String>();
    if (settings.category != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}category_id = ${settings.category}");
    }

    if (settings.subcategory != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}subcategory_id = ${settings.subcategory}");
    }

    if (settings.month != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}month_id = ${settings.month}");
    }

    if (settings.day != null) {
      queue
          .add("${tableName != "" ? "$tableName." : ""}date = ${settings.day}");
    }

    if (settings.before != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}date <= ${settings.before}");
    }

    if (settings.expenses != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}is_expense = ${settings.expenses ? 1 : 0}");
    }

    if (settings.incomes != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}is_expense = ${settings.incomes ? 0 : 1}");
    }

    if (settings.dateInMonth != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}month_id = (SELECT months.id FROM months "
          "WHERE months.first_date <= ${settings.dateInMonth} "
          "AND months.last_date >= ${settings.dateInMonth})");
    }
    return queue;
  }

  /// Parse the whole [TransactionFilterSettings] object
  /// into one WHERE-clause.
  @override
  String parse({String tableName = ""}) {
    final Queue<String> args = _getQueueOfArguments(tableName: tableName);
    if (args.isEmpty) return "";

    final buffer = StringBuffer();
    buffer.write(" WHERE ");
//    String whereQuery = " WHERE ";
    int index = 0;
    for (final String query in args) {
      if (index > 0) {
//        whereQuery += " AND ";
        buffer.write(" AND ");
      }
//      whereQuery += query;
      buffer.write(query);
      index++;
    }
    // TODO Check back here
//    whereQuery = whereQuery.split(" ").join(" ");
    buffer.toString();
    return buffer.toString().split(" ").join(" ");
  }
}

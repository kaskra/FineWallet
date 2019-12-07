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
  Queue _getQueueOfArguments() {
    Queue queue = new Queue();
    if (settings.category != null) {
      queue.add("category = ${settings.category}");
    }

    if (settings.subcategory != null) {
      queue.add("category = ${settings.subcategory}");
    }

    if (settings.month != null) {
      queue.add("month = ${settings.month}");
    }

    if (settings.day != null) {
      queue.add("date = ${settings.day}");
    }

    if (settings.before != null) {
      queue.add("date <= ${settings.before}");
    }

    if (settings.expenses != null) {
      queue.add("is_expense = ${settings.expenses ? 1 : 0}");
    }

    if (settings.incomes != null) {
      queue.add("is_expense = ${settings.incomes ? 0 : 1}");
    }

    if (settings.dateInMonth != null) {
      queue.add(" id = (SELECT id FROM months "
          "WHERE first_date >= ${settings.dateInMonth} "
          "AND last_date <= ${settings.dateInMonth})");
    }
    return queue;
  }

  /// Parse the whole [TransactionFilterSettings] object
  /// into one WHERE-clause.
  @override
  String parse() {
    Queue args = _getQueueOfArguments();
    if (args.length <= 0) return "";

    String whereQuery = " WHERE ";
    int index = 0;
    for (String query in args) {
      if (index > 0) {
        whereQuery += " AND ";
      }
      whereQuery += query;
      index++;
    }

    whereQuery = whereQuery.split(" ").join(" ");
    return whereQuery;
  }
}

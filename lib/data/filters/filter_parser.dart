import 'dart:collection';

import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';

/// This abstract class holds the structure for all filter parsers.
/// [E] is an [FilterSettings] and [K] any parsed output type.
abstract class FilterParser<E extends FilterSettings, K> {
  /// Filter settings to be parsed.
  E settings;

  FilterParser(this.settings) : assert(settings != null);

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
    const converter = DateTimeConverter();
    final Queue<String> queue = Queue<String>();
    if (settings.category != null) {
      queue.add("s.categoryId = ${settings.category}");
    }

    if (settings.subcategory != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}subcategoryId = ${settings.subcategory}");
    }

    if (settings.month != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}monthId = ${settings.month}");
    }

    if (settings.day != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}date = '${converter.mapToSql(settings.day)}'");
    }

    if (settings.before != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}date <= '${converter.mapToSql(settings.before)}'");
    }

    if (settings.expenses != null) {
      queue.add(
          "${settings.expenses ? "" : "NOT"} ${tableName != "" ? "$tableName." : ""}isExpense");
    }

    if (settings.incomes != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}isExpense = ${settings.incomes ? 0 : 1}");
    }

    if (settings.dateInMonth != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}monthId = (SELECT months.id FROM months "
          "WHERE months.firstDate <= '${converter.mapToSql(settings.dateInMonth)}' "
          "AND months.lastDate >= '${converter.mapToSql(settings.dateInMonth)}')");
    }

    if (settings.onlyRecurrences != null) {
      queue.add(
          "${tableName != "" ? "$tableName." : ""}recurrenceType > ${settings.onlyRecurrences ? 1 : 0}");
    }
    return queue;
  }

  /// Parse the whole [TransactionFilterSettings] object
  /// into one WHERE-clause.
  @override
  String parse({String tableName = ""}) {
    final Queue<String> args = _getQueueOfArguments(tableName: tableName);
    if (args == null) return "true";
    if (args.isEmpty) return "true";

    final buffer = StringBuffer();
    int index = 0;
    for (final query in args) {
      if (index > 0) {
        buffer.write(" AND ");
      }
      buffer.write(query);
      index++;
    }

    return buffer.toString();
  }
}

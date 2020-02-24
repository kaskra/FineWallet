import 'package:flutter/cupertino.dart';

/// This abstract class is only used to be a parent of a generic type.
abstract class FilterSettings {}

/// This class is used to build and pass certain
/// filters for querying the database.
class TransactionFilterSettings extends FilterSettings {
  final int category;
  final int subcategory;
  final int month;
  final DateTime day;
  final bool expenses;
  final bool incomes;
  final DateTime before;
  final DateTime dateInMonth;

  TransactionFilterSettings({
    this.category,
    this.subcategory,
    this.month,
    this.day,
    this.expenses,
    this.incomes,
    this.before,
    this.dateInMonth,
  });

  factory TransactionFilterSettings.byCategory(int categoryId) =>
      TransactionFilterSettings(category: categoryId);

  factory TransactionFilterSettings.bySubcategory(int subcategoryId) =>
      TransactionFilterSettings(subcategory: subcategoryId);

  factory TransactionFilterSettings.byMonth(int monthId) =>
      TransactionFilterSettings(month: monthId);

  factory TransactionFilterSettings.byDay(DateTime day) =>
      TransactionFilterSettings(day: day);

  factory TransactionFilterSettings.byExpense({@required bool isExpense}) =>
      TransactionFilterSettings(expenses: isExpense);

  factory TransactionFilterSettings.byIncome({@required bool isIncome}) =>
      TransactionFilterSettings(incomes: isIncome);

  factory TransactionFilterSettings.beforeDate(DateTime date) =>
      TransactionFilterSettings(before: date);

  factory TransactionFilterSettings.inMonth(DateTime date) =>
      TransactionFilterSettings(dateInMonth: date);
}

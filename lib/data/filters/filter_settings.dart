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
  final bool onlyRecurrences;

  TransactionFilterSettings({
    this.onlyRecurrences,
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

  factory TransactionFilterSettings.onlyRecurrences() =>
      TransactionFilterSettings(onlyRecurrences: true);

  TransactionFilterSettings copyWith(
          {int subcategory,
          int category,
          int month,
          DateTime day,
          bool expenses,
          bool incomes,
          DateTime before,
          DateTime dateInMonth,
          bool onlyRecurrences}) =>
      TransactionFilterSettings(
          subcategory: subcategory ?? this.subcategory,
          category: category ?? this.category,
          month: month ?? this.month,
          day: day ?? this.day,
          expenses: expenses ?? this.expenses,
          incomes: incomes ?? this.incomes,
          before: before ?? this.before,
          dateInMonth: dateInMonth ?? this.dateInMonth,
          onlyRecurrences: onlyRecurrences ?? this.onlyRecurrences);

  @override
  String toString() {
    return 'TransactionFilterSettings{category: $category, subcategory: $subcategory, '
        'month: $month, day: $day, expenses: $expenses, incomes: $incomes, '
        'before: $before, dateInMonth: $dateInMonth, '
        'onlyRecurrences: $onlyRecurrences}';
  }
}

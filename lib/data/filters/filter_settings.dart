import 'package:FineWallet/utils.dart';

/// This abstract class is only used to be a parent of a generic type.
abstract class FilterSettings {}

/// This class is used to build and pass certain
/// filters for querying the database.
class TransactionFilterSettings extends FilterSettings {
  final int category;
  final int subcategory;
  final int month;
  final int day;
  final bool expenses;
  final bool incomes;
  final int before;

  TransactionFilterSettings({
    this.category,
    this.subcategory,
    this.month,
    this.day,
    this.expenses,
    this.incomes,
    this.before,
  });

  factory TransactionFilterSettings.byCategory(int categoryId) =>
      TransactionFilterSettings(category: categoryId);

  factory TransactionFilterSettings.bySubcategory(int subcategoryId) =>
      TransactionFilterSettings(subcategory: subcategoryId);

  factory TransactionFilterSettings.byMonth(int monthId) =>
      TransactionFilterSettings(month: monthId);

  factory TransactionFilterSettings.byDay(int day) =>
      TransactionFilterSettings(day: day);

  factory TransactionFilterSettings.byExpense(bool isExpense) =>
      TransactionFilterSettings(expenses: isExpense);

  factory TransactionFilterSettings.byIncome(bool isIncome) =>
      TransactionFilterSettings(incomes: isIncome);

  factory TransactionFilterSettings.beforeDate(DateTime date) =>
      TransactionFilterSettings(before: dayInMillis(date));
}

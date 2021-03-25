/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_parser.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:moor/moor.dart';

part 'transaction_dao.g.dart';

class TransactionWithCategoryAndCurrency {
  final TransactionsResult tx;
  final db_file.Subcategory sub;
  final db_file.Currency currency;

  TransactionWithCategoryAndCurrency({this.tx, this.sub, this.currency});

  @override
  String toString() {
    return 'TransactionWithCategoryAndCurrency{tx: $tx, sub: $sub, currency: $currency}';
  }
}

@UseDao(
  include: {
    "moor_files/transaction_queries.moor",
  },
  tables: [
    BaseTransactions,
    RecurrenceTypes,
    Categories,
    Subcategories,
    Months,
    Currencies,
  ],
)
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;

  TransactionDao(this.db) : super(db);

  /// Returns every transaction unfiltered from the transactions table.
  ///
  /// Should use [watchTransactionsWithFilter] instead, when needed to
  /// display transactions.
  Future<List<TransactionsResult>> getAllTransactions() => transactions().get();

  /// Inserts a [db_file.Transaction] into the transactions table.
  ///
  /// While inserting, it makes sure that the month id exists, if not
  /// it creates a new month that fits. It generates all recurrences according
  /// to the recurring type passed in by the transaction. At last, it
  /// bulk inserts every created transaction.
  ///
  /// Input
  /// -----
  /// - [db_file.Transaction] that should be inserted.
  ///
  Future insertTransaction(BaseTransaction tx) async {
    // Setup: Get next id set original id to that.
    // Prevents SELECT in SQL-transaction.

    // TODO input by AddPage DataType
    return transaction(() async {
      final Currency currency =
          await db.currencyDao.getCurrencyById(tx.currencyId);
      print("Search for month id");
      final int monthId = await db.monthDao.createOrGetMonth(tx.date);
      print("Search for month id after");

      final double exchangeRate = currency?.exchangeRate ?? 1.0;
      final originalAmount = tx.amount;
      final amount = tx.amount * exchangeRate;

      await into(baseTransactions).insert(
        BaseTransactionsCompanion.insert(
          amount: amount,
          originalAmount: originalAmount,
          exchangeRate: exchangeRate,
          isExpense: tx.isExpense,
          date: tx.date,
          label: tx.label,
          subcategoryId: tx.subcategoryId,
          monthId: monthId,
          currencyId: tx.currencyId,
          recurrenceType: tx.recurrenceType,
          until: Value(tx.until),
        ),
      );
    });
  }

  /// Updates the transaction and its recurrences in the database.
  /// After updating, all months are synced to make sure that the max budget is
  /// still up-to-date.
  ///
  /// Input
  /// -----
  /// - [db_file.Transaction] that should be updated.
  ///
  Future updateTransaction(BaseTransaction tx) async {
    await transaction(() async {
      // final tempTx = db_file.Transaction(
      //     id: null,
      //     amount: tx.amount,
      //     originalAmount: tx.originalAmount,
      //     exchangeRate: tx.exchangeRate,
      //     monthId: tx.monthId,
      //     date: tx.date,
      //     subcategoryId: tx.subcategoryId,
      //     isExpense: tx.isExpense,
      //     isRecurring: tx.isRecurring,
      //     until: tx.until,
      //     recurrenceType: tx.recurrenceType,
      //     currencyId: tx.currencyId,
      //     label: tx.label);
      // await insertTransaction(tempTx);
      // TODO
    });
    return db.monthDao.batchedSyncMonths();
  }

  Future deleteTransaction(BaseTransaction transaction) =>
      deleteTransactionById(transaction.id);

  Future deleteTransactionById(int id) async {
    await deleteTxById(id);
    await db.monthDao.batchedSyncMonths();
  }

  Future deleteTransactionsByIds(List<int> transactionIds) async {
    await transaction(() async {
      deleteTxsByIds(transactionIds);
      await db.monthDao.batchedSyncMonths();
    });
  }

  /// Returns a [Stream] with the savings up to the current month.
  /// The stream is updated every time the database is changed.
  Stream<double> watchTotalSavings() {
    final currentDate = today().getFirstDateOfMonth();
    return totalSavings(currentDate.toSql()).watchSingle();
  }

  /// Returns a [Stream] that watches the transactions table.
  ///
  /// The stream is updated when ever the table changes.
  ///
  /// Input
  /// -----
  ///  - [TransactionFilterSettings] to filter the query results.
  ///
  Stream<List<TransactionsWithFilterResult>> watchTransactionsWithFilter(
      TransactionFilterSettings settings) {
    final txParser = TransactionFilterParser(settings);
    final settingsContent =
        txParser.parse(tableName: "t", useInCustomExp: true);
    final parsedSettings = CustomExpression<bool>(settingsContent);

    return transactionsWithFilter(predicate: parsedSettings).watch();
  }

  /// Returns a [Stream] of the monthly income.
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the monthly income.
  ///
  Stream<double> watchMonthlyIncome(DateTime date) =>
      monthlyIncome(date.toSql()).watchSingle();

  /// Returns a [Stream] of summed up monthly expenses grouped and ordered by day.
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [ExpensesPerDayInMonthResult]s with date and summed up expenses.
  ///
  Stream<List<ExpensesPerDayInMonthResult>> watchExpensesPerDayInMonth(
          DateTime dateInMonth) =>
      expensesPerDayInMonth(dateInMonth.toSql()).watch();

  /// Returns a [Stream] of categories and their corresponding
  /// summed up transactions.
  ///
  /// Input
  /// -----
  /// [TransactionFilterSettings] to filter the transactions.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of type [Tuple3]
  ///
  Stream<List<SumTransactionsByCategoryResult>>
      watchSumOfTransactionsByCategories(TransactionFilterSettings settings) {
    final parser = TransactionFilterParser(settings);
    final parsedSettings = CustomExpression<bool>(
        parser.parse(tableName: "t", useInCustomExp: true));
    return sumTransactionsByCategory(predicate: parsedSettings).watch();
  }

  /// Watches the latest non-recurrence transaction.
  Stream<NLatestTransactionsResult> watchLatestTransaction() =>
      nLatestTransactions(1).watchSingle();

  /// Watches the latest N non-recurrence transactions.
  Stream<List<NLatestTransactionsResult>> watchNLatestTransactions(int N) =>
      nLatestTransactions(N).watch();

  /// Returns a [Stream] of the monthly budget.
  ///
  /// Budget calculation
  ///
  /// `budget = max_budget - expenses;`
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the daily budget.
  ///
  Stream<double> watchMonthlyBudget(DateTime date) =>
      monthlyBudget(date.toSql()).watchSingle();

  /// Returns a [Stream] of the daily budget.
  ///
  /// Budget calculation
  ///
  /// `budget = max_budget - expenses;`
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the daily budget.
  ///
  Stream<double> watchDailyBudget(DateTime date) =>
      dailyBudget(date.toSql(), date.remainingDaysInMonth).watchSingle();

  /// Returns all expenses of the last seven days grouped by date and summed up.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [LastWeeksTransactionsResult]s with a day's date
  /// epoch and the sum of its expenses.
  Stream<List<LastWeeksTransactionsResult>> watchLastWeeksTransactions() {
    return lastWeeksTransactions().watch();
  }

  Future<List<String>> getTransactionsLabels({bool isExpense}) {
    return transactionsLabels(isExpense).get();
  }
}

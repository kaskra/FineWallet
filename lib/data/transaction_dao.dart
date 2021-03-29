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
  Future<List<TransactionsResult>> getAllTransactions() =>
      _transactions().get();

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
  Future<int> insertTransaction(BaseTransaction tx) => _upsertTransaction(tx);

  /// Updates the transaction and its recurrences in the database.
  /// After updating, all months are synced to make sure that the max budget is
  /// still up-to-date.
  ///
  /// Input
  /// -----
  /// - [db_file.Transaction] that should be updated.
  ///
  Future<int> updateTransaction(BaseTransaction tx) async {
    final id = await _upsertTransaction(tx, update: true);
    await db.monthDao.batchedSyncMonths();
    return id;
  }

  Future<int> _upsertTransaction(BaseTransaction tx, {bool update = false}) {
    return transaction<int>(() async {
      // TODO do all of this in sql?
      final int monthId = await db.monthDao.createOrGetMonth(tx.date);

      final Currency currency =
          await db.currencyDao.getCurrencyById(tx.currencyId);
      final double exchangeRate = currency?.exchangeRate ?? 1.0;
      final originalAmount = tx.amount;
      final amount = tx.amount * exchangeRate;

      return into(baseTransactions).insertOnConflictUpdate(
        BaseTransactionsCompanion.insert(
          id: update ? Value(tx.id) : const Value.absent(),
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

  Future deleteTransaction(TransactionsResult transaction) =>
      deleteTransactionById(transaction.id);

  Future deleteTransactionById(int id) async {
    await _deleteTxById(id);
    await db.monthDao.batchedSyncMonths();
  }

  Future deleteTransactionsByIds(List<int> transactionIds) async {
    await transaction(() async {
      _deleteTxsByIds(transactionIds);
      await db.monthDao.batchedSyncMonths();
    });
  }

  /// Returns a [Stream] with the savings up to the current month.
  /// The stream is updated every time the database is changed.
  Stream<double> watchTotalSavings() {
    final currentDate = today().getFirstDateOfMonth();
    return _totalSavings(currentDate.toSql()).watchSingle();
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
    final settingsContent = txParser.parse(tableName: "t");
    final parsedSettings = CustomExpression<bool>(settingsContent);

    return _transactionsWithFilter(predicate: parsedSettings).watch();
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
      _monthlyIncome(date.toSql()).watchSingle();

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
      _expensesPerDayInMonth(dateInMonth.toSql()).watch();

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
    final parsedSettings = CustomExpression<bool>(parser.parse(tableName: "t"));
    return _sumTransactionsByCategory(predicate: parsedSettings).watch();
  }

  /// Watches the latest non-recurrence transaction.
  Stream<NLatestTransactionsResult> watchLatestTransaction() =>
      _nLatestTransactions(1).watchSingleOrNull();

  /// Watches the latest N non-recurrence transactions.
  Stream<List<NLatestTransactionsResult>> watchNLatestTransactions(int N) =>
      _nLatestTransactions(N).watch();

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
      _monthlyBudget(date.toSql()).watchSingle();

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
      _dailyBudget(date.toSql(), date.remainingDaysInMonth).watchSingle();

  /// Returns all expenses of the last seven days grouped by date and summed up.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [LastWeeksTransactionsResult]s with a day's date
  /// epoch and the sum of its expenses.
  Stream<List<LastWeeksTransactionsResult>> watchLastWeeksTransactions() {
    return _lastWeeksTransactions().watch();
  }

  Future<List<String>> getTransactionsLabels({bool isExpense}) {
    return _transactionsLabels(isExpense).get();
  }
}

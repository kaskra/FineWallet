/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/filters/filter_parser.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/recurrence_utils.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'transaction_dao.g.dart';

class TransactionsWithCategory {
  final int id;
  final double amount;
  final int date;
  final bool isExpense;
  final bool isRecurring;
  final int recurringUntil;
  final int subcategoryId;
  final String subcategoryName;
  final int categoryId;
  final int originalId;
  final int recurringType;

  TransactionsWithCategory(
      {this.id,
      this.amount,
      this.date,
      this.isExpense,
      this.isRecurring,
      this.recurringUntil,
      this.subcategoryId,
      this.subcategoryName,
      this.originalId,
      this.recurringType,
      this.categoryId});

  @override
  String toString() {
    return 'TransactionsWithCategory{id: $id, amount: $amount, date: $date, isExpense: $isExpense, isRecurring: $isRecurring, recurringUntil: $recurringUntil, subcategoryId: $subcategoryId, subcategoryName: $subcategoryName, categoryId: $categoryId, originalId: $originalId, recurringType: $recurringType}';
  }

  factory TransactionsWithCategory.fromQueryRow(QueryRow row) {
    return TransactionsWithCategory(
      id: row.readInt("id"),
      isExpense: row.readBool("is_expense"),
      subcategoryId: row.readInt("subcategory_id"),
      categoryId: row.readInt("category_id"),
      subcategoryName: row.readString("name"),
      amount: row.readDouble("amount"),
      isRecurring: row.readBool("is_recurring"),
      recurringUntil: row.readInt("recurring_until"),
      originalId: row.readInt("original_id"),
      recurringType: row.readInt("recurring_type"),
      date: row.readInt("date"),
    );
  }
}

@UseDao(
  tables: [
    Transactions,
    Categories,
    Subcategories,
    Months,
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
  Future<List<db_file.Transaction>> getAllTransactions() =>
      select(transactions).get();

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
  Future insertTransaction(db_file.Transaction tx) async {
    // Setup: Get next id set original id to that.
    // Prevents SELECT in SQL-transaction.
    int maxTransactionID = await db.maxTransactionId();
    int nextId = (maxTransactionID ?? 0) + 1;
    tx = tx.copyWith(originalId: nextId);

    // Fill in month id
    if (tx.monthId == null) {
      int id = await db.monthDao.createOrGetMonth(tx.date);
      tx = tx.copyWith(monthId: id);
    }

    // Make sure that every transaction has its correct month id assigned.
    List<Insertable<db_file.Transaction>> txs = [];

    if (tx.isRecurring) {
      List<db_file.Transaction> recurrences = generateRecurrences(tx);
      for (var t in recurrences) {
        int id = await db.monthDao.createOrGetMonth(t.date);
        txs.add(t.copyWith(monthId: id ?? t.monthId).createCompanion(true));
      }
    }

    // Add all transactions to database in SQL-transaction.
    return transaction(() async {
      await into(transactions).insert(
        tx.createCompanion(true).copyWith(id: Value(nextId)),
      );

      if (tx.isRecurring) {
        await batch((b) {
          b.insertAll(transactions, txs);
        });
      }
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
  Future updateTransaction(db_file.Transaction tx) async {
    await transaction(() async {
      await deleteTransactionById(tx.originalId, beforeInsert: true);
      tx = db_file.Transaction(
          id: null,
          originalId: null,
          amount: tx.amount,
          monthId: tx.monthId,
          date: tx.date,
          subcategoryId: tx.subcategoryId,
          isExpense: tx.isExpense,
          isRecurring: tx.isRecurring,
          recurringUntil: tx.recurringUntil,
          recurringType: tx.recurringType);
      await insertTransaction(tx);
    });
    return await db.monthDao.syncMonths();
  }

  Future deleteTransaction(db_file.Transaction transaction) async {
    await delete(transactions).delete(transaction.createCompanion(true));
    await db.monthDao.syncMonths();
  }

  Future deleteTransactionById(int id, {bool beforeInsert = false}) async {
    await (delete(transactions)..where((t) => t.originalId.equals(id))).go();
    if (!beforeInsert) await db.monthDao.syncMonths();
  }

  /// Returns a [Stream] with the savings up to the current month.
  /// The stream is updated every time the database is changed.
  Stream<double> watchTotalSavings() {
    int currentDate = getFirstDateOfMonthInMillis(DateTime.now());
    final savings = customSelectQuery(
            "SELECT IFNULL( (SELECT SUM(amount) FROM incomes "
            "WHERE date < $currentDate), 0) - "
            "IFNULL((SELECT SUM(amount) FROM expenses "
            "WHERE date < $currentDate), 0) AS savings",
            readsFrom: {transactions})
        .watchSingle()
        .map((row) => row.readDouble("savings"));
    return savings;
  }

  /// Returns a [Stream] that watches the transactions table.
  ///
  /// The stream is updated when ever the table changes.
  ///
  /// Input
  /// -----
  ///  - [TransactionFilterSettings] to filter the query results.
  ///
  Stream<List<TransactionsWithCategory>> watchTransactionsWithFilter(
      TransactionFilterSettings settings) {
    var txParser = new TransactionFilterParser(settings);

    final query2 = customSelectQuery(
        "SELECT * FROM transactions_with_categories t"
        "${txParser.parse(tableName: "t")} ORDER BY date DESC, id DESC",
        readsFrom: {transactions, subcategories});

    return query2.watch().map((rows) =>
        rows.map((row) => TransactionsWithCategory.fromQueryRow(row)).toList());
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
  Stream<double> watchMonthlyIncome(DateTime date) {
    final income = customSelectQuery(
            "SELECT IFNULL( (SELECT SUM(amount) FROM incomes "
            "WHERE month_id = (SELECT id FROM months "
            "WHERE first_date <= ${dayInMillis(date)} "
            "AND last_date >= ${dayInMillis(date)}) ), 0) AS income",
            readsFrom: {transactions, months})
        .watchSingle()
        .map((row) => row.readDouble("income"));

    return income;
  }

  /// Returns a [Stream] of summed up monthly expenses grouped and ordered by day.
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [Tuple2]s with date and summed up expenses.
  ///
  Stream<List<Tuple2<int, double>>> watchExpensesPerDayInMonth(
      DateTime dateInMonth) {
    final expenses =
        customSelectQuery("SELECT SUM(amount) as sumAmount, date FROM expenses "
                "WHERE month_id = (SELECT id FROM months "
                "WHERE first_date <= ${dayInMillis(dateInMonth)} "
                "AND last_date >= ${dayInMillis(dateInMonth)})"
                "GROUP BY date ORDER BY date")
            .watch()
            .map((r) => r
                .map((row) => Tuple2<int, double>(
                    row.readInt("date"), row.readDouble("sumAmount")))
                .toList());

    return expenses;
  }

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
  Stream<List<Tuple3<int, String, double>>> watchSumOfTransactionsByCategories(
      TransactionFilterSettings settings) {
    final parser = TransactionFilterParser(settings);

    final query = customSelectQuery(
        "SELECT SUM(t.amount) AS amount, c.id as category_id, c.name as category_name "
        "FROM transactions_with_categories t "
        "INNER JOIN categories c "
        "ON t.category_id = c.id "
        "${parser.parse(tableName: "t")} GROUP BY category_id",
        readsFrom: {
          transactions,
          subcategories,
          categories,
        });

    return query.watch().map((rows) => rows
        .map((row) => Tuple3<int, String, double>(row.readInt("category_id"),
            row.readString("category_name"), row.readDouble("amount")))
        .toList());
  }

  /// Returns the latest non-recurrence transaction.
  Stream<TransactionsWithCategory> watchLatestTransaction() {
    final query =
        customSelectQuery("SElECT * FROM transactions_with_categories t "
            "WHERE t.id = t.original_id ORDER BY t.id DESC LIMIT 1");

    return query
        .watchSingle()
        .map((row) => TransactionsWithCategory.fromQueryRow(row));
  }

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
  Stream<double> watchMonthlyBudget(DateTime date) {
    final budget = customSelectQuery(
            "SELECT IFNULL( (SELECT max_budget "
            "FROM months "
            "WHERE first_date <= ${dayInMillis(date)} "
            "AND last_date >= ${dayInMillis(date)}),0) - "
            "IFNULL( (SELECT SUM(amount) FROM expenses "
            "WHERE month_id = (SELECT id FROM months "
            "WHERE first_date <= ${dayInMillis(date)} "
            "AND last_date >= ${dayInMillis(date)}) ), 0) AS budget",
            readsFrom: {transactions, months})
        .watchSingle()
        .map((row) => row.readDouble("budget"));

    return budget;
  }

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
  Stream<double> watchDailyBudget(DateTime date) {
    int remainingDays = getRemainingDaysInMonth(date);

    String maxBudget = "(SELECT max_budget FROM months "
        "WHERE first_date <= ${dayInMillis(date)} "
        "AND last_date >= ${dayInMillis(date)})";
    String monthId = "(SELECT id FROM months "
        "WHERE first_date <= ${dayInMillis(date)} "
        "AND last_date >= ${dayInMillis(date)})";

    String monthlyExpenses = "(SELECT SUM(amount) FROM expenses "
        "WHERE month_id = $monthId "
        "AND NOT (date = ${dayInMillis(date)})"
        "AND (recurring_type = 1 OR is_recurring = 0))";
    String todayExpenses = "(SELECT SUM(amount) FROM expenses "
        "WHERE date = ${dayInMillis(date)} "
        "AND month_id = $monthId"
        "AND (recurring_type = 1 OR is_recurring = 0))";

    final dailyBudget = customSelectQuery(
            "SELECT (IFNULL($maxBudget, 0) - IFNULL($monthlyExpenses, 0)) "
            "/ $remainingDays - IFNULL( $todayExpenses, 0) AS budget",
            readsFrom: {transactions, months})
        .watchSingle()
        .map((row) => row.readDouble("budget"));

    return dailyBudget;
  }

  /// Returns all expenses of the last seven days grouped by date and summed up.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [Tuple2]s with a day's date in milliseconds since
  /// epoch and the sum of its expenses.
  Stream<List<Tuple2<int, double>>> watchLastWeeksTransactions() {
    // Set initial values.
    int millisPerDay = Duration.millisecondsPerDay;
    int currentDateInMillis = dayInMillis(DateTime.now());

    // Setup watch of last weeks transactions.
    final lastWeekQuery = customSelectQuery(
            "SELECT SUM(amount) AS amount, date FROM transactions "
            "WHERE is_expense = 1 "
            "AND date > ${currentDateInMillis - 7 * millisPerDay} "
            "GROUP BY date "
            "LIMIT 7",
            readsFrom: {transactions})
        .watch()
        .map((rows) => rows
            .map((row) => Tuple2<int, double>(
                row.readInt("date"), row.readDouble("amount")))
            .toList());

    return lastWeekQuery;
  }
}

/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_parser.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/recurrence_utils.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'transaction_dao.g.dart';

class TransactionWithCategory {
  final db_file.Transaction tx;
  final db_file.Subcategory sub;

  TransactionWithCategory({this.tx, this.sub});

  @override
  String toString() {
    return 'TransactionWithCategory{transaction: $tx, subcategory: $sub}';
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
    final maxTransactionID = await db.maxTransactionId();
    final nextId = (maxTransactionID ?? 0) + 1;
    var tempTx = tx.copyWith(originalId: nextId);

    // Fill in month id
    if (tempTx.monthId == null) {
      final int id = await db.monthDao.createOrGetMonth(tempTx.date);
      tempTx = tempTx.copyWith(monthId: id);
    }

    // Make sure that every transaction has its correct month id assigned.
    final List<Insertable<db_file.Transaction>> txs = [];

    if (tempTx.isRecurring) {
      final List<db_file.Transaction> recurrences = generateRecurrences(tempTx);
      for (final t in recurrences) {
        final id = await db.monthDao.createOrGetMonth(t.date);
        txs.add(t.copyWith(monthId: id ?? t.monthId).createCompanion(true));
      }
    }

    // Add all transactions to database in SQL-transaction.
    return transaction(() async {
      await into(transactions).insert(
        tempTx.createCompanion(true).copyWith(id: Value(nextId)),
      );

      if (tempTx.isRecurring) {
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
      final tempTx = db_file.Transaction(
          id: null,
          originalId: null,
          amount: tx.amount,
          monthId: tx.monthId,
          date: tx.date,
          subcategoryId: tx.subcategoryId,
          isExpense: tx.isExpense,
          isRecurring: tx.isRecurring,
          until: tx.until,
          recurrenceType: tx.recurrenceType);
      await insertTransaction(tempTx);
    });
    return db.monthDao.syncMonths();
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
    const converter = DateTimeConverter();
    final currentDate = converter.mapToSql(today().getFirstDateOfMonth());
    final savings = customSelectQuery(
            "SELECT IFNULL( (SELECT SUM(amount) FROM incomes "
            "WHERE date < '$currentDate'), 0) - "
            "IFNULL((SELECT SUM(amount) FROM expenses "
            "WHERE date < '$currentDate'), 0) AS savings",
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
  Stream<List<TransactionWithCategory>> watchTransactionsWithFilter(
      TransactionFilterSettings settings) {
    final txParser = TransactionFilterParser(settings);

    final query2 = customSelectQuery(
        "SELECT * FROM transactions_with_categories t"
        "${txParser.parse(tableName: "t")} ORDER BY date DESC, id DESC",
        readsFrom: {transactions, subcategories});

    return query2.map((row) {
      final tx = db_file.Transaction.fromData(row.data, db);
      final sub = Subcategory(
          id: row.readInt("subcategory_id"),
          name: row.readString("name"),
          categoryId: row.readInt("category_id"));
      return TransactionWithCategory(sub: sub, tx: tx);
    }).watch();
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
    const converter = DateTimeConverter();
    final income = customSelectQuery(
            "SELECT IFNULL( (SELECT SUM(amount) FROM incomes "
            "WHERE month_id = (SELECT id FROM months "
            "WHERE first_date <= '${converter.mapToSql(date)}' "
            "AND last_date >= '${converter.mapToSql(date)}') ), 0) AS income",
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
  Stream<List<Tuple2<DateTime, double>>> watchExpensesPerDayInMonth(
      DateTime dateInMonth) {
    const converter = DateTimeConverter();
    return customSelectQuery(
            "SELECT SUM(amount) as amount, date FROM expenses "
            "WHERE month_id = (SELECT id FROM months "
            "WHERE first_date <= '${converter.mapToSql(dateInMonth)}' "
            "AND last_date >= '${converter.mapToSql(dateInMonth)}')"
            "GROUP BY date ORDER BY date",
            readsFrom: {transactions})
        .watch()
        .map((r) => r
            .map((row) => Tuple2<DateTime, double>(
                converter.mapToDart(row.readString("date")),
                row.readDouble("amount")))
            .toList());
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

  /// Watches the latest non-recurrence transaction.
  Stream<TransactionWithCategory> watchLatestTransaction() {
    final query =
        customSelectQuery("SELECT * FROM transactions_with_categories t "
            "WHERE t.id = t.original_id ORDER BY t.id DESC LIMIT 1");

    return query.map((row) {
      final tx = db_file.Transaction.fromData(row.data, db);
      final sub = Subcategory(
          id: row.readInt("subcategory_id"),
          categoryId: row.readInt("category_id"),
          name: row.readString("name"));
      return TransactionWithCategory(tx: tx, sub: sub);
    }).watchSingle();
  }

  /// Watches the latest N non-recurrence transactions.
  Stream<List<TransactionWithCategory>> watchNLatestTransactions(int N) {
    final query = customSelectQuery(
        "SELECT * FROM transactions_with_categories t "
        "WHERE t.id = t.original_id ORDER BY t.id DESC LIMIT $N",
        readsFrom: {transactions});

    return query.map((row) {
      final tx = db_file.Transaction.fromData(row.data, db);
      final sub = Subcategory(
          id: row.readInt("subcategory_id"),
          categoryId: row.readInt("category_id"),
          name: row.readString("name"));
      return TransactionWithCategory(tx: tx, sub: sub);
    }).watch();
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
    const converter = DateTimeConverter();
    final budget = customSelectQuery(
            "SELECT IFNULL( (SELECT max_budget "
            "FROM months "
            "WHERE first_date <= '${converter.mapToSql(date)}' "
            "AND last_date >= '${converter.mapToSql(date)}'),0) - "
            "IFNULL( (SELECT SUM(amount) FROM expenses "
            "WHERE month_id = (SELECT id FROM months "
            "WHERE first_date <= '${converter.mapToSql(date)}' "
            "AND last_date >= '${converter.mapToSql(date)}') ), 0) AS budget",
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
    const converter = DateTimeConverter();
    final remainingDays = date.remainingDaysInMonth;

    final maxBudget = "(SELECT max_budget FROM months "
        "WHERE first_date <= '${converter.mapToSql(date)}' "
        "AND last_date >= '${converter.mapToSql(date)}')";
    final monthId = "(SELECT id FROM months "
        "WHERE first_date <= '${converter.mapToSql(date)}' "
        "AND last_date >= '${converter.mapToSql(date)}')";

    final monthlyExpenses = "(SELECT SUM(amount) FROM expenses "
        "WHERE month_id = $monthId "
        "AND NOT (date='${converter.mapToSql(date)}') "
        "AND (recurring_type = 1 OR is_recurring = 0))";
    final todayExpenses = "(SELECT SUM(amount) FROM expenses "
        "WHERE date = '${converter.mapToSql(date)}' "
        "AND month_id = $monthId "
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
  Stream<List<Tuple2<DateTime, double>>> watchLastWeeksTransactions() {
    // Get converter and compute date 7 days behind.
    const converter = DateTimeConverter();
    final dateLastWeek =
        converter.mapToSql(today().subtract(const Duration(days: 7)));

    // Setup watch of last weeks transactions.
    final lastWeekQuery = customSelectQuery(
            "SELECT SUM(amount) AS amount, date FROM transactions "
            "WHERE is_expense = 1 "
            "AND date > '$dateLastWeek' "
            "GROUP BY date "
            "LIMIT 7",
            readsFrom: {transactions})
        .watch()
        .map((rows) => rows
            .map((row) => Tuple2<DateTime, double>(
                converter.mapToDart(row.readString("date")),
                row.readDouble("amount")))
            .toList());

    return lastWeekQuery;
  }
}

/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/filters/filter_parser.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/recurrence_utils.dart';
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
}

@UseDao(tables: [Transactions, Subcategories, Months])
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
    List<int> countTransactions = await db.maxTransactionId();
    int nextId = (countTransactions?.first ?? 0) + 1;
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
        await into(transactions).insertAll(txs);
      }
    });
  }

  Future updateTransaction(db_file.Transaction transaction) async {
    print(transaction);
    // Fill in month id
    if (transaction.monthId == null) {
      int id = await db.monthDao.createOrGetMonth(transaction.date);
      transaction = transaction.copyWith(monthId: id);
    }

//    await update(transactions).replace(transaction.createCompanion(true));
    // TODO Revisit as soon as history is done
    await (update(transactions)
          ..where((t) => t.originalId.equals(transaction.originalId)))
        .write(transaction);
    await db.monthDao.syncMonths();
  }

  Future deleteTransaction(db_file.Transaction transaction) async {
    await delete(transactions).delete(transaction.createCompanion(true));
    await db.monthDao.syncMonths();
  }

  Future deleteTransactionById(int id) async {
    await (delete(transactions)..where((t) => t.originalId.equals(id))).go();
    await db.monthDao.syncMonths();
  }

  /// Returns a [Stream] that watches the database table. The stream is updated
  /// every time the database is changed.
  Stream<double> watchTotalSavings() {
    final savings = customSelectQuery(
            "SELECT (SELECT SUM(amount) FROM incomes) - "
            "(SELECT SUM(amount) FROM expenses) AS savings",
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
    FilterParser txParser = new TransactionFilterParser(settings);

//    print("SELECT * FROM transactions_with_categories "
//        "${txParser.parse()}");

    final query2 = customSelectQuery(
        "SELECT * FROM transactions_with_categories "
        "${txParser.parse()} ORDER BY date DESC, id DESC",
        readsFrom: {transactions, subcategories});

    return query2.watch().map((rows) => rows
        .map((row) => TransactionsWithCategory(
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
            date: row.readInt("date")))
        .toList());
  }
}

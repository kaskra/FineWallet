/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/resources/moor_queries.dart' as moor_queries;
import 'package:moor_flutter/moor_flutter.dart';

part 'transaction_dao.g.dart';

class TransactionsWithCategory {
  final double amount;
  final int date;
  final bool isExpense;
  final bool isRecurring;
  final int recurringUntil;
  final int subcategoryId;
  final String subcategoryName;
  final int categoryId;
  final int originalId;

  TransactionsWithCategory(
      {this.amount,
      this.date,
      this.isExpense,
      this.isRecurring,
      this.recurringUntil,
      this.subcategoryId,
      this.subcategoryName,
      this.originalId,
      this.categoryId});
}

@UseDao(tables: [Transactions, Subcategories])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;

  TransactionDao(this.db) : super(db);

  Future<List<db_file.Transaction>> getAllTransactions() =>
      select(transactions).get();

  // TODO rework insertion to account for recurring txs
  Future insertTransaction(Insertable<db_file.Transaction> transaction) =>
      into(transactions).insert(transaction);

  Future updateTransaction(Insertable<db_file.Transaction> transaction) =>
      update(transactions).replace(transaction);

  Future deleteTransaction(Insertable<db_file.Transaction> transaction) =>
      delete(transactions).delete(transaction);

  Stream<double> watchTotalSavings() {
    final savings = customSelectQuery(
            "SELECT (SELECT SUM(amount) FROM incomes) - "
            "(SELECT SUM(amount) FROM expenses) AS savings",
            readsFrom: {transactions})
        .watchSingle()
        .map((row) => row.readDouble("savings"));

    return savings;
  }

  Stream<List<TransactionsWithCategory>> watchTransactionsOfCategory(
      int categoryId) {

    // TODO test new impl
    final query2 = customSelectQuery(
        "SELECT * FROM transactions_with_categories t "
        "WHERE ${moor_queries.ofCategory("t", categoryId)}",
        //variables: [Variable.withInt(categoryId)],
        readsFrom: {transactions, subcategories});

    return query2.watch().map((rows) => rows
        .map((row) => TransactionsWithCategory(
            isExpense: row.readBool("is_expense"),
            subcategoryId: row.readInt("subcategory_id"),
            categoryId: row.readInt("category_id"),
            subcategoryName: row.readString("name"),
            amount: row.readDouble("amount"),
            isRecurring: row.readBool("is_recurring"),
            recurringUntil: row.readInt("recurring_until"),
            originalId: row.readInt("original_id"),
            date: row.readInt("date")))
        .toList());
  }
}

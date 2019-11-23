/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/resources/moor_initialization.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'transaction_dao.g.dart';

class TransactionsWithCategory {
  final double amount;
  final int date;
  final bool isExpense;
  final bool isRecurring;
  final int recurringUntil;
  final int recurringType;
  final int subcategoryId;
  final String subcategoryName;
  final int categoryId;

  TransactionsWithCategory(
      {this.amount,
      this.date,
      this.isExpense,
      this.isRecurring,
      this.recurringUntil,
      this.recurringType,
      this.subcategoryId,
      this.subcategoryName,
      this.categoryId});
}

@UseDao(tables: [Transactions, Subcategories])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;

  TransactionDao(this.db) : super(db);

  Future<List<db_file.Transaction>> getAllTransactions() =>
      select(transactions).get();

  Future insertTransaction(Insertable<db_file.Transaction> transaction) =>
      into(transactions).insert(transaction);

  Future updateTransaction(Insertable<db_file.Transaction> transaction) =>
      update(transactions).replace(transaction);

  Future deleteTransaction(Insertable<db_file.Transaction> transaction) =>
      delete(transactions).delete(transaction);

  Stream<double> watchTotalSavings() {
    final savings = customSelectQuery(
        "SELECT (SELECT SUM(amount) FROM transactions WHERE is_expense = 0) - "
        "(SELECT SUM(amount) FROM transactions WHERE is_expense = 1) AS savings",
        readsFrom: {
          transactions
        }).watchSingle().map((row) => row.readDouble("savings"));

    return savings;
  }

  Stream<List<TransactionsWithCategory>> watchTransactionsOfCategory(
      int categoryId) {
    // TODO implement database method to apply recurring txs
    final query2 = customSelectQuery(
        "SELECT * FROM transactions t "
        "INNER JOIN subcategories s "
        "ON s.id = t.subcategory_id "
        "WHERE s.category_id == ?",
        variables: [Variable.withInt(categoryId)],
        readsFrom: {transactions, subcategories});

    return query2.watch().map((rows) => rows
        .map((row) => TransactionsWithCategory(
            isExpense: row.readBool("is_expense"),
            subcategoryId: row.readInt("subcategory_id"),
            categoryId: row.readInt("category_id"),
            subcategoryName: row.readString("name"),
            amount: row.readDouble("amount"),
            isRecurring: row.readBool("is_recurring"),
            recurringType: row.readInt("recurring_type"),
            recurringUntil: row.readInt("recurring_until"),
            date: row.readInt("date")))
        .toList());
  }
}

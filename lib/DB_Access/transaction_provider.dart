/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/DB_Access/db_provider.dart';
import 'package:finewallet/DB_Access/transaction_list.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/utils.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsProvider {
  TransactionsProvider._();

  static final TransactionsProvider db = TransactionsProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await Provider.db.database;
    return _database;
  }

  Future<TransactionList> getAllTrans(int untilDay) async {
    final db = await Provider.db.database;
    String whereDay = "";
    if (untilDay != null) whereDay = " WHERE transactions.date <= $untilDay";
    var res = await db.rawQuery(
        "SELECT transactions.* , subcategories.name, subcategories.category "
        "FROM transactions "
        "LEFT JOIN subcategories "
        "ON transactions.subcategory = subcategories.id "
        "$whereDay "
        "ORDER BY transactions.date DESC, transactions.id DESC");
    TransactionList list = res.isNotEmpty
        ? toTransactionList(
            res.map((t) => TransactionModel.fromMap(t)).toList())
        : new TransactionList();
    list.addRecurringTransactions(untilDay);
    list.sortByDateNameDESC();
    list.removeWhere((tx) => tx.date > untilDay);
    return list;
  }

  Future<TransactionList> getTransactionsOfDay(int dayInMillis) async {
    TransactionList res = await getAllTrans(dayInMillis);
    return res.byDayInMillis(dayInMillis);
  }

  Future<TransactionList> getTransactionsByCategory(
      String categoryName, int untilDay) async {
    final db = await Provider.db.database;
    var table = await db.query("categories",
        columns: ["id"], where: "name = ?", whereArgs: [categoryName]);
    if (table.isEmpty) return new TransactionList();
    int id = table.first["id"];
    return (await getAllTrans(untilDay)).byCategory(id);
  }

  Future<List<SumOfTransactionModel>> getExpensesGroupedByDay(
      int untilDay) async {
    var res2 = await getAllTrans(untilDay);
    var res = res2.where((TransactionModel tx) => tx.isExpense == 1);

    List<SumOfTransactionModel> result = List();
    res.forEach((TransactionModel tx) {
      if (!result.contains(tx.date)) {
        result.add(SumOfTransactionModel(date: tx.date, amount: 0));
      }
    });

    result
        .map((SumOfTransactionModel s) => s.amount = res
            .where((tx) => tx.date == s.date)
            .fold(0.0, (prev, curr) => prev + curr.amount.toDouble()))
        .toList();
    return result;
  }

  Future<TransactionList> getTransactionsOfMonth(int dateInMonth) async {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateInMonth);

    int lastDay = getLastDayOfMonth(date);
    assert(lastDay <= 31 && lastDay >= 1);
    DateTime firstOfMonth = DateTime.utc(date.year, date.month, 1);
    DateTime lastOfMonth =
        DateTime.utc(date.year, date.month, lastDay, 23, 59, 59);

    var res = await getAllTrans(dayInMillis(lastOfMonth));
    return res.after(firstOfMonth);
  }
}

/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:36 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/db_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/utils.dart';

class TransactionsProvider {
  TransactionsProvider._();

  static final TransactionsProvider db = TransactionsProvider._();

  Future<TransactionList> getAllTrans(int untilDay) async {
    final db = await DatabaseProvider.db.database;
    String whereDay = "";
    if (untilDay != null) whereDay = " WHERE transactions.date <= $untilDay";
    var res = await db.rawQuery(
        "SELECT transactions.* , subcategories.name, subcategories.category "
        "FROM transactions "
        "LEFT JOIN subcategories "
        "ON transactions.subcategory = subcategories.id "
        "$whereDay "
        "ORDER BY transactions.date DESC, transactions.id DESC");
    if (res.isEmpty) return new TransactionList();

    TransactionList list =
        toTransactionList(res.map((t) => TransactionModel.fromMap(t)).toList())
            .addRecurringTransactions(untilDay)
            .sortByDateNameDESC()
            .removeWhere((tx) => tx.date > untilDay);
    return list;
  }

  Future<TransactionList> getTransactionsOfDay(int dayInMillis) async {
    TransactionList res = await getAllTrans(dayInMillis);
    return res.byDayInMillis(dayInMillis);
  }

  Future<TransactionList> getTransactionsByCategory(
      String categoryName, int untilDay) async {
    final db = await DatabaseProvider.db.database;
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
        result.add(
          SumOfTransactionModel(
              date: DateTime.fromMillisecondsSinceEpoch(tx.date), amount: 0),
        );
      }
    });

    result
        .map(
          (SumOfTransactionModel s) => s.amount = res
              .where((tx) => tx.date == s.date.millisecondsSinceEpoch)
              .fold(0.0, (prev, curr) => prev + curr.amount.toDouble()),
        )
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

  Future update(TransactionModel tx) async {
    await DatabaseProvider.db.updateTransaction(tx);
  }
}

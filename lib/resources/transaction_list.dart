/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:collection';

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/utils.dart';

TransactionList toTransactionList(List<TransactionModel> l) {
  TransactionList list = new TransactionList();
  list.addAll(l);
  return list;
}

class TransactionList extends ListBase<TransactionModel> {
  final List<TransactionModel> l = [];
  TransactionList();

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  TransactionModel operator [](int index) => l[index];
  operator []=(int index, TransactionModel value) {
    l[index] = value;
  }

  /// Returns the sum of all expense transactions.
  double sumExpenses() {
    return this
        .where((TransactionModel txn) => txn.isExpense == 1)
        .fold(0.0, (prev, next) => prev + next.amount);
  }

  /// Returns the sum of all income transactions.
  double sumIncomes() {
    return this
        .where((TransactionModel txn) => txn.isExpense == 0)
        .fold(0.0, (prev, next) => prev + next.amount);
  }

  /// Returns transactions by category [id].
  TransactionList byCategory(int id) {
    return this.where((TransactionModel txn) => id == txn.category);
  }

  /// Returns the transactions at day [dayInMillis].
  TransactionList byDayInMillis(int dayInMillis) {
    return this.where((TransactionModel tx) => tx.date == dayInMillis);
  }

  /// Returns transactions that are after [day].
  ///
  /// [day] is either [DateTime] or [int].
  TransactionList after(dynamic day) {
    assert(day is int || day is DateTime);

    if (day is int) {
      return this.where((TransactionModel tx) => tx.date >= day);
    }
    return this.where((TransactionModel tx) =>
        tx.date >= (day as DateTime).millisecondsSinceEpoch);
  }

  /// Adds the recurrent transactions to the list until [generateUntilDay].
  TransactionList addRecurringTransactions(int generateUntilDay) {
    TransactionList txs = TransactionList();
    l.where((element) => element.isRecurring == 1).forEach((tx) {
      int until = tx.replayUntil == null ? generateUntilDay : tx.replayUntil;
      int firstInterval = isRecurrencePossible(tx.date, until, tx.replayType);
      if (firstInterval != -1) {
        txs.addAll(_generateEveryRecurringTransaction(
            tx,
            tx.date,
            tx.replayUntil == null ? generateUntilDay : tx.replayUntil,
            firstInterval));
      }
    });
    l.addAll(txs);
    return toTransactionList(l);
  }

  List<TransactionModel> _generateEveryRecurringTransaction(
      TransactionModel tx, int currentDate, int untilDay, int interval) {
    List<TransactionModel> txs = List();
    for (int i = currentDate + interval; i <= untilDay; i += interval) {
      TransactionModel generatedTx = new TransactionModel(
          id: tx.id,
          subcategory: tx.subcategory,
          amount: tx.amount,
          date: i,
          isExpense: tx.isExpense,
          subcategoryName: tx.subcategoryName,
          category: tx.category,
          isRecurring: tx.isRecurring,
          replayType: tx.replayType,
          replayUntil: tx.replayUntil);
      txs.add(generatedTx);
      interval = replayTypeToMillis(tx.replayType, i);
    }
    return txs;
  }

  /// Sort transactions in list descending. First by date, then by name.
  TransactionList sortByDateNameDESC() {
    int sortTransactionsByDateName(TransactionModel txA, TransactionModel txB) {
      if (txA.date == txB.date) {
        if (txA.id == txB.id)
          return 0;
        else if (txA.id < txB.id)
          return -1;
        else
          return 1;
      } else if (txA.date < txB.date) {
        return -1;
      } else {
        return 1;
      }
    }

    l.sort((TransactionModel a, TransactionModel b) =>
        -sortTransactionsByDateName(a, b));
    return toTransactionList(l);
  }

  TransactionList removeWhere(bool Function(TransactionModel element) test) {
    l.removeWhere((TransactionModel txn) => test(txn));
    return toTransactionList(l);
  }

  TransactionList where(bool Function(TransactionModel element) test) {
    return toTransactionList(super.where(test).toList());
  }
}

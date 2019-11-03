/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:30 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/db_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/utils.dart';

class TransactionBloc {
  TransactionBloc({int untilDay}) {
    _untilDay = untilDay ?? dayInMillis(DateTime.now());
    getAllTransactions();
    getMonthlyTransactions(dateInMonth: _untilDay);
  }

  int _untilDay;

  final _allTransactionsController =
      StreamController<TransactionList>.broadcast();
  final _monthlyTransactionsController =
      StreamController<TransactionList>.broadcast();
  final _savingsController = StreamController<double>.broadcast();

  get allTransactions => _allTransactionsController.stream;

  get monthlyTransactions => _monthlyTransactionsController.stream;

  get savings => _savingsController.stream;

  void updateAllTransactions() async {
    getAllTransactions();
  }

  void dispose() {
    _allTransactionsController.close();
    _monthlyTransactionsController.close();
    _savingsController.close();
  }

  getAllTransactions() async {
    _allTransactionsController.sink
        .add(await TransactionsProvider.db.getAllTrans(_untilDay));
  }

  getMonthlyTransactions({int dateInMonth}) async {
    dateInMonth = dateInMonth ?? dayInMillis(DateTime.now());
    _monthlyTransactionsController.sink
        .add(await TransactionsProvider.db.getTransactionsOfMonth(dateInMonth));
  }

  add(TransactionModel tx) async {
    await DatabaseProvider.db.newTransaction(tx);
    await getAllTransactions();
  }

  delete(int id) async {
    await DatabaseProvider.db.deleteTransaction(id);
    await getAllTransactions();
  }

  updateTransaction(TransactionModel tx) async {
    await DatabaseProvider.db.updateTransaction(tx);
    await getAllTransactions();
  }

  getSavings() async {
    TransactionList transactions =
        await TransactionsProvider.db.getAllTrans(dayInMillis(DateTime.now()));
    transactions.retainWhere((tx) =>
        getFirstDateOfMonth(DateTime.fromMillisecondsSinceEpoch(tx.date)) !=
        getFirstDateOfMonth(DateTime.now()));
    double savings = transactions.sumIncomes() - transactions.sumExpenses();
    _savingsController.sink.add(savings);
  }
}

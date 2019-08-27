/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:async';

import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/resources/transaction_provider.dart';
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
  final _lastWeekTransactionsController = StreamController<List<SumOfTransactionModel>>.broadcast();

  get allTransactions => _allTransactionsController.stream;

  get monthlyTransactions => _monthlyTransactionsController.stream;

  get lastWeekTransactions => _lastWeekTransactionsController.stream;

  void updateAllTransactions() {
    getAllTransactions();
  }

  void dispose() {
    _allTransactionsController.close();
    _monthlyTransactionsController.close();
    _lastWeekTransactionsController.close();
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

  getLastWeekTransactions() async {
    List<SumOfTransactionModel> groupedExpenses = await TransactionsProvider.db
          .getExpensesGroupedByDay(dayInMillis(DateTime.now()));

    List<SumOfTransactionModel> resultingExpenses = [];

    for (DateTime date in getLastWeekAsDates()) {
      int index = groupedExpenses
          .indexWhere((s) => s.hasSameValue(dayInMillis(date)));
      if (index < 0){
        resultingExpenses.add(SumOfTransactionModel(date: date.weekday, amount: 0.0));
      }else {
        resultingExpenses.add(SumOfTransactionModel(date: date.weekday, amount: groupedExpenses[index].amount));
      }
    }
    _lastWeekTransactionsController.add(resultingExpenses);
  }

  add(TransactionModel tx) {
    DatabaseProvider.db.newTransaction(tx);
    getAllTransactions();
  }

  delete(int id) {
    DatabaseProvider.db.deleteTransaction(id);
    getAllTransactions();
  }

  updateTransaction(TransactionModel tx) {
    DatabaseProvider.db.updateTransaction(tx);
    getAllTransactions();
  }
}


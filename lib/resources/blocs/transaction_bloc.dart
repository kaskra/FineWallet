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
  }

  int _untilDay;

  final _allTransactionsController =
      StreamController<TransactionList>.broadcast();
  final _monthlyTransactionsController =
      StreamController<TransactionList>.broadcast();

  get allTransactions => _allTransactionsController.stream;

  get monthlyTransactions => _monthlyTransactionsController.stream;

  void updateAllTransactions() {
    getAllTransactions();
  }

  void dispose() {
    _allTransactionsController.close();
    _monthlyTransactionsController.close();
  }

  getAllTransactions() async {
    _allTransactionsController.sink
        .add(await TransactionsProvider.db.getAllTrans(_untilDay));
  }

  getMonthlyTransactions(int dateInMonth) async {
    _monthlyTransactionsController.sink
        .add(await TransactionsProvider.db.getTransactionsOfMonth(dateInMonth));
  }

  add(TransactionModel tx) {
    Provider.db.newTransaction(tx);
    getAllTransactions();
  }

  delete(int id) {
    Provider.db.deleteTransaction(id);
    getAllTransactions();
  }

  updateTransaction(TransactionModel tx) {
    Provider.db.updateTransaction(tx);
    getAllTransactions();
  }
}

/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:async';

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';

class TransactionBloc {
  final _transactionController =
      StreamController<List<TransactionModel>>.broadcast();

  int _untilDay;

  get transactions => _transactionController.stream;

  void dispose() {
    _transactionController.close();
  }

  getTransactions() async {
    _transactionController.sink
        .add(await DBProvider.db.getAllTransactions(_untilDay));
  }

  TransactionBloc([int untilDay]) {
    _untilDay = untilDay;
    getTransactions();
  }

  add(TransactionModel tx) {
    DBProvider.db.newTransaction(tx);
    getTransactions();
  }

  delete(int id) {
    DBProvider.db.deleteTransaction(id);
    getTransactions();
  }
}

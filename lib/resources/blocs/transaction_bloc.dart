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

class TransactionBloc {
  final _transactionController = StreamController<TransactionList>.broadcast();

  int _untilDay;

  get transactions => _transactionController.stream;

  void update() {
    getTransactions();
  }

  void dispose() {
    _transactionController.close();
  }

  getTransactions() async {
    _transactionController.sink
        .add(await TransactionsProvider.db.getAllTrans(_untilDay));
  }

  TransactionBloc(int untilDay) {
    _untilDay = untilDay;
    getTransactions();
  }

  add(TransactionModel tx) {
    Provider.db.newTransaction(tx);
    getTransactions();
  }

  delete(int id) {
    Provider.db.deleteTransaction(id);
    getTransactions();
  }

  updateTransaction(TransactionModel tx) {
    Provider.db.updateTransaction(tx);
    getTransactions();
  }
}

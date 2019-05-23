import 'dart:async';

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';

class TransactionBloc {
  final _transactionController = StreamController<List<TransactionModel>>.broadcast();

  get transactions => _transactionController.stream;

  void dispose() { 
    _transactionController.close();
  }

  getTransactions() async{
    _transactionController.sink.add(await DBProvider.db.getAllTransactions());
  }

  TransactionBloc (){
    getTransactions();
  }

  add(TransactionModel tx){
    DBProvider.db.newTransaction(tx);
    getTransactions();
  }

  delete(int id){
    DBProvider.db.deleteTransaction(id);
    getTransactions();
  }

}

class TransactionGroupedBloc {
  final _transactionController = StreamController<List<TransactionModel>>.broadcast();

  get transactions => _transactionController.stream;

  void dispose() { 
    _transactionController.close();
  }

  getClients() async{
    _transactionController.sink.add(await DBProvider.db.getExpensesGroupedByDay());
  }

  TransactionGroupedBloc (){
    getClients();
  }

  add(TransactionModel tx){
    DBProvider.db.newTransaction(tx);
    getClients();
  }

  delete(int id){
    DBProvider.db.deleteTransaction(id);
    getClients();
  }

}
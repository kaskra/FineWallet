/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/utils.dart';

List<TransactionModel> getRecurringTransactions(
    List<TransactionModel> queryResult, int generateUntilDay) {
  List<TransactionModel> txs = List();
  List<TransactionModel> res = queryResult;
  res = res.where((element) => element.isRecurring == 1).toList();
  res.forEach((tx) {
    int until = tx.replayUntil == null ? generateUntilDay : tx.replayUntil;
    int firstInterval = isRecurrencePossible(tx.date, until, tx.replayType);
    if (firstInterval != -1) {
      txs.addAll(generateEveryRecurringTransaction(
          tx,
          tx.date,
          tx.replayUntil == null ? generateUntilDay : tx.replayUntil,
          firstInterval));
    }
  });
  return txs;
}

List<TransactionModel> generateEveryRecurringTransaction(
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

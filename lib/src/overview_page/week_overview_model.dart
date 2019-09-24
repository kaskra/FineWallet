/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:51 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/src/base_model.dart';
import 'package:FineWallet/utils.dart';

class WeekOverviewModel extends BaseModel {
  List<SumOfTransactionModel> expenses = [];

  Future updateExpenseList() async {
    setBusy(true);

    List<SumOfTransactionModel> groupedExpenses = await TransactionsProvider.db
        .getExpensesGroupedByDay(dayInMillis(DateTime.now()));

    List<SumOfTransactionModel> resultingExpenses = [];

    for (DateTime date in getLastWeekAsDates()) {
      int index = groupedExpenses.indexWhere((s) => s.hasSameValue(date));

      if (index < 0) {
        resultingExpenses.add(
          SumOfTransactionModel(
            date: date,
            amount: 0.0,
          ),
        );
      } else {
        resultingExpenses.add(
          SumOfTransactionModel(
            date: date,
            amount: groupedExpenses[index].amount,
          ),
        );
      }
    }
    expenses = resultingExpenses;
    setBusy(false);
  }
}

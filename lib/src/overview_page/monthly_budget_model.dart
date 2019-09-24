/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:32:07 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/src/base_model.dart';
import 'package:FineWallet/utils.dart';

class MonthlyBudgetViewModel extends BaseModel {
  double budget = 0;

  void updateBudget() async {
    setBusy(true);

    TransactionList list = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();
    double currentSavings = await MonthProvider.db.getAllSavings();
    double currentMaxBudget = currentMonth?.currentMaxBudget ?? 0;

    budget = currentMaxBudget + currentSavings - list.sumExpenses();
    setBusy(false);
  }
}

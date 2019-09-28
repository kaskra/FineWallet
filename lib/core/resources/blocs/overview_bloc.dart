/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 10:34:51 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/utils.dart';

class OverviewBloc {
  final _dailyBudgetController = StreamController<double>.broadcast();
  final _lastWeekTransactionsController =
      StreamController<List<SumOfTransactionModel>>.broadcast();
  final _monthlyBudgetController = StreamController<double>.broadcast();

  get lastWeekTransactions => _lastWeekTransactionsController.stream;

  get dailyBudget => _dailyBudgetController.stream;

  get monthlyBudget => _monthlyBudgetController.stream;

  void dispose() {
    _dailyBudgetController.close();
    _monthlyBudgetController.close();
    _lastWeekTransactionsController.close();
  }

  getMonthlyBudget() async {
    TransactionList list = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();
    double currentMaxBudget = currentMonth?.currentMaxBudget ?? 0;

    double monthlySpareBudget = currentMaxBudget - list.sumExpenses();
    _monthlyBudgetController.sink.add(monthlySpareBudget);
  }

  getDailyBudget() async {
    TransactionList list = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();
    double currentMaxBudget = currentMonth?.currentMaxBudget ?? 0;

    int remainingDaysInMonth = getRemainingDaysInMonth();

    double monthlyExpenses = list.exceptDate(DateTime.now()).sumExpenses();

    double expensesToday =
        list.byDayInMillis(dayInMillis(DateTime.now())).sumExpenses();

    double monthlySpareBudget = currentMaxBudget - monthlyExpenses;

    double budgetPerDay =
        (monthlySpareBudget / remainingDaysInMonth) - expensesToday;
    _dailyBudgetController.sink.add(budgetPerDay);
  }

  getLastWeekTransactions() async {
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
    _lastWeekTransactionsController.add(resultingExpenses);
  }
}

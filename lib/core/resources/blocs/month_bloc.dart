/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:24 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/db_provider.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/utils.dart';

class MonthBloc {
  MonthBloc() {
    syncMonths();
  }

  final _allMonthController = StreamController<List<MonthModel>>.broadcast();
  final _currentMonthController = StreamController<MonthModel>.broadcast();

  get currentMonth => _currentMonthController.stream;

  get allMonths => _allMonthController.stream;

  void dispose() {
    _currentMonthController.close();
    _allMonthController.close();
  }

  getCurrentMonth() async {
    _currentMonthController.sink.add(await MonthProvider.db.getCurrentMonth());
  }

  getMonths() async {
    _allMonthController.sink.add(await MonthProvider.db.getAllRecordedMonths());
  }

  add(MonthModel month) async {
    await DatabaseProvider.db.newMonth(month);
    await syncMonths();
  }

  updateMonth(MonthModel month) async {
    await DatabaseProvider.db.updateMonth(month);
    await syncMonths();
  }

  syncMonths() async {
    TransactionList transactions =
        await TransactionsProvider.db.getAllTrans(dayInMillis(DateTime.now()));
    List<int> ids = getAllMonthIds(transactions);

    // Add current month id, even if no transaction was done yet
    if (!ids.contains(getFirstDateOfMonth(DateTime.now()))) {
      ids.add(getFirstDateOfMonthInMillis(DateTime.now()));
    }

    List<MonthModel> allMonths = await MonthProvider.db.getAllRecordedMonths();
    List<int> recordedMonthIds =
        allMonths.map((m) => m.firstDayOfMonth).toList();

    for (int i in ids) {
      if (recordedMonthIds.contains(i)) {
        MonthModel currentMonth =
            allMonths.firstWhere((m) => m.firstDayOfMonth == i);

        TransactionList transactionsOfMonth =
            await TransactionsProvider.db.getTransactionsOfMonth(i);

        // Update monthly expenses and savings.
        currentMonth.monthlyExpenses = transactionsOfMonth.sumExpenses();
        currentMonth.savings =
            transactionsOfMonth.sumIncomes() - currentMonth.monthlyExpenses;

        // Check whether max budget is below monthly incomes.
        // Set max budget to max budget possible.
        if (transactionsOfMonth.sumIncomes() < currentMonth.currentMaxBudget) {
          currentMonth.currentMaxBudget = transactionsOfMonth.sumIncomes();
        }

        // Update month
        MonthProvider.db.updateMonth(currentMonth);
      } else {
        MonthModel current = new MonthModel(
          currentMaxBudget: 0,
          monthlyExpenses: 0,
          savings: 0,
          firstDayOfMonth: i,
        );
        DatabaseProvider.db.newMonth(current);
      }
    }

    // Reset every month that has no transactions left
    // TODO integrate above?
    allMonths.removeWhere((month) => ids.contains(month.firstDayOfMonth));
    for (MonthModel m in allMonths) {
      m.reset();
      MonthProvider.db.updateMonth(m);
    }

    await getCurrentMonth();
    await getMonths();
  }
}

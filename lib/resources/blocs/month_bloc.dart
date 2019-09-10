import 'dart:async';

import 'package:FineWallet/models/month_model.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/month_provider.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/resources/transaction_provider.dart';
import 'package:FineWallet/utils.dart';

class MonthBloc {
  MonthBloc() {
    syncMonths();
  }

  final _allMonthController = StreamController<List<MonthModel>>.broadcast();
  final _currentMonthController = StreamController<MonthModel>.broadcast();
  final _savingsController = StreamController<double>.broadcast();
  final _budgetOverviewController = StreamController<Map<String, double>>.broadcast();

  get currentMonth => _currentMonthController.stream;

  get allMonths => _allMonthController.stream;

  get savings => _savingsController.stream;

  get budgetOverview => _budgetOverviewController.stream;

  void dispose() {
    _currentMonthController.close();
    _allMonthController.close();
    _savingsController.close();
    _budgetOverviewController.close();
  }

  getCurrentMonth() async {
    _currentMonthController.sink.add(await MonthProvider.db.getCurrentMonth());
  }

  getMonths() async {
    _allMonthController.sink.add(await MonthProvider.db.getAllRecordedMonths());
  }

  getSavings() async {
    double x = await MonthProvider.db.getAllSavings();
    _savingsController.sink.add(x);
  }

  add(MonthModel month) {
    DatabaseProvider.db.newMonth(month);
    syncMonths();
  }

  updateMonth(MonthModel month) {
    DatabaseProvider.db.updateMonth(month);
    syncMonths();
  }

  syncMonths() async {
    TransactionList transactions = await TransactionsProvider.db.getAllTrans(dayInMillis(DateTime.now()));
    List<int> ids = getAllMonthIds(transactions);
    
    List<MonthModel> allMonths = await MonthProvider.db.getAllRecordedMonths();
    List<int> recordedMonthIds = allMonths.map((m) => m.firstDayOfMonth).toList();

    for (int i in ids){
      if (recordedMonthIds.contains(i)){
        MonthModel currentMonth = allMonths.firstWhere((m) => m.firstDayOfMonth == i);
        TransactionList transactionsOfMonth = await TransactionsProvider.db.getTransactionsOfMonth(i);
        currentMonth.monthlyExpenses = transactionsOfMonth.sumExpenses();
        currentMonth.savings = transactionsOfMonth.sumIncomes() - currentMonth.monthlyExpenses;
        MonthProvider.db.updateMonth(currentMonth);
      }else {
        MonthModel current = new MonthModel(
          currentMaxBudget: 0,
          monthlyExpenses: 0,
          savings: 0,
          firstDayOfMonth: i,
        );
        add(current);
      }
    }

    // Reset every month that has no transactions left
    // TODO integrate above?
    allMonths.removeWhere((month) => ids.contains(month.firstDayOfMonth));
    for (MonthModel m in allMonths) {
      m.reset();
      MonthProvider.db.updateMonth(m);
    }


    getCurrentMonth();
    getMonths();
    getSavings();
    getBudgetOverview();
  }

  /// Calculate the budget for the current day as well as the spare budget for the month.
  /// 
  /// Add the Map to the budgetOverview stream.
  getBudgetOverview() async {
    TransactionList list = await TransactionsProvider.db.getTransactionsOfMonth(dayInMillis(DateTime.now()));
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();
    double currentMaxBudget = currentMonth != null ? currentMonth.currentMaxBudget : 0;

    int remainingDaysInMonth =
        getLastDayOfMonth(DateTime.now()) - DateTime.now().day + 1;

    double monthlyExpenses = list
        .exceptDate(DateTime.now())
        .sumExpenses();

    double expensesToday = list
        .byDayInMillis(dayInMillis(DateTime.now()))
        .sumExpenses();

    double monthlySpareBudget = currentMaxBudget - monthlyExpenses;

    double budgetPerDay =
        (monthlySpareBudget / remainingDaysInMonth) - expensesToday;

    _budgetOverviewController.sink.add({
      'dayBudget': budgetPerDay,
      'monthSpareBudget': monthlySpareBudget - expensesToday,
    });
  }

}
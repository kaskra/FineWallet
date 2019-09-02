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

  get currentMonth => _currentMonthController.stream;

  get allMonths => _allMonthController.stream;

  get savings => _savingsController.stream;

  void dispose() {
    _currentMonthController.close();
    _allMonthController.close();
    _savingsController.close();
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
    
    
    print("ids: $ids");
    print("recorded ids: $recordedMonthIds");
    allMonths.forEach((m) => print(m.toMap()));

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
    print(allMonths);

    for (MonthModel m in allMonths) {
      print(m.id);
      m.reset();
      MonthProvider.db.updateMonth(m);
    }


    getCurrentMonth();
    getMonths();
    getSavings();
  }
}
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

  add(MonthModel month) {
    DatabaseProvider.db.newMonth(month);
    getCurrentMonth();
    getMonths();
  }

  updateMonth(MonthModel month) {
    DatabaseProvider.db.updateMonth(month);
    getCurrentMonth();
    getMonths();
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

    getCurrentMonth();
    getMonths();
  }
}

import 'dart:async';

import 'package:FineWallet/models/month_model.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/month_provider.dart';

class MonthBloc {
  MonthBloc();

  final _allMonthController = StreamController<List<MonthModel>>.broadcast();
  final _currentMonthController = StreamController<MonthModel>.broadcast();

  get _currentMonth => _currentMonthController.stream;

  get _allMonths => _allMonthController.stream;

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
}

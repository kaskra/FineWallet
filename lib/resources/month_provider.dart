/*
 * Developed by Lukas Krauch 27.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/month_model.dart';
import 'package:finewallet/resources/db_provider.dart';
import 'package:finewallet/utils.dart' as utils;
import 'package:finewallet/utils.dart';

class MonthProvider {
  MonthProvider._();

  static final MonthProvider db = MonthProvider._();

  Future<MonthModel> getMonth(dynamic dayInMonth) async {
    assert(dayInMonth is int || dayInMonth is DateTime);
    DateTime firstOfMonth;
    int dayInMillis = -1;
    if (dayInMonth is int) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dayInMillis);
      firstOfMonth = DateTime(date.year, date.month, 1);
    } else {
      firstOfMonth = DateTime(
          (dayInMonth as DateTime).year, (dayInMonth as DateTime).month, 1);
    }
    dayInMillis = utils.dayInMillis(firstOfMonth);

    var res = await Provider.db.findMonth(dayInMillis);

    if (res.isEmpty) return null;
    return MonthModel.fromMap(res.first);
  }

  Future<List<MonthModel>> getAllRecordedMonths() async {
    var db = await Provider.db.database;
    List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM months");
    if (res.isEmpty) return [];
    List<MonthModel> list = res
        .map((Map<String, dynamic> json) => MonthModel.fromMap(json))
        .toList();
    return list;
  }

  Future<int> amountRecordedMonths() async {
    List<MonthModel> list = await getAllRecordedMonths();
    return list.length;
  }

  Future<MonthModel> getCurrentMonth() async {
    return await getMonth(DateTime.now());
  }

  updateCurrentMonth(
      num currentMaxBudget, num savings, num monthlyExpenses) async {
    MonthModel monthEntity = MonthModel(
        firstDayOfMonth:
            dayInMillis(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        currentMaxBudget: currentMaxBudget,
        savings: savings,
        monthlyExpenses: monthlyExpenses);
    updateMonth(monthEntity);
  }

  updateMonth(MonthModel monthModelEntity) async {
    var db = await Provider.db.database;
    db.update("months", monthModelEntity.toMap(),
        where: "firstOfMonth = ?",
        whereArgs: [monthModelEntity.firstDayOfMonth]);
  }
}

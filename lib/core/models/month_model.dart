/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';

MonthModel monthFromJson(String str) {
  final jsonData = json.decode(str);
  return MonthModel.fromMap(jsonData);
}

String monthToJson(MonthModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class MonthModel {
  int id;
  num savings;
  num currentMaxBudget;
  int firstDayOfMonth;
  num monthlyExpenses;

  MonthModel(
      {this.id,
      @required this.savings,
      @required this.currentMaxBudget,
      @required this.firstDayOfMonth,
      @required this.monthlyExpenses});

  factory MonthModel.fromMap(Map<String, dynamic> json) => new MonthModel(
        id: json["id"],
        savings: json["savings"],
        currentMaxBudget: json["currentMaxBudget"],
        firstDayOfMonth: json["firstOfMonth"],
        monthlyExpenses: json["monthlyExpenses"],
      );

  reset() {
    currentMaxBudget = 0;
    savings = 0;
    monthlyExpenses = 0;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "savings": savings,
        "currentMaxBudget": currentMaxBudget,
        "firstOfMonth": firstDayOfMonth,
        "monthlyExpenses": monthlyExpenses
      };
}

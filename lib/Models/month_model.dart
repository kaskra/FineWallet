/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
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
  double savings;
  double currentMaxBudget;
  int firstDayOfMonth;

  MonthModel(
      {this.id,
      @required this.savings,
      @required this.currentMaxBudget,
      @required this.firstDayOfMonth});

  factory MonthModel.fromMap(Map<String, dynamic> json) => new MonthModel(
        id: json["id"],
        savings: json["savings"],
        currentMaxBudget: json["currentMaxBudget"],
        firstDayOfMonth: json["firstOfMonth"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "savings": savings,
        "currentMaxBudget": currentMaxBudget,
        "firstOfMonth": firstDayOfMonth,
      };
}

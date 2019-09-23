/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:37 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:convert';

TransactionModel transactionFromJson(String str) {
  final jsonData = json.decode(str);
  return TransactionModel.fromMap(jsonData);
}

String transactionToJson(TransactionModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class TransactionModel {
  int id;
  int subcategory;
  num amount;
  int date;
  int isExpense;
  int isRecurring;
  int replayType;
  int replayUntil;

  String subcategoryName;
  int category;

  TransactionModel(
      {this.id,
      this.subcategory,
      this.amount,
      this.date,
      this.isExpense,
      this.subcategoryName,
      this.category,
      this.isRecurring,
      this.replayType,
      this.replayUntil});

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      new TransactionModel(
          id: json["id"],
          subcategory: json["subcategory"],
          amount: json["amount"],
          date: json["date"],
          isExpense: json["isExpense"],
          subcategoryName: json["name"],
          category: json["category"],
          isRecurring: json["isRecurring"],
          replayType: json["replayType"],
          replayUntil: json["replayUntil"]);

  Map<String, dynamic> toMap() => {
        "id": id != null ? id : null,
        "subcategory": subcategory,
        "amount": amount,
        "date": date,
        "isExpense": isExpense,
        "isRecurring": isRecurring,
        "replayType": replayType,
        "replayUntil": replayUntil,
      };
}

class SumOfTransactionModel {
  int weekday;
  num amount;
  DateTime date;

  SumOfTransactionModel({this.amount, this.date}) : this.weekday = date.weekday;

  factory SumOfTransactionModel.fromMap(Map<String, dynamic> json) =>
      new SumOfTransactionModel(
        amount: json["amount"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "date": date,
        "weekday": date.weekday,
      };

  bool hasSameValue(dynamic v) {
    if (v is DateTime) {
      return date.difference(v) < Duration(hours: 24);
    } else if (v is double) {
      return amount == v;
    } else
      return false;
  }
}

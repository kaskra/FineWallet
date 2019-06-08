/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
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

  String subcategoryName;
  int category;

  TransactionModel(
      {this.id,
      this.subcategory,
      this.amount,
      this.date,
      this.isExpense,
      this.subcategoryName,
      this.category});

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      new TransactionModel(
          id: json["id"],
          subcategory: json["subcategory"],
          amount: json["amount"],
          date: json["date"],
          isExpense: json["isExpense"],
          subcategoryName: json["name"],
          category: json["category"]);

  Map<String, dynamic> toMap() => {
        "id": id != null ? id : null,
        "subcategory": subcategory,
        "amount": amount,
        "date": date,
        "isExpense": isExpense,
      };
}

class SumOfTransactionModel {
  int date;
  num amount;

  SumOfTransactionModel({this.amount, this.date});

  factory SumOfTransactionModel.fromMap(Map<String, dynamic> json) =>
      new SumOfTransactionModel(
        amount: json["amount"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "date": date,
      };

  bool hasSameValue(dynamic v) {
    return date == v || amount == v;
  }
}

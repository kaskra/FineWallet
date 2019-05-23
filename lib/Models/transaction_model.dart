import 'dart:convert';

TransactionModel transactionFromJson(String str){
  final jsonData = json.decode(str);
  return TransactionModel.fromMap(jsonData);
}

String transactionToJson(TransactionModel data){
  final dyn = data.toMap();
  return json.encode(dyn);
}


class TransactionModel{
  int id;
  int subcategory;
  num amount;
  int date;
  int isExpense;

  TransactionModel({this.id, this.subcategory, this.amount, this.date, this.isExpense});

  factory TransactionModel.fromMap(Map<String, dynamic> json) => new TransactionModel(
    id: json["id"],
    subcategory: json["subcategory"],
    amount: json["amount"],
    date: json["date"],
    isExpense: json["isExpense"]
  );

  Map<String, dynamic> toMap() => {
    "id": id != null? id : null,
    "subcategory": subcategory,
    "amount": amount,
    "date": date,
    "isExpense": isExpense
  };


}


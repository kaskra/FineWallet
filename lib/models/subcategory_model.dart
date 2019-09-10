/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:29 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:convert';

SubcategoryModel categoryFromJson(String str) {
  final jsonData = json.decode(str);
  return SubcategoryModel.fromMap(jsonData);
}

String categoryToJson(SubcategoryModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class SubcategoryModel {
  int id;
  String name;
  int category;

  SubcategoryModel({this.id, this.name, this.category});

  factory SubcategoryModel.fromMap(Map<String, dynamic> json) =>
      new SubcategoryModel(
        id: json["id"],
        name: json["name"],
        category: json["category"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
      };
}

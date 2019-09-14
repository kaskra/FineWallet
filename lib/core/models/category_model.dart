/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:16 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:convert';

CategoryModel categoryFromJson(String str) {
  final jsonData = json.decode(str);
  return CategoryModel.fromMap(jsonData);
}

String categoryToJson(CategoryModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class CategoryModel {
  int id;
  String name;

  CategoryModel({this.id, this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> json) => new CategoryModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

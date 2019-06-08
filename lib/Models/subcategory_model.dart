/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
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

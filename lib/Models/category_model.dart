/*
 * Developed by Lukas Krauch 08.06.19 11:44.
 * Copyright (c) 2019. All rights reserved.
 *
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

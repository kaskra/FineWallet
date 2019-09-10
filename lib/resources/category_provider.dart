/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:48 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/models/category_model.dart';
import 'package:FineWallet/models/subcategory_model.dart';
import 'package:FineWallet/resources/category_list.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/subcategory_list.dart';

class CategoryProvider {
  CategoryProvider._();

  static final CategoryProvider db = CategoryProvider._();

  Future<CategoryList> getAllCategories({bool isExpense}) async {
    final db = await DatabaseProvider.db.database;
    var res = await db.query("categories");

    if (res.isEmpty) return new CategoryList();

    CategoryList list =
        toCategoryList(res.map((c) => CategoryModel.fromMap(c)).toList());

    if (isExpense != null) {
      if (isExpense)
        return list
            .where((CategoryModel category) => category.name != "Income");
      return list.where((CategoryModel category) => category.name == "Income");
    }

    return list;
  }

  Future<SubcategoryList> getSubcategories([int categoryId]) async {
    final db = await DatabaseProvider.db.database;
    List res = [];
    if (categoryId != null) {
      res = await db.query("subcategories",
          where: "category = ?", whereArgs: [categoryId]);
    } else {
      res = await db.query("subcategories");
    }

    if (res.isEmpty) return new SubcategoryList();

    SubcategoryList list =
        toSubcategoryList(res.map((c) => SubcategoryModel.fromMap(c)).toList());
    return list;
  }

  Future<int> indexOf(int subcategoryId) async {
    final db = await DatabaseProvider.db.database;
    var c = await db.query("subcategories",
        columns: ["category"], where: "id=?", whereArgs: [subcategoryId]);
    if (c.isEmpty) return null;
    int category = c.first["category"];

    var res = await db.rawQuery(
        "SELECT COUNT(*) as count FROM subcategories WHERE category < $category");
    return res.first["count"];
  }
}

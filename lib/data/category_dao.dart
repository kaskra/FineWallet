/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:27 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'category_dao.g.dart';

class CategoryWithSubs {
  final Insertable<Category> category;
  final List<Insertable<Subcategory>> subcategories;

  CategoryWithSubs(this.category, this.subcategories);
}

@UseDao(tables: [Categories, Subcategories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final AppDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<List<Category>> getAllCategoriesByType(bool isExpense) =>
      (select(categories)..where((c) => c.isExpense.equals(isExpense))).get();

  Stream<List<Category>> watchAllCategoriesByType(bool isExpense) =>
      (select(categories)..where((c) => c.isExpense.equals(isExpense))).watch();

  Future insertCategory(Insertable<Category> category) =>
      into(categories).insert(category);

  Future updateCategory(Insertable<Category> category) =>
      update(categories).replace(category);

  Future deleteCategory(Insertable<Category> category) =>
      delete(categories).delete(category);

  Future<List<Subcategory>> getAllSubcategories() =>
      select(subcategories).get();

  Future<List<Subcategory>> getAllSubcategoriesOf(int id) =>
      (select(subcategories)..where((s) => s.categoryId.equals(id))).get();

  Future insertSubcategory(Insertable<Subcategory> subcategory) =>
      into(subcategories).insert(subcategory);

  Future updateSubcategory(Insertable<Subcategory> subcategory) =>
      update(subcategories).replace(subcategory);

  Future deleteSubcategory(Insertable<Subcategory> subcategory) =>
      delete(subcategories).delete(subcategory);

  Future<void> insertCategoryWithSubs(CategoryWithSubs catWithSubs) {
    return transaction(() async {
      await into(categories).insert(catWithSubs.category, orReplace: true);
      await batch((b) {
        b.insertAll(subcategories, catWithSubs.subcategories,
            mode: InsertMode.insertOrReplace);
      });
    });
  }
}

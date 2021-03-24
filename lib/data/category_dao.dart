/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:27 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:moor/moor.dart';

part 'category_dao.g.dart';

class CategoryWithSubs {
  final Insertable<Category> category;
  final List<Insertable<Subcategory>> subcategories;

  CategoryWithSubs(this.category, this.subcategories);
}

@UseDao(
  tables: [
    Categories,
    Subcategories,
  ],
  include: {
    "moor_files/category_queries.moor",
  },
)
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final AppDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() => allCategories().get();

  Future<List<Category>> getAllCategoriesByType({@required bool isExpense}) =>
      categoriesByType(isExpense).get();

  Stream<List<Category>> watchAllCategoriesByType({@required bool isExpense}) =>
      categoriesByType(isExpense).watch();

  Future insertCategory(Insertable<Category> category) =>
      into(categories).insert(category);

  Future updateCategory(Insertable<Category> category) =>
      update(categories).replace(category);

  Future deleteCategory(Insertable<Category> category) =>
      delete(categories).delete(category);

  Future deleteCategoryWithSubcategories(int id) {
    return transaction(() async {
      // await (delete(subcategories)..where((s) => s.categoryId.equals(id))).go();
      deleteCustomCategory(id);
    });
  }

  Future<List<Subcategory>> getAllSubcategories() => allSubcategories().get();

  Future<List<Subcategory>> getAllSubcategoriesOf(int id) =>
      allSubcategoriesOfCategory(id).get();

  Stream<List<Subcategory>> watchAllSubcategoriesOf(int id) =>
      allSubcategoriesOfCategory(id).watch();

  Stream<List<Subcategory>> watchAllSubcategories() =>
      allSubcategories().watch();

  Future insertSubcategory(Insertable<Subcategory> subcategory) =>
      into(subcategories).insert(subcategory);

  Future updateSubcategory(Insertable<Subcategory> subcategory) =>
      update(subcategories).replace(subcategory);

  Future deleteSubcategory(Insertable<Subcategory> subcategory) =>
      delete(subcategories).delete(subcategory);

  Future<void> insertCategoryWithSubs(CategoryWithSubs catWithSubs) {
    return transaction(() async {
      await into(categories)
          .insert(catWithSubs.category, mode: InsertMode.insertOrReplace);
      await batch((b) {
        b.insertAll(subcategories, catWithSubs.subcategories,
            mode: InsertMode.insertOrReplace);
      });
    });
  }
}

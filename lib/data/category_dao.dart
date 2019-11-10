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

@UseDao(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final AppDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();
  Future insertCategory(Insertable<Category> category) =>
      into(categories).insert(category);
  Future updateCategory(Insertable<Category> category) =>
      update(categories).replace(category);
  Future deleteCategory(Insertable<Category> category) =>
      delete(categories).delete(category);
}

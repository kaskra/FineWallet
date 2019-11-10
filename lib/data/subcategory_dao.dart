/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:17 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:moor/moor.dart';

part 'subcategory_dao.g.dart';

@UseDao(tables: [Subcategories])
class SubcategoryDao extends DatabaseAccessor<AppDatabase>
    with _$SubcategoryDaoMixin {
  final AppDatabase db;

  SubcategoryDao(this.db) : super(db);

  Future<List<Subcategory>> get getAllSubcategories =>
      select(subcategories).get();
  Future insertSubcategory(Insertable<Subcategory> subcategory) =>
      into(subcategories).insert(subcategory);
  Future updateSubcategory(Insertable<Subcategory> subcategory) =>
      update(subcategories).replace(subcategory);
  Future deleteSubcategory(Insertable<Subcategory> subcategory) =>
      delete(subcategories).delete(subcategory);
}

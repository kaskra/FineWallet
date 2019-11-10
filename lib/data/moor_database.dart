/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/transaction_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  IntColumn get subcategoryId => integer()();
  IntColumn get categoryId => integer()();
  IntColumn get monthId => integer()();
  IntColumn get date => integer()();
  BoolColumn get isExpense => boolean()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  IntColumn get recurringType => integer().nullable()();
  IntColumn get recurringUnitl => integer().nullable()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
}

@DataClassName('Subcategory')
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  IntColumn get categoryId => integer()();
}

@DataClassName('Month')
class Months extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get maxBudget => real()();
  IntColumn get firstDate => integer()();
  IntColumn get lastDate => integer()();
}

@UseMoor(
    tables: [Transactions, Categories, Subcategories, Months],
    daos: [TransactionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true)));

  @override
  int get schemaVersion => 1;
}

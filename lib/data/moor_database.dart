/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/moor_initialization.dart'
    as moor_init;
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real().customConstraint("CHECK (amount > 0)")();

  IntColumn get subcategoryId =>
      integer().customConstraint("REFERENCES subcategories(id)")();

  IntColumn get monthId =>
      integer().customConstraint("REFERENCES months(id)")();

  IntColumn get date => integer()();

  BoolColumn get isExpense => boolean()();

  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();

  IntColumn get recurringType => integer()
      .nullable()
      .customConstraint("NULL REFERENCES recurrences(type)")();

  IntColumn get recurringUntil => integer().nullable()();

  IntColumn get originalId => integer()
      .nullable()
      .customConstraint("NULL REFERENCES transactions(id)")();

  @override
  List<String> get customConstraints => [
        "CHECK (is_recurring = 0 OR (recurring_until NOT NULL AND "
            "recurring_type NOT NULL AND "
            "original_id NOT NULL))"
      ];
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 20)();

  BoolColumn get isExpense => boolean().withDefault(const Constant(true))();
}

@DataClassName('Subcategory')
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 30)();

  IntColumn get categoryId =>
      integer().customConstraint("REFERENCES categories(id)")();
}

@DataClassName('Month')
class Months extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get maxBudget =>
      real().customConstraint("CHECK (max_budget >= 0)")();

  IntColumn get firstDate => integer()();

  IntColumn get lastDate => integer()();
}

@DataClassName('Recurrence')
class Recurrences extends Table {
  IntColumn get type => integer().autoIncrement()();

  TextColumn get name => text().withLength(max: 40, min: 2)();
}

@UseMoor(
  tables: [Transactions, Categories, Subcategories, Months, Recurrences],
  daos: [TransactionDao, CategoryDao, MonthDao],
  queries: {
    "getTimestamp":
        "SELECT strftime('%s','now', 'localtime') * 1000 AS timestamp",
    "maxTransactionId": "SELECT MAX(id) FROM transactions"
  },
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true)));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAllTables();
        },
        beforeOpen: (details) async {
          await customStatement("PRAGMA foreign_keys = ON");

          if (details.wasCreated) {
            // When changing sth in here reinstall the app
            await into(months).insert(moor_init.currentMonth);

            await into(recurrences).insertAll(moor_init.recurrences);

            for (var catWithSubs in moor_init.categories) {
              await into(categories)
                  .insert(catWithSubs.category, orReplace: true);
              await into(subcategories)
                  .insertAll(catWithSubs.subcategories, orReplace: true);
            }

            // TODO remove when done testing

            var tx1 = TransactionsCompanion.insert(
                amount: 15,
                subcategoryId: 1,
                monthId: 1,
                date: dayInMillis(DateTime.now()),
                isExpense: true);
            var tx2 = TransactionsCompanion.insert(
                amount: 10,
                subcategoryId: 5,
                monthId: 1,
                date: dayInMillis(DateTime.now()),
                isExpense: true);
            var tx3 = TransactionsCompanion.insert(
                amount: 5,
                subcategoryId: 2,
                monthId: 1,
                date: dayInMillis(DateTime.now()),
                isExpense: true);
            var tx4 = TransactionsCompanion.insert(
                amount: 50,
                subcategoryId: 68,
                monthId: 1,
                date: dayInMillis(DateTime.now()),
                isExpense: false);
            var tx5 = TransactionsCompanion.insert(
                amount: 100,
                subcategoryId: 68,
                monthId: 1,
                date: dayInMillis(DateTime.now()),
                isExpense: false);

            await into(transactions).insertAll([tx1, tx2, tx3, tx4, tx5]);

            await customStatement("CREATE VIEW IF NOT EXISTS expenses "
                "AS SELECT * FROM transactions WHERE is_expense = 1");
            await customStatement("CREATE VIEW IF NOT EXISTS incomes "
                "AS SELECT * FROM transactions WHERE is_expense = 0");
            await customStatement(
                "CREATE VIEW IF NOT EXISTS transactions_with_categories "
                "AS SELECT * FROM transactions t "
                "INNER JOIN subcategories s "
                "ON s.id = t.subcategory_id");
            await customStatement(
                "CREATE VIEW IF NOT EXISTS transactions_with_months "
                "AS SELECT * FROM transactions t "
                "INNER JOIN months m "
                "ON t.month_id = m.id");
          }

          // Check if in new month and update accordingly
          await monthDao.checkLatestMonths();
        },
      );
}

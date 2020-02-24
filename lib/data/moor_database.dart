/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/moor_initialization.dart'
    as moor_init;
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real().customConstraint("CHECK (amount > 0)")();

  IntColumn get subcategoryId =>
      integer().customConstraint("REFERENCES subcategories(id)")();

  IntColumn get monthId =>
      integer().customConstraint("REFERENCES months(id)")();

  TextColumn get date => text().map(const DateTimeConverter())();

  BoolColumn get isExpense => boolean()();

  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();

  IntColumn get recurringType => integer()
      .nullable()
      .customConstraint("NULL REFERENCES recurrence_types(type)")();

  TextColumn get recurringUntil =>
      text().map(const DateTimeConverter()).nullable()();

  IntColumn get originalId => integer()
      .nullable()
      .customConstraint("NULL REFERENCES transactions(id)")();

  @override
  List<String> get customConstraints => [
        // ignore: no_adjacent_strings_in_list
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

  TextColumn get firstDate => text().map(const DateTimeConverter())();

  TextColumn get lastDate => text().map(const DateTimeConverter())();
}

@DataClassName('RecurrenceType')
class RecurrenceTypes extends Table {
  IntColumn get type => integer().autoIncrement()();

  TextColumn get name => text().withLength(max: 40, min: 2)();
}

@DataClassName('Language')
class Languages extends Table {
  TextColumn get languageId => text().customConstraint("UNIQUE")();

  TextColumn get name => text().withLength(max: 40, min: 2)();
}

@DataClassName('Currency')
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get abbrev => text().withLength(max: 40, min: 2)();

  TextColumn get symbol => text().withLength(max: 1, min: 1)();

  RealColumn get exchangeRate => real()();
}

@UseMoor(
  tables: [
    Transactions,
    Categories,
    Subcategories,
    Months,
    RecurrenceTypes,
    Languages,
    Currencies,
  ],
  daos: [TransactionDao, CategoryDao, MonthDao],
  queries: {
    "getTimestamp":
        "SELECT strftime('%s','now', 'localtime') * 1000 AS timestamp"
  },
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement("PRAGMA foreign_keys = ON");

          if (details.wasCreated) {
            // When changing sth in here reinstall the app
            await into(months).insert(moor_init.currentMonth);

            await batch((b) {
              b.insertAll(recurrenceTypes, moor_init.recurrences);

              for (final catWithSubs in moor_init.categories) {
                b.insert(categories, catWithSubs.category,
                    mode: InsertMode.insertOrReplace);
              }
            });

            // Has to be done in extra batch, because
            // otherwise it would not insert anything.
            await batch((b) {
              for (final catWithSubs in moor_init.categories) {
                b.insertAll(subcategories, catWithSubs.subcategories,
                    mode: InsertMode.insertOrReplace);
              }
            });

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

  /// Returns the current maximum AUTO INCREMENT value of table transactions.
  Future<int> maxTransactionId() {
    final res = customSelectQuery(
        "SELECT seq FROM sqlite_sequence WHERE name='transactions'");
    return res.map((row) => row.readInt("seq")).getSingle();
  }

  /// Return a list of all [Recurrence]s in database table.
  ///
  /// Return
  /// ------
  /// list of all [Recurrence]s
  Future<List<RecurrenceType>> getRecurrences() =>
      select(recurrenceTypes).get();
}

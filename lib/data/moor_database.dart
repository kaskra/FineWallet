/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:31 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:io';

import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/currency_dao.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/moor_initialization.dart'
    as moor_init;
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;

part 'moor_database.g.dart';

@UseMoor(
  include: {
    "moor_files/tables.moor",
    "moor_files/general_queries.moor",
    "moor_files/trigger.moor",
    "moor_files/views.moor",
  },
  tables: [
    BaseTransactions,
    Categories,
    Subcategories,
    Months,
    RecurrenceTypes,
    Currencies,
    UserProfiles,
  ],
  daos: [
    TransactionDao,
    CategoryDao,
    MonthDao,
    CurrencyDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor e})
      : super(LazyDatabase(() async {
          if (e != null) {
            return e;
          }
          final dbFolder = await getDatabasesPath();
          final file = File(p.join(dbFolder, 'database.sqlite'));
          return VmDatabase(file, logStatements: true);
          // TODO add setup function to add user-defined functions
        }));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (migration, from, to) {
          // migrate_1_2(migration, from, to, this);
          return;
        },
        beforeOpen: (details) async {
          await customStatement("PRAGMA foreign_keys = ON");

          if (details.wasCreated) {
            // When changing sth in here reinstall the app
            await into(months).insert(moor_init.currentMonth);

            await batch((b) {
              b.insertAll(recurrenceTypes, moor_init.recurrenceTypes);

              for (final catWithSubs in moor_init.categories) {
                b.insert(categories, catWithSubs.category,
                    mode: InsertMode.insertOrReplace);
              }

              b.insertAll(currencies, moor_init.currencies);
            });

            // Has to be done in extra batch, because
            // otherwise it would not insert anything.
            await batch((b) {
              for (final catWithSubs in moor_init.categories) {
                b.insertAll(subcategories, catWithSubs.subcategories,
                    mode: InsertMode.insertOrReplace);
              }
            });
          }

          // Check if in new month and update accordingly
          // TODO do i need this?
          // await monthDao.checkLatestMonths();
        },
      );

  /// Returns the current maximum AUTO INCREMENT value of table transactions.
  Future<int> maxTransactionId() {
    final res = customSelect(
        "SELECT seq FROM sqlite_sequence WHERE name='transactions'");
    return res.map((row) => row.readInt("seq")).getSingleOrNull();
  }

  /// Return a list of all [Recurrence]s in database table.
  ///
  /// Return
  /// ------
  /// list of all [Recurrence]s
  Future<List<RecurrenceType>> getRecurrences() =>
      select(recurrenceTypes).get();

  Future addUserProfile(Insertable<UserProfile> profile) =>
      into(userProfiles).insert(profile, mode: InsertMode.insertOrReplace);
}

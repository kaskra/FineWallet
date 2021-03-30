/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:moor/moor.dart';

part 'month_dao.g.dart';

@UseDao(
  tables: [
    Months,
    BaseTransactions,
  ],
  include: {
    "moor_files/month_queries.moor",
  },
)
class MonthDao extends DatabaseAccessor<AppDatabase> with _$MonthDaoMixin {
  final AppDatabase db;

  MonthDao(this.db) : super(db);

  Future<List<Month>> getAllMonths() => _allMonths().get();

  Stream<List<Month>> watchAllMonths() => _allMonths().watch();

  Future<int> insertMonth(Insertable<Month> month) =>
      into(months).insert(month);

  Future<bool> updateMonth(Insertable<Month> month) =>
      update(months).replace(month);

  Future<int> deleteMonth(Insertable<Month> month) =>
      delete(months).delete(month);

  Future<int> getMonthIdByDate(DateTime date) =>
      _monthIdByDate(date.toSql()).getSingleOrNull();

  Future<Month> getCurrentMonth(
          [DateTime Function() _getCurrentTime = today]) =>
      _monthByDate(_getCurrentTime().toSql()).getSingleOrNull();

  Stream<Month> watchCurrentMonth(
          [DateTime Function() _getCurrentTime = today]) =>
      _monthByDate(_getCurrentTime().toSql()).watchSingleOrNull();

  Future<Month> getMonthById(int id) => _monthById(id).getSingleOrNull();

  Stream<Month> watchMonthById(int id) => _monthById(id).watchSingleOrNull();

  Future<int> restrictMaxBudgetByMonthlyIncome() => _syncMaxBudgetFromIncome();

  /// Insert current month if not in database already.
  Future<int> checkForCurrentMonth() => _insertCurrentMonthIfNotExists();

  Future checkMonth(DateTime date) async {
    if ((await getMonthIdByDate(date)) == null) {
      final first = date.getFirstDateOfMonth();
      final last = date.getLastDateOfMonth();

      final newMonth = MonthsCompanion.insert(firstDate: first, lastDate: last);
      await insertMonth(newMonth);
    }
  }

  /// Returns the id of a month by date.
  /// If no month month was found that included the date, every
  Future<int> createOrGetMonth(DateTime date) async {
    int id = await getMonthIdByDate(date);
    if (id == null) {
      await checkMonth(date);
      id = await getMonthIdByDate(date);
    }
    assert(id != null);
    return id;
  }

  /// Returns a [Stream] that watches the months and transactions table. Only
  /// streams the months which have a corresponding transaction.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [MonthWithDetails] which consists of a [Month]
  /// entity and a [Tuple3] to hold the month's details, like monthly income,
  /// monthly expenses and the monthly savings.
  ///
  Stream<List<MonthWithDetails>> watchAllMonthsWithDetails(
          [DateTime Function() _getCurrentTime = today]) =>
      _allMonthDetails(_getCurrentTime().toSql()).watch();

  /// Returns a [Stream] that watches the current month and the
  /// transactions in that month.
  ///
  /// Return
  /// ------
  /// [Stream] of an entity of [MonthWithDetails] which consists of a [Month]
  /// entity and a [Tuple3] to hold the month's details, like monthly income,
  /// monthly expenses and the monthly savings.
  ///
  Stream<MonthWithDetails> watchCurrentMonthWithDetails(
          [DateTime Function() _getCurrentTime = today]) =>
      _currentMonthDetails(_getCurrentTime().toSql()).watchSingle();
}

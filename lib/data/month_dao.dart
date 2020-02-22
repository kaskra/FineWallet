/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/month_utils.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'month_dao.g.dart';

class MonthWithDetails {
  final Month month;
  final Tuple3<double, double, double> details;

  MonthWithDetails(this.month, this.details);

  @override
  String toString() {
    return 'MonthWithDetails(month: $month, details: $details)';
  }

  double get savings => details.third;

  double get income => details.first;

  double get expense => details.second;
}

@UseDao(tables: [Months, Transactions])
class MonthDao extends DatabaseAccessor<AppDatabase> with _$MonthDaoMixin {
  final AppDatabase db;

  MonthDao(this.db) : super(db);

  Future<List<Month>> getAllMonths() => select(months).get();

  Future insertMonth(Insertable<Month> month) => into(months).insert(month);

  Future updateMonth(Insertable<Month> month) => update(months).replace(month);

  Future deleteMonth(Insertable<Month> month) => delete(months).delete(month);

  Future<int> getMonthIdByDate(int dateInMillis) async {
    Month m = await (select(months)
          ..where((m) => m.firstDate.isSmallerOrEqualValue(dateInMillis))
          ..where((m) => m.lastDate.isBiggerOrEqualValue(dateInMillis)))
        .getSingle();
    return m?.id;
  }

  Future<Month> getCurrentMonth() => (select(months)
        ..where((m) =>
            m.firstDate.isSmallerOrEqualValue(dayInMillis(DateTime.now())))
        ..where((m) =>
            m.lastDate.isBiggerOrEqualValue(dayInMillis(DateTime.now()))))
      .getSingle();

  Future<Month> getMonthById(int id) =>
      (select(months)..where((m) => m.id.equals(id))).getSingle();

  Stream<Month> watchCurrentMonth() {
    const inMonth = CustomExpression<bool, BoolType>(
        "first_date <= strftime('%s','now', 'localtime') * 1000 AND last_date >= strftime('%s','now', 'localtime') * 1000");
    return (select(months)..where((month) => inMonth)).watchSingle();
  }

  Stream<List<Month>> watchAllMonths() => (select(months)
        ..orderBy([
          (m) => OrderingTerm(expression: m.firstDate, mode: OrderingMode.asc)
        ]))
      .watch();

  Future syncSingleMonth(Month month) async {
    List<db_file.Transaction> txs = await (select(transactions)
          ..where((t) => t.monthId.equals(month.id))
          ..where((t) => t.isExpense.equals(false)))
        .get();

    double sumIncomes = txs.fold(0.0, (prev, next) => prev + next.amount);
    if (sumIncomes < month.maxBudget) {
      month = month.copyWith(maxBudget: sumIncomes);
      await updateMonth(month.createCompanion(true));
    }
  }

  Future syncMonths() async {
    List<Month> months = await getAllMonths();
    for (Month m in months) await syncSingleMonth(m);
  }

  /// Check months after last recorded month to see whether any are missing.
  Future checkLatestMonths() async {
    Month lastRecordedMonth = await (select(months)
          ..orderBy([
            (m) => OrderingTerm(expression: m.lastDate, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingle();

    List missingMonths = getMissingMonths(lastRecordedMonth);
    List<Insertable<Month>> newMonths = [];

    /* TODO rework dates to be only year, month, day --> without
        any hours. Currently the month begins on 1st 12am and ends at
        1st 0:59 am next month.
    */
    for (DateTime m in missingMonths) {
      int first = getFirstDateOfMonthInMillis(m);
      int last = getLastDateOfMonthInMillis(m);
      newMonths.add(MonthsCompanion.insert(
          maxBudget: 0, firstDate: first, lastDate: last));
    }

    if (newMonths.length > 0) {
      await batch((b) {
        b.insertAll(months, newMonths);
      });
    }
  }

  Future checkMonth(int date) async {
    if ((await db.monthDao.getMonthIdByDate(date)) == null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      int first = getFirstDateOfMonthInMillis(dateTime);
      int last = getLastDateOfMonthInMillis(dateTime);

      var newMonth = MonthsCompanion.insert(
          maxBudget: 0, firstDate: first, lastDate: last);
      await insertMonth(newMonth);
    }
  }

  /// Returns the id of a month by date (in milliseconds since epoch).
  /// If no month month was found that included the date, every
  Future<int> createOrGetMonth(int date) async {
    int id = await getMonthIdByDate(date);
    if (id == null) {
      await checkMonth(date);
      id = await getMonthIdByDate(date);
    }
    assert(id != null);
    return id;
  }

  /// Returns a [Stream] that watches the months and transactions table.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [MonthWithDetails] which consists of a [Month]
  /// entity and a [Tuple3] to hold the month's details, like monthly income,
  /// monthly expenses and the monthly savings.
  ///
  Stream<List<MonthWithDetails>> watchAllMonthsWithDetails() {
    final query = customSelectQuery(
        "SELECT IFNULL((SELECT SUM(amount) FROM incomes WHERE month_id = m.id), 0) "
        "AS month_income, "
        "IFNULL((SELECT SUM(amount) FROM expenses WHERE month_id = m.id), 0) "
        "AS month_expense,  m.* "
        "FROM months m "
        "WHERE ${dayInMillis(DateTime.now())} >= m.first_date "
        "GROUP BY m.id "
        "ORDER BY m.first_date DESC",
        readsFrom: {
          months,
          transactions
        }).watch().map((rows) => rows
        .map(
          (row) => MonthWithDetails(
              Month.fromData(row.data, db),
              Tuple3<double, double, double>(
                  row.readDouble("month_income"),
                  row.readDouble("month_expense"),
                  row.readDouble("month_income") -
                      row.readDouble("month_expense"))),
        )
        .toList());

    return query;
  }

  /// Returns a [Stream] that watches the current month and the
  /// transactions in that month.
  ///
  /// Return
  /// ------
  /// [Stream] of an entity of [MonthWithDetails] which consists of a [Month]
  /// entity and a [Tuple3] to hold the month's details, like monthly income,
  /// monthly expenses and the monthly savings.
  ///
  Stream<MonthWithDetails> watchCurrentMonthWithDetails() {
    final query = customSelectQuery(
            "SELECT IFNULL((SELECT SUM(amount) FROM incomes WHERE month_id = m.id), 0) "
            "AS month_income, "
            "IFNULL((SELECT SUM(amount) FROM expenses WHERE month_id = m.id), 0) "
            "AS month_expense,  m.* "
            "FROM months m "
            "WHERE ${dayInMillis(DateTime.now())} BETWEEN m.first_date AND m.last_date",
            readsFrom: {months, transactions}).watchSingle().map(
          (row) => MonthWithDetails(
              Month.fromData(row.data, db),
              Tuple3<double, double, double>(
                  row.readDouble("month_income"),
                  row.readDouble("month_expense"),
                  row.readDouble("month_income") -
                      row.readDouble("month_expense"))),
        );

    return query;
  }
}

/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/utils/month_utils.dart';
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

  Future<int> getMonthIdByDate(DateTime date) async {
    const converter = DateTimeConverter();

    final sqlDate = converter.mapToSql(date);
    final inMonthExp = months.firstDate.isSmallerOrEqualValue(sqlDate) &
        months.lastDate.isBiggerOrEqualValue(sqlDate);

    final month = await (select(months)..where((m) => inMonthExp)).getSingle();

    return month?.id;
  }

  Future<Month> getCurrentMonth() {
    const converter = DateTimeConverter();

    final sqlDate = converter.mapToSql(today());
    final inMonthExp = months.firstDate.isSmallerOrEqualValue(sqlDate) &
        months.lastDate.isBiggerOrEqualValue(sqlDate);

    return (select(months)..where((m) => inMonthExp)).getSingle();
  }

  Future<Month> getMonthById(int id) =>
      (select(months)..where((m) => m.id.equals(id))).getSingle();

  Stream<Month> watchCurrentMonth() {
    const converter = DateTimeConverter();

    final sqlDate = converter.mapToSql(today());
    final inMonthExp = months.firstDate.isSmallerOrEqualValue(sqlDate) &
        months.lastDate.isBiggerOrEqualValue(sqlDate);

    return (select(months)..where((month) => inMonthExp)).watchSingle();
  }

  Stream<List<Month>> watchAllMonths() => (select(months)
        ..orderBy([
          (m) => OrderingTerm(expression: m.firstDate, mode: OrderingMode.asc)
        ]))
      .watch();

  /// Returns every month id for which a (recursive) transaction is in the month.
  Future<List<int>> getMonthIdsFromTransaction(int txOriginalId) {
    return (selectOnly(transactions, distinct: true)
          ..addColumns([transactions.monthId])
          ..where(transactions.originalId.equals(txOriginalId)))
        .map((r) => r.read(transactions.monthId))
        .get();
  }

  Future syncSingleMonth(Month month) async {
    final txs = await (select(transactions)
          ..where((t) => t.monthId.equals(month.id))
          ..where((t) => t.isExpense.equals(false)))
        .get();

    final double sumIncomes = txs.fold(0.0, (prev, next) => prev + next.amount);
    if (sumIncomes < month.maxBudget) {
      final tempMonth = month.copyWith(maxBudget: sumIncomes);
      await updateMonth(tempMonth.toCompanion(true));
    }
  }

  Future syncMonths() async {
    final List<Month> months = await getAllMonths();
    for (final Month m in months) {
      await syncSingleMonth(m);
    }
  }

  /// Check months after last recorded month to see whether any are missing.
  Future checkLatestMonths() async {
    final lastRecordedMonth = await (select(months)
          ..orderBy([
            (m) => OrderingTerm(expression: m.lastDate, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingle();

    final missingMonths = getMissingMonths(lastRecordedMonth);
    final List<Insertable<Month>> newMonths = [];

    for (final m in missingMonths) {
      final first = m.getFirstDateOfMonth();
      final last = m.getLastDateOfMonth();
      newMonths.add(MonthsCompanion.insert(
          maxBudget: 0, firstDate: first, lastDate: last));
    }

    if (newMonths.isNotEmpty) {
      await batch((b) {
        b.insertAll(months, newMonths);
      });
    }
  }

  Future checkMonth(DateTime date) async {
    if ((await db.monthDao.getMonthIdByDate(date)) == null) {
      final first = date.getFirstDateOfMonth();
      final last = date.getLastDateOfMonth();

      final newMonth = MonthsCompanion.insert(
          maxBudget: 0, firstDate: first, lastDate: last);
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
  Stream<List<MonthWithDetails>> watchAllMonthsWithDetails() {
    const converter = DateTimeConverter();
    final sqlDate = converter.mapToSql(today());

    return customSelect(
        "SELECT IFNULL((SELECT SUM(amount) FROM incomes WHERE month_id = m.id), 0) "
        "AS month_income, "
        "IFNULL((SELECT SUM(amount) FROM expenses WHERE month_id = m.id), 0) "
        "AS month_expense,  m.* "
        "FROM months m "
        "WHERE '$sqlDate' >= m.first_date "
        "GROUP BY m.id "
        "ORDER BY m.first_date DESC",
        readsFrom: {
          months,
          transactions
        }).watch().map((rows) => rows
        .map(
          (row) {
            final double income = row.readDouble("month_income");
            final double expense = row.readDouble("month_expense");

            return MonthWithDetails(Month.fromData(row.data, db),
                Tuple3(income, expense, income - expense));
          },
        )
        .where((element) => element.expense != 0 || element.income != 0)
        .toList());
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
    const converter = DateTimeConverter();
    final query = customSelect(
            "SELECT IFNULL((SELECT SUM(amount) FROM incomes WHERE month_id = m.id), 0) "
            "AS month_income, "
            "IFNULL((SELECT SUM(amount) FROM expenses WHERE month_id = m.id), 0) "
            "AS month_expense,  m.* "
            "FROM months m "
            "WHERE '${converter.mapToSql(today())}' BETWEEN m.first_date AND m.last_date",
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

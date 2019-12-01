/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/month_utils.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'month_dao.g.dart';

class MonthWithTransactions {
  final Month month;
  final List<db_file.Transaction> transactions;

  MonthWithTransactions(this.month, this.transactions);
}

@UseDao(tables: [Months, Transactions])
class MonthDao extends DatabaseAccessor<AppDatabase> with _$MonthDaoMixin {
  final AppDatabase db;

  MonthDao(this.db) : super(db);

  Future<List<Month>> getAllMonths() => select(months).get();

  Future insertMonth(Insertable<Month> month) => into(months).insert(month);

  Future updateMonth(Insertable<Month> month) => update(months).replace(month);

  Future deleteMonth(Insertable<Month> month) => delete(months).delete(month);

  Future<int> getMonthByDate(int dateInMillis) async {
    Month m = await (select(months)
          ..where((m) => m.firstDate.isSmallerOrEqualValue(dateInMillis))
          ..where((m) => m.lastDate.isBiggerOrEqualValue(dateInMillis)))
        .getSingle();
    return m?.id;
  }

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

  Future syncSingleMonth(int id) async {
    List<db_file.Transaction> txs = await (select(transactions)
          ..where((t) => t.monthId.equals(id))
          ..where((t) => t.isExpense.equals(false)))
        .get();

    double sumIncomes = txs.fold(0.0, (prev, next) => prev + next.amount);
    Month m = await getMonthById(id);

    if (sumIncomes < m.maxBudget) {
      m.copyWith(maxBudget: sumIncomes);
      updateMonth(m.createCompanion(true));
    }
  }

  Future syncMonths() async {
    List<Month> months = await getAllMonths();

    for (Month m in months) await syncSingleMonth(m.id);
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
      await into(months).insertAll(newMonths);
    }
  }

  Future checkMonth(int date) async {
    if ((await db.monthDao.getMonthByDate(date)) == null) {
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
    int id = await getMonthByDate(date);
    if (id == null) {
      await checkMonth(date);
      id = await getMonthByDate(date);
    }
    assert(id != null);
    return id;
  }
}

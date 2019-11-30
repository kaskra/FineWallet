/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:23 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:moor_flutter/moor_flutter.dart';

part 'month_dao.g.dart';

class MonthWithTransactions {
  final Month month;
  final List<db_file.Transaction> transactions;

  MonthWithTransactions(this.month, this.transactions);
}

@UseDao(tables: [Months])
class MonthDao extends DatabaseAccessor<AppDatabase> with _$MonthDaoMixin {
  final AppDatabase db;

  MonthDao(this.db) : super(db);

  Future<List<Month>> getAllMonths() => select(months).get();

  Future insertMonth(Insertable<Month> month) => into(months).insert(month);

  Future updateMonth(Insertable<Month> month) => update(months).replace(month);

  Future deleteMonth(Insertable<Month> month) => delete(months).delete(month);

  Future<int> getMonth(int dateInMillis) async {
    Month m = await (select(months)
          ..where((m) => m.firstDate.isSmallerOrEqualValue(dateInMillis))
          ..where((m) => m.lastDate.isBiggerOrEqualValue(dateInMillis)))
        .getSingle();
    return m?.id;
  }

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
}

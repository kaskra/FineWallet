/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:moor_flutter/moor_flutter.dart';

part 'transaction_dao.g.dart';

@UseDao(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;

  TransactionDao(this.db) : super(db);

  Future<List<db_file.Transaction>> getAllTransactions() =>
      select(transactions).get();
  Future insertTransaction(Insertable<db_file.Transaction> transaction) =>
      into(transactions).insert(transaction);
  Future updateTransaction(Insertable<db_file.Transaction> transaction) =>
      update(transactions).replace(transaction);
  Future deleteTransaction(Insertable<db_file.Transaction> transaction) =>
      delete(transactions).delete(transaction);
}

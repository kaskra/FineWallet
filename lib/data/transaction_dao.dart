/*
 * Project: FineWallet
 * Last Modified: Sunday, 10th November 2019 10:41:11 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/converters/datetime_converter.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_parser.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/moor_database.dart' as db_file;
import 'package:FineWallet/data/utils/recurrence_utils.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

part 'transaction_dao.g.dart';

class TransactionWithCategoryAndCurrency {
  final db_file.Transaction tx;
  final db_file.Subcategory sub;
  final db_file.Currency currency;

  TransactionWithCategoryAndCurrency({this.tx, this.sub, this.currency});

  @override
  String toString() {
    return 'TransactionWithCategoryAndCurrency{tx: $tx, sub: $sub, currency: $currency}';
  }
}

@UseDao(
  tables: [
    Transactions,
    Categories,
    Subcategories,
    Months,
    Currencies,
  ],
)
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;

  TransactionDao(this.db) : super(db);

  /// Returns every transaction unfiltered from the transactions table.
  ///
  /// Should use [watchTransactionsWithFilter] instead, when needed to
  /// display transactions.
  Future<List<db_file.Transaction>> getAllTransactions() =>
      select(transactions).get();

  /// Inserts a [db_file.Transaction] into the transactions table.
  ///
  /// While inserting, it makes sure that the month id exists, if not
  /// it creates a new month that fits. It generates all recurrences according
  /// to the recurring type passed in by the transaction. At last, it
  /// bulk inserts every created transaction.
  ///
  /// Input
  /// -----
  /// - [db_file.Transaction] that should be inserted.
  ///
  Future insertTransaction(db_file.Transaction tx) async {
    // Setup: Get next id set original id to that.
    // Prevents SELECT in SQL-transaction.
    final maxTransactionID = await db.maxTransactionId();
    final double exchangeRate =
        (await db.currencyDao.getCurrencyById(tx.currencyId)).exchangeRate ??
            1.0;
    final nextId = (maxTransactionID ?? 0) + 1;
    var tempTx = tx.copyWith(
      originalId: nextId,
      amount: tx.amount * exchangeRate,
      exchangeRate: exchangeRate,
    );

    // Fill in month id
    if (tempTx.monthId == null) {
      final int id = await db.monthDao.createOrGetMonth(tempTx.date);
      tempTx = tempTx.copyWith(monthId: id);
    }

    // Make sure that every transaction has its correct month id assigned.
    final List<Insertable<db_file.Transaction>> txs = [];

    if (tempTx.isRecurring) {
      final List<db_file.Transaction> recurrences = generateRecurrences(tempTx);
      for (final t in recurrences) {
        final id = await db.monthDao.createOrGetMonth(t.date);
        txs.add(t.copyWith(monthId: id ?? t.monthId).toCompanion(true));
      }
    }

    // Add all transactions to database in SQL-transaction.
    return transaction(() async {
      await into(transactions).insert(
        tempTx.toCompanion(true).copyWith(id: Value(nextId)),
      );

      if (tempTx.isRecurring) {
        await batch((b) {
          b.insertAll(transactions, txs);
        });
      }
    });
  }

  /// Updates the transaction and its recurrences in the database.
  /// After updating, all months are synced to make sure that the max budget is
  /// still up-to-date.
  ///
  /// Input
  /// -----
  /// - [db_file.Transaction] that should be updated.
  ///
  Future updateTransaction(db_file.Transaction tx) async {
    await transaction(() async {
      await deleteTransactionById(tx.originalId, beforeInsert: true);
      final tempTx = db_file.Transaction(
          id: null,
          amount: tx.amount,
          originalAmount: tx.originalAmount,
          exchangeRate: tx.exchangeRate,
          monthId: tx.monthId,
          date: tx.date,
          subcategoryId: tx.subcategoryId,
          isExpense: tx.isExpense,
          isRecurring: tx.isRecurring,
          until: tx.until,
          recurrenceType: tx.recurrenceType,
          currencyId: tx.currencyId,
          label: tx.label);
      await insertTransaction(tempTx);
    });
    return db.monthDao.syncMonths();
  }

  Future deleteTransaction(db_file.Transaction transaction) async {
    await delete(transactions).delete(transaction.toCompanion(true));
    await db.monthDao.syncMonths();
  }

  Future deleteTransactionById(int id, {bool beforeInsert = false}) async {
    await (delete(transactions)..where((t) => t.originalId.equals(id))).go();
    if (!beforeInsert) await db.monthDao.syncMonths();
  }

  /// Returns a [Stream] with the savings up to the current month.
  /// The stream is updated every time the database is changed.
  Stream<double> watchTotalSavings() {
    const converter = DateTimeConverter();
    final currentDate = converter.mapToSql(today().getFirstDateOfMonth());

    final sumAmount = transactions.amount.total();

    final expenseStream = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(transactions.isExpense &
              transactions.date.isSmallerThanValue(currentDate)))
        .watchSingle()
        .map((event) => event.read(sumAmount));

    final incomeStream = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(transactions.isExpense.not() &
              transactions.date.isSmallerThanValue(currentDate)))
        .watchSingle()
        .map((event) => event.read(sumAmount));

    final combinedQuery = CombineLatestStream.combine2(
        expenseStream, incomeStream, (expense, income) {
      return income - expense;
    });

    return combinedQuery.cast();
  }

  /// Returns a [Stream] that watches the transactions table.
  ///
  /// The stream is updated when ever the table changes.
  ///
  /// Input
  /// -----
  ///  - [TransactionFilterSettings] to filter the query results.
  ///
  Stream<List<TransactionWithCategoryAndCurrency>> watchTransactionsWithFilter(
      TransactionFilterSettings settings) {
    final txParser = TransactionFilterParser(settings);
    final settingsContent = txParser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true);
    final parsedSettings = CustomExpression<bool>(settingsContent);

    final query = select(transactions).join([
      innerJoin(subcategories,
          subcategories.id.equalsExp(transactions.subcategoryId)),
      innerJoin(currencies, currencies.id.equalsExp(transactions.currencyId)),
    ])
      ..orderBy([
        OrderingTerm.desc(transactions.date),
        OrderingTerm.desc(transactions.id)
      ]);

    // Only apply where if parsed settings have content.
    if (settingsContent.isNotEmpty) {
      query.where(parsedSettings);
    }

    return query.map((row) {
      final tx = row.readTable(transactions);
      final sub = row.readTable(subcategories);
      final currency = row.readTable(currencies);
      return TransactionWithCategoryAndCurrency(
          tx: tx, sub: sub, currency: currency);
    }).watch();
  }

  /// Returns a [Stream] of the monthly income.
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the monthly income.
  ///
  Stream<double> watchMonthlyIncome(DateTime date) {
    final parser = TransactionFilterParser(
        TransactionFilterSettings(dateInMonth: date, incomes: true));
    final parsedSettings = CustomExpression<bool>(parser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true));
    final sumAmount = transactions.amount.total();

    final query = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(parsedSettings))
        .watchSingle()
        .map((row) => row.read(sumAmount));

    return query.cast();
  }

  /// Returns a [Stream] of summed up monthly expenses grouped and ordered by day.
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [Tuple2]s with date and summed up expenses.
  ///
  Stream<List<Tuple2<DateTime, double>>> watchExpensesPerDayInMonth(
      DateTime dateInMonth) {
    const converter = DateTimeConverter();
    final parser = TransactionFilterParser(
        TransactionFilterSettings(dateInMonth: dateInMonth, expenses: true));
    final parsedSettings = CustomExpression<bool>(parser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true));
    final sumAmount = transactions.amount.total();

    final query = (selectOnly(transactions)
          ..addColumns([sumAmount, transactions.date])
          ..where(parsedSettings)
          ..groupBy([transactions.date])
          ..orderBy([OrderingTerm.asc(transactions.date)]))
        .watch()
        .map((rows) => rows
            .map((row) => Tuple2<DateTime, double>(
                converter.mapToDart(row.read(transactions.date)),
                row.read(sumAmount)))
            .toList());

    return query;
  }

  /// Returns a [Stream] of categories and their corresponding
  /// summed up transactions.
  ///
  /// Input
  /// -----
  /// [TransactionFilterSettings] to filter the transactions.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of type [Tuple3]
  ///
  Stream<List<Tuple3<int, String, double>>> watchSumOfTransactionsByCategories(
      TransactionFilterSettings settings) {
    final parser = TransactionFilterParser(settings);

    final sumAmount = transactions.amount.total();
    final parsedSettings = CustomExpression<bool>(parser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true));

    final query = selectOnly(transactions).join([
      innerJoin(
          subcategories, subcategories.id.equalsExp(transactions.subcategoryId),
          useColumns: false),
      innerJoin(categories, categories.id.equalsExp(subcategories.categoryId),
          useColumns: false)
    ])
      ..where(parsedSettings)
      ..addColumns([sumAmount, categories.id, categories.name])
      ..groupBy([categories.id]);

    return query.watch().map((event) => event
        .map((row) => Tuple3<int, String, double>(row.read(categories.id),
            tryTranslatePreset(row.read(categories.name)), row.read(sumAmount)))
        .toList());
  }

  /// Watches the latest non-recurrence transaction.
  Stream<TransactionWithCategoryAndCurrency> watchLatestTransaction() {
    final query = select(transactions).join([
      innerJoin(subcategories,
          subcategories.id.equalsExp(transactions.subcategoryId)),
      innerJoin(currencies, currencies.id.equalsExp(transactions.currencyId)),
    ])
      ..where(transactions.id.equalsExp(transactions.originalId))
      ..orderBy([OrderingTerm.desc(transactions.id)])
      ..limit(1);

    return query.map((row) {
      final tx = row.readTable(transactions);
      final sub = row.readTable(subcategories);
      final curr = row.readTable(currencies);
      return TransactionWithCategoryAndCurrency(
          tx: tx, sub: sub, currency: curr);
    }).watchSingle();
  }

  /// Watches the latest N non-recurrence transactions.
  Stream<List<TransactionWithCategoryAndCurrency>> watchNLatestTransactions(
      int N) {
    final query = select(transactions).join([
      innerJoin(subcategories,
          subcategories.id.equalsExp(transactions.subcategoryId)),
      innerJoin(currencies, currencies.id.equalsExp(transactions.currencyId)),
    ])
      ..where(transactions.id.equalsExp(transactions.originalId))
      ..orderBy([OrderingTerm.desc(transactions.id)])
      ..limit(N);

    return query.map((row) {
      final tx = row.readTable(transactions);
      final sub = row.readTable(subcategories);
      final curr = row.readTable(currencies);
      return TransactionWithCategoryAndCurrency(
          tx: tx, sub: sub, currency: curr);
    }).watch();
  }

  /// Returns a [Stream] of the monthly budget.
  ///
  /// Budget calculation
  ///
  /// `budget = max_budget - expenses;`
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the daily budget.
  ///
  Stream<double> watchMonthlyBudget(DateTime date) {
    const converter = DateTimeConverter();
    final settings =
        TransactionFilterSettings(dateInMonth: date, expenses: true);
    final parser = TransactionFilterParser(settings);

    final parsedSettings = CustomExpression<bool>(parser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true));
    final sqlDate = converter.mapToSql(date);
    final sumAmount = transactions.amount.total();

    final expensesStream = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(parsedSettings))
        .watchSingle()
        .map((row) => row.read(sumAmount));

    final maxBudgetStream = (selectOnly(months)
          ..addColumns([months.maxBudget])
          ..where(months.firstDate.isSmallerOrEqualValue(sqlDate) &
              months.lastDate.isBiggerOrEqualValue(sqlDate)))
        .watchSingle()
        .map((row) => row.read(months.maxBudget));

    final combinedStream = CombineLatestStream.combine2(
        maxBudgetStream, expensesStream, (max, exp) => max - exp);

    return combinedStream.cast();
  }

  /// Returns a [Stream] of the daily budget.
  ///
  /// Budget calculation
  ///
  /// `budget = max_budget - expenses;`
  ///
  /// Input
  /// -----
  /// [DateTime] a date in the month to watch.
  ///
  /// Return
  /// ------
  /// [Stream] of type [double] that holds the daily budget.
  ///
  Stream<double> watchDailyBudget(DateTime date) {
    const converter = DateTimeConverter();
    final settings =
        TransactionFilterSettings(dateInMonth: date, expenses: true);
    final parser = TransactionFilterParser(settings);
    final parsedSettings = CustomExpression<bool>(parser.parse(
        tableName: transactions.tableWithAlias, useInCustomExp: true));

    final remainingDays = date.remainingDaysInMonth;
    final sqlDate = converter.mapToSql(date);
    final sumAmount = transactions.amount.total();

    final maxBudgetStream = (selectOnly(months)
          ..addColumns([months.maxBudget])
          ..where(months.firstDate.isSmallerOrEqualValue(sqlDate) &
              months.lastDate.isBiggerOrEqualValue(sqlDate)))
        .watchSingle()
        .map((row) => row.read(months.maxBudget));

    final monthlyExpensesStream = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(parsedSettings &
              transactions.date.equals(sqlDate).not() &
              (transactions.recurrenceType.equals(1) |
                  transactions.isRecurring.not())))
        .watchSingle()
        .map((event) => event.read(sumAmount));

    final todayExpensesStream = (selectOnly(transactions)
          ..addColumns([sumAmount])
          ..where(parsedSettings &
              transactions.date.equals(sqlDate) &
              (transactions.recurrenceType.equals(1) |
                  transactions.isRecurring.not())))
        .watchSingle()
        .map((event) => event.read(sumAmount));

    final dailyBudgetStream = CombineLatestStream.combine3(
        maxBudgetStream, monthlyExpensesStream, todayExpensesStream,
        (double max, double m, double t) {
      return (max - m) / remainingDays - t;
    });

    return dailyBudgetStream.cast();
  }

  /// Returns all expenses of the last seven days grouped by date and summed up.
  ///
  /// Return
  /// ------
  /// [Stream] of a list of [Tuple2]s with a day's date
  /// epoch and the sum of its expenses.
  Stream<List<Tuple2<DateTime, double>>> watchLastWeeksTransactions() {
    // Get converter and compute date 7 days behind.
    const converter = DateTimeConverter();
    final dateLastWeek =
        converter.mapToSql(today().subtract(const Duration(days: 7)));

    // Setup watch of last weeks transactions.
    final sumAmount = transactions.amount.total();
    final query = selectOnly(transactions)
      ..addColumns([sumAmount, transactions.date])
      ..where(transactions.isExpense &
          transactions.date.isBiggerThanValue(dateLastWeek))
      ..groupBy([transactions.date])
      ..limit(7);

    return query.watch().map((rows) => rows
        .map((row) => Tuple2<DateTime, double>(
            converter.mapToDart(row.read(transactions.date)),
            row.read(sumAmount)))
        .toList());
  }

  Future<List<String>> getTransactionsLabels() {
    return (selectOnly(transactions, distinct: true)
          ..addColumns([transactions.label])
          ..where(transactions.label.equals("").not())
          ..orderBy([OrderingTerm.asc(transactions.label)]))
        .map((transaction) => transaction.read(transactions.label))
        .get();
  }
}

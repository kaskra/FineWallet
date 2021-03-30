import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';

final onceTransactions = [
  BaseTransaction(
    id: null,
    amount: 100,
    originalAmount: null,
    exchangeRate: null,
    isExpense: false,
    date: DateTime(2021, 3, 21),
    label: "Gehalt",
    subcategoryId: 66,
    monthId: null,
    currencyId: 2,
    recurrenceType: 1,
  ),
  BaseTransaction(
    id: null,
    amount: 42,
    originalAmount: null,
    exchangeRate: null,
    isExpense: true,
    date: DateTime(2021, 3, 21),
    label: "Kaffee",
    subcategoryId: 43,
    monthId: null,
    currencyId: 2,
    recurrenceType: 1,
  ),
];

final daily = BaseTransaction(
  id: null,
  amount: 10,
  originalAmount: 10,
  exchangeRate: null,
  isExpense: true,
  date: DateTime(2021, 3, 21),
  label: "Mittagessen",
  subcategoryId: 12,
  monthId: null,
  currencyId: 2,
  recurrenceType: 2,
  until: DateTime(2021, 3, 21).add(const Duration(days: 4)),
);

final weekly = BaseTransaction(
  id: null,
  amount: 21,
  originalAmount: 21,
  exchangeRate: null,
  isExpense: true,
  date: DateTime(2021, 3, 21),
  label: "Paaartyy",
  subcategoryId: 18,
  monthId: null,
  currencyId: 2,
  recurrenceType: 3,
  until: DateTime(2021, 3, 21).add(const Duration(days: 15)),
);

final monthly = BaseTransaction(
  id: null,
  amount: 4.5,
  originalAmount: 4.5,
  exchangeRate: null,
  isExpense: true,
  date: DateTime(2021, 3, 21),
  label: "Netflix",
  subcategoryId: 18,
  monthId: null,
  currencyId: 2,
  recurrenceType: 4,
  until: DateTime(2021, 3, 21).add(const Duration(days: 70)),
);

final yearly = BaseTransaction(
  id: null,
  amount: 69,
  originalAmount: 69,
  exchangeRate: null,
  isExpense: true,
  date: DateTime(2021, 3, 21),
  label: "Amazon",
  subcategoryId: 18,
  monthId: null,
  currencyId: 2,
  recurrenceType: 6,
  until: DateTime(2021, 3, 21).add(const Duration(days: 400)),
);

void main() {
  testTransactions();
}

void testTransactions() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(e: VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  test('currencies are not empty', () async {
    final res = await database.currencyDao.getAllCurrencies();
    expect(res, isNotEmpty);
  });

  test('categories are not empty', () async {
    final res = await database.categoryDao.getAllCategories();
    expect(res, isNotEmpty);
  });

  test('subcategories are not empty', () async {
    final res = await database.categoryDao.getAllSubcategories();
    expect(res, isNotEmpty);
  });

  test('recurrenceTypes are not empty', () async {
    final res = await database.getRecurrences();
    expect(res, isNotEmpty);
  });

  group('"once" transactions', () {
    test('new transaction can be inserted', () async {
      final id = await database.transactionDao
          .insertTransaction(onceTransactions.first);

      final r = await database.transactionDao.getAllTransactions();

      final res = r.first;
      final model = onceTransactions.first;

      expect(r.length, 1);
      expect(res.exchangeRate, isNotNull);
      expect(res.monthId, isNotNull);
      expect(res.until, isNull);

      expect(res.until, isNull);
      expect(res.id, id);
      expect(res.date, model.date.toSql());
      expect(res.amount, model.amount);
      expect(res.originalAmount, model.amount);
      expect(res.isExpense, model.isExpense);
      expect(res.label, model.label);
      expect(res.recurrenceType, model.recurrenceType);
      expect(res.currencyId, model.currencyId);
      expect(res.subcategoryId, model.subcategoryId);
    });

    test('transaction can be deleted by id', () async {
      final id = await database.transactionDao
          .insertTransaction(onceTransactions.first);

      final resBefore = await database.transactionDao.getAllTransactions();

      expect(resBefore.length, 1);

      await database.transactionDao.deleteTransactionById(id);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 0);
    });

    test('transaction can be deleted by model', () async {
      await database.transactionDao.insertTransaction(onceTransactions.first);

      final resBefore = await database.transactionDao.getAllTransactions();
      expect(resBefore.length, 1);

      final txModel = resBefore.first;

      await database.transactionDao.deleteTransaction(txModel);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 0);
    });

    test('multiple transactions can be deleted by ids', () async {
      final id =
          await database.transactionDao.insertTransaction(onceTransactions[0]);
      final id2 =
          await database.transactionDao.insertTransaction(onceTransactions[1]);

      final resBeforeDelete =
          await database.transactionDao.getAllTransactions();
      expect(resBeforeDelete.length, 2);

      await database.transactionDao.deleteTransactionsByIds([id, id2]);

      final resAfterDelete = await database.transactionDao.getAllTransactions();
      expect(resAfterDelete.length, 0);
    });

    test('only right transactions is deleted', () async {
      final id =
          await database.transactionDao.insertTransaction(onceTransactions[0]);
      final id2 =
          await database.transactionDao.insertTransaction(onceTransactions[1]);

      final resBefore = await database.transactionDao.getAllTransactions();
      expect(resBefore.length, 2);

      await database.transactionDao.deleteTransactionById(id);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 1);
      expect(res.first.id, id2);
    });

    test('deleting transactions with wrong id does not delete anything',
        () async {
      await database.transactionDao.insertTransaction(onceTransactions.first);

      final resBefore = await database.transactionDao.getAllTransactions();

      expect(resBefore.length, 1);

      await database.transactionDao.deleteTransactionById(2);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 1);
    });

    test('deleting transactions with negative id does not delete anything',
        () async {
      await database.transactionDao.insertTransaction(onceTransactions.first);

      final resBefore = await database.transactionDao.getAllTransactions();

      expect(resBefore.length, 1);

      await database.transactionDao.deleteTransactionById(-1);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 1);
    });

    test('transaction can be deleted even with wrong id in id list', () async {
      final id =
          await database.transactionDao.insertTransaction(onceTransactions[0]);
      final id2 =
          await database.transactionDao.insertTransaction(onceTransactions[1]);

      final resBeforeDelete =
          await database.transactionDao.getAllTransactions();
      expect(resBeforeDelete.length, 2);

      await database.transactionDao.deleteTransactionsByIds([42, id]);

      final resAfterDelete = await database.transactionDao.getAllTransactions();
      expect(resAfterDelete.length, 1);
      expect(resAfterDelete.first.id, id2);
    });

    test('value of transaction should change after update', () async {
      final id =
          await database.transactionDao.insertTransaction(onceTransactions[0]);

      final updatedTx = onceTransactions[0].copyWith(id: id, amount: 28);

      await database.transactionDao.updateTransaction(updatedTx);

      final r = await database.transactionDao.getAllTransactions();

      final res = r.first;

      expect(r.length, 1);
      expect(res.id, id);
      expect(res.amount, updatedTx.amount);
      expect(updatedTx.amount, isNot(onceTransactions[0].amount));
    });

    test('value of transaction should not change after failed update',
        () async {
      final id =
          await database.transactionDao.insertTransaction(onceTransactions[0]);

      final updatedTx = onceTransactions[0].copyWith(amount: 28);

      try {
        await database.transactionDao.updateTransaction(updatedTx);
      } catch (InvalidDataException) {
        expect(true, true);
      }

      final r = await database.transactionDao.getAllTransactions();

      final res = r.first;

      expect(r.length, 1);
      expect(res.id, id);
      expect(res.amount, onceTransactions[0].amount);
    });
  });

  // ====================================================================
  // Recurring transactions
  group('recurring transactions', () {
    group('transaction can be inserted', () {
      test('new daily transaction can be inserted', () async {
        final id = await database.transactionDao.insertTransaction(daily);

        final r = await database.transactionDao.getAllTransactions();

        final res = r.first;

        expect(r.length, 5);
        expect(res.date, daily.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(daily.amount));
        expect(r.map((e) => e.originalAmount), everyElement(daily.amount));
        expect(r.map((e) => e.isExpense), everyElement(daily.isExpense));
        expect(r.map((e) => e.label), everyElement(daily.label));
        expect(
            r.map((e) => e.recurrenceType), everyElement(daily.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(daily.currencyId));
        expect(
            r.map((e) => e.subcategoryId), everyElement(daily.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));
        expect(r.map((e) => e.until), everyElement(isNotNull));

        expect(r.last.date, daily.until.toSql());
      });

      test('new weekly transaction can be inserted', () async {
        final id = await database.transactionDao.insertTransaction(weekly);

        final r = await database.transactionDao.getAllTransactions();

        final res = r.first;

        expect(r.length, 3);
        expect(res.date, weekly.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(weekly.amount));
        expect(r.map((e) => e.originalAmount), everyElement(weekly.amount));
        expect(r.map((e) => e.isExpense), everyElement(weekly.isExpense));
        expect(r.map((e) => e.label), everyElement(weekly.label));
        expect(r.map((e) => e.recurrenceType),
            everyElement(weekly.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(weekly.currencyId));
        expect(
            r.map((e) => e.subcategoryId), everyElement(weekly.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));
        expect(r.map((e) => e.until), everyElement(isNotNull));

        final DateTime d = DateTime.parse(r.last.date);
        final DateTime until = r.first.until;
        expect(
            DateTime.utc(d.year, d.month, d.day).isBeforeOrEqual(
                DateTime.utc(until.year, until.month, until.day)),
            true);
      });

      test('new monthly transaction can be inserted', () async {
        final id = await database.transactionDao.insertTransaction(monthly);

        final r = await database.transactionDao.getAllTransactions();

        final res = r.first;

        expect(r.length, 3);
        expect(res.date, monthly.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(monthly.amount));
        expect(r.map((e) => e.originalAmount), everyElement(monthly.amount));
        expect(r.map((e) => e.isExpense), everyElement(monthly.isExpense));
        expect(r.map((e) => e.label), everyElement(monthly.label));
        expect(r.map((e) => e.recurrenceType),
            everyElement(monthly.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(monthly.currencyId));
        expect(
            r.map((e) => e.subcategoryId), everyElement(monthly.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));
        expect(r.map((e) => e.until), everyElement(isNotNull));

        final DateTime d = DateTime.parse(r.last.date);
        final DateTime until = r.first.until;
        expect(
            DateTime.utc(d.year, d.month, d.day).isBeforeOrEqual(
                DateTime.utc(until.year, until.month, until.day)),
            true);
      });

      test('new yearly transaction can be inserted', () async {
        final id = await database.transactionDao.insertTransaction(yearly);

        final r = await database.transactionDao.getAllTransactions();

        final res = r.first;

        expect(r.length, 2);
        expect(res.date, yearly.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(yearly.amount));
        expect(r.map((e) => e.originalAmount), everyElement(yearly.amount));
        expect(r.map((e) => e.isExpense), everyElement(yearly.isExpense));
        expect(r.map((e) => e.label), everyElement(yearly.label));
        expect(r.map((e) => e.recurrenceType),
            everyElement(yearly.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(yearly.currencyId));
        expect(
            r.map((e) => e.subcategoryId), everyElement(yearly.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));
        expect(r.map((e) => e.until), everyElement(isNotNull));

        final DateTime d = DateTime.parse(r.last.date);
        final DateTime until = r.first.until;
        expect(
            DateTime.utc(d.year, d.month, d.day).isBeforeOrEqual(
                DateTime.utc(until.year, until.month, until.day)),
            true);
      });

      test('daily unlimited recurring transactions can be inserted', () async {
        final tx = BaseTransaction(
          id: null,
          amount: 10,
          originalAmount: 10,
          exchangeRate: null,
          isExpense: true,
          date: DateTime(today().year, today().month,
              today().getLastDateOfMonth().day - 3),
          label: "Mittagessen",
          subcategoryId: 12,
          monthId: null,
          currencyId: 2,
          recurrenceType: 2,
        );

        final id = await database.transactionDao.insertTransaction(tx);

        final r = await database.transactionDao.getAllTransactions();

        final res = r.first;

        expect(r.length, 4);
        expect(res.date, tx.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(tx.amount));
        expect(r.map((e) => e.originalAmount), everyElement(tx.amount));
        expect(r.map((e) => e.isExpense), everyElement(tx.isExpense));
        expect(r.map((e) => e.label), everyElement(tx.label));
        expect(r.map((e) => e.recurrenceType), everyElement(tx.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(tx.currencyId));
        expect(r.map((e) => e.subcategoryId), everyElement(tx.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));

        expect(r.last.date, today().getLastDateOfMonth().toSql());
      });

      test('weekly unlimited recurring transactions can be inserted', () async {
        final tx = BaseTransaction(
          id: null,
          amount: 10,
          originalAmount: 10,
          exchangeRate: null,
          isExpense: true,
          date: DateTime(today().year, today().month,
              today().getLastDateOfMonth().day - 3),
          label: "Mittagessen",
          subcategoryId: 12,
          monthId: null,
          currencyId: 2,
          recurrenceType: 3,
        );

        final id = await database.transactionDao.insertTransaction(tx);

        final r = await database.transactionDao.getAllTransactions();

        expect(r.length, 1);
        expect(r.first.date, tx.date.toSql());

        expect(r.map((e) => e.id), everyElement(id));
        expect(r.map((e) => e.amount), everyElement(tx.amount));
        expect(r.map((e) => e.originalAmount), everyElement(tx.amount));
        expect(r.map((e) => e.isExpense), everyElement(tx.isExpense));
        expect(r.map((e) => e.label), everyElement(tx.label));
        expect(r.map((e) => e.recurrenceType), everyElement(tx.recurrenceType));
        expect(r.map((e) => e.currencyId), everyElement(tx.currencyId));
        expect(r.map((e) => e.subcategoryId), everyElement(tx.subcategoryId));
        expect(r.map((e) => e.exchangeRate), everyElement(isNotNull));
        expect(r.map((e) => e.monthId), everyElement(isNotNull));
      });
    });

    group('transaction can be deleted by id', () {
      test('daily transaction can be deleted by id', () async {
        final id = await database.transactionDao.insertTransaction(daily);

        final resBefore = await database.transactionDao.getAllTransactions();

        expect(resBefore.length, 5);

        await database.transactionDao.deleteTransactionById(id);

        final res = await database.transactionDao.getAllTransactions();
        expect(res.length, 0);
      });

      test('monthly transaction can be deleted by id', () async {
        final id = await database.transactionDao.insertTransaction(monthly);

        final resBefore = await database.transactionDao.getAllTransactions();

        expect(resBefore.length, 3);

        await database.transactionDao.deleteTransactionById(id);

        final res = await database.transactionDao.getAllTransactions();
        expect(res.length, 0);
      });
    });

    group('transactions can be deleted by model', () {
      test('daily transaction can be deleted by model', () async {
        await database.transactionDao.insertTransaction(daily);

        final resBefore = await database.transactionDao.getAllTransactions();
        expect(resBefore.length, 5);

        final txModel = resBefore.first;

        await database.transactionDao.deleteTransaction(txModel);

        final res = await database.transactionDao.getAllTransactions();
        expect(res.length, 0);
      });

      test('monthly transaction can be deleted by model', () async {
        await database.transactionDao.insertTransaction(monthly);

        final resBefore = await database.transactionDao.getAllTransactions();
        expect(resBefore.length, 3);

        final txModel = resBefore.first;

        await database.transactionDao.deleteTransaction(txModel);

        final res = await database.transactionDao.getAllTransactions();
        expect(res.length, 0);
      });
    });

    test('multiple transactions can be deleted by ids', () async {
      final id = await database.transactionDao.insertTransaction(daily);
      final id2 = await database.transactionDao.insertTransaction(weekly);

      final resBeforeDelete =
          await database.transactionDao.getAllTransactions();
      expect(resBeforeDelete.length, 8);

      await database.transactionDao.deleteTransactionsByIds([id, id2]);

      final resAfterDelete = await database.transactionDao.getAllTransactions();
      expect(resAfterDelete.length, 0);
    });

    test('only right transactions is deleted', () async {
      final id = await database.transactionDao.insertTransaction(daily);
      final id2 = await database.transactionDao.insertTransaction(weekly);

      final resBefore = await database.transactionDao.getAllTransactions();
      expect(resBefore.length, 8);

      await database.transactionDao.deleteTransactionById(id);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 3);
      expect(res.first.id, id2);
    });

    test('deleting transactions with wrong id does not delete anything',
        () async {
      await database.transactionDao.insertTransaction(daily);

      final resBefore = await database.transactionDao.getAllTransactions();

      expect(resBefore.length, 5);

      await database.transactionDao.deleteTransactionById(2);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 5);
    });

    test('deleting transactions with negative id does not delete anything',
        () async {
      await database.transactionDao.insertTransaction(yearly);

      final resBefore = await database.transactionDao.getAllTransactions();

      expect(resBefore.length, 2);

      await database.transactionDao.deleteTransactionById(-1);

      final res = await database.transactionDao.getAllTransactions();
      expect(res.length, 2);
    });

    test('transaction can be deleted even with wrong id in id list', () async {
      final id = await database.transactionDao.insertTransaction(weekly);
      final id2 = await database.transactionDao.insertTransaction(yearly);

      final resBeforeDelete =
          await database.transactionDao.getAllTransactions();
      expect(resBeforeDelete.length, 5);

      await database.transactionDao.deleteTransactionsByIds([1321, id]);

      final resAfterDelete = await database.transactionDao.getAllTransactions();
      expect(resAfterDelete.length, 2);
      expect(resAfterDelete.first.id, id2);
    });

    test('value of transaction should change after update', () async {
      final id = await database.transactionDao.insertTransaction(daily);

      final updatedTx = daily.copyWith(id: id, amount: 28);

      await database.transactionDao.updateTransaction(updatedTx);

      final r = await database.transactionDao.getAllTransactions();

      expect(r.length, 5);
      expect(r.map((e) => e.id), everyElement(id));
      expect(r.map((e) => e.amount), everyElement(updatedTx.amount));
      expect(updatedTx.amount, isNot(daily.amount));
    });

    test('value of transaction should not change after failed update',
        () async {
      final id = await database.transactionDao.insertTransaction(weekly);

      final updatedTx = weekly.copyWith(amount: 28);

      try {
        await database.transactionDao.updateTransaction(updatedTx);
      } catch (InvalidDataException) {
        expect(true, true);
      }

      final r = await database.transactionDao.getAllTransactions();

      expect(r.length, 3);
      expect(r.map((e) => e.id), everyElement(id));
      expect(r.map((e) => e.amount), everyElement(weekly.amount));
    });

    group('difference between transaction dates should be according to name',
        () {
      test('daily transactions should be every day', () async {
        await database.transactionDao.insertTransaction(daily);

        final res = await database.transactionDao.getAllTransactions();
        expect(res.length, 5);

        for (int i = 1; i < res.length; i++) {
          DateTime prev = DateTime.parse(res[i - 1].date);
          prev = DateTime.utc(prev.year, prev.month, prev.day);

          DateTime curr = DateTime.parse(res[i].date);
          curr = DateTime.utc(curr.year, curr.month, curr.day);

          final Duration diff = curr.difference(prev);
          expect(diff.inDays, 1);
        }
      });

      test('weekly transactions should be same day each week', () async {
        await database.transactionDao.insertTransaction(weekly);

        final res = await database.transactionDao.getAllTransactions();
        DateTime first = DateTime.parse(res.first.date);
        first = DateTime.utc(first.year, first.month, first.day);
        expect(res.length, 3);

        for (int i = 1; i < res.length; i++) {
          DateTime prev = DateTime.parse(res[i - 1].date);
          prev = DateTime.utc(prev.year, prev.month, prev.day);

          DateTime curr = DateTime.parse(res[i].date);
          curr = DateTime.utc(curr.year, curr.month, curr.day);

          final Duration diff = curr.difference(prev);
          expect(diff.inDays, 7);
          expect(curr.weekday, first.weekday);
        }
      });

      test(
          'monthly transactions should be same weekday in the n-th week each month',
          () async {
        await database.transactionDao.insertTransaction(monthly);

        final res = await database.transactionDao.getAllTransactions();
        DateTime first = DateTime.parse(res.first.date);
        first = DateTime.utc(first.year, first.month, first.day);
        final int originalWeekInMonth = ((first.day - 1) / 7).floor() + 1;

        expect(res.length, 3);
        for (int i = 1; i < res.length; i++) {
          DateTime prev = DateTime.parse(res[i - 1].date);
          prev = DateTime.utc(prev.year, prev.month, prev.day);

          DateTime curr = DateTime.parse(res[i].date);
          curr = DateTime.utc(curr.year, curr.month, curr.day);

          final int currWeekInMonth = ((curr.day - 1) / 7).floor() + 1;
          expect(prev.month + 1 == curr.month, true);
          expect(curr.weekday, first.weekday);
          expect(currWeekInMonth, originalWeekInMonth);
        }
      });

      test('yearly transactions should be same date each year', () async {
        await database.transactionDao.insertTransaction(yearly);

        final res = await database.transactionDao.getAllTransactions();
        DateTime first = DateTime.parse(res.first.date);
        first = DateTime.utc(first.year, first.month, first.day);

        expect(res.length, 2);
        for (int i = 1; i < res.length; i++) {
          DateTime prev = DateTime.parse(res[i - 1].date);
          prev = DateTime.utc(prev.year, prev.month, prev.day);

          DateTime curr = DateTime.parse(res[i].date);
          curr = DateTime.utc(curr.year, curr.month, curr.day);

          expect(prev.year + 1 == curr.year, true);
          expect(prev.month == first.month, true);
          expect(prev.day == first.day, true);
        }
      });

      // TODO edge cases missing, end of february, each end of month, week with 5 vs 4 weeks...
    });
  });

  group('totalSavings', () {
    test('only incomes total savings should be positive', () async {
      final expectation = expectLater(
          database.transactionDao.watchTotalSavings(),
          emitsAnyOf([0.0, 100.0, 120.0]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
    });

    test('no transactions total savings show be zero', () async {
      final expectation = expectLater(
          database.transactionDao.watchTotalSavings(), emitsAnyOf([0.0]));

      await expectation;
    });

    test('only expenses total savings should be negative', () async {
      final expectation = expectLater(
          database.transactionDao.watchTotalSavings(),
          emitsAnyOf([0.0, -100.0, -120.0]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
    });

    test('total savings should be income - expenses', () async {
      final expectation = expectLater(
          database.transactionDao.watchTotalSavings(),
          emitsAnyOf([0.0, 100.0, 80.0]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
    });

    test('total savings should not consider transactions from current month',
        () async {
      final expectation = expectLater(
          database.transactionDao.watchTotalSavings(),
          emitsAnyOf([0.0, 100.0]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, DateTime.now().day, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, DateTime.now().day, 22)),
      );
      await expectation;
    });
  });

  group('monthlyIncome', () {
    test('monthly income should be positive and consider no expenses',
        () async {
      final expectation = expectLater(
          database.transactionDao.watchMonthlyIncome(DateTime.utc(2021, 2, 15)),
          emits(isNonNegative));
      final expectation2 = expectLater(
          database.transactionDao.watchMonthlyIncome(DateTime.utc(2021, 2, 15)),
          emitsAnyOf([0, 100]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
      await expectation2;
    });

    test('monthly income should only consider income of one month', () async {
      final expectation = expectLater(
          database.transactionDao.watchMonthlyIncome(DateTime.utc(2021, 3, 15)),
          emits(isZero));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
    });
  });

  group('expensesPerDayInMonth', () {
    test('should only consider expenses not income', () async {
      final stream = database.transactionDao
          .watchExpensesPerDayInMonth(DateTime.utc(2021, 2, 15))
          .map((event) => event.fold(
              0.0,
              (double previousValue, element) =>
                  previousValue + element.expense));

      final stream2 = database.transactionDao
          .watchExpensesPerDayInMonth(DateTime.utc(2021, 2, 15))
          .map((event) => event.map((e) => e.date).toList());

      final expectation = expectLater(stream, emits(isNonNegative));
      final expectation2 = expectLater(stream, emitsAnyOf([0, 20]));
      final expectation3 = expectLater(
          stream2,
          emitsAnyOf([
            [],
            ['2021-2-21', '2021-2-22']
          ]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
      await expectation2;
      await expectation3;
    });

    test('should only consider expenses of month', () async {
      final stream = database.transactionDao
          .watchExpensesPerDayInMonth(DateTime.utc(2021, 3, 15))
          .map((event) => event.fold(
              0.0,
              (double previousValue, element) =>
                  previousValue + element.expense));

      final stream2 = database.transactionDao
          .watchExpensesPerDayInMonth(DateTime.utc(2021, 3, 15))
          .map((event) => event.map((e) => e.date).toList());

      final expectation = expectLater(stream, emitsAnyOf([0, 100]));
      final expectation2 = expectLater(
          stream2,
          emitsAnyOf([
            [],
            ['2021-3-21']
          ]));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 3, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: true,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );

      await expectation;
      await expectation2;
    });

    test('should be zero if no expenses given', () async {
      final stream = database.transactionDao
          .watchExpensesPerDayInMonth(DateTime.utc(2021, 2, 15))
          .map((event) => event.fold(
              0.0,
              (double previousValue, element) =>
                  previousValue + element.expense));

      final expectation = expectLater(stream, emits(isZero));

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 100,
            originalAmount: 100,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 1),
      );

      await database.transactionDao.insertTransaction(
        BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: 1.0,
            isExpense: false,
            date: DateTime.utc(2021, 2, 21),
            label: "",
            subcategoryId: 66,
            monthId: null,
            currencyId: 1,
            recurrenceType: 2,
            until: DateTime.utc(2021, 2, 22)),
      );
      await expectation;
    });
  });

  group('latestTransaction', () {
    test('latest transaction should be returned', () async {
      await database.transactionDao.insertTransaction(onceTransactions[0]);

      final stream = database.transactionDao
          .watchLatestTransaction()
          .map((event) => event?.t?.id);
      final expectation = expectLater(stream, emits(1));
      final expectation2 = expectLater(stream, emitsInOrder([1, 2]));

      await expectation;
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await expectation2;
    });

    test('null if no transaction is present', () async {
      final stream = database.transactionDao
          .watchLatestTransaction()
          .map((event) => event?.t?.id);

      final expectation = expectLater(stream, emits(null));
      await expectation;
    });

    test('list of N latest transactions should be returned', () async {
      final stream = database.transactionDao
          .watchNLatestTransactions(3)
          .map((event) => event.map((e) => e.t.id).toList());
      final expectation = expectLater(
          stream,
          emitsAnyOf([
            [],
            [1],
            [2, 1],
            [3, 2, 1],
            [4, 3, 2]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await expectation;
    });

    test('empty list if no transactions are present', () async {
      final stream = database.transactionDao
          .watchNLatestTransactions(3)
          .map((event) => event.map((e) => e.t.id).toList());
      final expectation = expectLater(stream, emits([]));

      await expectation;
    });

    test('latest transactions should be in descending order', () async {
      final stream = database.transactionDao
          .watchNLatestTransactions(3)
          .map((event) => event.map((e) => e.t.id).toList());

      final expectation = expectLater(stream, emits(isList));

      final expectation2 = expectLater(
          stream,
          emitsInOrder([
            orderedEquals([]),
            orderedEquals([1]),
            orderedEquals([1]),
            orderedEquals([1]),
            orderedEquals([2, 1]),
            orderedEquals([3, 2, 1]),
            orderedEquals([4, 3, 2]),
          ]));
      final expectation3 = expectLater(
          stream,
          emitsInOrder([
            orderedEquals([]),
            orderedEquals([1]),
            orderedEquals([1]),
            orderedEquals([1]),
            isNot(orderedEquals([1, 2])),
            isNot(orderedEquals([3, 1, 2])),
            isNot(orderedEquals([2, 4, 3])),
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[0]);

      await expectation;
      await expectation2;
      await expectation3;
    });

    test('consider only unique transactions', () async {
      final stream = database.transactionDao
          .watchNLatestTransactions(3)
          .map((event) => event.map((e) => e.t.id).toList());

      final expectation = expectLater(
          stream,
          emitsInAnyOrder([
            [2, 1],
            [1],
            [1],
            [1],
            [],
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(daily);
      await expectation;
    });
  });

  group('monthlyBudget', () {
    test('should be negative without setting a max budget', () async {
      final stream =
          database.transactionDao.watchMonthlyBudget(DateTime(2021, 3, 21));

      final expectation = expectLater(stream, emits(isNonPositive));
      final expectation2 =
          expectLater(stream, emitsInOrder([0, -42, -42, -42, -42, -72]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(BaseTransaction(
        id: null,
        amount: 10,
        originalAmount: 10,
        exchangeRate: null,
        isExpense: true,
        date: DateTime(2021, 3, 21),
        label: "Mittagessen",
        subcategoryId: 12,
        monthId: null,
        currencyId: 2,
        recurrenceType: 2,
        until: DateTime(2021, 3, 21).add(const Duration(days: 2)),
      ));

      await expectation;
      await expectation2;
    });

    test('should only consider expenses of month', () async {
      final stream =
          database.transactionDao.watchMonthlyBudget(DateTime(2021, 3, 21));

      final expectation = expectLater(stream, emits(isNonPositive));
      final expectation2 = expectLater(stream, emitsAnyOf([-42, 0]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);

      await expectation;
      await expectation2;
    });

    test('should be zero with no max budget and expenses', () async {
      final stream =
          database.transactionDao.watchMonthlyBudget(DateTime(2021, 3, 21));

      final expectation = expectLater(stream, emits(isZero));
      await expectation;
    });

    test('should be positive with max budget and no expenses', () async {
      final month = await database.monthDao.getCurrentMonth();
      await database.monthDao.updateMonth(month.copyWith(maxBudget: 80));

      final stream = database.transactionDao.watchMonthlyBudget(today());

      final expectation = expectLater(stream, emits(isNonNegative));
      final expectation2 = expectLater(stream, emitsAnyOf([80, 0]));

      await expectation;
      await expectation2;
    });
  });

  group('dailyBudget', () {
    test('should be negative without setting a max budget', () async {
      final stream =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 26));

      const double first = -42 / 6;
      const double second = -72 / 6;

      final expectation = expectLater(stream, emits(isNonPositive));
      final expectation2 = expectLater(
          stream, emitsInOrder([0, first, first, first, first, second]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(BaseTransaction(
        id: null,
        amount: 10,
        originalAmount: 10,
        exchangeRate: null,
        isExpense: true,
        date: DateTime(2021, 3, 21),
        label: "Mittagessen",
        subcategoryId: 12,
        monthId: null,
        currencyId: 2,
        recurrenceType: 2,
        until: DateTime(2021, 3, 21).add(const Duration(days: 2)),
      ));

      await expectation;
      await expectation2;
    });

    test('should only consider expenses of month', () async {
      final stream =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 26));

      const double first = -42 / 6;
      const double second = -72 / 6;

      final expectation = expectLater(stream, emits(isNonPositive));
      final expectation2 = expectLater(stream, emitsAnyOf([second, first, 0]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(BaseTransaction(
        id: null,
        amount: 10,
        originalAmount: 10,
        exchangeRate: null,
        isExpense: true,
        date: DateTime(2021, 3, 21),
        label: "Mittagessen",
        subcategoryId: 12,
        monthId: null,
        currencyId: 2,
        recurrenceType: 2,
        until: DateTime(2021, 3, 21).add(const Duration(days: 2)),
      ));

      await expectation;
      await expectation2;
    });

    test('should change depending on remaining days in month', () async {
      final stream =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 26));
      const double first = -42 / 6;
      final expectation = expectLater(stream, emits(isNonPositive));
      final expectation2 = expectLater(stream, emitsInOrder([0, first]));

      final stream2 =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 29));
      const double second = -42 / 3;
      final expectation3 = expectLater(stream2, emits(isNonPositive));
      final expectation4 = expectLater(stream2, emitsInOrder([0, second]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      expect(first, isNot(equals(second)));
      await expectation;
      await expectation2;

      await expectation3;
      await expectation4;
    });

    test('should be zero with no max budget and no expenses', () async {
      final stream =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 26));
      final expectation = expectLater(stream, emits(isNonNegative));
      await expectation;
    });

    test('should be positive with max budget and no expenses', () async {
      final month = await database.monthDao.getCurrentMonth();
      await database.monthDao.updateMonth(month.copyWith(maxBudget: 80));

      final stream =
          database.transactionDao.watchDailyBudget(DateTime(2021, 3, 26));

      const res = 80 / 6;

      final expectation = expectLater(stream, emits(isNonNegative));
      final expectation2 = expectLater(stream, emits(res));

      await expectation;
      await expectation2;
    });

    test('should decrease with more expenses on the given day', () async {
      const double maxBudget = 80;
      final double onceExpense = onceTransactions[1].amount;
      const double recurringExpense = 5;

      final month = await database.monthDao.getCurrentMonth();
      await database.monthDao.updateMonth(month.copyWith(maxBudget: maxBudget));

      final stream = database.transactionDao.watchDailyBudget(
          DateTime(month.lastDate.year, month.lastDate.month, 26));

      final int remainingDays =
          DateTime(month.lastDate.year, month.lastDate.month, 26)
              .remainingDaysInMonth;

      // Calc expected outcomes
      final double withoutTx = maxBudget / remainingDays;
      final double first = (maxBudget - onceExpense) / remainingDays;
      final double second =
          (maxBudget - onceExpense - recurringExpense) / remainingDays -
              recurringExpense;

      expect(withoutTx, greaterThanOrEqualTo(first));
      expect(first, greaterThanOrEqualTo(second));

      final expectation =
          expectLater(stream, emitsInOrder([withoutTx, first, second]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          amount: recurringExpense,
          date: DateTime(month.lastDate.year, month.lastDate.month, 25),
          until: DateTime(month.lastDate.year, month.lastDate.month, 26)));

      await expectation;
    });

    test('should not be impacted by weekly expenses', () async {
      const double maxBudget = 80;
      final double onceExpense = onceTransactions[1].amount;
      const double recurringExpense = 5;

      final month = await database.monthDao.getCurrentMonth();
      await database.monthDao.updateMonth(month.copyWith(maxBudget: maxBudget));

      final stream = database.transactionDao.watchDailyBudget(
          DateTime(month.lastDate.year, month.lastDate.month, 26));

      final int remainingDays =
          DateTime(month.lastDate.year, month.lastDate.month, 26)
              .remainingDaysInMonth;

      // Calc expected outcomes
      final double withoutTx = maxBudget / remainingDays;
      final double first = (maxBudget - onceExpense) / remainingDays;
      final double second = (maxBudget - onceExpense) / remainingDays;

      expect(withoutTx, greaterThanOrEqualTo(first));
      expect(first, greaterThanOrEqualTo(second));

      final expectation =
          expectLater(stream, emitsInOrder([withoutTx, first, second]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          amount: recurringExpense,
          recurrenceType: 3,
          date: DateTime(month.lastDate.year, month.lastDate.month, 19),
          until: DateTime(month.lastDate.year, month.lastDate.month, 26)));

      await expectation;
    });
  });

  group('lastWeeksTransactions', () {
    test('sum of expenses of last 7 days should be returned', () async {
      final stream = database.transactionDao
          .watchLastWeeksTransactions()
          .map((event) => event.map((e) => e.sumAmount));

      final expectation = expectLater(
          stream,
          emitsAnyOf([
            [52, 10, 10],
            [42],
            []
          ]));

      final expectation2 =
          expectLater(stream, emits(hasLength(lessThanOrEqualTo(7))));

      await database.transactionDao.insertTransaction(onceTransactions[0]
          .copyWith(date: today().add(const Duration(days: -5))));
      await database.transactionDao.insertTransaction(onceTransactions[1]
          .copyWith(date: today().add(const Duration(days: -5))));
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: today().add(const Duration(days: -5)),
          until: today().add(const Duration(days: -3))));

      await expectation2;
      await expectation;
    });

    test('empty list if no expenses are present', () async {
      final stream = database.transactionDao
          .watchLastWeeksTransactions()
          .map((event) => event.map((e) => e.sumAmount));

      final expectation = expectLater(stream, emits(isEmpty));

      await database.transactionDao.insertTransaction(onceTransactions[0]
          .copyWith(date: today().add(const Duration(days: -5))));

      await expectation;
    });

    test('no date should be returned twice', () async {
      final stream = database.transactionDao
          .watchLastWeeksTransactions()
          .map((event) => event.map((e) => e.date).toList());

      stream.listen((o) {
        if (o.isNotEmpty) {
          expect(o, o.toSet().toList());
        }
      });

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: today().add(const Duration(days: -5)),
          until: today().add(const Duration(days: -3))));
      await database.transactionDao.insertTransaction(onceTransactions[0]
          .copyWith(date: today().add(const Duration(days: -5))));
      await database.transactionDao.insertTransaction(onceTransactions[1]
          .copyWith(date: today().add(const Duration(days: -5))));
    });

    test('latest date in list should be today', () async {
      final stream = database.transactionDao
          .watchLastWeeksTransactions()
          .map((event) => event.map((e) => DateTime.parse(e.date)).toList());

      stream.listen((o) {
        if (o.isNotEmpty) {
          final maxDate = o.reduce((a, b) => a.isAfter(b) ? a : b);
          expect(maxDate.difference(today()).inDays, greaterThanOrEqualTo(0));
        }
      });

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: today().add(const Duration(days: -1)),
          until: today().add(const Duration(days: 2))));
    });
  });

  group('transactionLabels', () {
    test('distinct expense labels only', () async {
      await database.transactionDao
          .insertTransaction(onceTransactions[1].copyWith(label: "Tested"));
      await database.transactionDao
          .insertTransaction(daily.copyWith(label: "Tested"));

      final res =
          await database.transactionDao.getTransactionsLabels(isExpense: true);

      expect(res, hasLength(equals(1)));
      expect(listEquals(res, res.toSet().toList()), true);
    });

    test('list should not contain empty labels', () async {
      await database.transactionDao
          .insertTransaction(onceTransactions[1].copyWith(label: "Tested"));
      await database.transactionDao
          .insertTransaction(daily.copyWith(label: ""));

      final res =
          await database.transactionDao.getTransactionsLabels(isExpense: true);

      expect(res, isNot(contains('')));
    });

    test('empty list if no expense transaction is present', () async {
      final res =
          await database.transactionDao.getTransactionsLabels(isExpense: true);

      expect(res, isEmpty);
    });

    test('labels should be in ascending order ', () async {
      await database.transactionDao
          .insertTransaction(onceTransactions[1].copyWith(label: "Foo"));
      await database.transactionDao
          .insertTransaction(daily.copyWith(label: "Bar"));

      final res =
          await database.transactionDao.getTransactionsLabels(isExpense: true);

      expect(res, equals(["Bar", "Foo"]));
    });
  });

  group("sumOfTransactionsByCategories", () {
    test('return unique categories', () async {
      final settings = TransactionFilterSettings();

      var stream = database.transactionDao
          .watchSumOfTransactionsByCategories(settings)
          .map((event) => event.map((e) => e.c.id).toList());

      stream = stream.skipWhile((element) => element.isEmpty);

      stream.listen((event) {
        expect(event, event.toSet().toList());
      });

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);
      await database.transactionDao.insertTransaction(
          daily.copyWith(subcategoryId: onceTransactions[1].subcategoryId));
    });

    test('consider filter settings by expenses', () async {
      final settings = TransactionFilterSettings.byExpense(isExpense: true);

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsInOrder([
            [42],
            [50, 42]
          ]));

      final expectation2 = expectLater(
          stream.map((e) => e
              .map((e) => e.c.isExpense)
              .fold(true, (bool previous, element) => previous && element)),
          emits(isTrue));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
      await expectation2;
    });

    test('consider filter settings by incomes', () async {
      final settings = TransactionFilterSettings.byIncome(isIncome: true);

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)), emits([100]));

      final expectation2 = expectLater(
          stream.map((e) => e
              .map((e) => !e.c.isExpense)
              .fold(true, (bool previous, element) => previous && element)),
          emits(isTrue));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
      await expectation2;
    });

    test('consider filter settings before date', () async {
      final settings =
          TransactionFilterSettings.beforeDate(DateTime(2021, 3, 23));

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsAnyOf([
            [42],
            [30, 42]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('consider filter settings by month', () async {
      await database.transactionDao.insertTransaction(onceTransactions[1]);

      final id =
          await database.monthDao.getMonthIdByDate(onceTransactions[1].date);

      final settings = TransactionFilterSettings.byMonth(id);

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsInOrder([
            [42],
            [20, 42],
          ]));

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by category', () async {
      final settings = TransactionFilterSettings.byCategory(3);

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsInOrder([
            [60]
          ]));

      final expectation2 = expectLater(
          stream.map((event) => event.map((e) => e.c.id)),
          emitsInOrder([
            [3]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
      await expectation2;
    });

    test('consider filter settings by subcategory', () async {
      final settings = TransactionFilterSettings.bySubcategory(12);

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsInOrder([
            [60]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by date', () async {
      final settings = TransactionFilterSettings.byDay(DateTime(2021, 3, 31));

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsAnyOf([
            [42, 10],
            [42],
          ]));

      await database.transactionDao.insertTransaction(
          onceTransactions[1].copyWith(date: DateTime(2021, 3, 31)));
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by only recurrences', () async {
      final settings = TransactionFilterSettings.onlyRecurrences();

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsInOrder([
            [60]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider combinations of filters', () async {
      final settings = TransactionFilterSettings(
        expenses: true,
        before: DateTime(2021, 3, 31),
      );

      var stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)),
          emitsAnyOf([
            [20, 42],
            [42],
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('income and expense block each other', () async {
      final settings = TransactionFilterSettings(
        expenses: true,
        incomes: true,
      );

      final stream =
          database.transactionDao.watchSumOfTransactionsByCategories(settings);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.sumAmount)), emits(isEmpty));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('throws exception without entering filter settings', () async {
      expect(
          () async =>
              database.transactionDao.watchSumOfTransactionsByCategories(null),
          throwsA(isInstanceOf<AssertionError>()));
    });
  });

  group("watchTransactionsWithFilter", () {
    test('consider filter settings by expenses', () async {
      final settings = TransactionFilterSettings.byExpense(isExpense: true);

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.id)),
          emitsInOrder([
            [2],
            [3, 3, 3, 3, 3, 2]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('consider filter settings by incomes', () async {
      final settings = TransactionFilterSettings.byIncome(isIncome: true);

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation =
          expectLater(stream.map((e) => e.map((e) => e.id)), emits([1]));

      await database.transactionDao.insertTransaction(onceTransactions[0]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('consider filter settings before date', () async {
      final settings =
          TransactionFilterSettings.beforeDate(DateTime(2021, 3, 23));

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [42],
            [42],
            [42],
            [42],
            [42],
            [10, 10, 10, 42],
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('consider filter settings by month', () async {
      await database.transactionDao.insertTransaction(onceTransactions[1]);

      final id =
          await database.monthDao.getMonthIdByDate(onceTransactions[1].date);

      final settings = TransactionFilterSettings.byMonth(id);

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [42],
            [10, 10, 42],
          ]));

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by category', () async {
      final settings = TransactionFilterSettings.byCategory(3);

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [10, 10, 10, 10, 10, 10]
          ]));

      final expectation2 = expectLater(
          stream.map((event) => event.map((e) => e.c.id)),
          emitsInOrder([
            [2, 2, 2, 2, 2, 2]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
      await expectation2;
    });

    test('consider filter settings by subcategory', () async {
      final settings = TransactionFilterSettings.bySubcategory(12);

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [10, 10, 10, 10, 10, 10]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by date', () async {
      final settings = TransactionFilterSettings.byDay(DateTime(2021, 3, 31));

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsAnyOf([
            [42, 10],
            [42],
          ]));

      await database.transactionDao.insertTransaction(
          onceTransactions[1].copyWith(date: DateTime(2021, 3, 31)));
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider filter settings by only recurrences', () async {
      final settings = TransactionFilterSettings.onlyRecurrences();

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [10, 10, 10, 10, 10, 10]
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('consider combinations of filters', () async {
      final settings = TransactionFilterSettings(
        expenses: true,
        before: DateTime(2021, 3, 31),
      );

      var stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      stream = stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)),
          emitsInOrder([
            [42],
            [42],
            [42],
            [42],
            [42],
            [10, 10, 42],
          ]));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 30), until: DateTime(2021, 4, 4)));

      await expectation;
    });

    test('income and expense block each other', () async {
      final settings = TransactionFilterSettings(
        expenses: true,
        incomes: true,
      );

      final stream =
          database.transactionDao.watchTransactionsWithFilter(settings);

      final expectation = expectLater(
          stream.map((e) => e.map((e) => e.amount)), emits(isEmpty));

      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(daily);

      await expectation;
    });

    test('descending order by date', () async {
      final settings = TransactionFilterSettings();

      var stream = database.transactionDao
          .watchTransactionsWithFilter(settings)
          .map((e) => e.map((e) => DateTime.parse(e.date)).toList());

      stream = stream.skipWhile((element) => element.isEmpty);

      stream.listen((event) {
        for (var i = 1; i < event.length; i++) {
          final prev = event[i - 1];
          final current = event[i];
          expect(current.isBeforeOrEqual(prev), isTrue);
        }
      });

      final expectation = expectLater(stream, emits(isNotEmpty));

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 15), until: DateTime(2021, 3, 20)));
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);

      await expectation;
    });

    test('descending order by id', () async {
      final settings = TransactionFilterSettings();

      var stream = database.transactionDao
          .watchTransactionsWithFilter(settings)
          .map((e) => e.map((e) => e.id).toList());

      stream = stream.skipWhile((element) => element.isEmpty);

      stream.listen((event) {
        for (var i = 1; i < event.length; i++) {
          final prev = event[i - 1];
          final current = event[i];
          expect(current <= prev, isTrue);
        }
      });

      final expectation = expectLater(stream, emits(isNotEmpty));

      await database.transactionDao.insertTransaction(daily.copyWith(
          date: DateTime(2021, 3, 15), until: DateTime(2021, 3, 20)));
      await database.transactionDao.insertTransaction(onceTransactions[1]);
      await database.transactionDao.insertTransaction(onceTransactions[1]);

      await expectation;
    });

    test('throws exception without entering filter settings', () async {
      expect(
          () async => database.transactionDao.watchTransactionsWithFilter(null),
          throwsA(isInstanceOf<AssertionError>()));
    });
  });

//   test('returning clause test', () async {
//     final date = DateTime(2021, 3, 15).toSql();
// //
// //     final res = await database.customSelect('''
// //         INSERT INTO months (firstDate, lastDate)
// // SELECT DATE($date, 'start of month'), DATE($date, 'start of month', '+1 month', '-1 day')
// // WHERE NOT EXISTS(SELECT firstDate, lastDate FROM months
// //     WHERE  firstDate <= DATE($date) AND lastDate >= DATE($date)) RETURNING id;''').getSingleOrNull();
//
//     final res = await database.monthDao.cr
//
//     print(res?.data);
//
//     final res2 = await database.monthDao.getAllMonths();
//
//     res2.forEach((element) => print(element.firstDate));
//   });
}

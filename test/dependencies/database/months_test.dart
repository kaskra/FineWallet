import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull, isNotNull;

import 'transactions_test.dart';

final m1 = MonthsCompanion.insert(
    firstDate: DateTime(2020, 5),
    lastDate: DateTime(2020, 5, 30),
    maxBudget: const Value(42));

void main() {
  testMonths();
}

void testMonths() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(e: VmDatabase.memory(logStatements: false));
  });
  tearDown(() async {
    await database.close();
  });

  group('insert, update and delete', () {
    test('insert month creates month in database', () async {
      final int id = await database.monthDao.insertMonth(m1);

      // 2 because, 1 is the current month inserted when creating database.
      expect(id, 2);

      final m = await database.monthDao.getMonthById(2);

      expect(m1.lastDate.value.isAtSameMomentAs(m.lastDate), isTrue);
    });

    test('insert month as null throws exception', () async {
      expect(database.monthDao.insertMonth(null),
          throwsA(isInstanceOf<InvalidDataException>()));
    });

    test('insert month that already exists throws exception', () async {
      final m = await database.monthDao.getCurrentMonth();

      expect(m.id, 1);

      expect(database.monthDao.insertMonth(m),
          throwsA(isInstanceOf<SqliteException>()));
    });

    test('update month changes month in database', () async {
      await database.monthDao.insertMonth(m1);

      final mBeforeUpdate = await database.monthDao.getMonthById(2);

      await database.monthDao
          .updateMonth(mBeforeUpdate.copyWith(maxBudget: 100));

      final mAfterUpdate = await database.monthDao.getMonthById(2);

      expect(mBeforeUpdate.maxBudget, isNot(mAfterUpdate.maxBudget));
    });

    test('update month as null throws exception', () async {
      // TODO fix with null-safety update?
      expect(database.monthDao.updateMonth(null),
          throwsA(isInstanceOf<NoSuchMethodError>()));
    });

    test('delete month removes month from table', () async {
      await database.monthDao.insertMonth(m1);

      final mBeforeUpdate = await database.monthDao.getMonthById(2);

      await database.monthDao.deleteMonth(mBeforeUpdate);

      final mAfterUpdate = await database.monthDao.getMonthById(2);

      expect(mAfterUpdate, isNull);
    });

    test('delete month from null throws exception', () async {
      try {
        await database.monthDao.deleteMonth(null);
      } catch (e) {
        expect(e, isInstanceOf<NoSuchMethodError>());
      }
    });
  });

  group('different get methods', () {
    test('get all months returns all month models ', () async {
      final id = await database.monthDao.insertMonth(m1);
      final res = await database.monthDao.getAllMonths();

      expect(res, hasLength(2));
      expect(res.first.id, id);
    });

    test('watch all months updates once tables sees changes', () async {
      final stream = database.monthDao
          .watchAllMonths()
          .map((event) => event.map((e) => e.id));

      stream.skipWhile((element) => element.isEmpty);

      final expectation = expectLater(
          stream,
          emitsInOrder([
            [1],
            [2, 1]
          ]));

      await database.monthDao.insertMonth(m1);

      await expectation;
    });

    test('get correct month with given id', () async {
      final id = await database.monthDao.insertMonth(m1);

      final m = await database.monthDao.getMonthById(id);

      expect(id, m.id);
      expect(m1.maxBudget.value, m.maxBudget);
      expect(m1.firstDate.value, m.firstDate);
      expect(m1.lastDate.value, m.lastDate);
    });

    test('get month returns null if no month with given id', () async {
      await database.monthDao.insertMonth(m1);

      final m = await database.monthDao.getMonthById(3);
      expect(m, isNull);
    });

    test('watch correct month with given id', () async {
      final id = await database.monthDao.insertMonth(m1);
      final stream =
          database.monthDao.watchMonthById(id).map((event) => event.id);

      final expectation = expectLater(stream, emits(2));

      await database.monthDao
          .updateMonth(m1.copyWith(id: Value(id), maxBudget: const Value(100)));

      await expectation;
    });

    test('watch month is null if no month with given id', () async {
      final stream = database.monthDao.watchMonthById(5);

      final expectation = expectLater(stream, emits(isNull));
      await expectation;
    });

    test('get correct month id with given date', () async {
      final id = await database.monthDao.insertMonth(m1);

      final mid =
          await database.monthDao.getMonthIdByDate(DateTime(2020, 5, 15));

      final m = await database.monthDao.getMonthById(mid);

      expect(id, m.id);
      expect(m1.maxBudget.value, m.maxBudget);
      expect(m1.firstDate.value, m.firstDate);
      expect(m1.lastDate.value, m.lastDate);
    });

    test('get month id returns null if no month found for date', () async {
      final mid =
          await database.monthDao.getMonthIdByDate(DateTime(2020, 7, 15));

      expect(mid, isNull);
    });

    test('get correct current month', () async {
      final td = today();
      final m = await database.monthDao.getCurrentMonth();

      expect(m.id, 1);
      expect(m.firstDate.isBeforeOrEqual(td), true);
      expect(m.lastDate.isAfter(td) || m.lastDate.isAtSameMomentAs(td), true);
    });

    test('get current month returns null if no month for today is found',
        () async {
      final mockClock = Clock.fixed(DateTime(2020, 5, 20));

      final m = await database.monthDao.getCurrentMonth(mockClock.now);

      expect(m, isNull);
    });

    test('watch correct current month updates once table sees changes',
        () async {
      final td = today();
      final stream = database.monthDao.watchCurrentMonth();

      final expectation =
          expectLater(stream.map((event) => event.id), emits(1));

      final expectation2 = expectLater(
          stream.map((event) =>
              event.firstDate.isBeforeOrEqual(td) &&
              td.isBeforeOrEqual(event.lastDate)),
          emits(true));

      await expectation;
      await expectation2;
    });

    test('watch current month returns null if no month for today date is found',
        () async {
      final mockClock = Clock.fixed(DateTime(2020, 5, 20));

      final stream = database.monthDao.watchCurrentMonth(mockClock.now);
      final expectation = expectLater(stream, emits(isNull));
      await expectation;
    });
  });

  group('syncMonthlyMaxBudget', () {
    test('max budget is capped by sum of income in month', () async {
      final id = await database.monthDao
          .insertMonth(m1.copyWith(maxBudget: const Value(150)));
      await database.transactionDao.insertTransaction(
          onceTransactions[0].copyWith(date: DateTime(2020, 5, 15)));

      await database.monthDao.restrictMaxBudgetByMonthlyIncome();

      final m = await database.monthDao.getMonthById(id);
      expect(m.maxBudget, 100);
    });

    test('max budget not capped if income sum is above max budget', () async {
      final id = await database.monthDao
          .insertMonth(m1.copyWith(maxBudget: const Value(75)));
      await database.transactionDao.insertTransaction(
          onceTransactions[0].copyWith(date: DateTime(2020, 5, 15)));

      await database.monthDao.restrictMaxBudgetByMonthlyIncome();

      final m = await database.monthDao.getMonthById(id);
      expect(m.maxBudget, 75);
    });

    test('max budget capped to zero if no income', () async {
      final id = await database.monthDao
          .insertMonth(m1.copyWith(maxBudget: const Value(100)));

      await database.monthDao.restrictMaxBudgetByMonthlyIncome();

      final m = await database.monthDao.getMonthById(id);
      expect(m.maxBudget, 0);
    });
  });

  group('checkForCurrentMonth', () {
    test('inserts current month correctly', () async {
      final currentMonth = await database.monthDao.getCurrentMonth();
      await database.monthDao.deleteMonth(currentMonth);

      final currentMonthAfterDelete = await database.monthDao.getCurrentMonth();
      expect(currentMonthAfterDelete, isNull);

      await database.monthDao.checkForCurrentMonth();

      final currentMonthAfterCheck = await database.monthDao.getCurrentMonth();

      expect(currentMonthAfterCheck, isNotNull);
      expect(today().isBeforeOrEqual(currentMonthAfterCheck.lastDate), isTrue);
      expect(currentMonthAfterCheck.firstDate.isBeforeOrEqual(today()), isTrue);
      expect(currentMonthAfterCheck.maxBudget, 0);
    });

    test('does not insert month if it already exists', () async {
      final currentMonthBeforeCheck = await database.monthDao.getCurrentMonth();

      await database.monthDao.checkForCurrentMonth();

      final currentMonthAfterCheck = await database.monthDao.getCurrentMonth();
      final res = await database.monthDao.getAllMonths();
      expect(res, hasLength(1));

      expect(currentMonthAfterCheck.lastDate, currentMonthBeforeCheck.lastDate);
      expect(
          currentMonthAfterCheck.firstDate, currentMonthBeforeCheck.firstDate);
      expect(
          currentMonthAfterCheck.maxBudget, currentMonthBeforeCheck.maxBudget);
    });
  });
}

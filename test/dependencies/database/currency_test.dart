import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull, isNotNull;

void main() {
  testCurrency();
}

void testCurrency() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(e: VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  test('retrieve all currencies gets list of correct length', () async {
    final res = await database.currencyDao.getAllCurrencies();

    expect(res, hasLength(33));
  });

  test('insert currency adds row in table', () async {
    final before = await database.currencyDao.getAllCurrencies();

    await database.currencyDao.insertCurrency(
        CurrenciesCompanion.insert(abbrev: "TEST", symbol: "€"));

    final after = await database.currencyDao.getAllCurrencies();

    expect(before.length + 1, after.length);
  });

  test('insert null throws exception', () async {
    final before = await database.currencyDao.getAllCurrencies();

    expect(database.currencyDao.insertCurrency(null),
        throwsA(isInstanceOf<InvalidDataException>()));

    final after = await database.currencyDao.getAllCurrencies();

    expect(before.length, after.length);
  });

  test('update currency changes row in table', () async {
    final before = await database.currencyDao.getAllCurrencies();

    final id = before.first.id;
    await database.currencyDao
        .updateCurrency(before.first.copyWith(abbrev: "TEST"));

    final after = await database.currencyDao.getAllCurrencies();
    final afterCurr = after.where((element) => element.id == id).single;
    expect(afterCurr.abbrev, equals("TEST"));
  });

  test('update null throws exception', () async {
    expect(database.currencyDao.updateCurrency(null), throwsA(isInstanceOf()));
  });

  test('delete currency removes row from table', () async {
    final before = await database.currencyDao.getAllCurrencies();

    final deletedRows = await database.currencyDao.deleteCurrency(before.first);

    final after = await database.currencyDao.getAllCurrencies();

    expect(deletedRows, equals(1));
    expect(before.length - 1, after.length);
  });

  test('delete null throws exception', () async {
    try {
      await database.currencyDao.deleteCurrency(null);
    } catch (e) {
      expect(true, isTrue);
      return;
    }
    expect(false, isTrue);
  });

  test('get currency by id returns correct currency', () async {
    final curr = await database.currencyDao.getCurrencyById(2);

    expect(curr.id, equals(2));
  });

  test('get currency by id with wrong id returns null', () async {
    final curr = await database.currencyDao.getCurrencyById(null);
    expect(curr, isNull);
  });

  test('user currency by id returns currency from user profile', () async {
    await database.addUserProfile(UserProfilesCompanion.insert(currencyId: 2));

    final userProfile = await database.getUserProfile();
    expect(userProfile, isNotNull);

    final userCurr = await database.currencyDao.getUserCurrency();
    expect(userCurr.id, equals(2));
  });

  test('user currency by id returns null if no user profile specified',
      () async {
    final userProfile = await database.getUserProfile();
    expect(userProfile, isNull);

    final userCurr = await database.currencyDao.getUserCurrency();
    expect(userCurr, isNull);
  });

  test('update exchange rates updates all rows that match the currencies list',
      () async {
    final allCurrencies = await database.currencyDao.getAllCurrencies();
    final currenciesToUpdate = allCurrencies.sublist(0, 3);
    final ids = currenciesToUpdate.map((e) => e.id).toList();

    expect(
        currenciesToUpdate
            .map((e) => e.exchangeRate)
            .any((double element) => element != 1.0),
        isFalse);

    final rates = {for (var e in allCurrencies) e.abbrev: 10.0};

    await database.currencyDao.updateExchangeRates(rates, currenciesToUpdate);

    final currenciesAfter = await database.currencyDao.getAllCurrencies();
    final updatedCurrenciesIds = currenciesAfter
        .where((element) => element.exchangeRate == 10.0)
        .map((e) => e.id)
        .toList();

    expect(ids, equals(updatedCurrenciesIds));
  });

  test('update exchange rates updates throws exception for null rates',
      () async {
    final allCurrencies = await database.currencyDao.getAllCurrencies();

    expect(database.currencyDao.updateExchangeRates(null, allCurrencies),
        throwsA(isInstanceOf<NoSuchMethodError>()));
  });

  test('update exchange rates updates does not update for null currencies',
      () async {
    final allCurrencies = await database.currencyDao.getAllCurrencies();
    final rates = {for (var e in allCurrencies) e.abbrev: 10.0};
    await database.currencyDao.updateExchangeRates(rates, null);
    final allCurrenciesAfter = await database.currencyDao.getAllCurrencies();

    expect(allCurrenciesAfter, equals(allCurrencies));
  });
}

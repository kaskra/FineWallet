// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CurrencyDaoMixin on DatabaseAccessor<AppDatabase> {
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Recurrences get recurrences => attachedDatabase.recurrences;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  Selectable<Currency> allCurrencies() {
    return customSelect('SELECT * FROM currencies ORDER BY abbrev ASC',
        variables: [], readsFrom: {currencies}).map(currencies.mapFromRow);
  }

  Selectable<Currency> currencyById(int id) {
    return customSelect('SELECT * FROM currencies WHERE id=:id',
        variables: [Variable<int>(id)],
        readsFrom: {currencies}).map(currencies.mapFromRow);
  }

  Selectable<Currency> userCurrency() {
    return customSelect(
        'SELECT currencies.* FROM currencies, userProfiles WHERE currencies.id = userProfiles.currencyId',
        variables: [],
        readsFrom: {currencies, userProfiles}).map(currencies.mapFromRow);
  }
}

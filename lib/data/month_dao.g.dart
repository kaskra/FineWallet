// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$MonthDaoMixin on DatabaseAccessor<AppDatabase> {
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  Selectable<Month> allMonths() {
    return customSelect('SELECT * FROM months ORDER BY firstDate ASC',
        variables: [], readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<int> monthIdByDate(DateTime date) {
    return customSelect(
        'SELECT id FROM months WHERE :date <= lastDate AND :date >= firstDate',
        variables: [Variable<DateTime>(date)],
        readsFrom: {months}).map((QueryRow row) => row.readInt('id'));
  }

  Selectable<Month> monthByDate(DateTime date) {
    return customSelect(
        'SELECT * FROM months WHERE :date <= lastDate AND :date >= firstDate',
        variables: [Variable<DateTime>(date)],
        readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<Month> monthById(int id) {
    return customSelect('SELECT * FROM months WHERE id=:id',
        variables: [Variable<int>(id)],
        readsFrom: {months}).map(months.mapFromRow);
  }
}

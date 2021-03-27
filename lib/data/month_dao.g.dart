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
  Selectable<Month> _allMonths() {
    return customSelect('SELECT * FROM months ORDER BY firstDate ASC',
        variables: [], readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<int> _monthIdByDate(String date) {
    return customSelect(
        'SELECT id FROM months WHERE :date <= lastDate AND :date >= firstDate',
        variables: [Variable<String>(date)],
        readsFrom: {months}).map((QueryRow row) => row.read<int>('id'));
  }

  Selectable<Month> _monthByDate(String date) {
    return customSelect(
        'SELECT * FROM months WHERE :date <= lastDate AND :date >= firstDate',
        variables: [Variable<String>(date)],
        readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<Month> _monthById(int id) {
    return customSelect('SELECT * FROM months WHERE id=:id',
        variables: [Variable<int>(id)],
        readsFrom: {months}).map(months.mapFromRow);
  }
}

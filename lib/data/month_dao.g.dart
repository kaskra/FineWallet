// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$MonthDaoMixin on DatabaseAccessor<AppDatabase> {
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Recurrences get recurrences => attachedDatabase.recurrences;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
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

  Future<int> cOgMonth(
      DateTime date, double maxBudget, DateTime firstDate, DateTime lastDate) {
    return customInsert(
      'INSERT INTO months (id, maxBudget, firstDate, lastDate) VALUES ((SELECT * FROM months WHERE :date <= lastDate AND :date >= firstDate) ,:maxBudget, :firstDate, :lastDate)',
      variables: [
        Variable<DateTime>(date),
        Variable<double>(maxBudget),
        Variable<DateTime>(firstDate),
        Variable<DateTime>(lastDate)
      ],
      updates: {months},
    );
  }
}

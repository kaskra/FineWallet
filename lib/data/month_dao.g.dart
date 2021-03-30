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
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  Selectable<Month> _allMonths() {
    return customSelect(
        'SELECT *\r\n    FROM months\r\n    ORDER BY firstDate ASC',
        variables: [],
        readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<int> _monthIdByDate(String date) {
    return customSelect(
        'SELECT id\r\n    FROM months\r\n    WHERE :date <= lastDate\r\n      AND :date >= firstDate',
        variables: [Variable<String>(date)],
        readsFrom: {months}).map((QueryRow row) => row.read<int>('id'));
  }

  Selectable<Month> _monthByDate(String date) {
    return customSelect(
        'SELECT *\r\n    FROM months\r\n    WHERE :date <= lastDate\r\n      AND :date >= firstDate',
        variables: [Variable<String>(date)],
        readsFrom: {months}).map(months.mapFromRow);
  }

  Selectable<Month> _monthById(int id) {
    return customSelect('SELECT *\r\n    FROM months\r\n    WHERE id = :id',
        variables: [Variable<int>(id)],
        readsFrom: {months}).map(months.mapFromRow);
  }

  Future<int> _syncMaxBudgetFromIncome() {
    return customUpdate(
      'WITH maxBudgets(monthId, budget) AS (SELECT m.id, IFNULL(SUM(amount),0)\r\n    FROM months m LEFT OUTER JOIN (SELECT * FROM fullTransactions WHERE NOT isExpense) t\r\n    ON m.id = t.monthId\r\n    GROUP BY m.id)\r\nUPDATE months\r\nSET maxBudget = (SELECT budget FROM maxBudgets WHERE months.id = monthId)\r\nWHERE EXISTS(SELECT budget FROM maxBudgets WHERE months.id = monthId)\r\n  AND maxBudget > (SELECT budget FROM maxBudgets WHERE months.id = monthId)',
      variables: [],
      updates: {months},
      updateKind: UpdateKind.update,
    );
  }

  Future<int> _insertCurrentMonthIfNotExists() {
    return customInsert(
      'INSERT INTO months (maxBudget, firstDate, lastDate)\r\n    SELECT 0, DATE(\'now\', \'start of month\'), DATE(\'now\', \'start of month\', \'+1 month\', \'-1 day\')\r\n    WHERE NOT EXISTS( SELECT * FROM months WHERE lastDate >= DATE(\'now\') AND firstDate <= DATE(\'now\'))',
      variables: [],
      updates: {months},
    );
  }
}

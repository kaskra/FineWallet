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

  Selectable<MonthWithDetails> _allMonthDetails(String date) {
    return customSelect(
        'WITH\r\n    income(monthid, amount) AS (SELECT monthId, IFNULL(SUM(amount),0) FROM fullTransactions WHERE NOT isExpense GROUP BY monthId),\r\n    expense(monthid, amount) AS (SELECT monthId, IFNULL(SUM(amount),0) FROM fullTransactions WHERE isExpense GROUP BY monthId)\r\nSELECT IFNULL(i.amount,0) AS income, IFNULL(e.amount,0) AS expense, (IFNULL(i.amount,0) - IFNULL(e.amount,0)) AS savings, "month"."id" AS "nested_0.id", "month"."maxBudget" AS "nested_0.maxBudget", "month"."firstDate" AS "nested_0.firstDate", "month"."lastDate" AS "nested_0.lastDate"\r\nFROM months month\r\nLEFT JOIN income i ON i.monthid = month.id\r\nLEFT JOIN expense e ON e.monthid = month.id\r\nWHERE :date >= month.firstDate\r\nORDER BY month.firstDate DESC',
        variables: [
          Variable<String>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) {
      return MonthWithDetails(
        income: row.read<double>('income'),
        expense: row.read<double>('expense'),
        savings: row.read<double>('savings'),
        month: months.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
      );
    });
  }

  Selectable<MonthWithDetails> _currentMonthDetails(String date) {
    return customSelect(
        'WITH\r\n    income(monthid, amount) AS (SELECT monthId, IFNULL(SUM(amount),0) FROM fullTransactions WHERE NOT isExpense GROUP BY monthId),\r\n    expense(monthid, amount) AS (SELECT monthId, IFNULL(SUM(amount),0) FROM fullTransactions WHERE isExpense GROUP BY monthId)\r\nSELECT IFNULL(i.amount,0) AS income, IFNULL(e.amount,0) AS expense, (IFNULL(i.amount,0) - IFNULL(e.amount,0)) AS savings, "month"."id" AS "nested_0.id", "month"."maxBudget" AS "nested_0.maxBudget", "month"."firstDate" AS "nested_0.firstDate", "month"."lastDate" AS "nested_0.lastDate"\r\nFROM months month\r\nLEFT JOIN income i ON i.monthid = month.id\r\n    LEFT JOIN expense e ON e.monthid = month.id\r\nWHERE :date >= month.firstDate AND :date <= month.lastDate\r\nORDER BY month.firstDate DESC',
        variables: [
          Variable<String>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) {
      return MonthWithDetails(
        income: row.read<double>('income'),
        expense: row.read<double>('expense'),
        savings: row.read<double>('savings'),
        month: months.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
      );
    });
  }
}

class MonthWithDetails {
  final double income;
  final double expense;
  final double savings;
  final Month month;
  MonthWithDetails({
    @required this.income,
    @required this.expense,
    @required this.savings,
    this.month,
  });
}

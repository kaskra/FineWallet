// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  Selectable<TransactionsResult> _transactions() {
    return customSelect('SELECT *\r\nFROM fullTransactions',
            variables: [],
            readsFrom: {baseTransactions, recurrenceTypes, months})
        .map((QueryRow row) {
      return TransactionsResult(
        id: row.read<int>('id'),
        amount: row.read<double>('amount'),
        originalAmount: row.read<double>('originalAmount'),
        exchangeRate: row.read<double>('exchangeRate'),
        isExpense: row.read<bool>('isExpense'),
        date: row.read<String>('date'),
        label: row.read<String>('label'),
        subcategoryId: row.read<int>('subcategoryId'),
        monthId: row.read<int>('monthId'),
        currencyId: row.read<int>('currencyId'),
        recurrenceType: row.read<int>('recurrenceType'),
        until:
            BaseTransactions.$converter1.mapToDart(row.read<String>('until')),
      );
    });
  }

  Selectable<BaseTransaction> _baseTransactions() {
    return customSelect('SELECT * FROM baseTransactions',
        variables: [],
        readsFrom: {baseTransactions}).map(baseTransactions.mapFromRow);
  }

  Selectable<BaseTransaction> _baseTransactionById(int id) {
    return customSelect('SELECT * FROM baseTransactions WHERE id=:id',
        variables: [Variable<int>(id)],
        readsFrom: {baseTransactions}).map(baseTransactions.mapFromRow);
  }

  Future<int> _deleteTxById(int id) {
    return customUpdate(
      'DELETE\r\nFROM baseTransactions\r\nWHERE id = :id',
      variables: [Variable<int>(id)],
      updates: {baseTransactions},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> _deleteTxsByIds(List<int> ids) {
    var $arrayStartIndex = 1;
    final expandedids = $expandVar($arrayStartIndex, ids.length);
    $arrayStartIndex += ids.length;
    return customUpdate(
      'DELETE\r\nFROM baseTransactions\r\nWHERE id IN ($expandedids)',
      variables: [for (var $ in ids) Variable<int>($)],
      updates: {baseTransactions},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<double> _totalSavings(String date) {
    return customSelect(
        'SELECT (SELECT ifnull(SUM(amount),0) FROM fullTransactions WHERE NOT isExpense AND date < m.firstDate) -\r\n    (SELECT ifnull(SUM(amount),0) FROM fullTransactions WHERE isExpense AND date < m.firstDate)\r\nFROM months m\r\nWHERE m.firstDate <= :date AND m.lastDate >= :date',
        variables: [
          Variable<String>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) => row.read<double>(
        '(SELECT ifnull(SUM(amount),0) FROM fullTransactions WHERE NOT isExpense AND date < m.firstDate) -\r\n    (SELECT ifnull(SUM(amount),0) FROM fullTransactions WHERE isExpense AND date < m.firstDate)'));
  }

  Selectable<TransactionWithDetails> _transactionsWithFilter(
      {Expression<bool> predicate = const CustomExpression('(TRUE)')}) {
    final generatedpredicate = $write(predicate, hasMultipleTables: true);
    return customSelect(
        'SELECT t.*, "cc"."id" AS "nested_0.id", "cc"."name" AS "nested_0.name", "cc"."isExpense" AS "nested_0.isExpense", "cc"."isPreset" AS "nested_0.isPreset", "cc"."iconCodePoint" AS "nested_0.iconCodePoint", "s"."id" AS "nested_1.id", "s"."name" AS "nested_1.name", "s"."categoryId" AS "nested_1.categoryId", "s"."isPreset" AS "nested_1.isPreset", "c"."id" AS "nested_2.id", "c"."abbrev" AS "nested_2.abbrev", "c"."symbol" AS "nested_2.symbol", "c"."exchangeRate" AS "nested_2.exchangeRate"\r\nFROM fullTransactions t,\r\n     categories cc,\r\n     subcategories s,\r\n     currencies c\r\nWHERE t.subcategoryId = s.id\r\n  AND t.currencyId = c.id\r\n  AND s.categoryId = cc.id\r\n  AND ${generatedpredicate.sql}\r\nORDER BY t.date DESC, t.id DESC',
        variables: [
          ...generatedpredicate.introducedVariables
        ],
        readsFrom: {
          categories,
          subcategories,
          currencies,
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return TransactionWithDetails(
        id: row.read<int>('id'),
        amount: row.read<double>('amount'),
        originalAmount: row.read<double>('originalAmount'),
        exchangeRate: row.read<double>('exchangeRate'),
        isExpense: row.read<bool>('isExpense'),
        date: row.read<String>('date'),
        label: row.read<String>('label'),
        subcategoryId: row.read<int>('subcategoryId'),
        monthId: row.read<int>('monthId'),
        currencyId: row.read<int>('currencyId'),
        recurrenceType: row.read<int>('recurrenceType'),
        until:
            BaseTransactions.$converter1.mapToDart(row.read<String>('until')),
        cc: categories.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
        s: subcategories.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        c: currencies.mapFromRowOrNull(row, tablePrefix: 'nested_2'),
      );
    });
  }

  Selectable<double> _monthlyIncome(String date) {
    return customSelect(
        'SELECT ifnull(SUM(t.amount),0) as income\r\nFROM fullTransactions t\r\nWHERE NOT t.isExpense\r\n  AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date)',
        variables: [
          Variable<String>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) => row.read<double>('income'));
  }

  Selectable<ExpensesPerDayInMonthResult> _expensesPerDayInMonth(
      String dateInMonth) {
    return customSelect(
        'SELECT t.date, ifnull(SUM(t.amount),0) AS expense\r\nFROM fullTransactions t\r\nWHERE t.isExpense\r\n  AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :dateInMonth AND m.lastDate >= :dateInMonth)\r\nGROUP BY t.date\r\nORDER BY t.date ASC',
        variables: [
          Variable<String>(dateInMonth)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) {
      return ExpensesPerDayInMonthResult(
        date: row.read<String>('date'),
        expense: row.read<double>('expense'),
      );
    });
  }

  Selectable<SumTransactionsByCategoryResult> _sumTransactionsByCategory(
      {Expression<bool> predicate = const CustomExpression('(TRUE)')}) {
    final generatedpredicate = $write(predicate, hasMultipleTables: true);
    return customSelect(
        'SELECT "c"."id" AS "nested_0.id", "c"."name" AS "nested_0.name", "c"."isExpense" AS "nested_0.isExpense", "c"."isPreset" AS "nested_0.isPreset", "c"."iconCodePoint" AS "nested_0.iconCodePoint", ifnull(SUM(t.amount),0) as sumAmount\r\nFROM fullTransactions t,\r\n     categories c,\r\n     subcategories s\r\nWHERE t.subcategoryId = s.id\r\n  AND s.categoryId = c.id\r\n  AND ${generatedpredicate.sql}\r\nGROUP BY c.id',
        variables: [
          ...generatedpredicate.introducedVariables
        ],
        readsFrom: {
          categories,
          subcategories,
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return SumTransactionsByCategoryResult(
        sumAmount: row.read<double>('sumAmount'),
        c: categories.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
      );
    });
  }

  Selectable<TransactionWithDetails> _nLatestTransactions(int N) {
    return customSelect(
        'SELECT t.*, "cc"."id" AS "nested_0.id", "cc"."name" AS "nested_0.name", "cc"."isExpense" AS "nested_0.isExpense", "cc"."isPreset" AS "nested_0.isPreset", "cc"."iconCodePoint" AS "nested_0.iconCodePoint", "s"."id" AS "nested_1.id", "s"."name" AS "nested_1.name", "s"."categoryId" AS "nested_1.categoryId", "s"."isPreset" AS "nested_1.isPreset", "c"."id" AS "nested_2.id", "c"."abbrev" AS "nested_2.abbrev", "c"."symbol" AS "nested_2.symbol", "c"."exchangeRate" AS "nested_2.exchangeRate"\r\nFROM fullTransactions t,\r\n     categories cc,\r\n     subcategories s,\r\n     currencies c\r\nWHERE t.subcategoryId = s.id\r\n  AND t.currencyId = c.id\r\n  AND s.categoryId = cc.id\r\nGROUP BY t.id HAVING MIN(t.id) -- hack to get the same output model as \'with filter\'. Take first of recurrences\r\nORDER BY t.id DESC LIMIT :N',
        variables: [
          Variable<int>(N)
        ],
        readsFrom: {
          categories,
          subcategories,
          currencies,
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return TransactionWithDetails(
        id: row.read<int>('id'),
        amount: row.read<double>('amount'),
        originalAmount: row.read<double>('originalAmount'),
        exchangeRate: row.read<double>('exchangeRate'),
        isExpense: row.read<bool>('isExpense'),
        date: row.read<String>('date'),
        label: row.read<String>('label'),
        subcategoryId: row.read<int>('subcategoryId'),
        monthId: row.read<int>('monthId'),
        currencyId: row.read<int>('currencyId'),
        recurrenceType: row.read<int>('recurrenceType'),
        until:
            BaseTransactions.$converter1.mapToDart(row.read<String>('until')),
        cc: categories.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
        s: subcategories.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        c: currencies.mapFromRowOrNull(row, tablePrefix: 'nested_2'),
      );
    });
  }

  Selectable<double> _monthlyBudget(String date) {
    return customSelect(
        'SELECT (SELECT m.maxBudget + m.savingsBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date) -\r\n       (SELECT ifnull(SUM(t.amount),0)\r\n        FROM fullTransactions t\r\n        WHERE t.isExpense\r\n          AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date))',
        variables: [
          Variable<String>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) => row.read<double>(
        '(SELECT m.maxBudget + m.savingsBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date) -\r\n       (SELECT ifnull(SUM(t.amount),0)\r\n        FROM fullTransactions t\r\n        WHERE t.isExpense\r\n          AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date))'));
  }

  Selectable<double> _dailyBudget(String date, int remainingDays) {
    return customSelect(
        'WITH\r\n    monthByDate(id, amount) AS (SELECT m.id, m.maxBudget + m.savingsBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date),\r\n    allExpenses(date, amount) AS (SELECT t.date, t.amount FROM fullTransactions t WHERE t.isExpense\r\n        AND t.monthId = (SELECT m.id FROM monthByDate m) AND (t.recurrenceType = 2 OR t.recurrenceType = 1)),\r\n    monthlyExpenses(amount) AS (SELECT ifnull(SUM(t.amount),0) FROM allExpenses t WHERE t.date != :date),\r\n    dayExpenses(amount) AS (SELECT ifnull(SUM(t.amount),0) FROM allExpenses t WHERE t.date = :date)\r\nSELECT (b.amount - m.amount) / :remainingDays - d.amount\r\nFROM monthByDate b,\r\n     monthlyExpenses m,\r\n     dayExpenses d',
        variables: [
          Variable<String>(date),
          Variable<int>(remainingDays)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) =>
        row.read<double>('(b.amount - m.amount) / :remainingDays - d.amount'));
  }

  Selectable<LastWeeksTransactionsResult> _lastWeeksTransactions() {
    return customSelect(
        'SELECT date, ifnull(SUM(amount),0) AS sumAmount\r\nFROM fullTransactions\r\nWHERE isExpense AND date > DATE(\'now\', \'-7 days\')\r\nGROUP BY date\r\n    LIMIT 7',
        variables: [],
        readsFrom: {
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return LastWeeksTransactionsResult(
        date: row.read<String>('date'),
        sumAmount: row.read<double>('sumAmount'),
      );
    });
  }

  Selectable<String> _transactionsLabels(bool isExpense) {
    return customSelect(
        'SELECT DISTINCT label\r\nFROM baseTransactions\r\nWHERE isExpense = :isExpense\r\n  AND NOT label = \'\'\r\nORDER BY label ASC',
        variables: [
          Variable<bool>(isExpense)
        ],
        readsFrom: {
          baseTransactions
        }).map((QueryRow row) => row.read<String>('label'));
  }
}

class TransactionsResult {
  final int id;
  final double amount;
  final double originalAmount;
  final double exchangeRate;
  final bool isExpense;
  final String date;
  final String label;
  final int subcategoryId;
  final int monthId;
  final int currencyId;
  final int recurrenceType;
  final DateTime until;
  TransactionsResult({
    @required this.id,
    @required this.amount,
    @required this.originalAmount,
    @required this.exchangeRate,
    @required this.isExpense,
    @required this.date,
    @required this.label,
    @required this.subcategoryId,
    @required this.monthId,
    @required this.currencyId,
    @required this.recurrenceType,
    this.until,
  });
}

class TransactionWithDetails {
  final int id;
  final double amount;
  final double originalAmount;
  final double exchangeRate;
  final bool isExpense;
  final String date;
  final String label;
  final int subcategoryId;
  final int monthId;
  final int currencyId;
  final int recurrenceType;
  final DateTime until;
  final Category cc;
  final Subcategory s;
  final Currency c;
  TransactionWithDetails({
    @required this.id,
    @required this.amount,
    @required this.originalAmount,
    @required this.exchangeRate,
    @required this.isExpense,
    @required this.date,
    @required this.label,
    @required this.subcategoryId,
    @required this.monthId,
    @required this.currencyId,
    @required this.recurrenceType,
    this.until,
    this.cc,
    this.s,
    this.c,
  });
}

class ExpensesPerDayInMonthResult {
  final String date;
  final double expense;
  ExpensesPerDayInMonthResult({
    @required this.date,
    @required this.expense,
  });
}

class SumTransactionsByCategoryResult {
  final double sumAmount;
  final Category c;
  SumTransactionsByCategoryResult({
    @required this.sumAmount,
    this.c,
  });
}

class LastWeeksTransactionsResult {
  final String date;
  final double sumAmount;
  LastWeeksTransactionsResult({
    @required this.date,
    @required this.sumAmount,
  });
}

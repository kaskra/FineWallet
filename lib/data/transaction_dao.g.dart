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
  Selectable<TransactionsResult> transactions() {
    return customSelect('SELECT * FROM fullTransactions',
            variables: [],
            readsFrom: {baseTransactions, recurrenceTypes, months})
        .map((QueryRow row) {
      return TransactionsResult(
        id: row.readInt('id'),
        amount: row.readDouble('amount'),
        originalAmount: row.readDouble('originalAmount'),
        exchangeRate: row.readDouble('exchangeRate'),
        isExpense: row.readBool('isExpense'),
        date: row.readString('date'),
        label: row.readString('label'),
        subcategoryId: row.readInt('subcategoryId'),
        monthId: row.readInt('monthId'),
        currencyId: row.readInt('currencyId'),
        recurrenceType: row.readInt('recurrenceType'),
        until: row.readString('until'),
        recurrenceName: row.readString('recurrenceName'),
      );
    });
  }

  Future<int> deleteTxById(int id) {
    return customUpdate(
      'DELETE FROM baseTransactions WHERE id=:id',
      variables: [Variable<int>(id)],
      updates: {baseTransactions},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> deleteTxsByIds(List<int> ids) {
    var $arrayStartIndex = 1;
    final expandedids = $expandVar($arrayStartIndex, ids.length);
    $arrayStartIndex += ids.length;
    return customUpdate(
      'DELETE FROM baseTransactions WHERE id IN ($expandedids)',
      variables: [for (var $ in ids) Variable<int>($)],
      updates: {baseTransactions},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<double> totalSavings(DateTime date) {
    return customSelect(
        'SELECT (SELECT SUM(amount) FROM fullTransactions WHERE NOT isExpense AND date < :date) - (SELECT SUM(amount) FROM fullTransactions WHERE isExpense AND date < :date)',
        variables: [
          Variable<DateTime>(date)
        ],
        readsFrom: {
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) => row.readDouble(
        '(SELECT SUM(amount) FROM fullTransactions WHERE NOT isExpense AND date < :date) - (SELECT SUM(amount) FROM fullTransactions WHERE isExpense AND date < :date)'));
  }

  Selectable<TransactionsWithFilterResult> transactionsWithFilter(
      {Expression<bool> predicate = const CustomExpression('(TRUE)')}) {
    final generatedpredicate = $write(predicate, hasMultipleTables: true);
    return customSelect(
        'SELECT t.*, "cc"."id" AS "nested_0.id", "cc"."name" AS "nested_0.name", "cc"."isExpense" AS "nested_0.isExpense", "cc"."isPreset" AS "nested_0.isPreset", "cc"."iconCodePoint" AS "nested_0.iconCodePoint", "s"."id" AS "nested_1.id", "s"."name" AS "nested_1.name", "s"."categoryId" AS "nested_1.categoryId", "s"."isPreset" AS "nested_1.isPreset", "c"."id" AS "nested_2.id", "c"."abbrev" AS "nested_2.abbrev", "c"."symbol" AS "nested_2.symbol", "c"."exchangeRate" AS "nested_2.exchangeRate"\r\n    FROM fullTransactions t, categories cc, subcategories s, currencies c\r\n    WHERE t.subcategoryId = s.id AND t.currencyId = c.id AND s.categoryId = cc.id AND ${generatedpredicate.sql}\r\n    ORDER BY t.date DESC, t.id DESC',
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
      return TransactionsWithFilterResult(
        id: row.readInt('id'),
        amount: row.readDouble('amount'),
        originalAmount: row.readDouble('originalAmount'),
        exchangeRate: row.readDouble('exchangeRate'),
        isExpense: row.readBool('isExpense'),
        date: row.readString('date'),
        label: row.readString('label'),
        subcategoryId: row.readInt('subcategoryId'),
        monthId: row.readInt('monthId'),
        currencyId: row.readInt('currencyId'),
        recurrenceType: row.readInt('recurrenceType'),
        until: row.readString('until'),
        recurrenceName: row.readString('recurrenceName'),
        cc: categories.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
        s: subcategories.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        c: currencies.mapFromRowOrNull(row, tablePrefix: 'nested_2'),
      );
    });
  }

  Selectable<double> monthlyIncome(DateTime date) {
    return customSelect(
        'SELECT SUM(t.amount) as income FROM fullTransactions t\r\n    WHERE NOT t.isExpense AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date)',
        variables: [
          Variable<DateTime>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) => row.readDouble('income'));
  }

  Selectable<ExpensesPerDayInMonthResult> expensesPerDayInMonth(
      DateTime dateInMonth) {
    return customSelect(
        'SELECT t.date, SUM(t.amount) AS expense FROM fullTransactions t\r\n    WHERE t.isExpense AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :dateInMonth AND m.lastDate >= :dateInMonth)\r\n    GROUP BY t.date\r\n    ORDER BY t.date ASC',
        variables: [
          Variable<DateTime>(dateInMonth)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) {
      return ExpensesPerDayInMonthResult(
        date: row.readString('date'),
        expense: row.readDouble('expense'),
      );
    });
  }

  Selectable<SumTransactionsByCategoryResult> sumTransactionsByCategory(
      {Expression<bool> predicate = const CustomExpression('(TRUE)')}) {
    final generatedpredicate = $write(predicate, hasMultipleTables: true);
    return customSelect(
        'SELECT "c"."id" AS "nested_0.id", "c"."name" AS "nested_0.name", "c"."isExpense" AS "nested_0.isExpense", "c"."isPreset" AS "nested_0.isPreset", "c"."iconCodePoint" AS "nested_0.iconCodePoint", SUM(amount) as sumAmount FROM fullTransactions t, categories c, subcategories s\r\n                           WHERE t.subcategoryId = s.id AND s.categoryId = c.id AND ${generatedpredicate.sql}\r\n                           GROUP BY c.id',
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
        sumAmount: row.readDouble('sumAmount'),
        c: categories.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
      );
    });
  }

  Selectable<NLatestTransactionsResult> nLatestTransactions(int N) {
    return customSelect(
        'SELECT "t"."id" AS "nested_0.id", "t"."amount" AS "nested_0.amount", "t"."originalAmount" AS "nested_0.originalAmount", "t"."exchangeRate" AS "nested_0.exchangeRate", "t"."isExpense" AS "nested_0.isExpense", "t"."date" AS "nested_0.date", "t"."label" AS "nested_0.label", "t"."subcategoryId" AS "nested_0.subcategoryId", "t"."monthId" AS "nested_0.monthId", "t"."currencyId" AS "nested_0.currencyId", "t"."recurrenceType" AS "nested_0.recurrenceType", "t"."until" AS "nested_0.until", "cc"."id" AS "nested_1.id", "cc"."name" AS "nested_1.name", "cc"."isExpense" AS "nested_1.isExpense", "cc"."isPreset" AS "nested_1.isPreset", "cc"."iconCodePoint" AS "nested_1.iconCodePoint", "s"."id" AS "nested_2.id", "s"."name" AS "nested_2.name", "s"."categoryId" AS "nested_2.categoryId", "s"."isPreset" AS "nested_2.isPreset", "c"."id" AS "nested_3.id", "c"."abbrev" AS "nested_3.abbrev", "c"."symbol" AS "nested_3.symbol", "c"."exchangeRate" AS "nested_3.exchangeRate" FROM baseTransactions t,categories cc, subcategories s, currencies c\r\n    WHERE t.subcategoryId = s.id AND t.currencyId = c.id AND s.categoryId = cc.id\r\n    ORDER BY t.id DESC LIMIT :N',
        variables: [
          Variable<int>(N)
        ],
        readsFrom: {
          baseTransactions,
          categories,
          subcategories,
          currencies
        }).map((QueryRow row) {
      return NLatestTransactionsResult(
        t: baseTransactions.mapFromRowOrNull(row, tablePrefix: 'nested_0'),
        cc: categories.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        s: subcategories.mapFromRowOrNull(row, tablePrefix: 'nested_2'),
        c: currencies.mapFromRowOrNull(row, tablePrefix: 'nested_3'),
      );
    });
  }

  Selectable<double> monthlyBudget(DateTime date) {
    return customSelect(
        'SELECT (SELECT m.maxBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date) -\r\n                      (SELECT SUM(amount) FROM fullTransactions t\r\n                      WHERE t.isExpense\r\n                        AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date))',
        variables: [
          Variable<DateTime>(date)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) => row.readDouble(
        '(SELECT m.maxBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date) -\r\n                      (SELECT SUM(amount) FROM fullTransactions t\r\n                      WHERE t.isExpense\r\n                        AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date))'));
  }

  Selectable<double> dailyBudget(DateTime date, int remainingDays) {
    return customSelect(
        'WITH\r\n    budget(amount) AS (SELECT m.maxBudget FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date),\r\n    monthlyExpenses(amount) AS (SELECT SUM(amount) FROM fullTransactions t WHERE t.isExpense\r\n        AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date)\r\n        AND t.date != :date AND (t.recurrenceType == 2 OR t.recurrenceType == 1)),\r\n    dailyExpenses(amount) AS (SELECT SUM(amount) FROM fullTransactions t WHERE t.isExpense\r\n        AND t.monthId = (SELECT m.id FROM months m WHERE m.firstDate <= :date AND m.lastDate >= :date)\r\n        AND t.date = :date AND (t.recurrenceType == 2 OR t.recurrenceType == 1))\r\n    SELECT (b.amount - m.amount) / :remainingDays - d.amount FROM budget b, monthlyExpenses m, dailyExpenses d',
        variables: [
          Variable<DateTime>(date),
          Variable<int>(remainingDays)
        ],
        readsFrom: {
          months,
          baseTransactions,
          recurrenceTypes
        }).map((QueryRow row) =>
        row.readDouble('(b.amount - m.amount) / :remainingDays - d.amount'));
  }

  Selectable<LastWeeksTransactionsResult> lastWeeksTransactions() {
    return customSelect(
        'SELECT date, SUM(amount) AS sumAmount FROM fullTransactions\r\n    WHERE isExpense AND date > DATE(\'now\', \'-7 days\')\r\n    GROUP BY date\r\n    LIMIT 7',
        variables: [],
        readsFrom: {
          baseTransactions,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return LastWeeksTransactionsResult(
        date: row.readString('date'),
        sumAmount: row.readDouble('sumAmount'),
      );
    });
  }

  Selectable<String> transactionsLabels(bool isExpense) {
    return customSelect(
        'SELECT DISTINCT label FROM baseTransactions\r\n    WHERE isExpense=:isExpense AND NOT label = \'\'\r\n    ORDER BY label ASC',
        variables: [
          Variable<bool>(isExpense)
        ],
        readsFrom: {
          baseTransactions
        }).map((QueryRow row) => row.readString('label'));
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
  final String until;
  final String recurrenceName;
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
    @required this.until,
    @required this.recurrenceName,
  });
}

class TransactionsWithFilterResult {
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
  final String until;
  final String recurrenceName;
  final Category cc;
  final Subcategory s;
  final Currency c;
  TransactionsWithFilterResult({
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
    @required this.until,
    @required this.recurrenceName,
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

class NLatestTransactionsResult {
  final BaseTransaction t;
  final Category cc;
  final Subcategory s;
  final Currency c;
  NLatestTransactionsResult({
    this.t,
    this.cc,
    this.s,
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

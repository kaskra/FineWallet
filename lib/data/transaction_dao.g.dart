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
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Recurrences get recurrences => attachedDatabase.recurrences;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  Selectable<TransactionsResult> transactions() {
    return customSelect('SELECT * FROM fullTransactions',
            variables: [],
            readsFrom: {baseTransactions, recurrences, recurrenceTypes, months})
        .map((QueryRow row) {
      return TransactionsResult(
        id: row.readInt('id'),
        amount: row.readDouble('amount'),
        originalAmount: row.readDouble('originalAmount'),
        exchangeRate: row.readDouble('exchangeRate'),
        isExpense: row.readBool('isExpense'),
        date: row.readDateTime('date'),
        label: row.readString('label'),
        subcategoryId: row.readInt('subcategoryId'),
        monthId: row.readInt('monthId'),
        currencyId: row.readInt('currencyId'),
        recurrenceType: row.readInt('recurrenceType'),
        until: row.readDateTime('until'),
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
          recurrences,
          recurrenceTypes,
          months
        }).map((QueryRow row) => row.readDouble(
        '(SELECT SUM(amount) FROM fullTransactions WHERE NOT isExpense AND date < :date) - (SELECT SUM(amount) FROM fullTransactions WHERE isExpense AND date < :date)'));
  }

  Selectable<TransactionsWithFilterResult> transactionsWithFilter() {
    return customSelect(
        'SELECT * FROM fullTransactions WHERE\r\n\r\n-- sumTransactionsByCategory:\r\n\r\nnLatestTransactions',
        variables: [],
        readsFrom: {
          baseTransactions,
          recurrences,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return TransactionsWithFilterResult(
        id: row.readInt('id'),
        amount: row.readDouble('amount'),
        originalAmount: row.readDouble('originalAmount'),
        exchangeRate: row.readDouble('exchangeRate'),
        isExpense: row.readBool('isExpense'),
        date: row.readDateTime('date'),
        label: row.readString('label'),
        subcategoryId: row.readInt('subcategoryId'),
        monthId: row.readInt('monthId'),
        currencyId: row.readInt('currencyId'),
        recurrenceType: row.readInt('recurrenceType'),
        until: row.readDateTime('until'),
        recurrenceName: row.readString('recurrenceName'),
      );
    });
  }

  Selectable<LastWeeksTransactionsResult> lastWeeksTransactions() {
    return customSelect(
        'SELECT date, SUM(amount) AS sumAmount FROM fullTransactions\r\n    WHERE isExpense AND date > DATE(\'now\', \'-7 days\')\r\n    GROUP BY date\r\n    LIMIT 7',
        variables: [],
        readsFrom: {
          baseTransactions,
          recurrences,
          recurrenceTypes,
          months
        }).map((QueryRow row) {
      return LastWeeksTransactionsResult(
        date: row.readDateTime('date'),
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
  final DateTime date;
  final String label;
  final int subcategoryId;
  final int monthId;
  final int currencyId;
  final int recurrenceType;
  final DateTime until;
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
  final DateTime date;
  final String label;
  final int subcategoryId;
  final int monthId;
  final int currencyId;
  final int recurrenceType;
  final DateTime until;
  final String recurrenceName;
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
  });
}

class LastWeeksTransactionsResult {
  final DateTime date;
  final double sumAmount;
  LastWeeksTransactionsResult({
    @required this.date,
    @required this.sumAmount,
  });
}

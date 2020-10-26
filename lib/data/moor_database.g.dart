// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final double amount;
  final double originalAmount;
  final double exchangeRate;
  final int subcategoryId;
  final int monthId;
  final DateTime date;
  final bool isExpense;
  final bool isRecurring;
  final int recurrenceType;
  final DateTime until;
  final int originalId;
  final int currencyId;
  final String label;

  Transaction(
      {@required this.id,
      @required this.amount,
      @required this.originalAmount,
      @required this.exchangeRate,
      @required this.subcategoryId,
      @required this.monthId,
      @required this.date,
      @required this.isExpense,
      @required this.isRecurring,
      this.recurrenceType,
      this.until,
      this.originalId,
      @required this.currencyId,
      @required this.label});

  factory Transaction.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Transaction(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      originalAmount: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}original_amount']),
      exchangeRate: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}exchange_rate']),
      subcategoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}subcategory_id']),
      monthId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}month_id']),
      date: $TransactionsTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}date'])),
      isExpense: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_expense']),
      isRecurring: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_recurring']),
      recurrenceType: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}recurrence_type']),
      until: $TransactionsTable.$converter1.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}until'])),
      originalId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}original_id']),
      currencyId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}currency_id']),
      label:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}label']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || originalAmount != null) {
      map['original_amount'] = Variable<double>(originalAmount);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    if (!nullToAbsent || subcategoryId != null) {
      map['subcategory_id'] = Variable<int>(subcategoryId);
    }
    if (!nullToAbsent || monthId != null) {
      map['month_id'] = Variable<int>(monthId);
    }
    if (!nullToAbsent || date != null) {
      final converter = $TransactionsTable.$converter0;
      map['date'] = Variable<String>(converter.mapToSql(date));
    }
    if (!nullToAbsent || isExpense != null) {
      map['is_expense'] = Variable<bool>(isExpense);
    }
    if (!nullToAbsent || isRecurring != null) {
      map['is_recurring'] = Variable<bool>(isRecurring);
    }
    if (!nullToAbsent || recurrenceType != null) {
      map['recurrence_type'] = Variable<int>(recurrenceType);
    }
    if (!nullToAbsent || until != null) {
      final converter = $TransactionsTable.$converter1;
      map['until'] = Variable<String>(converter.mapToSql(until));
    }
    if (!nullToAbsent || originalId != null) {
      map['original_id'] = Variable<int>(originalId);
    }
    if (!nullToAbsent || currencyId != null) {
      map['currency_id'] = Variable<int>(currencyId);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      originalAmount: originalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAmount),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      subcategoryId: subcategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategoryId),
      monthId: monthId == null && nullToAbsent
          ? const Value.absent()
          : Value(monthId),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      isExpense: isExpense == null && nullToAbsent
          ? const Value.absent()
          : Value(isExpense),
      isRecurring: isRecurring == null && nullToAbsent
          ? const Value.absent()
          : Value(isRecurring),
      recurrenceType: recurrenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceType),
      until:
          until == null && nullToAbsent ? const Value.absent() : Value(until),
      originalId: originalId == null && nullToAbsent
          ? const Value.absent()
          : Value(originalId),
      currencyId: currencyId == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyId),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      originalAmount: serializer.fromJson<double>(json['originalAmount']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      subcategoryId: serializer.fromJson<int>(json['subcategoryId']),
      monthId: serializer.fromJson<int>(json['monthId']),
      date: serializer.fromJson<DateTime>(json['date']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceType: serializer.fromJson<int>(json['recurrenceType']),
      until: serializer.fromJson<DateTime>(json['until']),
      originalId: serializer.fromJson<int>(json['originalId']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'originalAmount': serializer.toJson<double>(originalAmount),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'subcategoryId': serializer.toJson<int>(subcategoryId),
      'monthId': serializer.toJson<int>(monthId),
      'date': serializer.toJson<DateTime>(date),
      'isExpense': serializer.toJson<bool>(isExpense),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceType': serializer.toJson<int>(recurrenceType),
      'until': serializer.toJson<DateTime>(until),
      'originalId': serializer.toJson<int>(originalId),
      'currencyId': serializer.toJson<int>(currencyId),
      'label': serializer.toJson<String>(label),
    };
  }

  Transaction copyWith(
          {int id,
          double amount,
          double originalAmount,
          double exchangeRate,
          int subcategoryId,
          int monthId,
          DateTime date,
          bool isExpense,
          bool isRecurring,
          int recurrenceType,
          DateTime until,
          int originalId,
          int currencyId,
          String label}) =>
      Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        originalAmount: originalAmount ?? this.originalAmount,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        monthId: monthId ?? this.monthId,
        date: date ?? this.date,
        isExpense: isExpense ?? this.isExpense,
        isRecurring: isRecurring ?? this.isRecurring,
        recurrenceType: recurrenceType ?? this.recurrenceType,
        until: until ?? this.until,
        originalId: originalId ?? this.originalId,
        currencyId: currencyId ?? this.currencyId,
        label: label ?? this.label,
      );

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('monthId: $monthId, ')
          ..write('date: $date, ')
          ..write('isExpense: $isExpense, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('until: $until, ')
          ..write('originalId: $originalId, ')
          ..write('currencyId: $currencyId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          amount.hashCode,
          $mrjc(
              originalAmount.hashCode,
              $mrjc(
                  exchangeRate.hashCode,
                  $mrjc(
                      subcategoryId.hashCode,
                      $mrjc(
                          monthId.hashCode,
                          $mrjc(
                              date.hashCode,
                              $mrjc(
                                  isExpense.hashCode,
                                  $mrjc(
                                      isRecurring.hashCode,
                                      $mrjc(
                                          recurrenceType.hashCode,
                                          $mrjc(
                                              until.hashCode,
                                              $mrjc(
                                                  originalId.hashCode,
                                                  $mrjc(
                                                      currencyId.hashCode,
                                                      label
                                                          .hashCode))))))))))))));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.originalAmount == this.originalAmount &&
          other.exchangeRate == this.exchangeRate &&
          other.subcategoryId == this.subcategoryId &&
          other.monthId == this.monthId &&
          other.date == this.date &&
          other.isExpense == this.isExpense &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceType == this.recurrenceType &&
          other.until == this.until &&
          other.originalId == this.originalId &&
          other.currencyId == this.currencyId &&
          other.label == this.label);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<double> originalAmount;
  final Value<double> exchangeRate;
  final Value<int> subcategoryId;
  final Value<int> monthId;
  final Value<DateTime> date;
  final Value<bool> isExpense;
  final Value<bool> isRecurring;
  final Value<int> recurrenceType;
  final Value<DateTime> until;
  final Value<int> originalId;
  final Value<int> currencyId;
  final Value<String> label;

  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.monthId = const Value.absent(),
    this.date = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.until = const Value.absent(),
    this.originalId = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.label = const Value.absent(),
  });

  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    @required double amount,
    @required double originalAmount,
    @required double exchangeRate,
    @required int subcategoryId,
    @required int monthId,
    @required DateTime date,
    @required bool isExpense,
    this.isRecurring = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.until = const Value.absent(),
    this.originalId = const Value.absent(),
    @required int currencyId,
    @required String label,
  })  : amount = Value(amount),
        originalAmount = Value(originalAmount),
        exchangeRate = Value(exchangeRate),
        subcategoryId = Value(subcategoryId),
        monthId = Value(monthId),
        date = Value(date),
        isExpense = Value(isExpense),
        currencyId = Value(currencyId),
        label = Value(label);

  static Insertable<Transaction> custom({
    Expression<int> id,
    Expression<double> amount,
    Expression<double> originalAmount,
    Expression<double> exchangeRate,
    Expression<int> subcategoryId,
    Expression<int> monthId,
    Expression<String> date,
    Expression<bool> isExpense,
    Expression<bool> isRecurring,
    Expression<int> recurrenceType,
    Expression<String> until,
    Expression<int> originalId,
    Expression<int> currencyId,
    Expression<String> label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (monthId != null) 'month_id': monthId,
      if (date != null) 'date': date,
      if (isExpense != null) 'is_expense': isExpense,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceType != null) 'recurrence_type': recurrenceType,
      if (until != null) 'until': until,
      if (originalId != null) 'original_id': originalId,
      if (currencyId != null) 'currency_id': currencyId,
      if (label != null) 'label': label,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int> id,
      Value<double> amount,
      Value<double> originalAmount,
      Value<double> exchangeRate,
      Value<int> subcategoryId,
      Value<int> monthId,
      Value<DateTime> date,
      Value<bool> isExpense,
      Value<bool> isRecurring,
      Value<int> recurrenceType,
      Value<DateTime> until,
      Value<int> originalId,
      Value<int> currencyId,
      Value<String> label}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      originalAmount: originalAmount ?? this.originalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      monthId: monthId ?? this.monthId,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      until: until ?? this.until,
      originalId: originalId ?? this.originalId,
      currencyId: currencyId ?? this.currencyId,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (originalAmount.present) {
      map['original_amount'] = Variable<double>(originalAmount.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<int>(subcategoryId.value);
    }
    if (monthId.present) {
      map['month_id'] = Variable<int>(monthId.value);
    }
    if (date.present) {
      final converter = $TransactionsTable.$converter0;
      map['date'] = Variable<String>(converter.mapToSql(date.value));
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceType.present) {
      map['recurrence_type'] = Variable<int>(recurrenceType.value);
    }
    if (until.present) {
      final converter = $TransactionsTable.$converter1;
      map['until'] = Variable<String>(converter.mapToSql(until.value));
    }
    if (originalId.present) {
      map['original_id'] = Variable<int>(originalId.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('monthId: $monthId, ')
          ..write('date: $date, ')
          ..write('isExpense: $isExpense, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('until: $until, ')
          ..write('originalId: $originalId, ')
          ..write('currencyId: $currencyId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  final GeneratedDatabase _db;
  final String _alias;

  $TransactionsTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;

  @override
  GeneratedRealColumn get amount => _amount ??= _constructAmount();

  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn('amount', $tableName, false,
        $customConstraints: 'CHECK (amount > 0)');
  }

  final VerificationMeta _originalAmountMeta =
      const VerificationMeta('originalAmount');
  GeneratedRealColumn _originalAmount;

  @override
  GeneratedRealColumn get originalAmount =>
      _originalAmount ??= _constructOriginalAmount();

  GeneratedRealColumn _constructOriginalAmount() {
    return GeneratedRealColumn('original_amount', $tableName, false,
        $customConstraints: 'CHECK (amount > 0)');
  }

  final VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  GeneratedRealColumn _exchangeRate;

  @override
  GeneratedRealColumn get exchangeRate =>
      _exchangeRate ??= _constructExchangeRate();

  GeneratedRealColumn _constructExchangeRate() {
    return GeneratedRealColumn(
      'exchange_rate',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subcategoryIdMeta =
      const VerificationMeta('subcategoryId');
  GeneratedIntColumn _subcategoryId;

  @override
  GeneratedIntColumn get subcategoryId =>
      _subcategoryId ??= _constructSubcategoryId();

  GeneratedIntColumn _constructSubcategoryId() {
    return GeneratedIntColumn('subcategory_id', $tableName, false,
        $customConstraints: 'REFERENCES subcategories(id)');
  }

  final VerificationMeta _monthIdMeta = const VerificationMeta('monthId');
  GeneratedIntColumn _monthId;

  @override
  GeneratedIntColumn get monthId => _monthId ??= _constructMonthId();

  GeneratedIntColumn _constructMonthId() {
    return GeneratedIntColumn('month_id', $tableName, false,
        $customConstraints: 'REFERENCES months(id)');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;

  @override
  GeneratedTextColumn get date => _date ??= _constructDate();

  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  GeneratedBoolColumn _isExpense;

  @override
  GeneratedBoolColumn get isExpense => _isExpense ??= _constructIsExpense();

  GeneratedBoolColumn _constructIsExpense() {
    return GeneratedBoolColumn(
      'is_expense',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  GeneratedBoolColumn _isRecurring;

  @override
  GeneratedBoolColumn get isRecurring =>
      _isRecurring ??= _constructIsRecurring();

  GeneratedBoolColumn _constructIsRecurring() {
    return GeneratedBoolColumn('is_recurring', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _recurrenceTypeMeta =
      const VerificationMeta('recurrenceType');
  GeneratedIntColumn _recurrenceType;

  @override
  GeneratedIntColumn get recurrenceType =>
      _recurrenceType ??= _constructRecurrenceType();

  GeneratedIntColumn _constructRecurrenceType() {
    return GeneratedIntColumn('recurrence_type', $tableName, true,
        $customConstraints: 'NULL REFERENCES recurrence_types(type)');
  }

  final VerificationMeta _untilMeta = const VerificationMeta('until');
  GeneratedTextColumn _until;

  @override
  GeneratedTextColumn get until => _until ??= _constructUntil();

  GeneratedTextColumn _constructUntil() {
    return GeneratedTextColumn(
      'until',
      $tableName,
      true,
    );
  }

  final VerificationMeta _originalIdMeta = const VerificationMeta('originalId');
  GeneratedIntColumn _originalId;

  @override
  GeneratedIntColumn get originalId => _originalId ??= _constructOriginalId();

  GeneratedIntColumn _constructOriginalId() {
    return GeneratedIntColumn('original_id', $tableName, true,
        $customConstraints: 'NULL REFERENCES transactions(id)');
  }

  final VerificationMeta _currencyIdMeta = const VerificationMeta('currencyId');
  GeneratedIntColumn _currencyId;

  @override
  GeneratedIntColumn get currencyId => _currencyId ??= _constructCurrencyId();

  GeneratedIntColumn _constructCurrencyId() {
    return GeneratedIntColumn('currency_id', $tableName, false,
        $customConstraints: 'REFERENCES currencies(id)');
  }

  final VerificationMeta _labelMeta = const VerificationMeta('label');
  GeneratedTextColumn _label;

  @override
  GeneratedTextColumn get label => _label ??= _constructLabel();

  GeneratedTextColumn _constructLabel() {
    return GeneratedTextColumn('label', $tableName, false,
        minTextLength: 0, maxTextLength: 256);
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        originalAmount,
        exchangeRate,
        subcategoryId,
        monthId,
        date,
        isExpense,
        isRecurring,
        recurrenceType,
        until,
        originalId,
        currencyId,
        label
      ];

  @override
  $TransactionsTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'transactions';
  @override
  final String actualTableName = 'transactions';

  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount'], _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('original_amount')) {
      context.handle(
          _originalAmountMeta,
          originalAmount.isAcceptableOrUnknown(
              data['original_amount'], _originalAmountMeta));
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate'], _exchangeRateMeta));
    } else if (isInserting) {
      context.missing(_exchangeRateMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
          _subcategoryIdMeta,
          subcategoryId.isAcceptableOrUnknown(
              data['subcategory_id'], _subcategoryIdMeta));
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (data.containsKey('month_id')) {
      context.handle(_monthIdMeta,
          monthId.isAcceptableOrUnknown(data['month_id'], _monthIdMeta));
    } else if (isInserting) {
      context.missing(_monthIdMeta);
    }
    context.handle(_dateMeta, const VerificationResult.success());
    if (data.containsKey('is_expense')) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableOrUnknown(data['is_expense'], _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring'], _isRecurringMeta));
    }
    if (data.containsKey('recurrence_type')) {
      context.handle(
          _recurrenceTypeMeta,
          recurrenceType.isAcceptableOrUnknown(
              data['recurrence_type'], _recurrenceTypeMeta));
    }
    context.handle(_untilMeta, const VerificationResult.success());
    if (data.containsKey('original_id')) {
      context.handle(
          _originalIdMeta,
          originalId.isAcceptableOrUnknown(
              data['original_id'], _originalIdMeta));
    }
    if (data.containsKey('currency_id')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currency_id'], _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label'], _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Transaction map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Transaction.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 =
      const DateTimeConverter();
  static TypeConverter<DateTime, String> $converter1 =
      const DateTimeConverter();
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final bool isExpense;
  final bool isPreset;

  Category(
      {@required this.id,
      @required this.name,
      @required this.isExpense,
      @required this.isPreset});

  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isExpense: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_expense']),
      isPreset:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_preset']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isExpense != null) {
      map['is_expense'] = Variable<bool>(isExpense);
    }
    if (!nullToAbsent || isPreset != null) {
      map['is_preset'] = Variable<bool>(isPreset);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isExpense: isExpense == null && nullToAbsent
          ? const Value.absent()
          : Value(isExpense),
      isPreset: isPreset == null && nullToAbsent
          ? const Value.absent()
          : Value(isPreset),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isExpense': serializer.toJson<bool>(isExpense),
      'isPreset': serializer.toJson<bool>(isPreset),
    };
  }

  Category copyWith({int id, String name, bool isExpense, bool isPreset}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        isExpense: isExpense ?? this.isExpense,
        isPreset: isPreset ?? this.isPreset,
      );

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isExpense: $isExpense, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(isExpense.hashCode, isPreset.hashCode))));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.isExpense == this.isExpense &&
          other.isPreset == this.isPreset);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isExpense;
  final Value<bool> isPreset;

  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.isPreset = const Value.absent(),
  });

  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isExpense = const Value.absent(),
    this.isPreset = const Value.absent(),
  }) : name = Value(name);

  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<bool> isExpense,
    Expression<bool> isPreset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isExpense != null) 'is_expense': isExpense,
      if (isPreset != null) 'is_preset': isPreset,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<bool> isExpense,
      Value<bool> isPreset}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isExpense: isExpense ?? this.isExpense,
      isPreset: isPreset ?? this.isPreset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isExpense: $isExpense, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String _alias;

  $CategoriesTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;

  @override
  GeneratedTextColumn get name => _name ??= _constructName();

  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 20);
  }

  final VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  GeneratedBoolColumn _isExpense;

  @override
  GeneratedBoolColumn get isExpense => _isExpense ??= _constructIsExpense();

  GeneratedBoolColumn _constructIsExpense() {
    return GeneratedBoolColumn('is_expense', $tableName, false,
        defaultValue: const Constant(true));
  }

  final VerificationMeta _isPresetMeta = const VerificationMeta('isPreset');
  GeneratedBoolColumn _isPreset;

  @override
  GeneratedBoolColumn get isPreset => _isPreset ??= _constructIsPreset();

  GeneratedBoolColumn _constructIsPreset() {
    return GeneratedBoolColumn('is_preset', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, isExpense, isPreset];

  @override
  $CategoriesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';

  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_expense')) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableOrUnknown(data['is_expense'], _isExpenseMeta));
    }
    if (data.containsKey('is_preset')) {
      context.handle(_isPresetMeta,
          isPreset.isAcceptableOrUnknown(data['is_preset'], _isPresetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

class Subcategory extends DataClass implements Insertable<Subcategory> {
  final int id;
  final String name;
  final int categoryId;
  final bool isPreset;

  Subcategory(
      {@required this.id,
      @required this.name,
      @required this.categoryId,
      @required this.isPreset});

  factory Subcategory.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Subcategory(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      isPreset:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_preset']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || isPreset != null) {
      map['is_preset'] = Variable<bool>(isPreset);
    }
    return map;
  }

  SubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubcategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isPreset: isPreset == null && nullToAbsent
          ? const Value.absent()
          : Value(isPreset),
    );
  }

  factory Subcategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Subcategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'isPreset': serializer.toJson<bool>(isPreset),
    };
  }

  Subcategory copyWith({int id, String name, int categoryId, bool isPreset}) =>
      Subcategory(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        isPreset: isPreset ?? this.isPreset,
      );

  @override
  String toString() {
    return (StringBuffer('Subcategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(categoryId.hashCode, isPreset.hashCode))));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Subcategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.isPreset == this.isPreset);
}

class SubcategoriesCompanion extends UpdateCompanion<Subcategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<bool> isPreset;

  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isPreset = const Value.absent(),
  });

  SubcategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int categoryId,
    this.isPreset = const Value.absent(),
  })  : name = Value(name),
        categoryId = Value(categoryId);

  static Insertable<Subcategory> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> categoryId,
    Expression<bool> isPreset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (isPreset != null) 'is_preset': isPreset,
    });
  }

  SubcategoriesCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> categoryId,
      Value<bool> isPreset}) {
    return SubcategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      isPreset: isPreset ?? this.isPreset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }
}

class $SubcategoriesTable extends Subcategories
    with TableInfo<$SubcategoriesTable, Subcategory> {
  final GeneratedDatabase _db;
  final String _alias;

  $SubcategoriesTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;

  @override
  GeneratedTextColumn get name => _name ??= _constructName();

  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 30);
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;

  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();

  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('category_id', $tableName, false,
        $customConstraints: 'REFERENCES categories(id)');
  }

  final VerificationMeta _isPresetMeta = const VerificationMeta('isPreset');
  GeneratedBoolColumn _isPreset;

  @override
  GeneratedBoolColumn get isPreset => _isPreset ??= _constructIsPreset();

  GeneratedBoolColumn _constructIsPreset() {
    return GeneratedBoolColumn('is_preset', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId, isPreset];

  @override
  $SubcategoriesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'subcategories';
  @override
  final String actualTableName = 'subcategories';

  @override
  VerificationContext validateIntegrity(Insertable<Subcategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('is_preset')) {
      context.handle(_isPresetMeta,
          isPreset.isAcceptableOrUnknown(data['is_preset'], _isPresetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Subcategory map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Subcategory.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubcategoriesTable createAlias(String alias) {
    return $SubcategoriesTable(_db, alias);
  }
}

class Month extends DataClass implements Insertable<Month> {
  final int id;
  final double maxBudget;
  final DateTime firstDate;
  final DateTime lastDate;

  Month(
      {@required this.id,
      @required this.maxBudget,
      @required this.firstDate,
      @required this.lastDate});

  factory Month.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final stringType = db.typeSystem.forDartType<String>();
    return Month(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      maxBudget: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}max_budget']),
      firstDate: $MonthsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_date'])),
      lastDate: $MonthsTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_date'])),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || maxBudget != null) {
      map['max_budget'] = Variable<double>(maxBudget);
    }
    if (!nullToAbsent || firstDate != null) {
      final converter = $MonthsTable.$converter0;
      map['first_date'] = Variable<String>(converter.mapToSql(firstDate));
    }
    if (!nullToAbsent || lastDate != null) {
      final converter = $MonthsTable.$converter1;
      map['last_date'] = Variable<String>(converter.mapToSql(lastDate));
    }
    return map;
  }

  MonthsCompanion toCompanion(bool nullToAbsent) {
    return MonthsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      maxBudget: maxBudget == null && nullToAbsent
          ? const Value.absent()
          : Value(maxBudget),
      firstDate: firstDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firstDate),
      lastDate: lastDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDate),
    );
  }

  factory Month.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Month(
      id: serializer.fromJson<int>(json['id']),
      maxBudget: serializer.fromJson<double>(json['maxBudget']),
      firstDate: serializer.fromJson<DateTime>(json['firstDate']),
      lastDate: serializer.fromJson<DateTime>(json['lastDate']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maxBudget': serializer.toJson<double>(maxBudget),
      'firstDate': serializer.toJson<DateTime>(firstDate),
      'lastDate': serializer.toJson<DateTime>(lastDate),
    };
  }

  Month copyWith(
          {int id, double maxBudget, DateTime firstDate, DateTime lastDate}) =>
      Month(
        id: id ?? this.id,
        maxBudget: maxBudget ?? this.maxBudget,
        firstDate: firstDate ?? this.firstDate,
        lastDate: lastDate ?? this.lastDate,
      );

  @override
  String toString() {
    return (StringBuffer('Month(')
          ..write('id: $id, ')
          ..write('maxBudget: $maxBudget, ')
          ..write('firstDate: $firstDate, ')
          ..write('lastDate: $lastDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(maxBudget.hashCode, $mrjc(firstDate.hashCode, lastDate.hashCode))));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Month &&
          other.id == this.id &&
          other.maxBudget == this.maxBudget &&
          other.firstDate == this.firstDate &&
          other.lastDate == this.lastDate);
}

class MonthsCompanion extends UpdateCompanion<Month> {
  final Value<int> id;
  final Value<double> maxBudget;
  final Value<DateTime> firstDate;
  final Value<DateTime> lastDate;

  const MonthsCompanion({
    this.id = const Value.absent(),
    this.maxBudget = const Value.absent(),
    this.firstDate = const Value.absent(),
    this.lastDate = const Value.absent(),
  });

  MonthsCompanion.insert({
    this.id = const Value.absent(),
    @required double maxBudget,
    @required DateTime firstDate,
    @required DateTime lastDate,
  })  : maxBudget = Value(maxBudget),
        firstDate = Value(firstDate),
        lastDate = Value(lastDate);

  static Insertable<Month> custom({
    Expression<int> id,
    Expression<double> maxBudget,
    Expression<String> firstDate,
    Expression<String> lastDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maxBudget != null) 'max_budget': maxBudget,
      if (firstDate != null) 'first_date': firstDate,
      if (lastDate != null) 'last_date': lastDate,
    });
  }

  MonthsCompanion copyWith(
      {Value<int> id,
      Value<double> maxBudget,
      Value<DateTime> firstDate,
      Value<DateTime> lastDate}) {
    return MonthsCompanion(
      id: id ?? this.id,
      maxBudget: maxBudget ?? this.maxBudget,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maxBudget.present) {
      map['max_budget'] = Variable<double>(maxBudget.value);
    }
    if (firstDate.present) {
      final converter = $MonthsTable.$converter0;
      map['first_date'] = Variable<String>(converter.mapToSql(firstDate.value));
    }
    if (lastDate.present) {
      final converter = $MonthsTable.$converter1;
      map['last_date'] = Variable<String>(converter.mapToSql(lastDate.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthsCompanion(')
          ..write('id: $id, ')
          ..write('maxBudget: $maxBudget, ')
          ..write('firstDate: $firstDate, ')
          ..write('lastDate: $lastDate')
          ..write(')'))
        .toString();
  }
}

class $MonthsTable extends Months with TableInfo<$MonthsTable, Month> {
  final GeneratedDatabase _db;
  final String _alias;

  $MonthsTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _maxBudgetMeta = const VerificationMeta('maxBudget');
  GeneratedRealColumn _maxBudget;

  @override
  GeneratedRealColumn get maxBudget => _maxBudget ??= _constructMaxBudget();

  GeneratedRealColumn _constructMaxBudget() {
    return GeneratedRealColumn('max_budget', $tableName, false,
        $customConstraints: 'CHECK (max_budget >= 0)');
  }

  final VerificationMeta _firstDateMeta = const VerificationMeta('firstDate');
  GeneratedTextColumn _firstDate;

  @override
  GeneratedTextColumn get firstDate => _firstDate ??= _constructFirstDate();

  GeneratedTextColumn _constructFirstDate() {
    return GeneratedTextColumn(
      'first_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastDateMeta = const VerificationMeta('lastDate');
  GeneratedTextColumn _lastDate;

  @override
  GeneratedTextColumn get lastDate => _lastDate ??= _constructLastDate();

  GeneratedTextColumn _constructLastDate() {
    return GeneratedTextColumn(
      'last_date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, maxBudget, firstDate, lastDate];

  @override
  $MonthsTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'months';
  @override
  final String actualTableName = 'months';

  @override
  VerificationContext validateIntegrity(Insertable<Month> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('max_budget')) {
      context.handle(_maxBudgetMeta,
          maxBudget.isAcceptableOrUnknown(data['max_budget'], _maxBudgetMeta));
    } else if (isInserting) {
      context.missing(_maxBudgetMeta);
    }
    context.handle(_firstDateMeta, const VerificationResult.success());
    context.handle(_lastDateMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Month map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Month.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $MonthsTable createAlias(String alias) {
    return $MonthsTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 =
      const DateTimeConverter();
  static TypeConverter<DateTime, String> $converter1 =
      const DateTimeConverter();
}

class RecurrenceType extends DataClass implements Insertable<RecurrenceType> {
  final int type;
  final String name;

  RecurrenceType({@required this.type, @required this.name});

  factory RecurrenceType.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return RecurrenceType(
      type: intType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  RecurrenceTypesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceTypesCompanion(
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory RecurrenceType.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RecurrenceType(
      type: serializer.fromJson<int>(json['type']),
      name: serializer.fromJson<String>(json['name']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<int>(type),
      'name': serializer.toJson<String>(name),
    };
  }

  RecurrenceType copyWith({int type, String name}) => RecurrenceType(
        type: type ?? this.type,
        name: name ?? this.name,
      );

  @override
  String toString() {
    return (StringBuffer('RecurrenceType(')
          ..write('type: $type, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(type.hashCode, name.hashCode));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is RecurrenceType &&
          other.type == this.type &&
          other.name == this.name);
}

class RecurrenceTypesCompanion extends UpdateCompanion<RecurrenceType> {
  final Value<int> type;
  final Value<String> name;

  const RecurrenceTypesCompanion({
    this.type = const Value.absent(),
    this.name = const Value.absent(),
  });

  RecurrenceTypesCompanion.insert({
    this.type = const Value.absent(),
    @required String name,
  }) : name = Value(name);

  static Insertable<RecurrenceType> custom({
    Expression<int> type,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (name != null) 'name': name,
    });
  }

  RecurrenceTypesCompanion copyWith({Value<int> type, Value<String> name}) {
    return RecurrenceTypesCompanion(
      type: type ?? this.type,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceTypesCompanion(')
          ..write('type: $type, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceTypesTable extends RecurrenceTypes
    with TableInfo<$RecurrenceTypesTable, RecurrenceType> {
  final GeneratedDatabase _db;
  final String _alias;

  $RecurrenceTypesTable(this._db, [this._alias]);

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedIntColumn _type;

  @override
  GeneratedIntColumn get type => _type ??= _constructType();

  GeneratedIntColumn _constructType() {
    return GeneratedIntColumn('type', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;

  @override
  GeneratedTextColumn get name => _name ??= _constructName();

  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 2, maxTextLength: 40);
  }

  @override
  List<GeneratedColumn> get $columns => [type, name];

  @override
  $RecurrenceTypesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'recurrence_types';
  @override
  final String actualTableName = 'recurrence_types';

  @override
  VerificationContext validateIntegrity(Insertable<RecurrenceType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type};

  @override
  RecurrenceType map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return RecurrenceType.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $RecurrenceTypesTable createAlias(String alias) {
    return $RecurrenceTypesTable(_db, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final int id;
  final String abbrev;
  final String symbol;
  final double exchangeRate;

  Currency(
      {@required this.id,
      @required this.abbrev,
      @required this.symbol,
      @required this.exchangeRate});

  factory Currency.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Currency(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      abbrev:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}abbrev']),
      symbol:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}symbol']),
      exchangeRate: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}exchange_rate']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || abbrev != null) {
      map['abbrev'] = Variable<String>(abbrev);
    }
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      abbrev:
          abbrev == null && nullToAbsent ? const Value.absent() : Value(abbrev),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<int>(json['id']),
      abbrev: serializer.fromJson<String>(json['abbrev']),
      symbol: serializer.fromJson<String>(json['symbol']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'abbrev': serializer.toJson<String>(abbrev),
      'symbol': serializer.toJson<String>(symbol),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
    };
  }

  Currency copyWith(
          {int id, String abbrev, String symbol, double exchangeRate}) =>
      Currency(
        id: id ?? this.id,
        abbrev: abbrev ?? this.abbrev,
        symbol: symbol ?? this.symbol,
        exchangeRate: exchangeRate ?? this.exchangeRate,
      );

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('abbrev: $abbrev, ')
          ..write('symbol: $symbol, ')
          ..write('exchangeRate: $exchangeRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(abbrev.hashCode, $mrjc(symbol.hashCode, exchangeRate.hashCode))));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.abbrev == this.abbrev &&
          other.symbol == this.symbol &&
          other.exchangeRate == this.exchangeRate);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<int> id;
  final Value<String> abbrev;
  final Value<String> symbol;
  final Value<double> exchangeRate;

  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.abbrev = const Value.absent(),
    this.symbol = const Value.absent(),
    this.exchangeRate = const Value.absent(),
  });

  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    @required String abbrev,
    @required String symbol,
    this.exchangeRate = const Value.absent(),
  })  : abbrev = Value(abbrev),
        symbol = Value(symbol);

  static Insertable<Currency> custom({
    Expression<int> id,
    Expression<String> abbrev,
    Expression<String> symbol,
    Expression<double> exchangeRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (abbrev != null) 'abbrev': abbrev,
      if (symbol != null) 'symbol': symbol,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<int> id,
      Value<String> abbrev,
      Value<String> symbol,
      Value<double> exchangeRate}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      abbrev: abbrev ?? this.abbrev,
      symbol: symbol ?? this.symbol,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (abbrev.present) {
      map['abbrev'] = Variable<String>(abbrev.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('abbrev: $abbrev, ')
          ..write('symbol: $symbol, ')
          ..write('exchangeRate: $exchangeRate')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  final GeneratedDatabase _db;
  final String _alias;

  $CurrenciesTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _abbrevMeta = const VerificationMeta('abbrev');
  GeneratedTextColumn _abbrev;

  @override
  GeneratedTextColumn get abbrev => _abbrev ??= _constructAbbrev();

  GeneratedTextColumn _constructAbbrev() {
    return GeneratedTextColumn('abbrev', $tableName, false,
        minTextLength: 2, maxTextLength: 40);
  }

  final VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  GeneratedTextColumn _symbol;

  @override
  GeneratedTextColumn get symbol => _symbol ??= _constructSymbol();

  GeneratedTextColumn _constructSymbol() {
    return GeneratedTextColumn('symbol', $tableName, false,
        minTextLength: 1, maxTextLength: 1);
  }

  final VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  GeneratedRealColumn _exchangeRate;

  @override
  GeneratedRealColumn get exchangeRate =>
      _exchangeRate ??= _constructExchangeRate();

  GeneratedRealColumn _constructExchangeRate() {
    return GeneratedRealColumn('exchange_rate', $tableName, false,
        defaultValue: const Constant(1.0));
  }

  @override
  List<GeneratedColumn> get $columns => [id, abbrev, symbol, exchangeRate];

  @override
  $CurrenciesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'currencies';
  @override
  final String actualTableName = 'currencies';

  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('abbrev')) {
      context.handle(_abbrevMeta,
          abbrev.isAcceptableOrUnknown(data['abbrev'], _abbrevMeta));
    } else if (isInserting) {
      context.missing(_abbrevMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol'], _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate'], _exchangeRateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Currency map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Currency.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(_db, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final int currencyId;

  UserProfile({@required this.id, @required this.currencyId});

  factory UserProfile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return UserProfile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      currencyId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}currency_id']),
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || currencyId != null) {
      map['currency_id'] = Variable<int>(currencyId);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      currencyId: currencyId == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyId),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyId': serializer.toJson<int>(currencyId),
    };
  }

  UserProfile copyWith({int id, int currencyId}) => UserProfile(
        id: id ?? this.id,
        currencyId: currencyId ?? this.currencyId,
      );

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, currencyId.hashCode));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.currencyId == this.currencyId);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<int> currencyId;

  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.currencyId = const Value.absent(),
  });

  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required int currencyId,
  }) : currencyId = Value(currencyId);

  static Insertable<UserProfile> custom({
    Expression<int> id,
    Expression<int> currencyId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyId != null) 'currency_id': currencyId,
    });
  }

  UserProfilesCompanion copyWith({Value<int> id, Value<int> currencyId}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      currencyId: currencyId ?? this.currencyId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  final GeneratedDatabase _db;
  final String _alias;

  $UserProfilesTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _currencyIdMeta = const VerificationMeta('currencyId');
  GeneratedIntColumn _currencyId;

  @override
  GeneratedIntColumn get currencyId => _currencyId ??= _constructCurrencyId();

  GeneratedIntColumn _constructCurrencyId() {
    return GeneratedIntColumn('currency_id', $tableName, false,
        $customConstraints: 'REFERENCES currencies(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, currencyId];

  @override
  $UserProfilesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'user_profiles';
  @override
  final String actualTableName = 'user_profiles';

  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('currency_id')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currency_id'], _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  UserProfile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UserProfile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $TransactionsTable _transactions;

  $TransactionsTable get transactions =>
      _transactions ??= $TransactionsTable(this);
  $CategoriesTable _categories;

  $CategoriesTable get categories => _categories ??= $CategoriesTable(this);
  $SubcategoriesTable _subcategories;

  $SubcategoriesTable get subcategories =>
      _subcategories ??= $SubcategoriesTable(this);
  $MonthsTable _months;

  $MonthsTable get months => _months ??= $MonthsTable(this);
  $RecurrenceTypesTable _recurrenceTypes;

  $RecurrenceTypesTable get recurrenceTypes =>
      _recurrenceTypes ??= $RecurrenceTypesTable(this);
  $CurrenciesTable _currencies;

  $CurrenciesTable get currencies => _currencies ??= $CurrenciesTable(this);
  $UserProfilesTable _userProfiles;

  $UserProfilesTable get userProfiles =>
      _userProfiles ??= $UserProfilesTable(this);
  TransactionDao _transactionDao;

  TransactionDao get transactionDao =>
      _transactionDao ??= TransactionDao(this as AppDatabase);
  CategoryDao _categoryDao;

  CategoryDao get categoryDao =>
      _categoryDao ??= CategoryDao(this as AppDatabase);
  MonthDao _monthDao;

  MonthDao get monthDao => _monthDao ??= MonthDao(this as AppDatabase);
  CurrencyDao _currencyDao;

  CurrencyDao get currencyDao =>
      _currencyDao ??= CurrencyDao(this as AppDatabase);

  Selectable<int> getTimestamp() {
    return customSelect(
        'SELECT strftime(\'%s\',\'now\', \'localtime\') * 1000 AS timestamp',
        variables: [],
        readsFrom: {}).map((QueryRow row) => row.readInt('timestamp'));
  }

  Selectable<UserProfile> getUserProfile() {
    return customSelect('SELECT * FROM user_profiles WHERE id=1',
        variables: [], readsFrom: {userProfiles}).map(userProfiles.mapFromRow);
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        transactions,
        categories,
        subcategories,
        months,
        recurrenceTypes,
        currencies,
        userProfiles
      ];
}

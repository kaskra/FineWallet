// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final double amount;
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
  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
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

  @override
  TransactionsCompanion createCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
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

  Transaction copyWith(
          {int id,
          double amount,
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
                                          $mrjc(currencyId.hashCode,
                                              label.hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
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
        subcategoryId = Value(subcategoryId),
        monthId = Value(monthId),
        date = Value(date),
        isExpense = Value(isExpense),
        currencyId = Value(currencyId),
        label = Value(label);
  TransactionsCompanion copyWith(
      {Value<int> id,
      Value<double> amount,
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
  VerificationContext validateIntegrity(TransactionsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.amount.present) {
      context.handle(
          _amountMeta, amount.isAcceptableValue(d.amount.value, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (d.subcategoryId.present) {
      context.handle(
          _subcategoryIdMeta,
          subcategoryId.isAcceptableValue(
              d.subcategoryId.value, _subcategoryIdMeta));
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (d.monthId.present) {
      context.handle(_monthIdMeta,
          monthId.isAcceptableValue(d.monthId.value, _monthIdMeta));
    } else if (isInserting) {
      context.missing(_monthIdMeta);
    }
    context.handle(_dateMeta, const VerificationResult.success());
    if (d.isExpense.present) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableValue(d.isExpense.value, _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (d.isRecurring.present) {
      context.handle(_isRecurringMeta,
          isRecurring.isAcceptableValue(d.isRecurring.value, _isRecurringMeta));
    }
    if (d.recurrenceType.present) {
      context.handle(
          _recurrenceTypeMeta,
          recurrenceType.isAcceptableValue(
              d.recurrenceType.value, _recurrenceTypeMeta));
    }
    context.handle(_untilMeta, const VerificationResult.success());
    if (d.originalId.present) {
      context.handle(_originalIdMeta,
          originalId.isAcceptableValue(d.originalId.value, _originalIdMeta));
    }
    if (d.currencyId.present) {
      context.handle(_currencyIdMeta,
          currencyId.isAcceptableValue(d.currencyId.value, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (d.label.present) {
      context.handle(
          _labelMeta, label.isAcceptableValue(d.label.value, _labelMeta));
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
  Map<String, Variable> entityToSql(TransactionsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.amount.present) {
      map['amount'] = Variable<double, RealType>(d.amount.value);
    }
    if (d.subcategoryId.present) {
      map['subcategory_id'] = Variable<int, IntType>(d.subcategoryId.value);
    }
    if (d.monthId.present) {
      map['month_id'] = Variable<int, IntType>(d.monthId.value);
    }
    if (d.date.present) {
      final converter = $TransactionsTable.$converter0;
      map['date'] =
          Variable<String, StringType>(converter.mapToSql(d.date.value));
    }
    if (d.isExpense.present) {
      map['is_expense'] = Variable<bool, BoolType>(d.isExpense.value);
    }
    if (d.isRecurring.present) {
      map['is_recurring'] = Variable<bool, BoolType>(d.isRecurring.value);
    }
    if (d.recurrenceType.present) {
      map['recurrence_type'] = Variable<int, IntType>(d.recurrenceType.value);
    }
    if (d.until.present) {
      final converter = $TransactionsTable.$converter1;
      map['until'] =
          Variable<String, StringType>(converter.mapToSql(d.until.value));
    }
    if (d.originalId.present) {
      map['original_id'] = Variable<int, IntType>(d.originalId.value);
    }
    if (d.currencyId.present) {
      map['currency_id'] = Variable<int, IntType>(d.currencyId.value);
    }
    if (d.label.present) {
      map['label'] = Variable<String, StringType>(d.label.value);
    }
    return map;
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
  Category({@required this.id, @required this.name, @required this.isExpense});
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
    );
  }
  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isExpense': serializer.toJson<bool>(isExpense),
    };
  }

  @override
  CategoriesCompanion createCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isExpense: isExpense == null && nullToAbsent
          ? const Value.absent()
          : Value(isExpense),
    );
  }

  Category copyWith({int id, String name, bool isExpense}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        isExpense: isExpense ?? this.isExpense,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isExpense: $isExpense')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, isExpense.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.isExpense == this.isExpense);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isExpense;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isExpense = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isExpense = const Value.absent(),
  }) : name = Value(name);
  CategoriesCompanion copyWith(
      {Value<int> id, Value<String> name, Value<bool> isExpense}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isExpense: isExpense ?? this.isExpense,
    );
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

  @override
  List<GeneratedColumn> get $columns => [id, name, isExpense];
  @override
  $CategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
  @override
  VerificationContext validateIntegrity(CategoriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isExpense.present) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableValue(d.isExpense.value, _isExpenseMeta));
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
  Map<String, Variable> entityToSql(CategoriesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.isExpense.present) {
      map['is_expense'] = Variable<bool, BoolType>(d.isExpense.value);
    }
    return map;
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
  Subcategory(
      {@required this.id, @required this.name, @required this.categoryId});
  factory Subcategory.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Subcategory(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
    );
  }
  factory Subcategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Subcategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  @override
  SubcategoriesCompanion createCompanion(bool nullToAbsent) {
    return SubcategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
    );
  }

  Subcategory copyWith({int id, String name, int categoryId}) => Subcategory(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('Subcategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, categoryId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Subcategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId);
}

class SubcategoriesCompanion extends UpdateCompanion<Subcategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  SubcategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int categoryId,
  })  : name = Value(name),
        categoryId = Value(categoryId);
  SubcategoriesCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> categoryId}) {
    return SubcategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
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

  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId];
  @override
  $SubcategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subcategories';
  @override
  final String actualTableName = 'subcategories';
  @override
  VerificationContext validateIntegrity(SubcategoriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
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
  Map<String, Variable> entityToSql(SubcategoriesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.categoryId.present) {
      map['category_id'] = Variable<int, IntType>(d.categoryId.value);
    }
    return map;
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

  @override
  MonthsCompanion createCompanion(bool nullToAbsent) {
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
  VerificationContext validateIntegrity(MonthsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.maxBudget.present) {
      context.handle(_maxBudgetMeta,
          maxBudget.isAcceptableValue(d.maxBudget.value, _maxBudgetMeta));
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
  Map<String, Variable> entityToSql(MonthsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.maxBudget.present) {
      map['max_budget'] = Variable<double, RealType>(d.maxBudget.value);
    }
    if (d.firstDate.present) {
      final converter = $MonthsTable.$converter0;
      map['first_date'] =
          Variable<String, StringType>(converter.mapToSql(d.firstDate.value));
    }
    if (d.lastDate.present) {
      final converter = $MonthsTable.$converter1;
      map['last_date'] =
          Variable<String, StringType>(converter.mapToSql(d.lastDate.value));
    }
    return map;
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

  @override
  RecurrenceTypesCompanion createCompanion(bool nullToAbsent) {
    return RecurrenceTypesCompanion(
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
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
  RecurrenceTypesCompanion copyWith({Value<int> type, Value<String> name}) {
    return RecurrenceTypesCompanion(
      type: type ?? this.type,
      name: name ?? this.name,
    );
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
  VerificationContext validateIntegrity(RecurrenceTypesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
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
  Map<String, Variable> entityToSql(RecurrenceTypesCompanion d) {
    final map = <String, Variable>{};
    if (d.type.present) {
      map['type'] = Variable<int, IntType>(d.type.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $RecurrenceTypesTable createAlias(String alias) {
    return $RecurrenceTypesTable(_db, alias);
  }
}

class Language extends DataClass implements Insertable<Language> {
  final String languageId;
  final String name;
  Language({@required this.languageId, @required this.name});
  factory Language.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Language(
      languageId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}language_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Language.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Language(
      languageId: serializer.fromJson<String>(json['languageId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'languageId': serializer.toJson<String>(languageId),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  LanguagesCompanion createCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      languageId: languageId == null && nullToAbsent
          ? const Value.absent()
          : Value(languageId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Language copyWith({String languageId, String name}) => Language(
        languageId: languageId ?? this.languageId,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('languageId: $languageId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(languageId.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Language &&
          other.languageId == this.languageId &&
          other.name == this.name);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<String> languageId;
  final Value<String> name;
  const LanguagesCompanion({
    this.languageId = const Value.absent(),
    this.name = const Value.absent(),
  });
  LanguagesCompanion.insert({
    @required String languageId,
    @required String name,
  })  : languageId = Value(languageId),
        name = Value(name);
  LanguagesCompanion copyWith({Value<String> languageId, Value<String> name}) {
    return LanguagesCompanion(
      languageId: languageId ?? this.languageId,
      name: name ?? this.name,
    );
  }
}

class $LanguagesTable extends Languages
    with TableInfo<$LanguagesTable, Language> {
  final GeneratedDatabase _db;
  final String _alias;
  $LanguagesTable(this._db, [this._alias]);
  final VerificationMeta _languageIdMeta = const VerificationMeta('languageId');
  GeneratedTextColumn _languageId;
  @override
  GeneratedTextColumn get languageId => _languageId ??= _constructLanguageId();
  GeneratedTextColumn _constructLanguageId() {
    return GeneratedTextColumn('language_id', $tableName, false,
        $customConstraints: 'UNIQUE');
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
  List<GeneratedColumn> get $columns => [languageId, name];
  @override
  $LanguagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'languages';
  @override
  final String actualTableName = 'languages';
  @override
  VerificationContext validateIntegrity(LanguagesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.languageId.present) {
      context.handle(_languageIdMeta,
          languageId.isAcceptableValue(d.languageId.value, _languageIdMeta));
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Language map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Language.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LanguagesCompanion d) {
    final map = <String, Variable>{};
    if (d.languageId.present) {
      map['language_id'] = Variable<String, StringType>(d.languageId.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $LanguagesTable createAlias(String alias) {
    return $LanguagesTable(_db, alias);
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

  @override
  CurrenciesCompanion createCompanion(bool nullToAbsent) {
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
  VerificationContext validateIntegrity(CurrenciesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.abbrev.present) {
      context.handle(
          _abbrevMeta, abbrev.isAcceptableValue(d.abbrev.value, _abbrevMeta));
    } else if (isInserting) {
      context.missing(_abbrevMeta);
    }
    if (d.symbol.present) {
      context.handle(
          _symbolMeta, symbol.isAcceptableValue(d.symbol.value, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (d.exchangeRate.present) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableValue(
              d.exchangeRate.value, _exchangeRateMeta));
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
  Map<String, Variable> entityToSql(CurrenciesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.abbrev.present) {
      map['abbrev'] = Variable<String, StringType>(d.abbrev.value);
    }
    if (d.symbol.present) {
      map['symbol'] = Variable<String, StringType>(d.symbol.value);
    }
    if (d.exchangeRate.present) {
      map['exchange_rate'] = Variable<double, RealType>(d.exchangeRate.value);
    }
    return map;
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(_db, alias);
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
  $LanguagesTable _languages;
  $LanguagesTable get languages => _languages ??= $LanguagesTable(this);
  $CurrenciesTable _currencies;
  $CurrenciesTable get currencies => _currencies ??= $CurrenciesTable(this);
  TransactionDao _transactionDao;
  TransactionDao get transactionDao =>
      _transactionDao ??= TransactionDao(this as AppDatabase);
  CategoryDao _categoryDao;
  CategoryDao get categoryDao =>
      _categoryDao ??= CategoryDao(this as AppDatabase);
  MonthDao _monthDao;
  MonthDao get monthDao => _monthDao ??= MonthDao(this as AppDatabase);
  Selectable<String> getTimestampQuery() {
    return customSelectQuery(
        'SELECT strftime(\'%s\',\'now\', \'localtime\') * 1000 AS timestamp',
        variables: [],
        readsFrom: {}).map((QueryRow row) => row.readString('timestamp'));
  }

  Future<List<String>> getTimestamp() {
    return getTimestampQuery().get();
  }

  Stream<List<String>> watchGetTimestamp() {
    return getTimestampQuery().watch();
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
        languages,
        currencies
      ];
}

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
  final int categoryId;
  final int monthId;
  final int date;
  final bool isExpense;
  final bool isRecurring;
  final int recurringType;
  final int recurringUnitl;
  Transaction(
      {@required this.id,
      @required this.amount,
      @required this.subcategoryId,
      @required this.categoryId,
      @required this.monthId,
      @required this.date,
      @required this.isExpense,
      @required this.isRecurring,
      this.recurringType,
      this.recurringUnitl});
  factory Transaction.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Transaction(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      subcategoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}subcategory_id']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      monthId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}month_id']),
      date: intType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      isExpense: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_expense']),
      isRecurring: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_recurring']),
      recurringType: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}recurring_type']),
      recurringUnitl: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}recurring_unitl']),
    );
  }
  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      subcategoryId: serializer.fromJson<int>(json['subcategoryId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      monthId: serializer.fromJson<int>(json['monthId']),
      date: serializer.fromJson<int>(json['date']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringType: serializer.fromJson<int>(json['recurringType']),
      recurringUnitl: serializer.fromJson<int>(json['recurringUnitl']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'subcategoryId': serializer.toJson<int>(subcategoryId),
      'categoryId': serializer.toJson<int>(categoryId),
      'monthId': serializer.toJson<int>(monthId),
      'date': serializer.toJson<int>(date),
      'isExpense': serializer.toJson<bool>(isExpense),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringType': serializer.toJson<int>(recurringType),
      'recurringUnitl': serializer.toJson<int>(recurringUnitl),
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
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
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
      recurringType: recurringType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringType),
      recurringUnitl: recurringUnitl == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringUnitl),
    );
  }

  Transaction copyWith(
          {int id,
          double amount,
          int subcategoryId,
          int categoryId,
          int monthId,
          int date,
          bool isExpense,
          bool isRecurring,
          int recurringType,
          int recurringUnitl}) =>
      Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        categoryId: categoryId ?? this.categoryId,
        monthId: monthId ?? this.monthId,
        date: date ?? this.date,
        isExpense: isExpense ?? this.isExpense,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringType: recurringType ?? this.recurringType,
        recurringUnitl: recurringUnitl ?? this.recurringUnitl,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('categoryId: $categoryId, ')
          ..write('monthId: $monthId, ')
          ..write('date: $date, ')
          ..write('isExpense: $isExpense, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringType: $recurringType, ')
          ..write('recurringUnitl: $recurringUnitl')
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
                  categoryId.hashCode,
                  $mrjc(
                      monthId.hashCode,
                      $mrjc(
                          date.hashCode,
                          $mrjc(
                              isExpense.hashCode,
                              $mrjc(
                                  isRecurring.hashCode,
                                  $mrjc(recurringType.hashCode,
                                      recurringUnitl.hashCode))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.subcategoryId == this.subcategoryId &&
          other.categoryId == this.categoryId &&
          other.monthId == this.monthId &&
          other.date == this.date &&
          other.isExpense == this.isExpense &&
          other.isRecurring == this.isRecurring &&
          other.recurringType == this.recurringType &&
          other.recurringUnitl == this.recurringUnitl);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> subcategoryId;
  final Value<int> categoryId;
  final Value<int> monthId;
  final Value<int> date;
  final Value<bool> isExpense;
  final Value<bool> isRecurring;
  final Value<int> recurringType;
  final Value<int> recurringUnitl;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.monthId = const Value.absent(),
    this.date = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringUnitl = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    @required double amount,
    @required int subcategoryId,
    @required int categoryId,
    @required int monthId,
    @required int date,
    @required bool isExpense,
    this.isRecurring = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.recurringUnitl = const Value.absent(),
  })  : amount = Value(amount),
        subcategoryId = Value(subcategoryId),
        categoryId = Value(categoryId),
        monthId = Value(monthId),
        date = Value(date),
        isExpense = Value(isExpense);
  TransactionsCompanion copyWith(
      {Value<int> id,
      Value<double> amount,
      Value<int> subcategoryId,
      Value<int> categoryId,
      Value<int> monthId,
      Value<int> date,
      Value<bool> isExpense,
      Value<bool> isRecurring,
      Value<int> recurringType,
      Value<int> recurringUnitl}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      categoryId: categoryId ?? this.categoryId,
      monthId: monthId ?? this.monthId,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      recurringUnitl: recurringUnitl ?? this.recurringUnitl,
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
    return GeneratedRealColumn(
      'amount',
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
    return GeneratedIntColumn(
      'subcategory_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn(
      'category_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _monthIdMeta = const VerificationMeta('monthId');
  GeneratedIntColumn _monthId;
  @override
  GeneratedIntColumn get monthId => _monthId ??= _constructMonthId();
  GeneratedIntColumn _constructMonthId() {
    return GeneratedIntColumn(
      'month_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedIntColumn _date;
  @override
  GeneratedIntColumn get date => _date ??= _constructDate();
  GeneratedIntColumn _constructDate() {
    return GeneratedIntColumn(
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

  final VerificationMeta _recurringTypeMeta =
      const VerificationMeta('recurringType');
  GeneratedIntColumn _recurringType;
  @override
  GeneratedIntColumn get recurringType =>
      _recurringType ??= _constructRecurringType();
  GeneratedIntColumn _constructRecurringType() {
    return GeneratedIntColumn(
      'recurring_type',
      $tableName,
      true,
    );
  }

  final VerificationMeta _recurringUnitlMeta =
      const VerificationMeta('recurringUnitl');
  GeneratedIntColumn _recurringUnitl;
  @override
  GeneratedIntColumn get recurringUnitl =>
      _recurringUnitl ??= _constructRecurringUnitl();
  GeneratedIntColumn _constructRecurringUnitl() {
    return GeneratedIntColumn(
      'recurring_unitl',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        subcategoryId,
        categoryId,
        monthId,
        date,
        isExpense,
        isRecurring,
        recurringType,
        recurringUnitl
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
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.amount.present) {
      context.handle(
          _amountMeta, amount.isAcceptableValue(d.amount.value, _amountMeta));
    } else if (amount.isRequired && isInserting) {
      context.missing(_amountMeta);
    }
    if (d.subcategoryId.present) {
      context.handle(
          _subcategoryIdMeta,
          subcategoryId.isAcceptableValue(
              d.subcategoryId.value, _subcategoryIdMeta));
    } else if (subcategoryId.isRequired && isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    } else if (categoryId.isRequired && isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (d.monthId.present) {
      context.handle(_monthIdMeta,
          monthId.isAcceptableValue(d.monthId.value, _monthIdMeta));
    } else if (monthId.isRequired && isInserting) {
      context.missing(_monthIdMeta);
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (date.isRequired && isInserting) {
      context.missing(_dateMeta);
    }
    if (d.isExpense.present) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableValue(d.isExpense.value, _isExpenseMeta));
    } else if (isExpense.isRequired && isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (d.isRecurring.present) {
      context.handle(_isRecurringMeta,
          isRecurring.isAcceptableValue(d.isRecurring.value, _isRecurringMeta));
    } else if (isRecurring.isRequired && isInserting) {
      context.missing(_isRecurringMeta);
    }
    if (d.recurringType.present) {
      context.handle(
          _recurringTypeMeta,
          recurringType.isAcceptableValue(
              d.recurringType.value, _recurringTypeMeta));
    } else if (recurringType.isRequired && isInserting) {
      context.missing(_recurringTypeMeta);
    }
    if (d.recurringUnitl.present) {
      context.handle(
          _recurringUnitlMeta,
          recurringUnitl.isAcceptableValue(
              d.recurringUnitl.value, _recurringUnitlMeta));
    } else if (recurringUnitl.isRequired && isInserting) {
      context.missing(_recurringUnitlMeta);
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
    if (d.categoryId.present) {
      map['category_id'] = Variable<int, IntType>(d.categoryId.value);
    }
    if (d.monthId.present) {
      map['month_id'] = Variable<int, IntType>(d.monthId.value);
    }
    if (d.date.present) {
      map['date'] = Variable<int, IntType>(d.date.value);
    }
    if (d.isExpense.present) {
      map['is_expense'] = Variable<bool, BoolType>(d.isExpense.value);
    }
    if (d.isRecurring.present) {
      map['is_recurring'] = Variable<bool, BoolType>(d.isRecurring.value);
    }
    if (d.recurringType.present) {
      map['recurring_type'] = Variable<int, IntType>(d.recurringType.value);
    }
    if (d.recurringUnitl.present) {
      map['recurring_unitl'] = Variable<int, IntType>(d.recurringUnitl.value);
    }
    return map;
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(_db, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  Category({@required this.id, @required this.name});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  CategoriesCompanion createCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Category copyWith({int id, String name}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  CategoriesCompanion copyWith({Value<int> id, Value<String> name}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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

  @override
  List<GeneratedColumn> get $columns => [id, name];
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
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
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
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Subcategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
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
  bool operator ==(other) =>
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
    return GeneratedIntColumn(
      'category_id',
      $tableName,
      false,
    );
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
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.categoryId.present) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableValue(d.categoryId.value, _categoryIdMeta));
    } else if (categoryId.isRequired && isInserting) {
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
  final int firstDate;
  final int lastDate;
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
    return Month(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      maxBudget: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}max_budget']),
      firstDate:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}first_date']),
      lastDate:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}last_date']),
    );
  }
  factory Month.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Month(
      id: serializer.fromJson<int>(json['id']),
      maxBudget: serializer.fromJson<double>(json['maxBudget']),
      firstDate: serializer.fromJson<int>(json['firstDate']),
      lastDate: serializer.fromJson<int>(json['lastDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'maxBudget': serializer.toJson<double>(maxBudget),
      'firstDate': serializer.toJson<int>(firstDate),
      'lastDate': serializer.toJson<int>(lastDate),
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

  Month copyWith({int id, double maxBudget, int firstDate, int lastDate}) =>
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
  bool operator ==(other) =>
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
  final Value<int> firstDate;
  final Value<int> lastDate;
  const MonthsCompanion({
    this.id = const Value.absent(),
    this.maxBudget = const Value.absent(),
    this.firstDate = const Value.absent(),
    this.lastDate = const Value.absent(),
  });
  MonthsCompanion.insert({
    this.id = const Value.absent(),
    @required double maxBudget,
    @required int firstDate,
    @required int lastDate,
  })  : maxBudget = Value(maxBudget),
        firstDate = Value(firstDate),
        lastDate = Value(lastDate);
  MonthsCompanion copyWith(
      {Value<int> id,
      Value<double> maxBudget,
      Value<int> firstDate,
      Value<int> lastDate}) {
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
    return GeneratedRealColumn(
      'max_budget',
      $tableName,
      false,
    );
  }

  final VerificationMeta _firstDateMeta = const VerificationMeta('firstDate');
  GeneratedIntColumn _firstDate;
  @override
  GeneratedIntColumn get firstDate => _firstDate ??= _constructFirstDate();
  GeneratedIntColumn _constructFirstDate() {
    return GeneratedIntColumn(
      'first_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastDateMeta = const VerificationMeta('lastDate');
  GeneratedIntColumn _lastDate;
  @override
  GeneratedIntColumn get lastDate => _lastDate ??= _constructLastDate();
  GeneratedIntColumn _constructLastDate() {
    return GeneratedIntColumn(
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
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.maxBudget.present) {
      context.handle(_maxBudgetMeta,
          maxBudget.isAcceptableValue(d.maxBudget.value, _maxBudgetMeta));
    } else if (maxBudget.isRequired && isInserting) {
      context.missing(_maxBudgetMeta);
    }
    if (d.firstDate.present) {
      context.handle(_firstDateMeta,
          firstDate.isAcceptableValue(d.firstDate.value, _firstDateMeta));
    } else if (firstDate.isRequired && isInserting) {
      context.missing(_firstDateMeta);
    }
    if (d.lastDate.present) {
      context.handle(_lastDateMeta,
          lastDate.isAcceptableValue(d.lastDate.value, _lastDateMeta));
    } else if (lastDate.isRequired && isInserting) {
      context.missing(_lastDateMeta);
    }
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
      map['first_date'] = Variable<int, IntType>(d.firstDate.value);
    }
    if (d.lastDate.present) {
      map['last_date'] = Variable<int, IntType>(d.lastDate.value);
    }
    return map;
  }

  @override
  $MonthsTable createAlias(String alias) {
    return $MonthsTable(_db, alias);
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
  TransactionDao _transactionDao;
  TransactionDao get transactionDao =>
      _transactionDao ??= TransactionDao(this as AppDatabase);
  CategoryDao _categoryDao;
  CategoryDao get categoryDao =>
      _categoryDao ??= CategoryDao(this as AppDatabase);
  SubcategoryDao _subcategoryDao;
  SubcategoryDao get subcategoryDao =>
      _subcategoryDao ??= SubcategoryDao(this as AppDatabase);
  MonthDao _monthDao;
  MonthDao get monthDao => _monthDao ??= MonthDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables =>
      [transactions, categories, subcategories, months];
}

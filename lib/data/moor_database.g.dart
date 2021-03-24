// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final bool isExpense;
  final bool isPreset;
  final int iconCodePoint;
  Category(
      {@required this.id,
      @required this.name,
      @required this.isExpense,
      @required this.isPreset,
      @required this.iconCodePoint});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isExpense:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}isExpense']),
      isPreset:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}isPreset']),
      iconCodePoint: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}iconCodePoint']),
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
      map['isExpense'] = Variable<bool>(isExpense);
    }
    if (!nullToAbsent || isPreset != null) {
      map['isPreset'] = Variable<bool>(isPreset);
    }
    if (!nullToAbsent || iconCodePoint != null) {
      map['iconCodePoint'] = Variable<int>(iconCodePoint);
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
      iconCodePoint: iconCodePoint == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCodePoint),
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
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
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
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
    };
  }

  Category copyWith(
          {int id,
          String name,
          bool isExpense,
          bool isPreset,
          int iconCodePoint}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        isExpense: isExpense ?? this.isExpense,
        isPreset: isPreset ?? this.isPreset,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isExpense: $isExpense, ')
          ..write('isPreset: $isPreset, ')
          ..write('iconCodePoint: $iconCodePoint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(isExpense.hashCode,
              $mrjc(isPreset.hashCode, iconCodePoint.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.isExpense == this.isExpense &&
          other.isPreset == this.isPreset &&
          other.iconCodePoint == this.iconCodePoint);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isExpense;
  final Value<bool> isPreset;
  final Value<int> iconCodePoint;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.isPreset = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isExpense = const Value.absent(),
    this.isPreset = const Value.absent(),
    @required int iconCodePoint,
  })  : name = Value(name),
        iconCodePoint = Value(iconCodePoint);
  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<bool> isExpense,
    Expression<bool> isPreset,
    Expression<int> iconCodePoint,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isExpense != null) 'isExpense': isExpense,
      if (isPreset != null) 'isPreset': isPreset,
      if (iconCodePoint != null) 'iconCodePoint': iconCodePoint,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<bool> isExpense,
      Value<bool> isPreset,
      Value<int> iconCodePoint}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isExpense: isExpense ?? this.isExpense,
      isPreset: isPreset ?? this.isPreset,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
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
      map['isExpense'] = Variable<bool>(isExpense.value);
    }
    if (isPreset.present) {
      map['isPreset'] = Variable<bool>(isPreset.value);
    }
    if (iconCodePoint.present) {
      map['iconCodePoint'] = Variable<int>(iconCodePoint.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isExpense: $isExpense, ')
          ..write('isPreset: $isPreset, ')
          ..write('iconCodePoint: $iconCodePoint')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, Category> {
  final GeneratedDatabase _db;
  final String _alias;
  Categories(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(name) >= 1 AND length(name) <= 20)');
  }

  final VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  GeneratedBoolColumn _isExpense;
  GeneratedBoolColumn get isExpense => _isExpense ??= _constructIsExpense();
  GeneratedBoolColumn _constructIsExpense() {
    return GeneratedBoolColumn('isExpense', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT True',
        defaultValue: const CustomExpression<bool>('True'));
  }

  final VerificationMeta _isPresetMeta = const VerificationMeta('isPreset');
  GeneratedBoolColumn _isPreset;
  GeneratedBoolColumn get isPreset => _isPreset ??= _constructIsPreset();
  GeneratedBoolColumn _constructIsPreset() {
    return GeneratedBoolColumn('isPreset', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT False',
        defaultValue: const CustomExpression<bool>('False'));
  }

  final VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  GeneratedIntColumn _iconCodePoint;
  GeneratedIntColumn get iconCodePoint =>
      _iconCodePoint ??= _constructIconCodePoint();
  GeneratedIntColumn _constructIconCodePoint() {
    return GeneratedIntColumn('iconCodePoint', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isExpense, isPreset, iconCodePoint];
  @override
  Categories get asDslTable => this;
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
    if (data.containsKey('isExpense')) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableOrUnknown(data['isExpense'], _isExpenseMeta));
    }
    if (data.containsKey('isPreset')) {
      context.handle(_isPresetMeta,
          isPreset.isAcceptableOrUnknown(data['isPreset'], _isPresetMeta));
    }
    if (data.containsKey('iconCodePoint')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['iconCodePoint'], _iconCodePointMeta));
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
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
  Categories createAlias(String alias) {
    return Categories(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
      categoryId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}categoryId']),
      isPreset:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}isPreset']),
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
      map['categoryId'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || isPreset != null) {
      map['isPreset'] = Variable<bool>(isPreset);
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
      if (categoryId != null) 'categoryId': categoryId,
      if (isPreset != null) 'isPreset': isPreset,
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
      map['categoryId'] = Variable<int>(categoryId.value);
    }
    if (isPreset.present) {
      map['isPreset'] = Variable<bool>(isPreset.value);
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

class Subcategories extends Table with TableInfo<Subcategories, Subcategory> {
  final GeneratedDatabase _db;
  final String _alias;
  Subcategories(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(name) >= 1 AND length(name) <= 30)');
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('categoryId', $tableName, false,
        $customConstraints:
            'NOT NULL REFERENCES categories (id) ON DELETE CASCADE');
  }

  final VerificationMeta _isPresetMeta = const VerificationMeta('isPreset');
  GeneratedBoolColumn _isPreset;
  GeneratedBoolColumn get isPreset => _isPreset ??= _constructIsPreset();
  GeneratedBoolColumn _constructIsPreset() {
    return GeneratedBoolColumn('isPreset', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT False',
        defaultValue: const CustomExpression<bool>('False'));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId, isPreset];
  @override
  Subcategories get asDslTable => this;
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
    if (data.containsKey('categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['categoryId'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('isPreset')) {
      context.handle(_isPresetMeta,
          isPreset.isAcceptableOrUnknown(data['isPreset'], _isPresetMeta));
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
  Subcategories createAlias(String alias) {
    return Subcategories(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Month(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      maxBudget: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}maxBudget']),
      firstDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}firstDate']),
      lastDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}lastDate']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || maxBudget != null) {
      map['maxBudget'] = Variable<double>(maxBudget);
    }
    if (!nullToAbsent || firstDate != null) {
      map['firstDate'] = Variable<DateTime>(firstDate);
    }
    if (!nullToAbsent || lastDate != null) {
      map['lastDate'] = Variable<DateTime>(lastDate);
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
    Expression<DateTime> firstDate,
    Expression<DateTime> lastDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maxBudget != null) 'maxBudget': maxBudget,
      if (firstDate != null) 'firstDate': firstDate,
      if (lastDate != null) 'lastDate': lastDate,
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
      map['maxBudget'] = Variable<double>(maxBudget.value);
    }
    if (firstDate.present) {
      map['firstDate'] = Variable<DateTime>(firstDate.value);
    }
    if (lastDate.present) {
      map['lastDate'] = Variable<DateTime>(lastDate.value);
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

class Months extends Table with TableInfo<Months, Month> {
  final GeneratedDatabase _db;
  final String _alias;
  Months(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _maxBudgetMeta = const VerificationMeta('maxBudget');
  GeneratedRealColumn _maxBudget;
  GeneratedRealColumn get maxBudget => _maxBudget ??= _constructMaxBudget();
  GeneratedRealColumn _constructMaxBudget() {
    return GeneratedRealColumn('maxBudget', $tableName, false,
        $customConstraints: 'NOT NULL CHECK (maxBudget >= 0)');
  }

  final VerificationMeta _firstDateMeta = const VerificationMeta('firstDate');
  GeneratedDateTimeColumn _firstDate;
  GeneratedDateTimeColumn get firstDate => _firstDate ??= _constructFirstDate();
  GeneratedDateTimeColumn _constructFirstDate() {
    return GeneratedDateTimeColumn('firstDate', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _lastDateMeta = const VerificationMeta('lastDate');
  GeneratedDateTimeColumn _lastDate;
  GeneratedDateTimeColumn get lastDate => _lastDate ??= _constructLastDate();
  GeneratedDateTimeColumn _constructLastDate() {
    return GeneratedDateTimeColumn('lastDate', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, maxBudget, firstDate, lastDate];
  @override
  Months get asDslTable => this;
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
    if (data.containsKey('maxBudget')) {
      context.handle(_maxBudgetMeta,
          maxBudget.isAcceptableOrUnknown(data['maxBudget'], _maxBudgetMeta));
    } else if (isInserting) {
      context.missing(_maxBudgetMeta);
    }
    if (data.containsKey('firstDate')) {
      context.handle(_firstDateMeta,
          firstDate.isAcceptableOrUnknown(data['firstDate'], _firstDateMeta));
    } else if (isInserting) {
      context.missing(_firstDateMeta);
    }
    if (data.containsKey('lastDate')) {
      context.handle(_lastDateMeta,
          lastDate.isAcceptableOrUnknown(data['lastDate'], _lastDateMeta));
    } else if (isInserting) {
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
  Months createAlias(String alias) {
    return Months(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
          .mapFromDatabaseResponse(data['${effectivePrefix}exchangeRate']),
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
      map['exchangeRate'] = Variable<double>(exchangeRate);
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
      if (exchangeRate != null) 'exchangeRate': exchangeRate,
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
      map['exchangeRate'] = Variable<double>(exchangeRate.value);
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

class Currencies extends Table with TableInfo<Currencies, Currency> {
  final GeneratedDatabase _db;
  final String _alias;
  Currencies(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _abbrevMeta = const VerificationMeta('abbrev');
  GeneratedTextColumn _abbrev;
  GeneratedTextColumn get abbrev => _abbrev ??= _constructAbbrev();
  GeneratedTextColumn _constructAbbrev() {
    return GeneratedTextColumn('abbrev', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(abbrev) >= 2 AND length(abbrev) <= 10)');
  }

  final VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  GeneratedTextColumn _symbol;
  GeneratedTextColumn get symbol => _symbol ??= _constructSymbol();
  GeneratedTextColumn _constructSymbol() {
    return GeneratedTextColumn('symbol', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(symbol) >= 1 AND length(symbol) <= 5)');
  }

  final VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  GeneratedRealColumn _exchangeRate;
  GeneratedRealColumn get exchangeRate =>
      _exchangeRate ??= _constructExchangeRate();
  GeneratedRealColumn _constructExchangeRate() {
    return GeneratedRealColumn('exchangeRate', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 1.0',
        defaultValue: const CustomExpression<double>('1.0'));
  }

  @override
  List<GeneratedColumn> get $columns => [id, abbrev, symbol, exchangeRate];
  @override
  Currencies get asDslTable => this;
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
    if (data.containsKey('exchangeRate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchangeRate'], _exchangeRateMeta));
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
  Currencies createAlias(String alias) {
    return Currencies(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class BaseTransaction extends DataClass implements Insertable<BaseTransaction> {
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
  BaseTransaction(
      {@required this.id,
      @required this.amount,
      @required this.originalAmount,
      @required this.exchangeRate,
      @required this.isExpense,
      @required this.date,
      @required this.label,
      @required this.subcategoryId,
      @required this.monthId,
      @required this.currencyId});
  factory BaseTransaction.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return BaseTransaction(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      originalAmount: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}originalAmount']),
      exchangeRate: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}exchangeRate']),
      isExpense:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}isExpense']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      label:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}label']),
      subcategoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}subcategoryId']),
      monthId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}monthId']),
      currencyId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}currencyId']),
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
      map['originalAmount'] = Variable<double>(originalAmount);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchangeRate'] = Variable<double>(exchangeRate);
    }
    if (!nullToAbsent || isExpense != null) {
      map['isExpense'] = Variable<bool>(isExpense);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || subcategoryId != null) {
      map['subcategoryId'] = Variable<int>(subcategoryId);
    }
    if (!nullToAbsent || monthId != null) {
      map['monthId'] = Variable<int>(monthId);
    }
    if (!nullToAbsent || currencyId != null) {
      map['currencyId'] = Variable<int>(currencyId);
    }
    return map;
  }

  BaseTransactionsCompanion toCompanion(bool nullToAbsent) {
    return BaseTransactionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      originalAmount: originalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAmount),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      isExpense: isExpense == null && nullToAbsent
          ? const Value.absent()
          : Value(isExpense),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      subcategoryId: subcategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategoryId),
      monthId: monthId == null && nullToAbsent
          ? const Value.absent()
          : Value(monthId),
      currencyId: currencyId == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyId),
    );
  }

  factory BaseTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BaseTransaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      originalAmount: serializer.fromJson<double>(json['originalAmount']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      date: serializer.fromJson<DateTime>(json['date']),
      label: serializer.fromJson<String>(json['label']),
      subcategoryId: serializer.fromJson<int>(json['subcategoryId']),
      monthId: serializer.fromJson<int>(json['monthId']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
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
      'isExpense': serializer.toJson<bool>(isExpense),
      'date': serializer.toJson<DateTime>(date),
      'label': serializer.toJson<String>(label),
      'subcategoryId': serializer.toJson<int>(subcategoryId),
      'monthId': serializer.toJson<int>(monthId),
      'currencyId': serializer.toJson<int>(currencyId),
    };
  }

  BaseTransaction copyWith(
          {int id,
          double amount,
          double originalAmount,
          double exchangeRate,
          bool isExpense,
          DateTime date,
          String label,
          int subcategoryId,
          int monthId,
          int currencyId}) =>
      BaseTransaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        originalAmount: originalAmount ?? this.originalAmount,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        isExpense: isExpense ?? this.isExpense,
        date: date ?? this.date,
        label: label ?? this.label,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        monthId: monthId ?? this.monthId,
        currencyId: currencyId ?? this.currencyId,
      );
  @override
  String toString() {
    return (StringBuffer('BaseTransaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isExpense: $isExpense, ')
          ..write('date: $date, ')
          ..write('label: $label, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('monthId: $monthId, ')
          ..write('currencyId: $currencyId')
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
                      isExpense.hashCode,
                      $mrjc(
                          date.hashCode,
                          $mrjc(
                              label.hashCode,
                              $mrjc(
                                  subcategoryId.hashCode,
                                  $mrjc(monthId.hashCode,
                                      currencyId.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BaseTransaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.originalAmount == this.originalAmount &&
          other.exchangeRate == this.exchangeRate &&
          other.isExpense == this.isExpense &&
          other.date == this.date &&
          other.label == this.label &&
          other.subcategoryId == this.subcategoryId &&
          other.monthId == this.monthId &&
          other.currencyId == this.currencyId);
}

class BaseTransactionsCompanion extends UpdateCompanion<BaseTransaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<double> originalAmount;
  final Value<double> exchangeRate;
  final Value<bool> isExpense;
  final Value<DateTime> date;
  final Value<String> label;
  final Value<int> subcategoryId;
  final Value<int> monthId;
  final Value<int> currencyId;
  const BaseTransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.date = const Value.absent(),
    this.label = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.monthId = const Value.absent(),
    this.currencyId = const Value.absent(),
  });
  BaseTransactionsCompanion.insert({
    this.id = const Value.absent(),
    @required double amount,
    @required double originalAmount,
    @required double exchangeRate,
    @required bool isExpense,
    @required DateTime date,
    @required String label,
    @required int subcategoryId,
    @required int monthId,
    @required int currencyId,
  })  : amount = Value(amount),
        originalAmount = Value(originalAmount),
        exchangeRate = Value(exchangeRate),
        isExpense = Value(isExpense),
        date = Value(date),
        label = Value(label),
        subcategoryId = Value(subcategoryId),
        monthId = Value(monthId),
        currencyId = Value(currencyId);
  static Insertable<BaseTransaction> custom({
    Expression<int> id,
    Expression<double> amount,
    Expression<double> originalAmount,
    Expression<double> exchangeRate,
    Expression<bool> isExpense,
    Expression<DateTime> date,
    Expression<String> label,
    Expression<int> subcategoryId,
    Expression<int> monthId,
    Expression<int> currencyId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (originalAmount != null) 'originalAmount': originalAmount,
      if (exchangeRate != null) 'exchangeRate': exchangeRate,
      if (isExpense != null) 'isExpense': isExpense,
      if (date != null) 'date': date,
      if (label != null) 'label': label,
      if (subcategoryId != null) 'subcategoryId': subcategoryId,
      if (monthId != null) 'monthId': monthId,
      if (currencyId != null) 'currencyId': currencyId,
    });
  }

  BaseTransactionsCompanion copyWith(
      {Value<int> id,
      Value<double> amount,
      Value<double> originalAmount,
      Value<double> exchangeRate,
      Value<bool> isExpense,
      Value<DateTime> date,
      Value<String> label,
      Value<int> subcategoryId,
      Value<int> monthId,
      Value<int> currencyId}) {
    return BaseTransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      originalAmount: originalAmount ?? this.originalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isExpense: isExpense ?? this.isExpense,
      date: date ?? this.date,
      label: label ?? this.label,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      monthId: monthId ?? this.monthId,
      currencyId: currencyId ?? this.currencyId,
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
      map['originalAmount'] = Variable<double>(originalAmount.value);
    }
    if (exchangeRate.present) {
      map['exchangeRate'] = Variable<double>(exchangeRate.value);
    }
    if (isExpense.present) {
      map['isExpense'] = Variable<bool>(isExpense.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (subcategoryId.present) {
      map['subcategoryId'] = Variable<int>(subcategoryId.value);
    }
    if (monthId.present) {
      map['monthId'] = Variable<int>(monthId.value);
    }
    if (currencyId.present) {
      map['currencyId'] = Variable<int>(currencyId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isExpense: $isExpense, ')
          ..write('date: $date, ')
          ..write('label: $label, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('monthId: $monthId, ')
          ..write('currencyId: $currencyId')
          ..write(')'))
        .toString();
  }
}

class BaseTransactions extends Table
    with TableInfo<BaseTransactions, BaseTransaction> {
  final GeneratedDatabase _db;
  final String _alias;
  BaseTransactions(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;
  GeneratedRealColumn get amount => _amount ??= _constructAmount();
  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn('amount', $tableName, false,
        $customConstraints: 'NOT NULL CHECK (amount > 0)');
  }

  final VerificationMeta _originalAmountMeta =
      const VerificationMeta('originalAmount');
  GeneratedRealColumn _originalAmount;
  GeneratedRealColumn get originalAmount =>
      _originalAmount ??= _constructOriginalAmount();
  GeneratedRealColumn _constructOriginalAmount() {
    return GeneratedRealColumn('originalAmount', $tableName, false,
        $customConstraints: 'NOT NULL CHECK (originalAmount > 0)');
  }

  final VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  GeneratedRealColumn _exchangeRate;
  GeneratedRealColumn get exchangeRate =>
      _exchangeRate ??= _constructExchangeRate();
  GeneratedRealColumn _constructExchangeRate() {
    return GeneratedRealColumn('exchangeRate', $tableName, false,
        $customConstraints: 'NOT NULL CHECK (exchangeRate > 0)');
  }

  final VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
  GeneratedBoolColumn _isExpense;
  GeneratedBoolColumn get isExpense => _isExpense ??= _constructIsExpense();
  GeneratedBoolColumn _constructIsExpense() {
    return GeneratedBoolColumn('isExpense', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn('date', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _labelMeta = const VerificationMeta('label');
  GeneratedTextColumn _label;
  GeneratedTextColumn get label => _label ??= _constructLabel();
  GeneratedTextColumn _constructLabel() {
    return GeneratedTextColumn('label', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(label) >= 0 AND length(label) <= 256)');
  }

  final VerificationMeta _subcategoryIdMeta =
      const VerificationMeta('subcategoryId');
  GeneratedIntColumn _subcategoryId;
  GeneratedIntColumn get subcategoryId =>
      _subcategoryId ??= _constructSubcategoryId();
  GeneratedIntColumn _constructSubcategoryId() {
    return GeneratedIntColumn('subcategoryId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES subcategories (id)');
  }

  final VerificationMeta _monthIdMeta = const VerificationMeta('monthId');
  GeneratedIntColumn _monthId;
  GeneratedIntColumn get monthId => _monthId ??= _constructMonthId();
  GeneratedIntColumn _constructMonthId() {
    return GeneratedIntColumn('monthId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES months (id)');
  }

  final VerificationMeta _currencyIdMeta = const VerificationMeta('currencyId');
  GeneratedIntColumn _currencyId;
  GeneratedIntColumn get currencyId => _currencyId ??= _constructCurrencyId();
  GeneratedIntColumn _constructCurrencyId() {
    return GeneratedIntColumn('currencyId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES currencies (id)');
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        originalAmount,
        exchangeRate,
        isExpense,
        date,
        label,
        subcategoryId,
        monthId,
        currencyId
      ];
  @override
  BaseTransactions get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'baseTransactions';
  @override
  final String actualTableName = 'baseTransactions';
  @override
  VerificationContext validateIntegrity(Insertable<BaseTransaction> instance,
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
    if (data.containsKey('originalAmount')) {
      context.handle(
          _originalAmountMeta,
          originalAmount.isAcceptableOrUnknown(
              data['originalAmount'], _originalAmountMeta));
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('exchangeRate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchangeRate'], _exchangeRateMeta));
    } else if (isInserting) {
      context.missing(_exchangeRateMeta);
    }
    if (data.containsKey('isExpense')) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableOrUnknown(data['isExpense'], _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label'], _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('subcategoryId')) {
      context.handle(
          _subcategoryIdMeta,
          subcategoryId.isAcceptableOrUnknown(
              data['subcategoryId'], _subcategoryIdMeta));
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (data.containsKey('monthId')) {
      context.handle(_monthIdMeta,
          monthId.isAcceptableOrUnknown(data['monthId'], _monthIdMeta));
    } else if (isInserting) {
      context.missing(_monthIdMeta);
    }
    if (data.containsKey('currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currencyId'], _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BaseTransaction map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BaseTransaction.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  BaseTransactions createAlias(String alias) {
    return BaseTransactions(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class RecurrenceType extends DataClass implements Insertable<RecurrenceType> {
  final int id;
  final String name;
  RecurrenceType({@required this.id, @required this.name});
  factory RecurrenceType.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return RecurrenceType(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
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
    return map;
  }

  RecurrenceTypesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceTypesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory RecurrenceType.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RecurrenceType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  RecurrenceType copyWith({int id, String name}) => RecurrenceType(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('RecurrenceType(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is RecurrenceType &&
          other.id == this.id &&
          other.name == this.name);
}

class RecurrenceTypesCompanion extends UpdateCompanion<RecurrenceType> {
  final Value<int> id;
  final Value<String> name;
  const RecurrenceTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RecurrenceTypesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  static Insertable<RecurrenceType> custom({
    Expression<int> id,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RecurrenceTypesCompanion copyWith({Value<int> id, Value<String> name}) {
    return RecurrenceTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class RecurrenceTypes extends Table
    with TableInfo<RecurrenceTypes, RecurrenceType> {
  final GeneratedDatabase _db;
  final String _alias;
  RecurrenceTypes(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints:
            'NOT NULL CHECK (length(name) >= 0 AND length(name) <= 40)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  RecurrenceTypes get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'recurrenceTypes';
  @override
  final String actualTableName = 'recurrenceTypes';
  @override
  VerificationContext validateIntegrity(Insertable<RecurrenceType> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurrenceType map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return RecurrenceType.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  RecurrenceTypes createAlias(String alias) {
    return RecurrenceTypes(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Recurrence extends DataClass implements Insertable<Recurrence> {
  final int id;
  final int recurrenceType;
  final int transactionId;
  final DateTime until;
  Recurrence(
      {@required this.id,
      @required this.recurrenceType,
      @required this.transactionId,
      this.until});
  factory Recurrence.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Recurrence(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      recurrenceType: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}recurrenceType']),
      transactionId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}transactionId']),
      until:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}until']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || recurrenceType != null) {
      map['recurrenceType'] = Variable<int>(recurrenceType);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transactionId'] = Variable<int>(transactionId);
    }
    if (!nullToAbsent || until != null) {
      map['until'] = Variable<DateTime>(until);
    }
    return map;
  }

  RecurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurrencesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      recurrenceType: recurrenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceType),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      until:
          until == null && nullToAbsent ? const Value.absent() : Value(until),
    );
  }

  factory Recurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Recurrence(
      id: serializer.fromJson<int>(json['id']),
      recurrenceType: serializer.fromJson<int>(json['recurrenceType']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      until: serializer.fromJson<DateTime>(json['until']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recurrenceType': serializer.toJson<int>(recurrenceType),
      'transactionId': serializer.toJson<int>(transactionId),
      'until': serializer.toJson<DateTime>(until),
    };
  }

  Recurrence copyWith(
          {int id, int recurrenceType, int transactionId, DateTime until}) =>
      Recurrence(
        id: id ?? this.id,
        recurrenceType: recurrenceType ?? this.recurrenceType,
        transactionId: transactionId ?? this.transactionId,
        until: until ?? this.until,
      );
  @override
  String toString() {
    return (StringBuffer('Recurrence(')
          ..write('id: $id, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('transactionId: $transactionId, ')
          ..write('until: $until')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(recurrenceType.hashCode,
          $mrjc(transactionId.hashCode, until.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Recurrence &&
          other.id == this.id &&
          other.recurrenceType == this.recurrenceType &&
          other.transactionId == this.transactionId &&
          other.until == this.until);
}

class RecurrencesCompanion extends UpdateCompanion<Recurrence> {
  final Value<int> id;
  final Value<int> recurrenceType;
  final Value<int> transactionId;
  final Value<DateTime> until;
  const RecurrencesCompanion({
    this.id = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.until = const Value.absent(),
  });
  RecurrencesCompanion.insert({
    this.id = const Value.absent(),
    @required int recurrenceType,
    @required int transactionId,
    this.until = const Value.absent(),
  })  : recurrenceType = Value(recurrenceType),
        transactionId = Value(transactionId);
  static Insertable<Recurrence> custom({
    Expression<int> id,
    Expression<int> recurrenceType,
    Expression<int> transactionId,
    Expression<DateTime> until,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recurrenceType != null) 'recurrenceType': recurrenceType,
      if (transactionId != null) 'transactionId': transactionId,
      if (until != null) 'until': until,
    });
  }

  RecurrencesCompanion copyWith(
      {Value<int> id,
      Value<int> recurrenceType,
      Value<int> transactionId,
      Value<DateTime> until}) {
    return RecurrencesCompanion(
      id: id ?? this.id,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      transactionId: transactionId ?? this.transactionId,
      until: until ?? this.until,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recurrenceType.present) {
      map['recurrenceType'] = Variable<int>(recurrenceType.value);
    }
    if (transactionId.present) {
      map['transactionId'] = Variable<int>(transactionId.value);
    }
    if (until.present) {
      map['until'] = Variable<DateTime>(until.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrencesCompanion(')
          ..write('id: $id, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('transactionId: $transactionId, ')
          ..write('until: $until')
          ..write(')'))
        .toString();
  }
}

class Recurrences extends Table with TableInfo<Recurrences, Recurrence> {
  final GeneratedDatabase _db;
  final String _alias;
  Recurrences(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _recurrenceTypeMeta =
      const VerificationMeta('recurrenceType');
  GeneratedIntColumn _recurrenceType;
  GeneratedIntColumn get recurrenceType =>
      _recurrenceType ??= _constructRecurrenceType();
  GeneratedIntColumn _constructRecurrenceType() {
    return GeneratedIntColumn('recurrenceType', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES recurrenceTypes (id)');
  }

  final VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  GeneratedIntColumn _transactionId;
  GeneratedIntColumn get transactionId =>
      _transactionId ??= _constructTransactionId();
  GeneratedIntColumn _constructTransactionId() {
    return GeneratedIntColumn('transactionId', $tableName, false,
        $customConstraints:
            'NOT NULL REFERENCES recurrences (id) ON DELETE CASCADE');
  }

  final VerificationMeta _untilMeta = const VerificationMeta('until');
  GeneratedDateTimeColumn _until;
  GeneratedDateTimeColumn get until => _until ??= _constructUntil();
  GeneratedDateTimeColumn _constructUntil() {
    return GeneratedDateTimeColumn('until', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, recurrenceType, transactionId, until];
  @override
  Recurrences get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'recurrences';
  @override
  final String actualTableName = 'recurrences';
  @override
  VerificationContext validateIntegrity(Insertable<Recurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('recurrenceType')) {
      context.handle(
          _recurrenceTypeMeta,
          recurrenceType.isAcceptableOrUnknown(
              data['recurrenceType'], _recurrenceTypeMeta));
    } else if (isInserting) {
      context.missing(_recurrenceTypeMeta);
    }
    if (data.containsKey('transactionId')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transactionId'], _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('until')) {
      context.handle(
          _untilMeta, until.isAcceptableOrUnknown(data['until'], _untilMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurrence map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Recurrence.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Recurrences createAlias(String alias) {
    return Recurrences(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
      currencyId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}currencyId']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || currencyId != null) {
      map['currencyId'] = Variable<int>(currencyId);
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
      if (currencyId != null) 'currencyId': currencyId,
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
      map['currencyId'] = Variable<int>(currencyId.value);
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

class UserProfiles extends Table with TableInfo<UserProfiles, UserProfile> {
  final GeneratedDatabase _db;
  final String _alias;
  UserProfiles(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _currencyIdMeta = const VerificationMeta('currencyId');
  GeneratedIntColumn _currencyId;
  GeneratedIntColumn get currencyId => _currencyId ??= _constructCurrencyId();
  GeneratedIntColumn _constructCurrencyId() {
    return GeneratedIntColumn('currencyId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES currencies (id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, currencyId];
  @override
  UserProfiles get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'userProfiles';
  @override
  final String actualTableName = 'userProfiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currencyId'], _currencyIdMeta));
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
  UserProfiles createAlias(String alias) {
    return UserProfiles(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  Categories _categories;
  Categories get categories => _categories ??= Categories(this);
  Subcategories _subcategories;
  Subcategories get subcategories => _subcategories ??= Subcategories(this);
  Months _months;
  Months get months => _months ??= Months(this);
  Currencies _currencies;
  Currencies get currencies => _currencies ??= Currencies(this);
  BaseTransactions _baseTransactions;
  BaseTransactions get baseTransactions =>
      _baseTransactions ??= BaseTransactions(this);
  RecurrenceTypes _recurrenceTypes;
  RecurrenceTypes get recurrenceTypes =>
      _recurrenceTypes ??= RecurrenceTypes(this);
  Recurrences _recurrences;
  Recurrences get recurrences => _recurrences ??= Recurrences(this);
  View _fullTransactions;
  View get fullTransactions => _fullTransactions ??= View('fullTransactions',
      'CREATE VIEW fullTransactions AS\r\nWITH RECURSIVE tmp(id, txDate, recType, until, name) AS (\r\n    SELECT t.id, t.date, r.recurrenceType, r.until, rt.name\r\n    FROM recurrences r,\r\n         baseTransactions t,\r\n         recurrenceTypes rt\r\n    WHERE t.id = r.transactionId\r\n      AND r.recurrenceType = rt.id\r\n    UNION\r\n    SELECT id,\r\n           (SELECT CASE tmp.recType\r\n                       WHEN 1 THEN\r\n        DATE (tmp.txDate)\r\n        WHEN 2 THEN DATE (tmp.txDate, \'+1 day\')\r\n        WHEN 3 THEN DATE (tmp.txDate, \'+7 days\')\r\n        ELSE tmp.txDate\r\n--         WHEN 4 THEN DATE (tmp.txDate, \'+1 month\', \'start of month\', \'weekday 5\', \'+7 days\')\r\nEND\r\n) AS txDate, recType, until, name\r\n      FROM tmp WHERE txDate <= until\r\n    )\r\nSELECT t.id,\r\n       t.amount,\r\n       t.originalAmount,\r\n       t.exchangeRate,\r\n       t.isExpense,\r\n       tmp.txDate AS date,\r\n       t.label,\r\n       t.subcategoryId,\r\n       (SELECT id FROM months m WHERE m.firstDate <= tmp.txDate AND m.lastDate >= tmp.txDate) AS monthId,\r\n       t.currencyId,\r\n       tmp.recType AS recurrenceType,\r\n       tmp.until,\r\n       tmp.name AS recurrenceName\r\nFROM tmp,\r\n     baseTransactions t\r\nWHERE tmp.id = t.id;');
  UserProfiles _userProfiles;
  UserProfiles get userProfiles => _userProfiles ??= UserProfiles(this);
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
  Selectable<UserProfile> getUserProfile() {
    return customSelect('SELECT * FROM userProfiles WHERE id = 1',
        variables: [], readsFrom: {userProfiles}).map(userProfiles.mapFromRow);
  }

  Selectable<int> getTimestamp() {
    return customSelect(
        'SELECT CAST(strftime(\'%s\', \'now\', \'localtime\') AS INT) * 1000 AS timestamp',
        variables: [],
        readsFrom: {}).map((QueryRow row) => row.readInt('timestamp'));
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        subcategories,
        months,
        currencies,
        baseTransactions,
        recurrenceTypes,
        recurrences,
        fullTransactions,
        userProfiles
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subcategories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recurrences',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recurrences', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Recurrences get recurrences => attachedDatabase.recurrences;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  Selectable<Category> allCategories() {
    return customSelect('SELECT * FROM categories',
        variables: [], readsFrom: {categories}).map(categories.mapFromRow);
  }

  Selectable<Category> categoriesByType(bool isExpense) {
    return customSelect('SELECT * FROM categories WHERE isExpense=:isExpense',
        variables: [Variable<bool>(isExpense)],
        readsFrom: {categories}).map(categories.mapFromRow);
  }

  Future<int> deleteCustomCategory(int id) {
    return customUpdate(
      'DELETE FROM categories WHERE id=:id AND NOT isPreset',
      variables: [Variable<int>(id)],
      updates: {categories},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<Subcategory> allSubcategories() {
    return customSelect('SELECT * FROM subcategories',
        variables: [],
        readsFrom: {subcategories}).map(subcategories.mapFromRow);
  }

  Selectable<Subcategory> allSubcategoriesOfCategory(int categoryId) {
    return customSelect(
        'SELECT * FROM subcategories WHERE categoryId=:categoryId',
        variables: [Variable<int>(categoryId)],
        readsFrom: {subcategories}).map(subcategories.mapFromRow);
  }
}

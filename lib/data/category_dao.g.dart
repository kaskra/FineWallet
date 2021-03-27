// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  RecurrenceTypes get recurrenceTypes => attachedDatabase.recurrenceTypes;
  Categories get categories => attachedDatabase.categories;
  Subcategories get subcategories => attachedDatabase.subcategories;
  Months get months => attachedDatabase.months;
  Currencies get currencies => attachedDatabase.currencies;
  UserProfiles get userProfiles => attachedDatabase.userProfiles;
  BaseTransactions get baseTransactions => attachedDatabase.baseTransactions;
  Selectable<Category> _allCategories() {
    return customSelect('SELECT * FROM categories',
        variables: [], readsFrom: {categories}).map(categories.mapFromRow);
  }

  Selectable<Category> _categoriesByType(bool isExpense) {
    return customSelect('SELECT * FROM categories WHERE isExpense=:isExpense',
        variables: [Variable<bool>(isExpense)],
        readsFrom: {categories}).map(categories.mapFromRow);
  }

  Future<int> _deleteCustomCategory(int id) {
    return customUpdate(
      'DELETE FROM categories WHERE id=:id AND NOT isPreset',
      variables: [Variable<int>(id)],
      updates: {categories},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<Subcategory> _allSubcategories() {
    return customSelect('SELECT * FROM subcategories',
        variables: [],
        readsFrom: {subcategories}).map(subcategories.mapFromRow);
  }

  Selectable<Subcategory> _allSubcategoriesOfCategory(int categoryId) {
    return customSelect(
        'SELECT * FROM subcategories WHERE categoryId=:categoryId',
        variables: [Variable<int>(categoryId)],
        readsFrom: {subcategories}).map(subcategories.mapFromRow);
  }
}

import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'transactions_test.dart';

final cat1 = CategoriesCompanion.insert(name: "Test1", iconCodePoint: 55555);

void main() {
  moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testCategory();
  testSubcategory();
}

void testCategory() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(e: VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  test('create category inserts into table', () async {
    final before = await database.categoryDao.getAllCategories();

    expect(before, hasLength(10));

    await database.categoryDao.insertCategory(cat1);
    final after = await database.categoryDao.getAllCategories();

    expect(after, hasLength(11));
  });

  test('insert null throws exception', () async {
    expect(database.categoryDao.insertCategory(null),
        throwsA(isInstanceOf<InvalidDataException>()));
  });

  test('update category updates', () async {
    final id = await database.categoryDao.insertCategory(cat1);
    final before = await database.categoryDao.getAllCategories();

    expect(before.last.name, equals("Test1"));
    final didUpdate = await database.categoryDao.updateCategory(
        cat1.copyWith(id: Value(id), name: const Value("TestTest")));

    expect(didUpdate, isTrue);

    final after = await database.categoryDao.getAllCategories();
    expect(after.last.name, equals("TestTest"));
  });

  test('update null throws exception', () async {
    expect(database.categoryDao.updateCategory(null),
        throwsA(isInstanceOf<NoSuchMethodError>()));
  });

  test('delete category deletes rows from table', () async {
    final id = await database.categoryDao.insertCategory(cat1);

    final numDeletedRos =
        await database.categoryDao.deleteCategory(cat1.copyWith(id: Value(id)));

    final after = await database.categoryDao.getAllCategories();

    expect(numDeletedRos, equals(1));
    expect(after, hasLength(10));
  });

  test('delete null throws exception', () async {
    try {
      await database.categoryDao.deleteCategory(null);
    } catch (e) {
      expect(true, isTrue);
      return;
    }
    expect(false, isTrue);
  });

  test('get categories by type only returns same type of categories', () async {
    await database.categoryDao.insertCategory(cat1);
    final expenses =
        await database.categoryDao.getAllCategoriesByType(isExpense: true);
    expect(expenses, hasLength(10));
    expect(
        expenses
            .map((e) => e.isExpense)
            .reduce((value, element) => value && element),
        isTrue);
  });

  test('deleteCategoryWithSubcategories deletes non-preset categories',
      () async {
    final id = await database.categoryDao.insertCategory(cat1);
    final before = await database.categoryDao.getAllCategories();
    await database.categoryDao.deleteCategoryWithSubcategories(id);
    final after = await database.categoryDao.getAllCategories();

    expect(before, hasLength(11));
    expect(after, hasLength(10));
  });

  test('deleteCategoryWithSubcategories not deletes preset categories',
      () async {
    final before = await database.categoryDao.getAllCategories();
    await database.categoryDao.deleteCategoryWithSubcategories(1);
    final after = await database.categoryDao.getAllCategories();

    expect(before, hasLength(10));
    expect(after, hasLength(10));
  });

  test('deleteCategoryWithSubcategories also deletes subcategories', () async {
    final id = await database.categoryDao.insertCategory(cat1);
    await database.categoryDao.insertSubcategory(
        SubcategoriesCompanion.insert(name: "TestSub1", categoryId: id));
    await database.categoryDao.insertSubcategory(
        SubcategoriesCompanion.insert(name: "TestSub2", categoryId: id));

    final before = await database.categoryDao.getAllCategories();
    final subcatsBefore = await database.categoryDao.getAllSubcategories();
    await database.categoryDao.deleteCategoryWithSubcategories(id);
    final subcatsAfter = await database.categoryDao.getAllSubcategories();
    final after = await database.categoryDao.getAllCategories();

    expect(before, hasLength(11));
    expect(after, hasLength(10));

    expect(subcatsBefore, hasLength(70));
    expect(subcatsAfter, hasLength(68));
  });

  test(
      'deleteCategoryWithSubcategories with wrong input does not delete anything',
      () async {
    final before = await database.categoryDao.getAllCategories();
    await database.categoryDao.deleteCategoryWithSubcategories(null);
    final after = await database.categoryDao.getAllCategories();

    expect(before, hasLength(10));
    expect(after, hasLength(10));
  });

  test('category cannot be deleted if used in transaction', () async {
    final id = await database.categoryDao.insertCategory(cat1);
    final subcatId = await database.categoryDao.insertSubcategory(
        SubcategoriesCompanion.insert(name: "TestSub1", categoryId: id));

    await database.transactionDao.insertTransaction(
        onceTransactions[1].copyWith(subcategoryId: subcatId));

    final before = await database.categoryDao.getAllCategories();
    expect(before, hasLength(11));

    expect(database.categoryDao.deleteCategoryWithSubcategories(id),
        throwsA(isInstanceOf<SqliteException>()));
  });
}

void testSubcategory() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(e: VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  test('get all subcategories returns correct amount of subcategories',
      () async {
    final subcats = await database.categoryDao.getAllSubcategories();

    expect(subcats, hasLength(68));
  });

  test('subcategory of id returns only entries with of same category ',
      () async {
    final subcats = await database.categoryDao.getAllSubcategoriesOf(1);

    expect(subcats, hasLength(5));
    expect(
        subcats.map((e) => e.categoryId).fold(
            true, (bool prevValue, int element) => prevValue && element == 1),
        isTrue);
  });

  test('subcategory of id returns nothing for wrong id ', () async {
    final subcats = await database.categoryDao.getAllSubcategoriesOf(null);
    expect(subcats, isEmpty);
  });

  test('insert subcategory creates row in table', () async {
    final id = await database.categoryDao.insertSubcategory(
        SubcategoriesCompanion.insert(name: "Sub1", categoryId: 1));

    final subcats = await database.categoryDao.getAllSubcategoriesOf(1);

    expect(subcats.last.id, id);
  });

  test('insert subcategory creates nothing for null input', () async {
    expect(database.categoryDao.insertSubcategory(null),
        throwsA(isInstanceOf<InvalidDataException>()));
  });

  test('delete subcategory removes row from table', () async {
    await database.categoryDao.insertSubcategory(
        SubcategoriesCompanion.insert(name: "Sub1", categoryId: 1));
    final subcatsBefore = await database.categoryDao.getAllSubcategoriesOf(1);

    final removedRows =
        await database.categoryDao.deleteSubcategory(subcatsBefore.last);
    final subcatsAfter = await database.categoryDao.getAllSubcategoriesOf(1);

    expect(subcatsBefore.length - 1, equals(subcatsAfter.length));
    expect(removedRows, equals(1));
  });

  test('delete null removes nothing from table', () async {
    try {
      await database.categoryDao.deleteSubcategory(null);
    } catch (e) {
      expect(true, isTrue);
      return;
    }
    expect(false, isTrue);
  });
}

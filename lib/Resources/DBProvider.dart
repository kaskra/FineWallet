import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/subcategory_model.dart';

class DBProvider{
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Transactions.db");
    return await openDatabase(path, version:1, onOpen: (db){}, onCreate: (Database db, int version) async{
      await db.execute("CREATE TABLE transactions ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "subcategory INTEGER,"
        "amount REAL,"
        "date INTEGER,"
        "isExpense INTEGER" 
      ")");
      await db.execute("CREATE TABLE categories("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT"    
      ")");
      await db.execute("CREATE TABLE subcategories ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT,"
        "category INTEGER"
      ")");
    });
  }

  newTransaction(TransactionModel newTransaction) async{
    final db = await database;
    var raw = await db.insert("transactions", newTransaction.toMap());
    return raw;
  }

  newCategory(CategoryModel newCategory) async {
    final db = await database;
    var raw = await db.insert("categories", newCategory.toMap());
    return raw;
  }

  newSubcategory(SubcategoryModel newSubcategory) async {
    final db = await database;

    // var nameUsed = await db.rawQuery("SELECT name FROM subcategories WHERE name = ${newSubcategory.name}");
    // if (nameUsed.isNotEmpty) throw Exception("Please ");

    var raw = await db.insert("subcategories", newSubcategory.toMap());
    return raw;
  }

  Future<List<TransactionModel>> getAllTransactions() async{
    final db = await database;
    var res = await db.query("transactions");
    List<TransactionModel> list = res.isNotEmpty ? res.map((t) => TransactionModel.fromMap(t)).toList(): [];
    return list;
  }

  Future<List<TransactionModel>> getTransactionsOfDay(int dayInMillis) async {
    final db = await database;
    var res = await db.query("transactions", where: "date = ?", whereArgs: [dayInMillis]);
    List<TransactionModel> list = res.isNotEmpty ? res.map((t) => TransactionModel.fromMap(t)).toList(): [];
    return list;
  }

  Future<List<TransactionModel>> getTransactionsByCategory(String categoryName) async{
    final db = await database;
    var table = await db.query("category", columns: ["id"] ,where: "name = ?", whereArgs: [categoryName]);
    int id = table.first["id"];
    var res = await db.query("transactions", where: "category = ?", whereArgs: [id]);
    List<TransactionModel> list = res.isNotEmpty ? res.map((t) => TransactionModel.fromMap(t)).toList(): [];
    return list;
  }

  Future<List<TransactionModel>> getExpensesGroupedByDay() async {
    final db = await database;
    var res = await db.rawQuery("SELECT date, SUM(amount) FROM transactions WHERE isExpense=1 GROUP BY date ORDER BY date");
    List<TransactionModel> list = res.isNotEmpty ? res.map((t) => TransactionModel.fromMap(t)).toList(): [];
    return list;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    var res = await db.query("categories");
    List<CategoryModel> list = res.isNotEmpty ? res.map((c) => CategoryModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<CategoryModel>> getExpenseCategories() async {
    final db = await database;
    var res = await db.query("categories", where: "id != ?", whereArgs: [10]);
    List<CategoryModel> list = res.isNotEmpty ? res.map((c) => CategoryModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<CategoryModel>> getIncomeCategory() async {
    final db = await database;
    var res = await db.query("categories", where: "id = ?", whereArgs: [10]);
    List<CategoryModel> list = res.isNotEmpty ? res.map((c) => CategoryModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SubcategoryModel>> getAllSubcategories() async {
    final db = await database;
    var res = await db.query("subcategories");
    List<SubcategoryModel> list = res.isNotEmpty ? res.map((c) => SubcategoryModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SubcategoryModel>> getSubcategoriesOfCategory(int id) async {
    final db = await database;
    var res = await db.query("subcategories", where: "category = ?", whereArgs: [id]);
    List<SubcategoryModel> list = res.isNotEmpty ? res.map((c) => SubcategoryModel.fromMap(c)).toList() : [];
    return list;
  }

  deleteTransaction(int id) async {
    final db = await database;
    return db.delete("transactions", where: "id = ?", whereArgs: [id]);
  }

  deleteCategory(int id) async {
    final db = await database;
    await deleteAllSubcategoriesOfCategory(id);
    return db.delete("categories", where: "id = ?", whereArgs: [id]);
  }
    
  deleteSubcategory(int id) async {
    final db = await database;
    return db.delete("subcategories", where: "id = ?", whereArgs: [id]);
  }

  deleteAllSubcategoriesOfCategory(int id) async {
    final db = await database;
    return db.delete("subcategories", where: "category = ?", whereArgs: [id]);
  }

}
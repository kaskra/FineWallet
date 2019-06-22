/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:io';

import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/subcategory_model.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/db_migration.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Provider {
  Provider._();

  static final Provider db = Provider._();
  static const int VERSION = 2;

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
    return await openDatabase(path, version: VERSION, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE transactions ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "subcategory INTEGER,"
          "amount REAL,"
          "date INTEGER,"
          "isExpense INTEGER,"
          "isRecurring INTEGER,"
          "replayType INTEGER,"
          "replayUntil INTEGER"
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
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion > newVersion) return;

      for (int oVersion in Migration.migrationScripts.keys) {
        if (oVersion >= oldVersion) {
          print("Migrating database to version $oVersion");
          for (String query in Migration.migrationScripts[oVersion]) {
            await db.execute(query);
          }
        }
      }
    });
  }

  newTransaction(TransactionModel newTransaction) async {
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
    var raw = await db.insert("subcategories", newSubcategory.toMap());
    return raw;
  }

  deleteTransaction(int id) async {
    final db = await database;
    return db.delete("transactions", where: "id = ?", whereArgs: [id]);
  }

  deleteCategory(int id) async {
    final db = await database;
    await _deleteAllSubcategoriesOfCategory(id);
    return db.delete("categories", where: "id = ?", whereArgs: [id]);
  }

  deleteSubcategory(int id) async {
    final db = await database;
    return db.delete("subcategories", where: "id = ?", whereArgs: [id]);
  }

  _deleteAllSubcategoriesOfCategory(int id) async {
    final db = await database;
    return db.delete("subcategories", where: "category = ?", whereArgs: [id]);
  }
}

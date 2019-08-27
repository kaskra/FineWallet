/*
 * Developed by Lukas Krauch 23.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/models/category_model.dart';
import 'package:FineWallet/models/month_model.dart';
import 'package:FineWallet/models/subcategory_model.dart';
import 'package:FineWallet/resources/category_list.dart';
import 'package:FineWallet/resources/category_provider.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/month_provider.dart';
import 'package:FineWallet/utils.dart';

void initDB() async {
  CategoryList categories = await CategoryProvider.db.getAllCategories();
  if (categories.length == 0) {
    var cat1 = CategoryModel(name: "Various");
    var cat2 = CategoryModel(name: "Myself");
    var cat3 = CategoryModel(name: "Food & Drinks");
    var cat4 = CategoryModel(name: "Home");
    var cat5 = CategoryModel(name: "Spare Time");
    var cat6 = CategoryModel(name: "Transport");
    var cat7 = CategoryModel(name: "Medical");
    var cat8 = CategoryModel(name: "Clothes");
    var cat9 = CategoryModel(name: "Gifts");

    var cat10 = CategoryModel(name: "Income");

    DatabaseProvider.db.newCategory(cat1);
    DatabaseProvider.db.newCategory(cat2);
    DatabaseProvider.db.newCategory(cat3);
    DatabaseProvider.db.newCategory(cat4);
    DatabaseProvider.db.newCategory(cat5);
    DatabaseProvider.db.newCategory(cat6);
    DatabaseProvider.db.newCategory(cat7);
    DatabaseProvider.db.newCategory(cat8);
    DatabaseProvider.db.newCategory(cat9);
    DatabaseProvider.db.newCategory(cat10);
  }

  List<SubcategoryModel> subcategories =
      await CategoryProvider.db.getSubcategories();
  if (subcategories.length == 0) {
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Debt"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Tuition"));
    DatabaseProvider.db.newSubcategory(
        SubcategoryModel(category: 1, name: "Computer & Supply"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Mail"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Gadget"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Mobile"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Tax"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Pet"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 2, name: "Education"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Fitness"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 2, name: "Subscription"));

    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Grocieres"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Sweets"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Backery"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Fast Food"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Take Away"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Café"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Dining Out"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Drinks"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Fruits"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Breakfast"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Ice Cream"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Baking"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "BBQ"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Rent"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Laundry"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 4, name: "Electricity"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Internet"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Cable"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Water"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Repairs"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Plants"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 4, name: "Furniture"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Heating"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Hotel"));

    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 5, name: "Going Out"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Event"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cinema"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Sport"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cultural"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Book"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Music"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "App"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Software"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Shopping"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Gas"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Maintenance"));
    DatabaseProvider.db.newSubcategory(
        SubcategoryModel(category: 6, name: "Public Transport"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Taxi"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Car Insurance"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Flight"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Parking"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Car Rental"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Penalty"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Medicine"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 7, name: "Doctors Visit"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Hospital"));
    DatabaseProvider.db.newSubcategory(
        SubcategoryModel(category: 7, name: "Medical Insurance"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Clothes"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Shoes"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 8, name: "Accessoire"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 8, name: "Underwear"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Bag"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Gift"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Souvenir"));

    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 10, name: "Payment"));
    DatabaseProvider.db
        .newSubcategory(SubcategoryModel(category: 10, name: "Money Gift"));
    DatabaseProvider.db.newSubcategory(SubcategoryModel(category: 10, name: "Voucher"));
  }

  int numRecordedMonths = await MonthProvider.db.amountRecordedMonths();
  if (numRecordedMonths == 0) {
    DatabaseProvider.db.newMonth(MonthModel(
        firstDayOfMonth:
            dayInMillis(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        currentMaxBudget: 0.0,
        savings: 0.0,
        monthlyExpenses: 0.0));
  }
}

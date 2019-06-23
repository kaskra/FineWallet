/*
 * Developed by Lukas Krauch 23.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/month_model.dart';
import 'package:finewallet/Models/subcategory_model.dart';
import 'package:finewallet/resources/category_list.dart';
import 'package:finewallet/resources/category_provider.dart';
import 'package:finewallet/resources/db_provider.dart';
import 'package:finewallet/resources/month_provider.dart';
import 'package:finewallet/utils.dart';

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

    Provider.db.newCategory(cat1);
    Provider.db.newCategory(cat2);
    Provider.db.newCategory(cat3);
    Provider.db.newCategory(cat4);
    Provider.db.newCategory(cat5);
    Provider.db.newCategory(cat6);
    Provider.db.newCategory(cat7);
    Provider.db.newCategory(cat8);
    Provider.db.newCategory(cat9);
    Provider.db.newCategory(cat10);
  }

  List<SubcategoryModel> subcategories =
      await CategoryProvider.db.getSubcategories();
  if (subcategories.length == 0) {
    Provider.db.newSubcategory(SubcategoryModel(category: 1, name: "Debt"));
    Provider.db.newSubcategory(SubcategoryModel(category: 1, name: "Tuition"));
    Provider.db.newSubcategory(
        SubcategoryModel(category: 1, name: "Computer & Supply"));
    Provider.db.newSubcategory(SubcategoryModel(category: 1, name: "Mail"));
    Provider.db.newSubcategory(SubcategoryModel(category: 1, name: "Gadget"));

    Provider.db.newSubcategory(SubcategoryModel(category: 2, name: "Mobile"));
    Provider.db.newSubcategory(SubcategoryModel(category: 2, name: "Tax"));
    Provider.db.newSubcategory(SubcategoryModel(category: 2, name: "Pet"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 2, name: "Education"));
    Provider.db.newSubcategory(SubcategoryModel(category: 2, name: "Fitness"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 2, name: "Subscription"));

    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Grocieres"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Sweets"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Backery"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Fast Food"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Take Away"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Café"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Dining Out"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Drinks"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Fruits"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Breakfast"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 3, name: "Ice Cream"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "Baking"));
    Provider.db.newSubcategory(SubcategoryModel(category: 3, name: "BBQ"));

    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Rent"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Laundry"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 4, name: "Electricity"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Internet"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Cable"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Water"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Repairs"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Plants"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 4, name: "Furniture"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Heating"));
    Provider.db.newSubcategory(SubcategoryModel(category: 4, name: "Hotel"));

    Provider.db
        .newSubcategory(SubcategoryModel(category: 5, name: "Going Out"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Event"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cinema"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Sport"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cultural"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Book"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Music"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "App"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Software"));
    Provider.db.newSubcategory(SubcategoryModel(category: 5, name: "Shopping"));

    Provider.db.newSubcategory(SubcategoryModel(category: 6, name: "Gas"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Maintenance"));
    Provider.db.newSubcategory(
        SubcategoryModel(category: 6, name: "Public Transport"));
    Provider.db.newSubcategory(SubcategoryModel(category: 6, name: "Taxi"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Car Insurance"));
    Provider.db.newSubcategory(SubcategoryModel(category: 6, name: "Flight"));
    Provider.db.newSubcategory(SubcategoryModel(category: 6, name: "Parking"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 6, name: "Car Rental"));
    Provider.db.newSubcategory(SubcategoryModel(category: 6, name: "Penalty"));

    Provider.db.newSubcategory(SubcategoryModel(category: 7, name: "Medicine"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 7, name: "Doctors Visit"));
    Provider.db.newSubcategory(SubcategoryModel(category: 7, name: "Hospital"));
    Provider.db.newSubcategory(
        SubcategoryModel(category: 7, name: "Medical Insurance"));

    Provider.db.newSubcategory(SubcategoryModel(category: 8, name: "Clothes"));
    Provider.db.newSubcategory(SubcategoryModel(category: 8, name: "Shoes"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 8, name: "Accessoire"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 8, name: "Underwear"));
    Provider.db.newSubcategory(SubcategoryModel(category: 8, name: "Bag"));

    Provider.db.newSubcategory(SubcategoryModel(category: 9, name: "Gift"));
    Provider.db.newSubcategory(SubcategoryModel(category: 9, name: "Souvenir"));

    Provider.db.newSubcategory(SubcategoryModel(category: 10, name: "Payment"));
    Provider.db
        .newSubcategory(SubcategoryModel(category: 10, name: "Money Gift"));
    Provider.db.newSubcategory(SubcategoryModel(category: 10, name: "Voucher"));
  }

  int numRecordedMonths = await MonthProvider.db.amountRecordedMonths();
  if (numRecordedMonths == 0) {
    Provider.db.newMonth(MonthModel(
      firstDayOfMonth:
          dayInMillis(DateTime(DateTime.now().year, DateTime.now().month, 1)),
      currentMaxBudget: 0.0,
      savings: 0.0,
    ));
  }
}

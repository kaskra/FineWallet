import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/subcategory_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';

void initDB() async {
  List<CategoryModel> categories = await DBProvider.db.getAllCategories();
  if (categories.length == 0){
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

    DBProvider.db.newCategory(cat1);
    DBProvider.db.newCategory(cat2);
    DBProvider.db.newCategory(cat3);
    DBProvider.db.newCategory(cat4);
    DBProvider.db.newCategory(cat5);
    DBProvider.db.newCategory(cat6);
    DBProvider.db.newCategory(cat7);
    DBProvider.db.newCategory(cat8);
    DBProvider.db.newCategory(cat9);
    DBProvider.db.newCategory(cat10);
  }

  List<SubcategoryModel> subcategories = await DBProvider.db.getAllSubcategories();
  if (subcategories.length == 0) {
    DBProvider.db.newSubcategory(SubcategoryModel(category: 0, name: "Debt"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 0, name: "Tuition"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 0, name: "Computer & Supply"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 0, name: "Mail"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 0, name: "Gadget"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Mobile"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Tax"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Pet"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Education"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Fitness"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Subscription"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Grocieres"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Sweets"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Backery"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Fast Food"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Take Away"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Café"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Dining Out"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Drinks"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Fruits"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Breakfast"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Ice Cream"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Baking"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "BBQ"));
    
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Rent"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Laundry"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Electricity"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Internet"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Cable"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Water"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Repairs"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Plants"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Furniture"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Heating"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Hotel"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Going Out"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Event"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Cinema"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Sport"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Cultural"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Book"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Music"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "App"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Software"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Shopping"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Gas"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Maintenance"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Public Transport"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Taxi"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Car Insurance"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Flight"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Parking"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Car Rental"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Penalty"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Medicine"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Doctors Visit"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Hospital"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Medical Insurance"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Clothes"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Shoes"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Accessoire"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Underwear"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Bag"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Gift"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Souvenir"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Payment"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Money Gift"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Voucher"));

  }

}
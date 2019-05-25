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
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Debt"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Tuition"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Computer & Supply"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Mail"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 1, name: "Gadget"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Mobile"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Tax"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Pet"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Education"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Fitness"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 2, name: "Subscription"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Grocieres"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Sweets"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Backery"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Fast Food"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Take Away"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Café"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Dining Out"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Drinks"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Fruits"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Breakfast"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Ice Cream"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "Baking"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 3, name: "BBQ"));
    
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Rent"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Laundry"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Electricity"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Internet"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Cable"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Water"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Repairs"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Plants"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Furniture"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Heating"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 4, name: "Hotel"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Going Out"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Event"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cinema"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Sport"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Cultural"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Book"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Music"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "App"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Software"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 5, name: "Shopping"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Gas"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Maintenance"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Public Transport"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Taxi"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Car Insurance"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Flight"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Parking"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Car Rental"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 6, name: "Penalty"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Medicine"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Doctors Visit"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Hospital"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 7, name: "Medical Insurance"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Clothes"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Shoes"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Accessoire"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Underwear"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 8, name: "Bag"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Gift"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 9, name: "Souvenir"));

    DBProvider.db.newSubcategory(SubcategoryModel(category: 10, name: "Payment"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 10, name: "Money Gift"));
    DBProvider.db.newSubcategory(SubcategoryModel(category: 10, name: "Voucher"));

  }

}
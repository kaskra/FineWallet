import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/utils.dart';
import 'package:moor/moor.dart';

var _cat1 = CategoriesCompanion.insert(name: "Various");
var _cat2 = CategoriesCompanion.insert(name: "Myself");
var _cat3 = CategoriesCompanion.insert(name: "Food & Drinks");
var _cat4 = CategoriesCompanion.insert(name: "Home");
var _cat5 = CategoriesCompanion.insert(name: "Spare Time");
var _cat6 = CategoriesCompanion.insert(name: "Transport");
var _cat7 = CategoriesCompanion.insert(name: "Medical");
var _cat8 = CategoriesCompanion.insert(name: "Clothes");
var _cat9 = CategoriesCompanion.insert(name: "Gifts");
var _cat10 =
    CategoriesCompanion.insert(name: "Income", isExpense: Value(false));

List<SubcategoriesCompanion> _subcategories1 = [
  SubcategoriesCompanion.insert(categoryId: 1, name: "Debt"),
  SubcategoriesCompanion.insert(categoryId: 1, name: "Tuition"),
  SubcategoriesCompanion.insert(categoryId: 1, name: "Computer & Supply"),
  SubcategoriesCompanion.insert(categoryId: 1, name: "Mail"),
  SubcategoriesCompanion.insert(categoryId: 1, name: "Gadget")
];

List<SubcategoriesCompanion> _subcategories2 = [
  SubcategoriesCompanion.insert(categoryId: 2, name: "Mobile"),
  SubcategoriesCompanion.insert(categoryId: 2, name: "Tax"),
  SubcategoriesCompanion.insert(categoryId: 2, name: "Pet"),
  SubcategoriesCompanion.insert(categoryId: 2, name: "Education"),
  SubcategoriesCompanion.insert(categoryId: 2, name: "Fitness"),
  SubcategoriesCompanion.insert(categoryId: 2, name: "Subscription")
];

List<SubcategoriesCompanion> _subcategories3 = [
  SubcategoriesCompanion.insert(categoryId: 3, name: "Grocieres"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Sweets"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Backery"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Fast Food"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Take Away"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Café"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Dining Out"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Drinks"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Fruits"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Breakfast"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Ice Cream"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "Baking"),
  SubcategoriesCompanion.insert(categoryId: 3, name: "BBQ"),
];

List<SubcategoriesCompanion> _subcategories4 = [
  SubcategoriesCompanion.insert(categoryId: 4, name: "Rent"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Laundry"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Electricity"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Internet"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Cable"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Water"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Repairs"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Plants"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Furniture"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Heating"),
  SubcategoriesCompanion.insert(categoryId: 4, name: "Hotel"),
];

List<SubcategoriesCompanion> _subcategories5 = [
  SubcategoriesCompanion.insert(categoryId: 5, name: "Going Out"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Event"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Cinema"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Sport"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Cultural"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Book"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Music"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "App"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Software"),
  SubcategoriesCompanion.insert(categoryId: 5, name: "Shopping"),
];

List<SubcategoriesCompanion> _subcategories6 = [
  SubcategoriesCompanion.insert(categoryId: 6, name: "Gas"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Maintenance"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Public Transport"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Taxi"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Car Insurance"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Flight"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Parking"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Car Rental"),
  SubcategoriesCompanion.insert(categoryId: 6, name: "Penalty"),
];

List<SubcategoriesCompanion> _subcategories7 = [
  SubcategoriesCompanion.insert(categoryId: 7, name: "Medicine"),
  SubcategoriesCompanion.insert(categoryId: 7, name: "Doctors Visit"),
  SubcategoriesCompanion.insert(categoryId: 7, name: "Hospital"),
  SubcategoriesCompanion.insert(categoryId: 7, name: "Medical Insurance"),
];

List<SubcategoriesCompanion> _subcategories8 = [
  SubcategoriesCompanion.insert(categoryId: 8, name: "Clothes"),
  SubcategoriesCompanion.insert(categoryId: 8, name: "Shoes"),
  SubcategoriesCompanion.insert(categoryId: 8, name: "Accessoire"),
  SubcategoriesCompanion.insert(categoryId: 8, name: "Underwear"),
  SubcategoriesCompanion.insert(categoryId: 8, name: "Bag"),
];

List<SubcategoriesCompanion> _subcategories9 = [
  SubcategoriesCompanion.insert(categoryId: 9, name: "Gift"),
  SubcategoriesCompanion.insert(categoryId: 9, name: "Souvenir"),
];

List<SubcategoriesCompanion> _subcategories10 = [
  SubcategoriesCompanion.insert(categoryId: 10, name: "Payment"),
  SubcategoriesCompanion.insert(categoryId: 10, name: "Money Gift"),
  SubcategoriesCompanion.insert(categoryId: 10, name: "Voucher"),
];

var categories = [
  CategoryWithSubs(_cat1, _subcategories1),
  CategoryWithSubs(_cat2, _subcategories2),
  CategoryWithSubs(_cat3, _subcategories3),
  CategoryWithSubs(_cat4, _subcategories4),
  CategoryWithSubs(_cat5, _subcategories5),
  CategoryWithSubs(_cat6, _subcategories6),
  CategoryWithSubs(_cat7, _subcategories7),
  CategoryWithSubs(_cat8, _subcategories8),
  CategoryWithSubs(_cat9, _subcategories9),
  CategoryWithSubs(_cat10, _subcategories10),
];

var currentMonth = MonthsCompanion.insert(
  maxBudget: 0,
  firstDate: getFirstDateOfMonth(DateTime.now()),
  lastDate: getLastDateOfMonth(DateTime.now()).millisecondsSinceEpoch,
);

var recurrences = [
  RecurrencesCompanion.insert(name: "Daily"),
  RecurrencesCompanion.insert(name: "Weekly"),
  RecurrencesCompanion.insert(name: "Monthly"),
  RecurrencesCompanion.insert(name: "Yearly"),
];

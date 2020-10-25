import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:moor/moor.dart';

import 'generated/locale_keys.g.dart';

var _cat1 = CategoriesCompanion.insert(name: LocaleKeys.moor_various.tr());
var _cat2 = CategoriesCompanion.insert(name: LocaleKeys.moor_myself.tr());
var _cat3 = CategoriesCompanion.insert(name: LocaleKeys.moor_food.tr());
var _cat4 = CategoriesCompanion.insert(name: LocaleKeys.moor_home.tr());
var _cat5 = CategoriesCompanion.insert(name: LocaleKeys.moor_spare_time.tr());
var _cat6 = CategoriesCompanion.insert(name: LocaleKeys.moor_transport.tr());
var _cat7 = CategoriesCompanion.insert(name: LocaleKeys.moor_medical.tr());
var _cat8 = CategoriesCompanion.insert(name: LocaleKeys.moor_clothes.tr());
var _cat9 = CategoriesCompanion.insert(name: LocaleKeys.moor_gifts.tr());
var _cat10 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_income.tr(), isExpense: const Value(false));

List<SubcategoriesCompanion> _subcategories1 = [
  SubcategoriesCompanion.insert(
      categoryId: 1, name: LocaleKeys.moor_cat1_debt.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 1, name: LocaleKeys.moor_cat1_tuition.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 1, name: LocaleKeys.moor_cat1_computer.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 1, name: LocaleKeys.moor_cat1_mail.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 1, name: LocaleKeys.moor_cat1_gadget.tr())
];

List<SubcategoriesCompanion> _subcategories2 = [
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_mobile.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_tax.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_pet.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_education.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_fitness.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 2, name: LocaleKeys.moor_cat2_subscription.tr())
];

List<SubcategoriesCompanion> _subcategories3 = [
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_groceries.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_sweets.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_bakery.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_fast_food.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_take_away.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_cafe.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_dining_out.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_drinks.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_fruits.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_breakfast.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_ice_cream.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_baking.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 3, name: LocaleKeys.moor_cat3_bbq.tr()),
];

List<SubcategoriesCompanion> _subcategories4 = [
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_rent.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_laundry.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_electricity.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_internet.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_cable.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_water.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_repairs.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_plants.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_furniture.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_heating.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 4, name: LocaleKeys.moor_cat4_hotel.tr()),
];

List<SubcategoriesCompanion> _subcategories5 = [
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_going_out.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_event.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_cinema.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_sport.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_cultural.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_book.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_music.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_app.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_software.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 5, name: LocaleKeys.moor_cat5_shopping.tr()),
];

List<SubcategoriesCompanion> _subcategories6 = [
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_gas.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_maintenance.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_public_transport.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_taxi.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_car_insurance.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_flight.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_parking.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_car_rental.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 6, name: LocaleKeys.moor_cat6_penalty.tr()),
];

List<SubcategoriesCompanion> _subcategories7 = [
  SubcategoriesCompanion.insert(
      categoryId: 7, name: LocaleKeys.moor_cat7_medicine.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 7, name: LocaleKeys.moor_cat7_doctors_visit.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 7, name: LocaleKeys.moor_cat7_hospital.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 7, name: LocaleKeys.moor_cat7_medical_insurance.tr()),
];

List<SubcategoriesCompanion> _subcategories8 = [
  SubcategoriesCompanion.insert(
      categoryId: 8, name: LocaleKeys.moor_cat8_clothes.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 8, name: LocaleKeys.moor_cat8_shoes.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 8, name: LocaleKeys.moor_cat8_accessories.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 8, name: LocaleKeys.moor_cat8_underwear.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 8, name: LocaleKeys.moor_cat8_bag.tr()),
];

List<SubcategoriesCompanion> _subcategories9 = [
  SubcategoriesCompanion.insert(
      categoryId: 9, name: LocaleKeys.moor_cat9_gift.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 9, name: LocaleKeys.moor_cat9_souvenir.tr()),
];

List<SubcategoriesCompanion> _subcategories10 = [
  SubcategoriesCompanion.insert(
      categoryId: 10, name: LocaleKeys.moor_cat10_payment.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 10, name: LocaleKeys.moor_cat10_money_gift.tr()),
  SubcategoriesCompanion.insert(
      categoryId: 10, name: LocaleKeys.moor_cat10_voucher.tr()),
];

List<CategoryWithSubs> categories = [
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

MonthsCompanion currentMonth = MonthsCompanion.insert(
  maxBudget: 0,
  firstDate: today().getFirstDateOfMonth(),
  lastDate: today().getLastDateOfMonth(),
);

List<RecurrenceTypesCompanion> recurrenceTypes = [
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_daily.tr()),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_weekly.tr()),
  RecurrenceTypesCompanion.insert(
      name: LocaleKeys.moor_recurrence_monthly.tr()),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_yearly.tr()),
];

List<CurrenciesCompanion> currencies = [
  CurrenciesCompanion.insert(abbrev: "USD", symbol: "\$"),
  CurrenciesCompanion.insert(abbrev: "EUR", symbol: "€"),
];

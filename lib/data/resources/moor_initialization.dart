import 'package:FineWallet/data/category_dao.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

import 'generated/locale_keys.g.dart';

var _cat1 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_various,
    isPreset: const Value(true),
    iconCodePoint: Icons.blur_on.codePoint);
var _cat2 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_myself,
    isPreset: const Value(true),
    iconCodePoint: Icons.person.codePoint);
var _cat3 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_food,
    isPreset: const Value(true),
    iconCodePoint: Icons.restaurant.codePoint);
var _cat4 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_home,
    isPreset: const Value(true),
    iconCodePoint: Icons.home.codePoint);
var _cat5 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_spare_time,
    isPreset: const Value(true),
    iconCodePoint: Icons.rowing.codePoint);
var _cat6 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_transport,
    isPreset: const Value(true),
    iconCodePoint: Icons.time_to_leave.codePoint);
var _cat7 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_medical,
    isPreset: const Value(true),
    iconCodePoint: Icons.healing.codePoint);
var _cat8 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_clothes,
    isPreset: const Value(true),
    iconCodePoint: Icons.local_mall.codePoint);
var _cat9 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_gifts,
    isPreset: const Value(true),
    iconCodePoint: Icons.cake.codePoint);
var _cat10 = CategoriesCompanion.insert(
    name: LocaleKeys.moor_income,
    isPreset: const Value(true),
    isExpense: const Value(false),
    iconCodePoint: Icons.attach_money.codePoint);

List<SubcategoriesCompanion> _subcategories1 = [
  SubcategoriesCompanion.insert(
      categoryId: 1,
      name: LocaleKeys.moor_cat1_debt,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 1,
      name: LocaleKeys.moor_cat1_tuition,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 1,
      name: LocaleKeys.moor_cat1_computer,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 1,
      name: LocaleKeys.moor_cat1_mail,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 1,
      name: LocaleKeys.moor_cat1_gadget,
      isPreset: const Value(true))
];

List<SubcategoriesCompanion> _subcategories2 = [
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_mobile,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_tax,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_pet,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_education,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_fitness,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 2,
      name: LocaleKeys.moor_cat2_subscription,
      isPreset: const Value(true))
];

List<SubcategoriesCompanion> _subcategories3 = [
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_groceries,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_sweets,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_bakery,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_fast_food,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_take_away,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_cafe,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_dining_out,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_drinks,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_fruits,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_breakfast,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_ice_cream,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_baking,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 3,
      name: LocaleKeys.moor_cat3_bbq,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories4 = [
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_rent,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_laundry,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_electricity,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_internet,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_cable,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_water,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_repairs,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_plants,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_furniture,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_heating,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 4,
      name: LocaleKeys.moor_cat4_hotel,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories5 = [
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_going_out,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_event,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_cinema,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_sport,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_cultural,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_book,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_music,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_app,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_software,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 5,
      name: LocaleKeys.moor_cat5_shopping,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories6 = [
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_gas,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_maintenance,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_public_transport,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_taxi,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_car_insurance,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_flight,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_parking,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_car_rental,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 6,
      name: LocaleKeys.moor_cat6_penalty,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories7 = [
  SubcategoriesCompanion.insert(
      categoryId: 7,
      name: LocaleKeys.moor_cat7_medicine,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 7,
      name: LocaleKeys.moor_cat7_doctors_visit,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 7,
      name: LocaleKeys.moor_cat7_hospital,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 7,
      name: LocaleKeys.moor_cat7_medical_insurance,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories8 = [
  SubcategoriesCompanion.insert(
      categoryId: 8,
      name: LocaleKeys.moor_cat8_clothes,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 8,
      name: LocaleKeys.moor_cat8_shoes,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 8,
      name: LocaleKeys.moor_cat8_accessories,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 8,
      name: LocaleKeys.moor_cat8_underwear,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 8,
      name: LocaleKeys.moor_cat8_bag,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories9 = [
  SubcategoriesCompanion.insert(
      categoryId: 9,
      name: LocaleKeys.moor_cat9_gift,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 9,
      name: LocaleKeys.moor_cat9_souvenir,
      isPreset: const Value(true)),
];

List<SubcategoriesCompanion> _subcategories10 = [
  SubcategoriesCompanion.insert(
      categoryId: 10,
      name: LocaleKeys.moor_cat10_payment,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 10,
      name: LocaleKeys.moor_cat10_money_gift,
      isPreset: const Value(true)),
  SubcategoriesCompanion.insert(
      categoryId: 10,
      name: LocaleKeys.moor_cat10_voucher,
      isPreset: const Value(true)),
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
  firstDate: today().getFirstDateOfMonth(),
  lastDate: today().getLastDateOfMonth(),
);

List<RecurrenceTypesCompanion> recurrenceTypes = [
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_once),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_daily),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_weekly),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_monthly),
  RecurrenceTypesCompanion.insert(
      name: LocaleKeys.moor_recurrence_monthly_date),
  RecurrenceTypesCompanion.insert(name: LocaleKeys.moor_recurrence_yearly),
];

List<CurrenciesCompanion> currencies = [
  CurrenciesCompanion.insert(abbrev: "USD", symbol: "\$"),
  CurrenciesCompanion.insert(abbrev: "EUR", symbol: "€"),
  CurrenciesCompanion.insert(abbrev: "JPY", symbol: "¥"),
  CurrenciesCompanion.insert(abbrev: "BGN", symbol: "лв"),
  CurrenciesCompanion.insert(abbrev: "CZK", symbol: "Kč"),
  CurrenciesCompanion.insert(abbrev: "DKK", symbol: "Ø"),
  CurrenciesCompanion.insert(abbrev: "GBP", symbol: "£"),
  CurrenciesCompanion.insert(abbrev: "HUF", symbol: "Ft"),
  CurrenciesCompanion.insert(abbrev: "PLN", symbol: "zł"),
  CurrenciesCompanion.insert(abbrev: "RON", symbol: "L"),
  CurrenciesCompanion.insert(abbrev: "SEK", symbol: "kr"),
  CurrenciesCompanion.insert(abbrev: "CHF", symbol: "Fr."),
  CurrenciesCompanion.insert(abbrev: "ISK", symbol: "kr"),
  CurrenciesCompanion.insert(abbrev: "NOK", symbol: "kr"),
  CurrenciesCompanion.insert(abbrev: "HRK", symbol: "kn"),
  CurrenciesCompanion.insert(abbrev: "RUB", symbol: "\u20BD"), //"₽"),
  CurrenciesCompanion.insert(abbrev: "TRY", symbol: "\u20BA"), //"₺"),
  CurrenciesCompanion.insert(abbrev: "AUD", symbol: "A\$"),
  CurrenciesCompanion.insert(abbrev: "BRL", symbol: "R\$"),
  CurrenciesCompanion.insert(abbrev: "CAD", symbol: "C\$"),
  CurrenciesCompanion.insert(abbrev: "CNY", symbol: "¥"),
  CurrenciesCompanion.insert(abbrev: "HKD", symbol: "HK\$"),
  CurrenciesCompanion.insert(abbrev: "IDR", symbol: "Rp"),
  CurrenciesCompanion.insert(abbrev: "ILS", symbol: "₪"),
  CurrenciesCompanion.insert(abbrev: "INR", symbol: "₹"),
  CurrenciesCompanion.insert(abbrev: "KRW", symbol: "₩"),
  CurrenciesCompanion.insert(abbrev: "MXN", symbol: "\$"),
  CurrenciesCompanion.insert(abbrev: "MYR", symbol: "RM"),
  CurrenciesCompanion.insert(abbrev: "NZD", symbol: "\$"),
  CurrenciesCompanion.insert(abbrev: "PHP", symbol: "\u20B1"), //"₱"),
  CurrenciesCompanion.insert(abbrev: "SGD", symbol: "\$"),
  CurrenciesCompanion.insert(abbrev: "THB", symbol: "฿"),
  CurrenciesCompanion.insert(abbrev: "ZAR", symbol: "R"),
];

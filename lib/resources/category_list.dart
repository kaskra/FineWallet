/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:collection';

import 'package:finewallet/models/category_model.dart';

CategoryList toCategoryList(List<CategoryModel> l) {
  CategoryList list = new CategoryList();
  list.addAll(l);
  return list;
}

class CategoryList extends ListBase<CategoryModel> {
  final List<CategoryModel> l = [];
  CategoryList();

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  CategoryModel operator [](int index) => l[index];
  operator []=(int index, CategoryModel value) {
    l[index] = value;
  }

  CategoryList removeWhere(bool Function(CategoryModel element) test) {
    l.removeWhere((CategoryModel txn) => test(txn));
    return toCategoryList(l);
  }

  CategoryList where(bool Function(CategoryModel element) test) {
    return toCategoryList(super.where(test).toList());
  }
}

/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:collection';

import 'package:finewallet/models/subcategory_model.dart';

SubcategoryList toSubcategoryList(List<SubcategoryModel> l) {
  SubcategoryList list = new SubcategoryList();
  list.addAll(l);
  return list;
}

class SubcategoryList extends ListBase<SubcategoryModel> {
  final List<SubcategoryModel> l = [];
  SubcategoryList();

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  SubcategoryModel operator [](int index) => l[index];
  operator []=(int index, SubcategoryModel value) {
    l[index] = value;
  }

  SubcategoryList removeWhere(bool Function(SubcategoryModel element) test) {
    l.removeWhere((SubcategoryModel txn) => test(txn));
    return toSubcategoryList(l);
  }

  SubcategoryList where(bool Function(SubcategoryModel element) test) {
    return toSubcategoryList(super.where(test).toList());
  }
}

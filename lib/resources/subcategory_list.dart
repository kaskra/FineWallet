/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:21 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:collection';

import 'package:FineWallet/models/subcategory_model.dart';

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

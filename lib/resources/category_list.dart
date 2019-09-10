/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:collection';

import 'package:FineWallet/models/category_model.dart';

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

  List<int> ids(){
    return super.map((c) => c.id).toList();
  }

  List<String> names() {
    return super.map((c) => c.name).toList();
  }

}

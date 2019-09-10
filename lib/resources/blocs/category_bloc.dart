/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:17 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/resources/category_provider.dart';
import 'package:FineWallet/resources/category_list.dart';

class CategoryBloc {
  
  final _categoriesController = StreamController<CategoryList>.broadcast();

  get allCategories => _categoriesController.stream;

  void dispose() {
    _categoriesController.close();
  }

  getCategories(bool isExpense) async {
    _categoriesController.sink.add(await CategoryProvider.db.getAllCategories(isExpense: isExpense));
  }
}
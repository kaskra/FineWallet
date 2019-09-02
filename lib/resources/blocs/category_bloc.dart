


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
import 'dart:async';

import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';

class CategoryBloc {
  final _categoryController = StreamController<List<CategoryModel>>.broadcast();

  get categories => _categoryController.stream;

  void dispose() { 
    _categoryController.close();
  }

  getCategories() async{
    List<CategoryModel> list = await DBProvider.db.getAllCategories();
    print(list);
    _categoryController.sink.add(list);
    print(_categoryController.stream.length);
  }

  CategoryBloc (){
    getCategories();
  }
}

class CategoryIncomeBloc {
  final _categoryController = StreamController<List<CategoryModel>>.broadcast();

  get categories => _categoryController.stream;

  void dispose() { 
    _categoryController.close();
  }

  getCategories() async{
    _categoryController.sink.add(await DBProvider.db.getIncomeCategory());
  }

  CategoryIncomeBloc (){
    getCategories();
  }
}
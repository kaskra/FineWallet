import 'package:flutter/material.dart';

class BudgetNotifier extends ChangeNotifier {
  BudgetNotifier({double budget, double savingsBudget}) : _budget = budget, _savingsBudget = savingsBudget;

  double _budget = 0;
  double _savingsBudget = 0;

  double get budget => _budget;
  double get savingsBudget => _savingsBudget;
  double get totalBudget =>  _budget + _savingsBudget; //monthly

  Future setBudget(double b) async {
    _budget = b;
    notifyListeners();
  }

  Future setSavingsBudget(double b) async {
    _savingsBudget = b;
    notifyListeners();
  }
}

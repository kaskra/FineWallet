import 'package:flutter/material.dart';

enum BudgetFlag {
  monthly,
  savings,
}

class BudgetNotifier extends ChangeNotifier {
  BudgetNotifier({double budget = 0, double savingsBudget = 0})
      : _budget = budget,
        _savingsBudget = savingsBudget;

  double _budget = 0;
  double _savingsBudget = 0;
  double get totalBudget => _budget + _savingsBudget;

  void setBudget(double b, BudgetFlag flag) {
    if (flag == BudgetFlag.savings) {
      _savingsBudget = b;
    } else {
      _budget = b;
    }
    notifyListeners();
  }

  double getBudget(BudgetFlag flag) {
    if (flag == BudgetFlag.savings) {
      return _savingsBudget;
    } else {
      return _budget;
    }
  }
}

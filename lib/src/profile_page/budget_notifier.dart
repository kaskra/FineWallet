import 'package:flutter/cupertino.dart';

class BudgetNotifier extends ChangeNotifier {
  BudgetNotifier({double budget}) : _budget = budget;

  double _budget = 0;

  double get budget => _budget;

  Future setBudget(double b) async {
    _budget = b;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';

class NavigationNotifier extends ChangeNotifier {
  int _page = 3;

  int get page => _page;

  Future setPage(int p) async {
    _page = p;
    notifyListeners();
  }
}
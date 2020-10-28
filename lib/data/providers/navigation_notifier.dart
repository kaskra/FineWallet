import 'dart:collection';

import 'package:flutter/cupertino.dart';

enum NavigationDirection { left, right }

class NavigationNotifier extends ChangeNotifier {
  int _page = 3;
  NavigationDirection _direction;

  int get page => _page;

  NavigationDirection get navigationDirection => _direction;

  final Queue<int> _navigations = Queue();

  Future setPage(int p) async {
    _navigations.addLast(_page);
    _updateDirection(p);

    if (_navigations.length > 10) {
      _navigations.removeFirst();
    }
    _page = p;
    notifyListeners();
  }

  void goBack() {
    if (_navigations.isNotEmpty) {
      final newPage = _navigations.removeLast();
      _updateDirection(newPage);
      _page = newPage;
      notifyListeners();
    }
  }

  void _updateDirection(int newPage) {
    if (_page < newPage) {
      _direction = NavigationDirection.left;
    } else {
      _direction = NavigationDirection.right;
    }
  }
}

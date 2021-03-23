import 'package:flutter/material.dart';

enum SelectionMode {
  on,
  off,
}

class SelectionModeNotifier extends ChangeNotifier {
  SelectionModeNotifier({SelectionMode mode}) : _mode = mode;

  SelectionMode _mode = SelectionMode.off;

  SelectionMode get mode => _mode;
  bool get isOn => _mode == SelectionMode.on;
  bool get isOff => _mode == SelectionMode.off;

  Future setMode(SelectionMode mode) async {
    _mode = mode;
    notifyListeners();
  }
}

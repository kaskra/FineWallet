import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  Future setBusy(bool b) async {
    _busy = b;
    notifyListeners();
  }
}

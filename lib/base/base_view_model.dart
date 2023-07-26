import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _ismounted = true;

  @override
  void dispose() {
    _ismounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_ismounted) {
      super.notifyListeners();
    }
  }
}

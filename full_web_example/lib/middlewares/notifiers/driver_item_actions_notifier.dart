import 'package:flutter/material.dart';

class DriverItemActionsNotifier extends ChangeNotifier {
  bool isVisible = false;

  void changeVisibility(bool newIsVisible) {
    isVisible = newIsVisible;
    notifyListeners();
  }
}

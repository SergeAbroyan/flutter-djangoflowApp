import 'package:flutter/material.dart';

class OrderItemActionsNotifier extends ChangeNotifier {
  bool isVisible = false;

  void changeVisibility(bool newIsVisible) {
    isVisible = newIsVisible;
    notifyListeners();
  }
}

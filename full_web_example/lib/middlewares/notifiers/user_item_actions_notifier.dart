import 'package:flutter/material.dart';

class UserItemActionsNotifier extends ChangeNotifier {
  bool isVisible = false;

  void changeVisibility(bool newIsVisible) {
    isVisible = newIsVisible;
    notifyListeners();
  }
}

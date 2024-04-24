import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class DrawerControllerNotifier extends ChangeNotifier {
  DrawerControllerNotifier({required this.drawerTypes});
  DrawerTypesEnum drawerTypes;

  void controlScreen(DrawerTypesEnum newDrawerTypes) {
    drawerTypes = newDrawerTypes;

    window.history.pushState(null, 'admin', '/${newDrawerTypes.name}');
    notifyListeners();
  }
}

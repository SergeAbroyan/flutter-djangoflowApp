import 'package:npua_project/screens/admin/widgets/dashboard/dashboard_widget.dart';
import 'package:npua_project/screens/admin/widgets/drivers/drivers_widget.dart';
import 'package:npua_project/screens/admin/widgets/info/info_widget.dart';
import 'package:npua_project/screens/admin/widgets/orders/orders_widget.dart';
import 'package:npua_project/screens/admin/widgets/orders/test_quick.dart';
import 'package:npua_project/screens/admin/widgets/users/users_widget.dart';
import 'package:flutter/material.dart';

enum DrawerTypesEnum {
  dashboard,
  student,
  professor,
  testItem,
  quickTest,
  info
}

extension DrawerTypeExtension on DrawerTypesEnum {
  String get title {
    switch (this) {
      case DrawerTypesEnum.dashboard:
        return 'Dashboard';
      case DrawerTypesEnum.student:
        return 'Student';
      case DrawerTypesEnum.professor:
        return 'Professor';
      case DrawerTypesEnum.testItem:
        return 'Test Item';
      case DrawerTypesEnum.quickTest:
        return 'Quick Test';
      case DrawerTypesEnum.info:
        return 'Information';
    }
  }

  IconData get iconData {
    switch (this) {
      case DrawerTypesEnum.dashboard:
        return Icons.dashboard;
      case DrawerTypesEnum.student:
        return Icons.supervised_user_circle;
      case DrawerTypesEnum.professor:
        return Icons.book_online_rounded;
      case DrawerTypesEnum.testItem:
        return Icons.catching_pokemon;
      case DrawerTypesEnum.quickTest:
        return Icons.text_snippet;
      case DrawerTypesEnum.info:
        return Icons.info_outline;
    }
  }

  Widget get widget {
    switch (this) {
      case DrawerTypesEnum.dashboard:
        return const DashboardWidget();
      case DrawerTypesEnum.student:
        return const UsersWidget();
      case DrawerTypesEnum.professor:
        return const DriversWidget();
      case DrawerTypesEnum.testItem:
        return const OrdersWidget();
      case DrawerTypesEnum.quickTest:
        return const QuickTestWidget();
      case DrawerTypesEnum.info:
        return const InfoWidget();
    }
  }
}

class GetDrawerType {
  GetDrawerType(this.value);
  final String value;

  dynamic type() {
    switch (value) {
      case 'dashboard':
        return DrawerTypesEnum.dashboard;
      case 'users':
        return DrawerTypesEnum.student;
      case 'drivers':
        return DrawerTypesEnum.professor;
      case 'orders':
        return DrawerTypesEnum.testItem;
      case 'quickTest':
        return DrawerTypesEnum.quickTest;
      case 'info':
        return DrawerTypesEnum.info;
    }
  }
}

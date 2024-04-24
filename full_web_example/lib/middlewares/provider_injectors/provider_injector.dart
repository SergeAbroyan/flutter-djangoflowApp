import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/notifiers/drawer_controller_notifier.dart';
import 'package:npua_project/middlewares/notifiers/driver_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/info_type_notifier.dart';
import 'package:npua_project/middlewares/notifiers/menu_controller_notifier.dart';
import 'package:npua_project/middlewares/notifiers/order_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/user_item_actions_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderInjector extends StatelessWidget {
  const ProviderInjector({required this.child, this.drawerTypes, super.key});

  final Widget child;
  final DrawerTypesEnum? drawerTypes;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) => DrawerControllerNotifier(
              drawerTypes: drawerTypes ?? DrawerTypesEnum.dashboard)),
      ChangeNotifierProvider(create: (_) => MenuControllerNotifier()),
      ChangeNotifierProvider(create: (_) => UserItemActionsNotifier()),
      ChangeNotifierProvider(create: (_) => DriverItemActionsNotifier()),
      ChangeNotifierProvider(create: (_) => OrderItemActionsNotifier()),
      ChangeNotifierProvider(create: (_) => InfoTypeNotifier()),
    ], child: child);
  }
}

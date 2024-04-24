import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/notifiers/drawer_controller_notifier.dart';
import 'package:npua_project/middlewares/notifiers/driver_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/order_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/user_item_actions_notifier.dart';
import 'package:npua_project/screens/admin/widgets/drawer/widgets/drawer_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerListWidget extends StatelessWidget {
  const DrawerListWidget({required this.drawerTypes, super.key});

  final DrawerTypesEnum drawerTypes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: DrawerTypesEnum.values.length,
        shrinkWrap: true,
        itemBuilder: (context, int index) => DrawerListTile(
            iconData: DrawerTypesEnum.values[index].iconData,
            press: () {
              context.read<OrderItemActionsNotifier>().changeVisibility(false);
              context.read<UserItemActionsNotifier>().changeVisibility(false);
              context.read<DriverItemActionsNotifier>().changeVisibility(false);
              context
                  .read<DrawerControllerNotifier>()
                  .controlScreen(DrawerTypesEnum.values[index]);
            },
            title: DrawerTypesEnum.values[index].title,
            selected: drawerTypes == DrawerTypesEnum.values[index]));
  }
}

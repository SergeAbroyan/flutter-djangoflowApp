import 'package:npua_project/components/buttons/centered_button.dart';
import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/notifiers/driver_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/menu_controller_notifier.dart';
import 'package:npua_project/middlewares/notifiers/order_item_actions_notifier.dart';
import 'package:npua_project/middlewares/notifiers/user_item_actions_notifier.dart';
import 'package:npua_project/middlewares/responsive.dart';
import 'package:npua_project/middlewares/typedef_functions.dart';
import 'package:npua_project/screens/admin/components/popover_date_picker_widget.dart';
import 'package:npua_project/screens/admin/components/search_filed.dart';
import 'package:npua_project/screens/admin/components/status_popup.dart';
import 'package:npua_project/screens/admin/widgets/drivers/widgets/driver_item_actions_widget.dart';
import 'package:npua_project/screens/admin/widgets/orders/widgets/order_item_actions_widget.dart';
import 'package:npua_project/screens/admin/widgets/users/widgets/user_item_actions_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(
      {required this.drawerTypes, required this.indexCallback, Key? key})
      : super(key: key);

  final DrawerTypesEnum drawerTypes;
  final IndexCallback indexCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!Responsive.isDesktop(context))
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      icon: const Icon(Icons.menu, size: 40),
                      onPressed:
                          context.read<MenuControllerNotifier>().controlMenu)),
            Text(drawerTypes.title,
                style: Theme.of(context).textTheme.displaySmall),
            if (!Responsive.isMobile(context) &&
                drawerTypes != DrawerTypesEnum.dashboard &&
                drawerTypes != DrawerTypesEnum.info)
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            if (Responsive.isMobile(context)) const SizedBox(width: 50),
            if (drawerTypes != DrawerTypesEnum.dashboard &&
                drawerTypes != DrawerTypesEnum.info)
              const Expanded(child: SearchField())
          ]),
          if (drawerTypes != DrawerTypesEnum.dashboard &&
              drawerTypes != DrawerTypesEnum.info)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                StatusPopup(),
                if (drawerTypes == DrawerTypesEnum.student)
                  CenteredButton(
                      title: 'Add Student',
                      width: 200,
                      onTap: () => indexCallback(0)),
                if (drawerTypes == DrawerTypesEnum.professor)
                  CenteredButton(
                      title: 'Add Professor',
                      width: 200,
                      onTap: () => indexCallback(1)),
                if (drawerTypes == DrawerTypesEnum.testItem)
                  CenteredButton(
                      title: 'Add Test',
                      width: 200,
                      onTap: () => indexCallback(2)),
                Selector<UserItemActionsNotifier, bool>(
                    selector: (_, provider) => provider.isVisible,
                    builder: (context, isVisible, child) => Visibility(
                        visible: isVisible,
                        child: const UserItemActionsWidget())),
                Selector<DriverItemActionsNotifier, bool>(
                    selector: (_, provider) => provider.isVisible,
                    builder: (context, isVisible, child) => Visibility(
                        visible: isVisible,
                        child: const DriverItemActionsWidget())),
                Selector<OrderItemActionsNotifier, bool>(
                    selector: (_, provider) => provider.isVisible,
                    builder: (context, isVisible, child) => Visibility(
                        visible: isVisible,
                        child: const OrderItemActionsWidget()))
              ]),
              const PopoverPicker()
            ])
        ]));
  }
}

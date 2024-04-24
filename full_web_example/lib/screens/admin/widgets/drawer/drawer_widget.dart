import 'package:npua_project/components/ink_well_widget.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/screens/admin/widgets/drawer/widgets/drawer_list_widget.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget with DeviceMetricsLessMixin {
  const DrawerMenu({required this.drawerTypes, Key? key}) : super(key: key);

  final DrawerTypesEnum drawerTypes;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 100),
      DrawerListWidget(drawerTypes: drawerTypes),
      InkWellWidget(
          child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Log Out',
                  style: getStyle(fontSize: 20, color: AppColors.redColor))))
    ])));
  }
}

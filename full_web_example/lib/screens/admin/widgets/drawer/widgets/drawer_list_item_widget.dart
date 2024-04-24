import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {required this.title,
      required this.iconData,
      required this.press,
      required this.selected,
      Key? key})
      : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback press;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          tileColor: selected ? AppColors.gainsboroColor : null,
          onTap: press,
          horizontalTitleGap: 0.0,
          leading: Icon(iconData,
              color: Theme.of(context).iconTheme.color, size: 20),
          title: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      const Divider()
    ]);
  }
}

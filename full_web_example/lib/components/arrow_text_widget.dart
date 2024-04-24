import 'package:npua_project/components/ink_well_widget.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ArrowTextWidget extends StatelessWidget {
  const ArrowTextWidget(
      {required this.title,
      this.fontSize = 24,
      this.iconSize = 24,
      this.padding = 10,
      this.isDivider = true,
      this.isIcon = true,
      super.key});

  final String title;
  final double fontSize;
  final double iconSize;
  final double padding;
  final bool isDivider;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (isDivider) const Divider(),
      InkWellWidget(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: getStyle(fontSize: fontSize)),
                    if (isIcon) Icon(Icons.arrow_forward_ios, size: iconSize)
                  ])))
    ]);
  }
}

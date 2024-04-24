import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/responsive.dart';
import 'package:flutter/material.dart';

class TableDecorationWidget extends StatelessWidget
    with DeviceMetricsLessMixin {
  const TableDecorationWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    constraints: BoxConstraints(
                        minWidth: Responsive.isTablet(context)
                            ? width(context) / 1.05
                            : width(context) / 1.25),
                    child: Card(
                        margin: const EdgeInsets.all(5),
                        clipBehavior: Clip.none,
                        child: child)))));
  }
}

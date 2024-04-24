import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget with DeviceMetricsLessMixin {
  const EmptyWidget({this.padding, Key? key}) : super(key: key);
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: padding ?? height(context) / 4),
        child: Center(child: Image.asset('assets/images/no_result.png')));
  }
}

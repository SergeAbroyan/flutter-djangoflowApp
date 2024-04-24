import 'package:flutter/material.dart';

mixin DeviceMetricsMixin<T extends StatefulWidget> on State<T> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

mixin DeviceMetricsLessMixin<T extends StatelessWidget> {
  double height(BuildContext context) => MediaQuery.of(context).size.height;
  double width(BuildContext context) => MediaQuery.of(context).size.width;
}

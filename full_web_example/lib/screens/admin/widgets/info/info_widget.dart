import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/screens/admin/widgets/info/widgets/info_default_widget.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> with DeviceMetricsMixin {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.solitudeColor,
                      blurRadius: 4,
                      spreadRadius: 7)
                ]),
            child: const SingleChildScrollView(child: InfoComponentsWidget())));
  }
}

class InfoComponentsWidget extends StatelessWidget {
  const InfoComponentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoDefaultWidget();
  }
}

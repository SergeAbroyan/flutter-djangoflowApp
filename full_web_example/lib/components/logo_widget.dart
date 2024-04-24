import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget with DeviceMetricsLessMixin {
  const AppLogoWidget(
      {this.dividedWordsSize = 12,
      this.color = AppColors.caribbeanGreenColor,
      super.key});

  final double dividedWordsSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Image.asset('assets/logo_words.png',
            width: width(context) / dividedWordsSize,
            height: height(context) / dividedWordsSize,
            color: color));
  }
}

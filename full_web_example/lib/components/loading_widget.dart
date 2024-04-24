import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({required this.visibleIndicator, this.progress, Key? key})
      : super(key: key);
  final bool visibleIndicator;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return visibleIndicator
        ? Center(
            child: CircularProgressIndicator(
                color: AppColors.redColor, value: progress))
        : Container();
  }
}

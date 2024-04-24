import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum StatusType { all, available, noAvailable }

extension StatusTypesExtension on StatusType {
  String get title {
    switch (this) {
      case StatusType.all:
        return 'All';
      case StatusType.available:
        return 'Available';
      case StatusType.noAvailable:
        return 'Unavailable';
    }
  }

  Color get textColor => this == StatusType.available
      ? AppColors.caribbeanGreenColor
      : AppColors.redColor;

  Color get dropdownTextColor => this == StatusType.noAvailable
      ? AppColors.caribbeanGreenColor
      : AppColors.redColor;

  Color get backgroundColor => this == StatusType.noAvailable
      ? AppColors.whiteColor
      : AppColors.whiteSmokeColor;

  Color get subBackgroundColor => this == StatusType.noAvailable
      ? AppColors.solitudeColor
      : AppColors.dimGrayColor;
}

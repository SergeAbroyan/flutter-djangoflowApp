import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

TextStyle getStyle(
    {FontWeight? fontWeight,
    double? fontSize,
    Color? color = AppColors.nightRiderColor,
    double? height,
    TextDecoration? decoration = TextDecoration.none}) {
  return TextStyle(
      fontWeight: fontWeight ?? FontWeight.w500,
      fontSize: fontSize ?? 18,
      height: height,
      color: color,
      decoration: decoration);
}

import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EditUtilsWidget extends StatelessWidget {
  const EditUtilsWidget({super.key});

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
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const []))));
  }
}

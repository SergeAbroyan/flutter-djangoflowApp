import 'package:npua_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
            hintText: 'Search',
            fillColor: AppColors.solitudeColor,
            filled: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            suffixIcon: InkWell(
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: AppColors.dimGrayColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Icon(Icons.search,
                        color: AppColors.whiteColor)))));
  }
}

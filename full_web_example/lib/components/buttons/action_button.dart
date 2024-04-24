import 'package:npua_project/components/ink_well_widget.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.title, super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
        child: Card(
            shadowColor: Colors.black,
            clipBehavior: Clip.none,
            child: Padding(
                padding: const EdgeInsets.all(10), child: Text(title))));
  }
}

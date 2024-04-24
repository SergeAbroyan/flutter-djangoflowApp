import 'package:npua_project/components/buttons/action_button.dart';
import 'package:flutter/material.dart';

class DriverItemActionsWidget extends StatelessWidget {
  const DriverItemActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      ActionButton(title: 'View'),
      ActionButton(title: 'Edit'),
      ActionButton(title: 'Delete')
    ]);
  }
}

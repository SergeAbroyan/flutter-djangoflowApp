import 'package:npua_project/components/buttons/action_button.dart';
import 'package:flutter/material.dart';

class OrderItemActionsWidget extends StatelessWidget {
  const OrderItemActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(children: const [
          ActionButton(title: 'View'),
          ActionButton(title: 'Edit'),
          ActionButton(title: 'Delete')
        ]));
  }
}

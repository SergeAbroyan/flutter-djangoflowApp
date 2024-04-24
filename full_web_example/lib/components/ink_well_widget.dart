import 'package:flutter/material.dart';

class InkWellWidget extends StatelessWidget {
  const InkWellWidget({this.child, this.onTap, Key? key}) : super(key: key);
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: child);
  }
}

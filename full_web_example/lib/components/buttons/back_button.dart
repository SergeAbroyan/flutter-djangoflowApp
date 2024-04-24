import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({this.onTap, this.top = 70, this.left = 40, super.key});

  final VoidCallback? onTap;
  final double top;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: left,
        child: GestureDetector(
            onTap: onTap ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 30)));
  }
}

import 'package:flutter/material.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';

class CustomDialog {
  CustomDialog(
      {required this.context,
      required this.title,
      required this.childrenWidget,
      this.children,
      this.pop});

  final BuildContext context;
  final String title;
  final Widget childrenWidget;

  final List<DialogButton>? children;
  final VoidCallback? pop;

  Future<void> show() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: getStyle(
                            color: AppColors.blackColor, fontSize: 20))),
                childrenWidget,
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: children ?? [])
              ]));
        });
  }

  Future<void> showDurationDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () => pop?.call());
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Text(title,
                  textAlign: TextAlign.center, style: getStyle(fontSize: 22)),
              title: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.dimGrayColor),
                  child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.done_outlined,
                          size: 40, color: AppColors.whiteColor))));
        });
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton(
      {required this.title,
      required this.onTap,
      this.titleColor = AppColors.dimGrayColor,
      Key? key})
      : super(key: key);
  final String title;
  final VoidCallback onTap;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text(title,
                    style: getStyle(color: titleColor, fontSize: 20)))),
      ],
    );
  }
}

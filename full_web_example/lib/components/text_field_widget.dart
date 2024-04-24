import 'package:npua_project/components/ink_well_widget.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/typedef_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {required this.controller,
      this.text,
      this.hintText,
      this.isInvalid = false,
      this.obscureText = false,
      this.onChanged,
      Key? key})
      : super(key: key);

  final TextEditingController controller;
  final String? text;
  final String? hintText;
  final bool isInvalid;
  final bool obscureText;
  final StringCallback? onChanged;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _renderText(),
          Container(
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: getBorder),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  inputFormatters: [
                    if (widget.controller.text.isEmpty)
                      FilteringTextInputFormatter.deny(RegExp('[ ]'))
                  ],
                  decoration: _decoration))
        ]));
  }

  Widget _renderText() => Text.rich(TextSpan(
      text: widget.text,
      style: getStyle(
          fontSize: 16,
          color: widget.isInvalid
              ? AppColors.redColor
              : AppColors.blueCharcoalColor)));

  InputDecoration get _decoration => InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.only(top: 14),
      hintText: widget.hintText,
      hintStyle: getStyle(fontSize: 16, color: AppColors.nightRiderColor),
      suffixIcon: widget.isInvalid
          ? const Icon(Icons.error_outline, color: AppColors.redColor)
          : widget.controller.text.isEmpty
              ? const SizedBox.shrink()
              : _clearButton());

  Color get getBorder =>
      widget.isInvalid ? AppColors.redColor : AppColors.nightRiderColor;

  Widget _clearButton() {
    return InkWellWidget(
        onTap: () => setState(() {
              widget.controller.clear();
              widget.onChanged?.call('');
            }),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.caribbeanGreenColor,
                    shape: BoxShape.circle),
                child: const Icon(Icons.clear_rounded,
                    size: 20, color: AppColors.whiteColor))));
  }
}

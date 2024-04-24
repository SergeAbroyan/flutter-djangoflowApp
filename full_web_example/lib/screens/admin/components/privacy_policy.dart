import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text.rich(TextSpan(
          text: 'By providing py phone number, I agree and \n accept the ',
          style: _textStyle,
          children: [
            TextSpan(
                text: 'Terms use',
                style: _linkTextStyle,
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
              text: ' and ',
              style: _textStyle,
            ),
            TextSpan(
                text: 'Privacy policy',
                style: _linkTextStyle,
                recognizer: TapGestureRecognizer()..onTap = () {}),
          ])),
    );
  }

  TextStyle get _textStyle => getStyle(fontSize: 12);

  TextStyle get _linkTextStyle => getStyle(
      fontSize: 14,
      color: AppColors.redColor,
      decoration: TextDecoration.underline);
}

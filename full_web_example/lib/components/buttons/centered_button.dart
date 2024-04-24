import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:flutter/material.dart';

class CenteredButton extends StatelessWidget {
  const CenteredButton(
      {required this.title,
      required this.width,
      this.textColor,
      this.inActiveBorderColor = AppColors.nightRiderColor,
      this.inActiveBackgroundColor = AppColors.whiteColor,
      this.activeBackgroundColor = AppColors.nightRiderColor,
      this.activeBorderColor,
      this.buttonState = ButtonState.active,
      this.ignoreButtonState = false,
      this.fontSize,
      this.onTap,
      super.key});

  final String title;
  final double width;
  final Color? textColor;
  final Color inActiveBorderColor;
  final Color? activeBorderColor;
  final Color inActiveBackgroundColor;
  final Color activeBackgroundColor;
  final ButtonState buttonState;
  final bool ignoreButtonState;
  final double? fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !ignoreButtonState && _ignoring,
      child: InkWell(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
                width: buttonState == ButtonState.loading
                    ? LoadingPreference.width
                    : width,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    color: buttonState == ButtonState.inactive
                        ? inActiveBackgroundColor
                        : activeBackgroundColor,
                    border: Border.all(
                      color: buttonState == ButtonState.inactive
                          ? inActiveBorderColor
                          : activeBorderColor ?? activeBackgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                duration: const Duration(milliseconds: 500),
                child: buttonState == ButtonState.loading
                    ? const _RenderLoading()
                    : _RenderText(
                        title: title,
                        buttonState: buttonState,
                        fontSize: fontSize,
                        textColor: textColor)),
          )),
    );
  }

  bool get _ignoring =>
      buttonState == ButtonState.inactive || buttonState == ButtonState.loading;
}

enum ButtonState { inactive, active, loading, error }

class LoadingPreference {
  static double height = 52;
  static double width = 52;
}

class _RenderText extends StatelessWidget {
  const _RenderText(
      {required this.title,
      required this.buttonState,
      this.fontSize,
      this.textColor,
      Key? key})
      : super(key: key);
  final String title;
  final ButtonState buttonState;
  final double? fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Text(title,
            textAlign: TextAlign.center,
            style: getStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: textColor ??
                    (buttonState == ButtonState.active
                        ? AppColors.whiteColor
                        : AppColors.blackColor))));
  }
}

class _RenderLoading extends StatelessWidget {
  const _RenderLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(color: AppColors.whiteColor));
  }
}

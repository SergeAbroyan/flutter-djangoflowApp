import 'package:npua_project/components/buttons/centered_button.dart';
import 'package:npua_project/components/text_field_widget.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/home_screen.dart';
import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/repositories/implementation/storage_repository_implement.dart';
import 'package:npua_project/middlewares/responsive.dart';
import 'package:npua_project/middlewares/typedef_functions.dart';
import 'package:npua_project/screens/admin/components/privacy_policy.dart';
import 'package:npua_project/screens/login/login_bloc/login_bloc.dart';
import 'package:npua_project/screens/login/login_bloc/login_event.dart';
import 'package:npua_project/screens/login/login_bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with DeviceMetricsMixin {
  late final LoginBloc _loginBloc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isRememberNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isInValidNotifier = ValueNotifier(false);
  final ValueNotifier<ButtonState> _buttonNotifier =
      ValueNotifier(ButtonState.inactive);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isRememberNotifier.dispose();
    _isInValidNotifier.dispose();
    _buttonNotifier.dispose();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => _loginBloc = LoginBloc(StorageRepositoryImp()),
        child: BlocConsumer<LoginBloc, LoginState>(
            listener: _listener,
            builder: (context, state) => Scaffold(
                    body: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      RegistrationWidget(
                          onTap: () => _loginBloc.add(TryLoginEvent(
                              email: _emailController.text,
                              password: _passwordController.text)),
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isRememberNotifier: _isRememberNotifier,
                          buttonNotifier: _buttonNotifier,
                          isInValidNotifier: _isInValidNotifier)
                    ]))));
  }

  void _listener(BuildContext context, LoginState state) {
    if (state is ChangeButtonState) {
      _buttonNotifier.value = state.buttonState;
    }

    if (state is LoginSuccessState) {
      GoRouter.of(context).push(AppRouter.home(DrawerTypesEnum.dashboard));
    }

    if (state is LoginFailedState) {
      _isInValidNotifier.value = true;
      _buttonNotifier.value = ButtonState.inactive;
    }
  }
}

class RegistrationWidget extends StatelessWidget with DeviceMetricsLessMixin {
  RegistrationWidget(
      {required this.onTap,
      required this.emailController,
      required this.passwordController,
      required this.isRememberNotifier,
      required this.buttonNotifier,
      required this.isInValidNotifier,
      super.key});

  final VoidCallback onTap;
  final ValueNotifier<bool> isRememberNotifier;
  final ValueNotifier<ButtonState> buttonNotifier;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> isInValidNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width:
            Responsive.isMobile(context) ? width(context) : width(context) / 2,
        child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color:
                              AppColors.caribbeanGreenColor.withOpacity(0.05),
                          blurRadius: 4,
                          spreadRadius: 7)
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextEditingWidgets(
                          emailController: emailController,
                          passwordController: passwordController,
                          onChange: _onChangeButtonState,
                          isInValidNotifier: isInValidNotifier),
                      RememberMeWidget(isRememberNotifier: isRememberNotifier),
                      const PrivacyPolicy(),
                      LoginButton(onTap: onTap, buttonNotifier: buttonNotifier)
                    ]))));
  }

  void _onChangeButtonState(String value) {
    isInValidNotifier.value = false;

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      buttonNotifier.value = ButtonState.active;
    } else {
      buttonNotifier.value = ButtonState.inactive;
    }
  }
}

class TextEditingWidgets extends StatelessWidget with DeviceMetricsLessMixin {
  TextEditingWidgets(
      {required this.isInValidNotifier,
      required this.emailController,
      required this.passwordController,
      required this.onChange,
      super.key});

  final ValueNotifier<bool> isInValidNotifier;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final StringCallback onChange;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isInValidNotifier,
        builder: (context, isInValid, child) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              Text('Log In ',
                  style: getStyle(
                      fontSize: width(context) / 20,
                      color: AppColors.nightRiderColor,
                      fontWeight: FontWeight.bold)),
              TextFieldWidget(
                  isInvalid: isInValid,
                  text: 'Email',
                  controller: emailController,
                  hintText: 'Enter email',
                  onChanged: onChange),
              TextFieldWidget(
                  isInvalid: isInValid,
                  text: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  hintText: 'Enter password',
                  onChanged: onChange)
            ])));
  }
}

class RememberMeWidget extends StatelessWidget with DeviceMetricsLessMixin {
  RememberMeWidget({required this.isRememberNotifier, super.key});
  final ValueNotifier<bool> isRememberNotifier;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Text('Remember me',
              style: getStyle(
                  fontSize: 14,
                  color: AppColors.nightRiderColor,
                  fontWeight: FontWeight.bold)),
          ValueListenableBuilder(
              valueListenable: isRememberNotifier,
              builder: (context, bool isRemember, child) => Checkbox(
                  activeColor: AppColors.caribbeanGreenColor,
                  value: isRemember,
                  onChanged: (value) =>
                      isRememberNotifier.value = value ?? false))
        ]));
  }
}

class LoginButton extends StatelessWidget with DeviceMetricsLessMixin {
  const LoginButton(
      {required this.buttonNotifier, required this.onTap, super.key});

  final ValueNotifier<ButtonState> buttonNotifier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ValueListenableBuilder(
            valueListenable: buttonNotifier,
            builder: (context, buttonState, child) => CenteredButton(
                buttonState: buttonState,
                title: 'Login',
                width: width(context) / 2,
                onTap: onTap)));
  }
}

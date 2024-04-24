import 'package:npua_project/components/buttons/centered_button.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends LoginState {}

class ChangeButtonState extends LoginState {
  ChangeButtonState(this.buttonState);

  final ButtonState buttonState;

  @override
  List<Object> get props => [buttonState];
}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {}

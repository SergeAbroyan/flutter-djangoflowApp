import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStartEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}

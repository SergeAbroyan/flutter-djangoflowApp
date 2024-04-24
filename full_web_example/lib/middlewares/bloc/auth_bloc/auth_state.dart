import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class UnAuthenticatedState extends AuthState {}

class AuthenticatedState extends AuthState {}

class LogOutState extends AuthState {}

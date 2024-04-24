import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AdminState {}

class AddStudentState extends AdminState {}

class AddProfessorState extends AdminState {}

class AddTestState extends AdminState {}

import 'package:equatable/equatable.dart';
import 'package:npua_project/middlewares/model/professor_model.dart';
import 'package:npua_project/middlewares/model/student_model.dart';
import 'package:npua_project/middlewares/model/test_model.dart';

abstract class AdminEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddStudentEvent extends AdminEvent {
  final StudentModel studentModel;

  AddStudentEvent({required this.studentModel});

  @override
  List<Object> get props => [studentModel];
}

class AddProfessorEvent extends AdminEvent {
  final ProfessorModel professorModel;

  AddProfessorEvent({required this.professorModel});

  @override
  List<Object> get props => [professorModel];
}

class AddTestEvent extends AdminEvent {
  final TestModel testModel;

  AddTestEvent({required this.testModel});

  @override
  List<Object> get props => [testModel];
}

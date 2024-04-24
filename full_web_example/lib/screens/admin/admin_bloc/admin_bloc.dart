import 'package:npua_project/middlewares/model/professor_model.dart';
import 'package:npua_project/middlewares/model/student_model.dart';
import 'package:npua_project/middlewares/model/test_model.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_event.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(InitialState()) {
    on<AddStudentEvent>(_onAddStudentEvent);
    on<AddProfessorEvent>(_onAddProfessorEvent);
    on<AddTestEvent>(_onAddTestEvent);
  }

  final List<StudentModel> students = [];
  final List<ProfessorModel> professor = [];
  final List<TestModel> test = [
    TestModel(
        question: 'What is the purpose of a university education?',
        answer1: 'To specialize in a specific trade or skill.',
        answer2:
            'To broaden ones intellectual horizons and critical thinking skills.',
        answer3: 'To socialize and make lifelong connections.',
        answer4: 'To solely prepare for a specific job.'),
    TestModel(
        question: 'How do universities contribute to personal development?',
        answer1: 'By focusing solely on academic achievements.',
        answer2:
            'By providing opportunities for extracurricular activities and leadership.',
        answer3: 'By offering high-paying job placements after graduation.',
        answer4: 'By minimizing interactions outside of the classroom.'),
    TestModel(
        question:
            'How can universities support students in preparing for their careers?',
        answer1:
            'By offering theoretical knowledge without practical applications.',
        answer2: 'By providing internship and co-op programs.',
        answer3: 'By solely relying on academic coursework.',
        answer4:
            'By discouraging students from exploring diverse career options.'),
  ];

  Future<void> _onAddStudentEvent(AddStudentEvent event, Emitter emit) async {
    emit(InitialState());
    students.add(event.studentModel);
    emit(AddStudentState());
  }

  Future<void> _onAddProfessorEvent(
      AddProfessorEvent event, Emitter emit) async {
    emit(InitialState());
    professor.add(event.professorModel);
    emit(AddProfessorState());
  }

  Future<void> _onAddTestEvent(AddTestEvent event, Emitter emit) async {
    emit(InitialState());
    test.add(event.testModel);
    emit(AddTestState());
  }
}

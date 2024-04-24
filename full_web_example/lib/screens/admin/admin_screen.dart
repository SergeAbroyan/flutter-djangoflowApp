import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npua_project/components/text_field_widget.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/model/professor_model.dart';
import 'package:npua_project/middlewares/model/student_model.dart';
import 'package:npua_project/middlewares/model/test_model.dart';
import 'package:npua_project/middlewares/notifiers/drawer_controller_notifier.dart';
import 'package:npua_project/middlewares/notifiers/menu_controller_notifier.dart';
import 'package:npua_project/middlewares/responsive.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_bloc.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_event.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_state.dart';
import 'package:npua_project/screens/admin/components/header.dart';
import 'package:npua_project/screens/admin/components/paginator_widget.dart';
import 'package:npua_project/screens/admin/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:npua_project/screens/dialog.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with DeviceMetricsMixin {
  final AdminBloc _adminBloc = AdminBloc();

  final TextEditingController nameStudent = TextEditingController();
  final TextEditingController phoneStudent = TextEditingController();
  final TextEditingController gmailStudent = TextEditingController();

  final TextEditingController nameProfessor = TextEditingController();
  final TextEditingController phoneProfessor = TextEditingController();
  final TextEditingController gmailProfessor = TextEditingController();

  final TextEditingController question = TextEditingController();
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();
  final TextEditingController answer3 = TextEditingController();
  final TextEditingController answer4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminBloc>(
        create: (context) => _adminBloc,
        child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) =>
                Selector<DrawerControllerNotifier, DrawerTypesEnum>(
                    selector: (_, provider) => provider.drawerTypes,
                    builder: (_, drawerTypes, child) => Scaffold(
                        key: context.read<MenuControllerNotifier>().scaffoldKey,
                        drawer: DrawerMenu(drawerTypes: drawerTypes),
                        body: SafeArea(
                            child: Row(children: [
                          if (Responsive.isDesktop(context))
                            Expanded(
                                child: DrawerMenu(drawerTypes: drawerTypes)),
                          Expanded(
                              flex: 5,
                              child: Column(children: [
                                HeaderWidget(
                                    drawerTypes: drawerTypes,
                                    indexCallback: (int index) => show(index)),
                                drawerTypes.widget,
                                if (drawerTypes != DrawerTypesEnum.dashboard &&
                                    drawerTypes != DrawerTypesEnum.info &&
                                    drawerTypes != DrawerTypesEnum.quickTest)
                                  const PaginatorWidget()
                              ]))
                        ]))))));
  }

  void show(int index) {
    if (index == 0) {
      showDialogStudent();
    }
    if (index == 1) {
      showDialogProfessor();
    }
    if (index == 2) {
      showDialogTest();
    }
  }

  void showDialogStudent() {
    CustomDialog(
        context: context,
        title: 'Would like to add student?',
        childrenWidget: studentText(),
        children: [
          DialogButton(
              title: 'Cancel',
              onTap: () {
                Navigator.pop(context);
                clearTestController();
              }),
          DialogButton(
              title: 'Submit',
              titleColor: AppColors.dimGrayColor,
              onTap: () {
                _adminBloc.add(AddStudentEvent(
                    studentModel: StudentModel(
                        name: nameStudent.text,
                        phone: phoneStudent.text,
                        gmail: gmailStudent.text,
                        dateTime: DateTime.now())));
                Navigator.pop(context);
                clearTestController();
              })
        ]).show();
  }

  void showDialogProfessor() {
    CustomDialog(
        context: context,
        childrenWidget: professorText(),
        title: 'Would like to add professor?',
        children: [
          DialogButton(
              title: 'Cancel',
              onTap: () {
                Navigator.pop(context);
                clearTestController();
              }),
          DialogButton(
              title: 'Submit',
              titleColor: AppColors.dimGrayColor,
              onTap: () {
                _adminBloc.add(AddProfessorEvent(
                    professorModel: ProfessorModel(
                        name: nameProfessor.text,
                        phone: phoneProfessor.text,
                        gmail: gmailProfessor.text,
                        dateTime: DateTime.now())));
                Navigator.pop(context);
                clearTestController();
              })
        ]).show();
  }

  void showDialogTest() {
    CustomDialog(
        context: context,
        title: 'Would like to add test?',
        childrenWidget: testText(),
        children: [
          DialogButton(
              title: 'Cancel',
              onTap: () {
                Navigator.pop(context);
                clearTestController();
              }),
          DialogButton(
              title: 'Submit',
              titleColor: AppColors.dimGrayColor,
              onTap: () {
                _adminBloc.add(AddTestEvent(
                    testModel: TestModel(
                        question: question.text,
                        answer1: answer1.text,
                        answer2: answer2.text,
                        answer3: answer3.text,
                        answer4: answer4.text)));
                Navigator.pop(context);
                clearTestController();
              })
        ]).show();
  }

  Widget studentText() {
    return Column(
      children: [
        TextFieldWidget(controller: nameStudent, hintText: 'Student Name'),
        TextFieldWidget(controller: phoneStudent, hintText: 'Student Phone'),
        TextFieldWidget(controller: gmailStudent, hintText: 'Student Email'),
      ],
    );
  }

  Widget professorText() {
    return Column(
      children: [
        TextFieldWidget(controller: nameProfessor, hintText: 'Professor Name'),
        TextFieldWidget(
            controller: phoneProfessor, hintText: 'Professor Phone'),
        TextFieldWidget(
            controller: gmailProfessor, hintText: 'Professor Email'),
      ],
    );
  }

  Widget testText() {
    return Column(
      children: [
        TextFieldWidget(controller: question, hintText: 'Question'),
        TextFieldWidget(controller: answer1, hintText: 'Variant 1'),
        TextFieldWidget(controller: answer2, hintText: 'Variant 2'),
        TextFieldWidget(controller: answer3, hintText: 'Variant 3'),
        TextFieldWidget(controller: answer4, hintText: 'Variant 4'),
      ],
    );
  }

  void clearTestController() {
    nameStudent.clear();
    phoneStudent.clear();
    gmailStudent.clear();
    nameProfessor.clear();
    phoneProfessor.clear();
    gmailProfessor.clear();
    question.clear();
    answer1.clear();
    answer2.clear();
    answer3.clear();
    answer4.clear();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npua_project/components/avatar_image_widget.dart';
import 'package:npua_project/components/table_decoration_widget.dart';
import 'package:npua_project/middlewares/enum/table_types_enums.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/model/student_model.dart';
import 'package:npua_project/middlewares/notifiers/user_item_actions_notifier.dart';
import 'package:flutter/material.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_bloc.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_state.dart';
import 'package:provider/provider.dart';

class UsersWidget extends StatefulWidget {
  const UsersWidget({super.key});

  @override
  State<UsersWidget> createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> with DeviceMetricsMixin {
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    _adminBloc = BlocProvider.of<AdminBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminBloc>.value(
        value: _adminBloc,
        child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) => TableDecorationWidget(
                child: DataTable(
                    columns: List.generate(
                        UserTableTypesEnum.values.length,
                        (index) => DataColumn(
                            label:
                                Text(UserTableTypesEnum.values[index].name))),
                    rows: List<DataRow>.generate(
                        _adminBloc.students.length,
                        (indexx) => DataRow(
                            cells: List<DataCell>.generate(
                                UserTableTypesEnum.values.length,
                                (index) => userDataCell(
                                    index, _adminBloc.students[indexx]))))))));
  }

  DataCell userDataCell(int index, StudentModel students) {
    switch (index) {
      case 0:
        return DataCell(const AvatarWidget(),
            onTap: () =>
                context.read<UserItemActionsNotifier>().changeVisibility(true));
      case 1:
        return DataCell(Text(students.name),
            onTap: () =>
                context.read<UserItemActionsNotifier>().changeVisibility(true));
      case 2:
        return DataCell(Text(students.phone),
            onTap: () =>
                context.read<UserItemActionsNotifier>().changeVisibility(true));
      case 3:
        return DataCell(Text(students.gmail),
            onTap: () =>
                context.read<UserItemActionsNotifier>().changeVisibility(true));
      case 4:
        return DataCell(Text(students.dateTime.toString().substring(0, 16)),
            onTap: () =>
                context.read<UserItemActionsNotifier>().changeVisibility(true));
    }
    return const DataCell(SizedBox.shrink());
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npua_project/components/table_decoration_widget.dart';
import 'package:npua_project/middlewares/enum/table_types_enums.dart';
import 'package:npua_project/middlewares/model/test_model.dart';
import 'package:npua_project/middlewares/notifiers/order_item_actions_notifier.dart';
import 'package:flutter/material.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_bloc.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_state.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
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
                    showBottomBorder: true,
                    columns: List.generate(
                        OrderTableTypesEnum.values.length,
                        (index) => DataColumn(
                            label:
                                Text(OrderTableTypesEnum.values[index].name))),
                    rows: List<DataRow>.generate(
                        _adminBloc.test.length,
                        (indexx) => DataRow(
                            cells: List<DataCell>.generate(
                                OrderTableTypesEnum.values.length,
                                (index) => userDataCell(
                                    index, _adminBloc.test[indexx]))))))));
  }

  DataCell userDataCell(int index, TestModel testModel) {
    switch (index) {
      case 0:
        return DataCell(Text(testModel.question),
            onTap: () => context
                .read<OrderItemActionsNotifier>()
                .changeVisibility(true));
      case 1:
        return DataCell(Text(testModel.answer1),
            onTap: () => context
                .read<OrderItemActionsNotifier>()
                .changeVisibility(true));
      case 2:
        return DataCell(Text(testModel.answer2),
            onTap: () => context
                .read<OrderItemActionsNotifier>()
                .changeVisibility(true));
      case 3:
        return DataCell(Text(testModel.answer3),
            onTap: () => context
                .read<OrderItemActionsNotifier>()
                .changeVisibility(true));
      case 4:
        return DataCell(Text(testModel.answer4),
            onTap: () => context
                .read<OrderItemActionsNotifier>()
                .changeVisibility(true));
    }
    return const DataCell(SizedBox.shrink());
  }
}

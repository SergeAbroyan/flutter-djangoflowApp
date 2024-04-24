import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:npua_project/components/buttons/centered_button.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/model/test_model.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_bloc.dart';
import 'package:npua_project/screens/admin/admin_bloc/admin_state.dart';

class QuickTestWidget extends StatefulWidget {
  const QuickTestWidget({super.key});

  @override
  State<QuickTestWidget> createState() => _QuickTestWidgetState();
}

class _QuickTestWidgetState extends State<QuickTestWidget>
    with DeviceMetricsMixin {
  late AdminBloc _adminBloc;
  int score = 0;
  bool isSubmit = false;

  ButtonState buttonState = ButtonState.inactive;
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
            builder: (context, state) => Column(
                  children: [
                    Container(
                      height: height - 300,
                      child: ListView.builder(
                        itemCount: _adminBloc.test.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => QuickList(
                          testModel: _adminBloc.test[index],
                          onChanged: () => setState(() {
                            buttonState = ButtonState.active;
                          }),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (isSubmit)
                          Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Scorre 75',
                                style: getStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.redColor),
                              )),
                        Padding(
                          padding: const EdgeInsets.only(left: 350),
                          child: CenteredButton(
                            title: 'Submit',
                            width: width / 4,
                            buttonState: buttonState,
                            onTap: () {
                              setState(() {
                                isSubmit = !isSubmit;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )));
  }
}

class QuickList extends StatefulWidget {
  const QuickList(
      {super.key, required this.testModel, required this.onChanged});

  final TestModel testModel;
  final VoidCallback onChanged;

  @override
  State<QuickList> createState() => _QuickListState();
}

class _QuickListState extends State<QuickList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          '${widget.testModel.question} ?',
          style: getStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Column(
        children: [
          CheckboxListTile(
            title: Text(widget.testModel.answer1),
            value: selectedIndex == 1,
            onChanged: (value) {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          CheckboxListTile(
            title: Text(widget.testModel.answer2),
            value: selectedIndex == 2,
            onChanged: (value) {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          CheckboxListTile(
            title: Text(widget.testModel.answer3),
            value: selectedIndex == 3,
            onChanged: (value) {
              setState(() {
                selectedIndex = 3;
              });
            },
          ),
          CheckboxListTile(
            title: Text(widget.testModel.answer4),
            value: selectedIndex == 4,
            onChanged: (value) {
              setState(() {
                selectedIndex = 4;
                widget.onChanged.call();
              });
            },
          )
        ],
      ),
      Divider()
    ]);
  }
}

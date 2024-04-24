import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/enum/date_type_enum.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:npua_project/middlewares/responsive.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PopoverPicker extends StatefulWidget {
  const PopoverPicker({this.onDateSelect, Key? key}) : super(key: key);
  final VoidCallback? onDateSelect;

  @override
  State<PopoverPicker> createState() => _PopoverPickerState();
}

class _PopoverPickerState extends State<PopoverPicker> with DeviceMetricsMixin {
  late final CustomPopupMenuController _popupController;
  final ValueNotifier<DateRangePickerController> _dateRangePickerController =
      ValueNotifier(DateRangePickerController());
  final ValueNotifier<String> _isSelectDateItemNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _popupController = CustomPopupMenuController();
  }

  @override
  void dispose() {
    _popupController.dispose();
    _dateRangePickerController.dispose();
    _isSelectDateItemNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
        controller: _popupController,
        arrowSize: 0,
        barrierColor: Colors.transparent,
        menuBuilder: () => CalendarWidget(
            dateRangePickerController: _dateRangePickerController,
            isSelectDateItemNotifier: _isSelectDateItemNotifier,
            popupController: _popupController),
        pressType: PressType.singleClick,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blackColor),
                color: AppColors.solitudeColor),
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder(
                valueListenable: _dateRangePickerController,
                builder: (context, value, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.calendar_month),
                          if (!Responsive.isMobile(context))
                            Text(_isSelectDateItemNotifier.value,
                                overflow: TextOverflow.clip,
                                style: getStyle(fontSize: 15))
                        ]))));
  }
}

class CalendarWidget extends StatelessWidget with DeviceMetricsLessMixin {
  const CalendarWidget(
      {required this.popupController,
      required this.dateRangePickerController,
      required this.isSelectDateItemNotifier,
      super.key});

  final CustomPopupMenuController popupController;
  final ValueNotifier<DateRangePickerController> dateRangePickerController;
  final ValueNotifier<String> isSelectDateItemNotifier;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: AppColors.solitudeColor, blurRadius: 4, spreadRadius: 7)
          ]),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PickerWidget(
                popupController: popupController,
                dateRangePickerController: dateRangePickerController,
                isSelectDateItemNotifier: isSelectDateItemNotifier),
            DateTypeWidget(
                dateRangePickerController: dateRangePickerController,
                isSelectDateItemNotifier: isSelectDateItemNotifier)
          ]),
    ));
  }
}

class PickerWidget extends StatelessWidget with DeviceMetricsLessMixin {
  const PickerWidget(
      {required this.popupController,
      required this.dateRangePickerController,
      required this.isSelectDateItemNotifier,
      super.key});

  final CustomPopupMenuController popupController;
  final ValueNotifier<DateRangePickerController> dateRangePickerController;
  final ValueNotifier<String> isSelectDateItemNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width(context) / 5,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ValueListenableBuilder(
          valueListenable: dateRangePickerController,
          builder: (context, dateController, child) => SfDateRangePicker(
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              monthViewSettings:
                  const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(color: AppColors.blackColor),
                  todayCellDecoration: BoxDecoration(
                      color: AppColors.solitudeColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              controller: dateController,
              viewSpacing: 5,
              showActionButtons: true,
              onSelectionChanged: _onSelectionChanged,
              onSubmit: _applyButtonTap,
              onCancel: _onCancel,
              backgroundColor: AppColors.whiteColor,
              todayHighlightColor: AppColors.redColor,
              selectionShape: DateRangePickerSelectionShape.rectangle,
              selectionColor: AppColors.caribbeanGreenColor,
              startRangeSelectionColor: AppColors.caribbeanGreenColor,
              endRangeSelectionColor: AppColors.caribbeanGreenColor,
              rangeSelectionColor:
                  AppColors.caribbeanGreenColor.withOpacity(0.1),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range),
        ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value.endDate != null && args.value.startDate != null) {
      final difference =
          args.value.endDate.difference(args.value.startDate).inDays;
      if (difference > 90) {
        dateRangePickerController.value.selectedRange = PickerDateRange(
            args.value.endDate,
            args.value.endDate.subtract(const Duration(days: 90)));
      }
    }
    isSelectDateItemNotifier.value = '';
  }

  void _onCancel() {
    isSelectDateItemNotifier.value = '';
    dateRangePickerController.value = DateRangePickerController();

    popupController.hideMenu();
  }

  void _applyButtonTap(_) {
    popupController.hideMenu();
  }
}

class DateTypeWidget extends StatelessWidget with DeviceMetricsLessMixin {
  const DateTypeWidget(
      {required this.isSelectDateItemNotifier,
      required this.dateRangePickerController,
      super.key});

  final ValueNotifier<String> isSelectDateItemNotifier;
  final ValueNotifier<DateRangePickerController> dateRangePickerController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isSelectDateItemNotifier,
        builder: (context, value, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 40,
              width: width(context) / 5,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: DateType.values.length,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => _onTapDefaultDate(index),
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isSelectDateItemNotifier.value ==
                                        DateType.values[index]
                                            .dateTime()
                                            .toString()
                                    ? AppColors.caribbeanGreenColor
                                        .withOpacity(0.5)
                                    : AppColors.solitudeColor),
                            child: Text(DateType.values[index].title,
                                style: getStyle(fontSize: 12))),
                      )),
            ));
  }

  void _onTapDefaultDate(int index) {
    isSelectDateItemNotifier.value =
        DateType.values[index].dateTime().toString();

    dateRangePickerController.value = DateRangePickerController();

    if (DateType.values[index] == DateType.yesterday) {}
  }
}

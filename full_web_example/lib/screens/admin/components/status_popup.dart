import 'package:npua_project/components/buttons/dropdown_status_button.dart';
import 'package:npua_project/constants/app_colors.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/enum/status_type_enum.dart';
import 'package:npua_project/middlewares/mixins/device_metrics_mixin.dart';
import 'package:flutter/material.dart';

class StatusPopup extends StatelessWidget with DeviceMetricsLessMixin {
  StatusPopup({super.key});

  final ValueNotifier<StatusType> _isActiveNotifier =
      ValueNotifier(StatusType.all);
  final ValueNotifier<StatusType> _isWorkingNotifier =
      ValueNotifier(StatusType.all);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isWorkingNotifier,
        builder: (context, StatusType value, child) => DropdownStatusButton(
            value: value.title,
            columnWidth: 150,
            items: StatusType.values
                .where((valueType) => valueType != _isWorkingNotifier.value)
                .map((StatusType valueType) {
              return DropdownMenuItem<String>(
                  onTap: () => _onTap(valueType, isActive: false),
                  value: valueType.name,
                  child: Text(valueType.title, style: getStyle()));
            }).toList(),
            backgroundColor: AppColors.solitudeColor));
  }

  void _onTap(StatusType status, {bool isActive = true}) {
    isActive
        ? _isActiveNotifier.value = status
        : _isWorkingNotifier.value = status;
  }
}

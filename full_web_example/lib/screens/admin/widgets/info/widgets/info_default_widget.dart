import 'package:npua_project/components/arrow_text_widget.dart';
import 'package:npua_project/constants/app_styles.dart';
import 'package:npua_project/middlewares/enum/utils_app_extension.dart';
import 'package:flutter/material.dart';

class InfoDefaultWidget extends StatelessWidget {
  const InfoDefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          FaqTitleWidget(),
          ArrowTextWidget(title: 'About'),
          ArrowTextWidget(title: 'Terms of us'),
          ArrowTextWidget(title: 'Privacy police'),
          ArrowTextWidget(title: 'Background info'),
          CompanyInfoWidget()
        ]);
  }
}

class FaqTitleWidget extends StatelessWidget {
  const FaqTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('FAQ', style: getStyle(fontSize: 24)),
      ListView.builder(
          shrinkWrap: true,
          itemCount: UtilsAppType.values.length,
          padding: const EdgeInsets.only(top: 10),
          itemBuilder: (context, index) => ArrowTextWidget(
              title: '\u2022 ${UtilsAppType.values[index].getFAQText()}',
              fontSize: 18,
              iconSize: 18,
              padding: 5,
              isDivider: false))
    ]);
  }
}

class CompanyInfoWidget extends StatelessWidget {
  const CompanyInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ArrowTextWidget(title: 'Company Address'),
          Text('Yerevan'),
          ArrowTextWidget(title: 'Company phone number'),
          Text('010-58-01-02')
        ]);
  }
}

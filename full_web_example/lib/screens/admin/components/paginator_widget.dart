import 'package:flutter/widgets.dart';
import 'package:number_paginator/number_paginator.dart';

class PaginatorWidget extends StatelessWidget {
  const PaginatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: NumberPaginator(
            numberPages: 100,
            onPageChange: (int index) {},
            config: const NumberPaginatorUIConfig(
                mode: ContentDisplayMode.dropdown)));
  }
}

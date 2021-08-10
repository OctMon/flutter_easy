import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'controller.dart';

class TuChongPage extends StatelessWidget {
  final TuChongController controller = Get.put(TuChongController());

  @override
  Widget build(BuildContext context) {
    return GetX<TuChongController>(
      init: controller,
      builder: (controller) {
        if (controller.list.isEmptyOrNull) {
          return BasePlaceholderView(
            title: controller.message.value,
          );
        }
        return Container(
          child: ListView(
            children: controller.list.map((element) {
              return Text(element?.toJson().toString());
            }).toList(),
          ),
        );
      },
    );
  }
}

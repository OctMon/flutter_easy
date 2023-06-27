import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'logic.dart';

class ConnectivityPage extends StatelessWidget {
  ConnectivityPage({Key? key}) : super(key: key);

  final logic = Get.put(ConnectivityLogic());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: Center(
        child: Obx(() {
          return Text("${logic.result.value}");
        }),
      ),
    );
  }
}

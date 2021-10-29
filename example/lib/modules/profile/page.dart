import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/user/service.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: Center(
          child: Text(
        "${UserService.find.user.value.toJson()}",
        style: appTheme(context).textTheme.headline3,
      )),
    );
  }
}

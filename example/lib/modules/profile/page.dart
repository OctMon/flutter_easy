import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user/store.dart';

import 'controller.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: Center(
          child: Text(
        "${UserStore.find.user.value.toJson()}",
        style: appTheme(context).textTheme.displaySmall,
      )),
    );
  }
}

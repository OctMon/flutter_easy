import 'package:flutter_easy/flutter_easy.dart';

import 'model.dart';

const String _keyUser = "w351kMZwl21f1pYd";

class UserStore extends GetxController {
  static UserStore get find => Get.find();

  bool get isLogin => user.value.userId != null;

  final user = UserModel().obs;

  Future<UserStore> load() async {
    final json = await getStorageMap(_keyUser);
    if (json != null) {
      user.value = UserModel.fromJson(json);
    }
    return this;
  }

  Future<bool> save(UserModel user) async {
    bool success = await setStorageMap(_keyUser, user.toJson());
    this.user.value = user;
    return success;
  }

  Future<bool> clean() async {
    bool success = await removeStorage(_keyUser);
    if (success) {
      user.value = UserModel();
    }
    return success;
  }
}

import 'package:flutter_easy/flutter_easy.dart';

import 'model.dart';

const String _keyUser = "w351kMZwl21f1pYd";

class UserService extends GetxController {
  static UserService get find => Get.find();

  bool get isLogin => user.value.userId != null;

  final user = UserModel().obs;

  Future<UserService> load() async {
    String? storage = await getStorageString(_keyUser);
    if (storage != null) {
      user.value = UserModel.fromJson(jsonDecode(storage));
    }
    return this;
  }

  Future<bool> save(UserModel user) async {
    bool success = await setStorageString(_keyUser, jsonEncode(user));
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

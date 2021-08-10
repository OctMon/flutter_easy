import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'model.dart';

const String _keyUser = "w351kMZwl21f1pYd";

/// 建立一个AppStore
/// 用于用户信息实时更新
class UserController extends GetxController {
  bool get isLogin => user != null;

  UserModel user;

  Future load() async {
    String storage = await getStorageString(_keyUser);
    if (storage != null) {
      user = UserModel.fromJson(jsonDecode(storage));
      update();
    }
  }

  Future<bool> save(UserModel user) async {
    bool success = await setStorageString(_keyUser, jsonEncode(user));
    this.user = user;
    update();
    return success;
  }

  Future<bool> clean() async {
    bool success = await removeStorage(_keyUser);
    if (success) {
      this.user = null;
      update();
    }
    return success;
  }
}

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'action.dart';
import 'model.dart';
import 'reducer.dart';
import 'state.dart';

export 'model.dart';

const String _keyUser = "w351kMZwl21f1pYd";

/// 建立一个AppStore
/// 用于用户信息实时更新
class UserStore {
  UserStore._();

  static Store<UserState> _userStore;

  static Store<UserState> get store => _userStore;

  static Future load() async {
    UserModel user;
    String storage = await getStorageString(_keyUser);
    if (storage != null) {
      user = UserModel.fromJson(jsonDecode(storage));
    }
    _userStore =
        createStore<UserState>(UserState()..user = user, buildReducer());
  }

  static Future<bool> save(UserModel user) async {
    bool success = await setStorageString(_keyUser, jsonEncode(user));
    UserStore.store.dispatch(UserActionCreator.setUser(user));
    return success;
  }

  static Future<bool> clean() async {
    bool success = await removeStorage(_keyUser);
    if (success) {
      UserStore.store.dispatch(UserActionCreator.setUser(null));
    }
    return success;
  }

  static void visitor(String path, Page<Object, dynamic> page) {
    /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
    /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
    if (page.isTypeof<UserBaseState>()) {
      /// 建立 AppStore 驱动 PageStore 的单向数据连接
      /// 1. 参数1 AppStore
      /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
      page.connectExtraStore<UserState>(UserStore.store,
          (Object pageState, UserState appState) {
        final UserBaseState p = pageState;
        if (p.user?.toJson()?.toString() !=
            appState.user?.toJson()?.toString()) {
          if (pageState is Cloneable) {
            final Object copy = pageState.clone();
            final UserBaseState newState = copy;
            newState.user = appState.user;
            return newState;
          }
        }
        return pageState;
      });
    }
  }
}

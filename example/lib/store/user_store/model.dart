/// userId : "1"
/// nickname : "用户flutter"
/// avatar : ""

class UserModel {
  String userId;
  String nickname;
  String avatar;

  static UserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserModel modelBean = UserModel();
    modelBean.userId = map['userId'];
    modelBean.nickname = map['nickname'];
    modelBean.avatar = map['avatar'];
    return modelBean;
  }

  Map toJson() => {
    "userId": userId,
    "nickname": nickname,
    "avatar": avatar,
  };
}
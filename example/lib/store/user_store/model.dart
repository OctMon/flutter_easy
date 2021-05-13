class UserModel {
  String? userId;
  String? nickname;
  String? avatar;

  UserModel({
      this.userId, 
      this.nickname, 
      this.avatar});

  UserModel.fromJson(dynamic json) {
    userId = json["userId"];
    nickname = json["nickname"];
    avatar = json["avatar"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    map["nickname"] = nickname;
    map["avatar"] = avatar;
    return map;
  }

}
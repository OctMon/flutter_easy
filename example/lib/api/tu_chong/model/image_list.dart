/// img_id : 799740569
/// img_id_str : "799740569"
/// user_id : 16389644
/// title : "710937"
/// excerpt : ""
/// width : 2048
/// height : 2048
/// description : ""

class ImageList {
  int? imgId;
  String? imgIdStr;
  int? userId;
  String? title;
  String? excerpt;
  int? width;
  int? height;
  String? description;

  ImageList({
      this.imgId, 
      this.imgIdStr, 
      this.userId, 
      this.title, 
      this.excerpt, 
      this.width, 
      this.height, 
      this.description});

  ImageList.fromJson(dynamic json) {
    imgId = json['img_id'];
    imgIdStr = json['img_id_str'];
    userId = json['user_id'];
    title = json['title'];
    excerpt = json['excerpt'];
    width = json['width'];
    height = json['height'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['img_id'] = imgId;
    map['img_id_str'] = imgIdStr;
    map['user_id'] = userId;
    map['title'] = title;
    map['excerpt'] = excerpt;
    map['width'] = width;
    map['height'] = height;
    map['description'] = description;
    return map;
  }

}
class TCModel {
  int? postId;
  String? type;
  String? url;
  String? siteId;
  String? authorId;
  String? publishedAt;
  String? passedTime;
  String? excerpt;
  int? favorites;
  int? comments;
  String? parentComments;
  String? rewards;
  int? views;
  bool? collected;
  int? shares;
  bool? recommend;
  bool? delete;
  bool? update;
  String? content;
  String? title;
  int? imageCount;
  List<TCImageModel>? imageList;
  List<String>? tags;
  List<String>? eventTags;
  String? dataType;
  String? createdAt;
  String? recomType;
  String? rqtId;
  bool? isFavorite;

  TCModel(
      {this.postId,
      this.type,
      this.url,
      this.siteId,
      this.authorId,
      this.publishedAt,
      this.passedTime,
      this.excerpt,
      this.favorites,
      this.comments,
      this.parentComments,
      this.rewards,
      this.views,
      this.collected,
      this.shares,
      this.recommend,
      this.delete,
      this.update,
      this.content,
      this.title,
      this.imageCount,
      this.imageList,
      this.tags,
      this.eventTags,
      this.dataType,
      this.createdAt,
      this.recomType,
      this.rqtId,
      this.isFavorite});

  TCModel.fromJson(dynamic json) {
    postId = json['post_id'];
    type = json['type'];
    url = json['url'];
    siteId = json['site_id'];
    authorId = json['author_id'];
    publishedAt = json['published_at'];
    passedTime = json['passed_time'];
    excerpt = json['excerpt'];
    favorites = json['favorites'];
    comments = json['comments'];
    parentComments = json['parent_comments'];
    rewards = json['rewards'];
    views = json['views'];
    collected = json['collected'];
    shares = json['shares'];
    recommend = json['recommend'];
    delete = json['delete'];
    update = json['update'];
    content = json['content'];
    title = json['title'];
    imageCount = json['image_count'];
    if (json['images'] != null) {
      imageList = [];
      json['images'].forEach((v) {
        imageList?.add(TCImageModel.fromJson(v));
      });
    }
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    eventTags =
        json['event_tags'] != null ? json['event_tags'].cast<String>() : [];
    dataType = json['data_type'];
    createdAt = json['created_at'];
    recomType = json['recom_type'];
    rqtId = json['rqt_id'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['post_id'] = postId;
    map['type'] = type;
    map['url'] = url;
    map['site_id'] = siteId;
    map['author_id'] = authorId;
    map['published_at'] = publishedAt;
    map['passed_time'] = passedTime;
    map['excerpt'] = excerpt;
    map['favorites'] = favorites;
    map['comments'] = comments;
    map['parent_comments'] = parentComments;
    map['rewards'] = rewards;
    map['views'] = views;
    map['collected'] = collected;
    map['shares'] = shares;
    map['recommend'] = recommend;
    map['delete'] = delete;
    map['update'] = update;
    map['content'] = content;
    map['title'] = title;
    map['image_count'] = imageCount;
    if (imageList != null) {
      map['images'] = imageList?.map((v) => v.toJson()).toList();
    }
    map['tags'] = tags;
    map['event_tags'] = eventTags;
    map['data_type'] = dataType;
    map['created_at'] = createdAt;
    map['recom_type'] = recomType;
    map['rqt_id'] = rqtId;
    map['is_favorite'] = isFavorite;
    return map;
  }
}

class TCImageModel {
  int? imgId;
  String? imgIdStr;
  int? userId;
  String? title;
  String? excerpt;
  int? width;
  int? height;
  String? description;

  TCImageModel(
      {this.imgId,
      this.imgIdStr,
      this.userId,
      this.title,
      this.excerpt,
      this.width,
      this.height,
      this.description});

  TCImageModel.fromJson(dynamic json) {
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

extension TuChongModelExtension on TCImageModel {
  static double spacing = 4;

  double imageHeightInWidth(double screenWidth) {
    if (isSquare) {
      return (screenWidth - spacing * 2) * height! / width!;
    }
    return 0;
  }

  bool get isSquare {
    return width! >= height!;
  }

  String get imageURL =>
      "https://photo.tuchong.com/" + "$userId" + "/f/" + "$imgId" + ".jpg";
}

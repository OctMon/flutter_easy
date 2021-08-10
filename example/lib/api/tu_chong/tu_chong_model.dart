/// created_at : ""
/// published_at : "2021-01-22 12:36:09"
/// favorite_list_prefix : []
/// comments : 3664
/// url : "https://yudachui.tuchong.com/82009786/"
/// rewardable : true
/// parent_comments : "3544"
/// site_id : "2353448"
/// type : "multi-photo"
/// passed_time : "01月22日"
/// favorites : 16910
/// shares : 2221
/// author_id : "2353448"
/// recom_type : "热门"
/// update : false
/// views : 322057
/// sites : []
/// site : {"description":"资深人像摄影师","videos":11,"is_bind_everphoto":true,"verifications":1,"verified":true,"domain":"yudachui.tuchong.com","url":"https://yudachui.tuchong.com/","type":"user","is_following":false,"verification_list":[{"verification_type":13,"verification_reason":"资深人像摄影师"}],"icon":"https://sf6-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_2353448_29","followers":113826,"site_id":"2353448","name":"俞大锤","has_everphoto_note":false}
/// images : [{"img_id":824771553,"excerpt":"","img_id_str":"824771553","height":1564,"title":"35409","width":1564,"user_id":2353448,"description":""},{"img_id":858522611,"excerpt":"","img_id_str":"858522611","height":5608,"title":"35405","width":3155,"user_id":2353448,"description":""},{"img_id":1292829728,"excerpt":"","img_id_str":"1292829728","height":6000,"title":"35407","width":3375,"user_id":2353448,"description":""},{"img_id":709755890,"excerpt":"","img_id_str":"709755890","height":5667,"title":"35400","width":3188,"user_id":2353448,"description":""},{"img_id":1258554294,"excerpt":"","img_id_str":"1258554294","height":5831,"title":"35404","width":3280,"user_id":2353448,"description":""},{"img_id":913572837,"excerpt":"","img_id_str":"913572837","height":6000,"title":"35406","width":3375,"user_id":2353448,"description":""},{"img_id":1027670978,"excerpt":"","img_id_str":"1027670978","height":4572,"title":"35403","width":2572,"user_id":2353448,"description":""},{"img_id":883753955,"excerpt":"","img_id_str":"883753955","height":5264,"title":"35402","width":2961,"user_id":2353448,"description":""},{"img_id":663356348,"excerpt":"","img_id_str":"663356348","height":5989,"title":"35401","width":3369,"user_id":2353448,"description":""},{"img_id":860029861,"excerpt":"","img_id_str":"860029861","height":5955,"title":"35399","width":3350,"user_id":2353448,"description":""}]
/// event_tags : ["日本摄影圈","我要上“首页推荐位”","我要上开屏"]
/// recommend : true
/// content : "那些值得被记录的日子。"
/// excerpt : "那些值得被记录的日子。"
/// delete : false
/// collected : false
/// title_image : null
/// tags : ["日本摄影圈","我要上“首页推荐位”","我要上开屏","俞大锤·正片滤镜","日本","旅游","环境"]
/// reward_list_prefix : []
/// rqt_id : "4a57f08e3f26f48ebf97ac035bcd01d2"
/// is_favorite : false
/// image_count : 10
/// data_type : "post"
/// title : ""
/// post_id : 82009786
/// rewards : "6"
/// comment_list_prefix : []

class TuChongModel {
  String createdAt;
  String publishedAt;
  int comments;
  String url;
  bool rewardable;
  String parentComments;
  String siteId;
  String type;
  String passedTime;
  int favorites;
  int shares;
  String authorId;
  String recomType;
  bool update;
  int views;
  List<Images> images;
  List<String> eventTags;
  bool recommend;
  String content;
  String excerpt;
  bool delete;
  bool collected;
  List<String> tags;
  String rqtId;
  bool isFavorite;
  int imageCount;
  String dataType;
  String title;
  int postId;
  String rewards;

  TuChongModel({
      this.createdAt,
      this.publishedAt,
      this.comments,
      this.url,
      this.rewardable,
      this.parentComments,
      this.siteId,
      this.type,
      this.passedTime,
      this.favorites,
      this.shares,
      this.authorId,
      this.recomType,
      this.update,
      this.views,
      this.images,
      this.eventTags,
      this.recommend,
      this.content,
      this.excerpt,
      this.delete,
      this.collected,
      this.tags,
      this.rqtId,
      this.isFavorite,
      this.imageCount,
      this.dataType,
      this.title,
      this.postId,
      this.rewards});

  TuChongModel.fromJson(dynamic json) {
    createdAt = json["created_at"];
    publishedAt = json["published_at"];
    comments = json["comments"];
    url = json["url"];
    rewardable = json["rewardable"];
    parentComments = json["parent_comments"];
    siteId = json["site_id"];
    type = json["type"];
    passedTime = json["passed_time"];
    favorites = json["favorites"];
    shares = json["shares"];
    authorId = json["author_id"];
    recomType = json["recom_type"];
    update = json["update"];
    views = json["views"];
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    eventTags = json["event_tags"] != null ? json["event_tags"].cast<String>() : [];
    recommend = json["recommend"];
    content = json["content"];
    excerpt = json["excerpt"];
    delete = json["delete"];
    collected = json["collected"];
    tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    rqtId = json["rqt_id"];
    isFavorite = json["is_favorite"];
    imageCount = json["image_count"];
    dataType = json["data_type"];
    title = json["title"];
    postId = json["post_id"];
    rewards = json["rewards"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["created_at"] = createdAt;
    map["published_at"] = publishedAt;
    map["comments"] = comments;
    map["url"] = url;
    map["rewardable"] = rewardable;
    map["parent_comments"] = parentComments;
    map["site_id"] = siteId;
    map["type"] = type;
    map["passed_time"] = passedTime;
    map["favorites"] = favorites;
    map["shares"] = shares;
    map["author_id"] = authorId;
    map["recom_type"] = recomType;
    map["update"] = update;
    map["views"] = views;
    if (images != null) {
      map["images"] = images.map((v) => v.toJson()).toList();
    }
    map["event_tags"] = eventTags;
    map["recommend"] = recommend;
    map["content"] = content;
    map["excerpt"] = excerpt;
    map["delete"] = delete;
    map["collected"] = collected;
    map["tags"] = tags;
    map["rqt_id"] = rqtId;
    map["is_favorite"] = isFavorite;
    map["image_count"] = imageCount;
    map["data_type"] = dataType;
    map["title"] = title;
    map["post_id"] = postId;
    map["rewards"] = rewards;
    return map;
  }

}

/// img_id : 824771553
/// excerpt : ""
/// img_id_str : "824771553"
/// height : 1564
/// title : "35409"
/// width : 1564
/// user_id : 2353448
/// description : ""

class Images {
  int imgId;
  String excerpt;
  String imgIdStr;
  int height;
  String title;
  int width;
  int userId;
  String description;

  Images({
      this.imgId,
      this.excerpt,
      this.imgIdStr,
      this.height,
      this.title,
      this.width,
      this.userId,
      this.description});

  Images.fromJson(dynamic json) {
    imgId = json["img_id"];
    excerpt = json["excerpt"];
    imgIdStr = json["img_id_str"];
    height = json["height"];
    title = json["title"];
    width = json["width"];
    userId = json["user_id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["img_id"] = imgId;
    map["excerpt"] = excerpt;
    map["img_id_str"] = imgIdStr;
    map["height"] = height;
    map["title"] = title;
    map["width"] = width;
    map["user_id"] = userId;
    map["description"] = description;
    return map;
  }

}

/// description : "资深人像摄影师"
/// videos : 11
/// is_bind_everphoto : true
/// verifications : 1
/// verified : true
/// domain : "yudachui.tuchong.com"
/// url : "https://yudachui.tuchong.com/"
/// type : "user"
/// is_following : false
/// verification_list : [{"verification_type":13,"verification_reason":"资深人像摄影师"}]
/// icon : "https://sf6-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_2353448_29"
/// followers : 113826
/// site_id : "2353448"
/// name : "俞大锤"
/// has_everphoto_note : false

class Site {
  String description;
  int videos;
  bool isBindEverphoto;
  int verifications;
  bool verified;
  String domain;
  String url;
  String type;
  bool isFollowing;
  List<VerificationList> verificationList;
  String icon;
  int followers;
  String siteId;
  String name;
  bool hasEverphotoNote;

  Site({
      this.description,
      this.videos,
      this.isBindEverphoto,
      this.verifications,
      this.verified,
      this.domain,
      this.url,
      this.type,
      this.isFollowing,
      this.verificationList,
      this.icon,
      this.followers,
      this.siteId,
      this.name,
      this.hasEverphotoNote});

  Site.fromJson(dynamic json) {
    description = json["description"];
    videos = json["videos"];
    isBindEverphoto = json["is_bind_everphoto"];
    verifications = json["verifications"];
    verified = json["verified"];
    domain = json["domain"];
    url = json["url"];
    type = json["type"];
    isFollowing = json["is_following"];
    if (json["verification_list"] != null) {
      verificationList = [];
      json["verification_list"].forEach((v) {
        verificationList.add(VerificationList.fromJson(v));
      });
    }
    icon = json["icon"];
    followers = json["followers"];
    siteId = json["site_id"];
    name = json["name"];
    hasEverphotoNote = json["has_everphoto_note"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = description;
    map["videos"] = videos;
    map["is_bind_everphoto"] = isBindEverphoto;
    map["verifications"] = verifications;
    map["verified"] = verified;
    map["domain"] = domain;
    map["url"] = url;
    map["type"] = type;
    map["is_following"] = isFollowing;
    if (verificationList != null) {
      map["verification_list"] = verificationList.map((v) => v.toJson()).toList();
    }
    map["icon"] = icon;
    map["followers"] = followers;
    map["site_id"] = siteId;
    map["name"] = name;
    map["has_everphoto_note"] = hasEverphotoNote;
    return map;
  }

}

/// verification_type : 13
/// verification_reason : "资深人像摄影师"

class VerificationList {
  int verificationType;
  String verificationReason;

  VerificationList({
      this.verificationType,
      this.verificationReason});

  VerificationList.fromJson(dynamic json) {
    verificationType = json["verification_type"];
    verificationReason = json["verification_reason"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["verification_type"] = verificationType;
    map["verification_reason"] = verificationReason;
    return map;
  }

}

extension TuChongModelExtension on Images {
  static double spacing = 4;

  double imageHeightInWidth(double screenWidth) {
    if (isSquare) {
      return (screenWidth - spacing * 2) * height / width;
    }
    return 0;
  }

  bool get isSquare {
    return width >= height;
  }

  String get imageURL =>
      "https://photo.tuchong.com/" + "$userId" + "/f/" + "$imgId" + ".jpg";
}

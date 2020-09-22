/// post_id : 70268574
/// type : "multi-photo"
/// url : "https://tuchong.com/3416599/70268574/"
/// site_id : "3416599"
/// author_id : "3416599"
/// published_at : "2020-08-24 09:40:13"
/// passed_time : "08月24日"
/// excerpt : "曼谷真的太有趣了，火车经过的通道竟然还有个热闹非凡的市场~无人机视角的铁道市场你见过吗？"
/// favorites : 22
/// comments : 2
/// rewardable : true
/// parent_comments : "2"
/// rewards : "0"
/// views : 682
/// collected : false
/// shares : 1
/// recommend : true
/// delete : false
/// update : false
/// content : "曼谷真的太有趣了，火车经过的通道竟然还有个热闹非凡的市场~无人机视角的铁道市场你见过吗？"
/// title : ""
/// image_count : 1
/// images : [{"img_id":312529951,"img_id_str":"312529951","user_id":3416599,"title":"Optional(","excerpt":"","width":1798,"height":2398,"description":""}]
/// title_image : null
/// tags : ["这个巷子有故事","胶片人文和纪实交流","用镜头诉说","独目天下（人文）","人文风光摄影圈","街道","交通工具"]
/// event_tags : ["这个巷子有故事","胶片人文和纪实交流","用镜头诉说","独目天下（人文）","人文风光摄影圈"]
/// favorite_list_prefix : []
/// reward_list_prefix : []
/// comment_list_prefix : []
/// data_type : "post"
/// created_at : ""
/// sites : []
/// site : {"site_id":"3416599","type":"user","name":"Supermickiii","domain":"","description":"Instagram/新浪微博/小红书同名\nmicki_fly@hotmail.com","followers":189,"url":"https://tuchong.com/3416599/","icon":"https://sf3-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_3416599_2","is_bind_everphoto":true,"has_everphoto_note":true,"verified":false,"verifications":0,"verification_list":[],"is_following":false}
/// recom_type : ""
/// rqt_id : "8626c461faaa3d20490d021a5b53c806"
/// is_favorite : false

class FeedModel {
  int postId;
  String type;
  String url;
  String siteId;
  String authorId;
  String publishedAt;
  String passedTime;
  String excerpt;
  int favorites;
  int comments;
  bool rewardable;
  String parentComments;
  String rewards;
  int views;
  bool collected;
  int shares;
  bool recommend;
  bool delete;
  bool update;
  String content;
  String title;
  int imageCount;
  List<Images> images;
  List<String> tags;
  List<String> eventTags;
  String dataType;
  String createdAt;
  Site site;
  String recomType;
  String rqtId;
  bool isFavorite;

  FeedModel(
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
      this.rewardable,
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
      this.images,
      this.tags,
      this.eventTags,
      this.dataType,
      this.createdAt,
      this.site,
      this.recomType,
      this.rqtId,
      this.isFavorite});

  FeedModel.fromJson(dynamic json) {
    postId = json["postId"];
    type = json["type"];
    url = json["url"];
    siteId = json["siteId"];
    authorId = json["authorId"];
    publishedAt = json["publishedAt"];
    passedTime = json["passedTime"];
    excerpt = json["excerpt"];
    favorites = json["favorites"];
    comments = json["comments"];
    rewardable = json["rewardable"];
    parentComments = json["parentComments"];
    rewards = json["rewards"];
    views = json["views"];
    collected = json["collected"];
    shares = json["shares"];
    recommend = json["recommend"];
    delete = json["delete"];
    update = json["update"];
    content = json["content"];
    title = json["title"];
    imageCount = json["imageCount"];
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    eventTags =
        json["eventTags"] != null ? json["eventTags"].cast<String>() : [];
    dataType = json["dataType"];
    createdAt = json["createdAt"];
    site = json["site"] != null ? Site.fromJson(json["site"]) : null;
    recomType = json["recomType"];
    rqtId = json["rqtId"];
    isFavorite = json["isFavorite"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["postId"] = postId;
    map["type"] = type;
    map["url"] = url;
    map["siteId"] = siteId;
    map["authorId"] = authorId;
    map["publishedAt"] = publishedAt;
    map["passedTime"] = passedTime;
    map["excerpt"] = excerpt;
    map["favorites"] = favorites;
    map["comments"] = comments;
    map["rewardable"] = rewardable;
    map["parentComments"] = parentComments;
    map["rewards"] = rewards;
    map["views"] = views;
    map["collected"] = collected;
    map["shares"] = shares;
    map["recommend"] = recommend;
    map["delete"] = delete;
    map["update"] = update;
    map["content"] = content;
    map["title"] = title;
    map["imageCount"] = imageCount;
    if (images != null) {
      map["images"] = images.map((v) => v.toJson()).toList();
    }
    map["tags"] = tags;
    map["eventTags"] = eventTags;
    map["dataType"] = dataType;
    map["createdAt"] = createdAt;
    if (site != null) {
      map["site"] = site.toJson();
    }
    map["recomType"] = recomType;
    map["rqtId"] = rqtId;
    map["isFavorite"] = isFavorite;
    return map;
  }
}

/// site_id : "3416599"
/// type : "user"
/// name : "Supermickiii"
/// domain : ""
/// description : "Instagram/新浪微博/小红书同名\nmicki_fly@hotmail.com"
/// followers : 189
/// url : "https://tuchong.com/3416599/"
/// icon : "https://sf3-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_3416599_2"
/// is_bind_everphoto : true
/// has_everphoto_note : true
/// verified : false
/// verifications : 0
/// verification_list : []
/// is_following : false

class Site {
  String siteId;
  String type;
  String name;
  String domain;
  String description;
  int followers;
  String url;
  String icon;
  bool isBindEverphoto;
  bool hasEverphotoNote;
  bool verified;
  int verifications;
  bool isFollowing;

  Site(
      {this.siteId,
      this.type,
      this.name,
      this.domain,
      this.description,
      this.followers,
      this.url,
      this.icon,
      this.isBindEverphoto,
      this.hasEverphotoNote,
      this.verified,
      this.verifications,
      this.isFollowing});

  Site.fromJson(dynamic json) {
    siteId = json["siteId"];
    type = json["type"];
    name = json["name"];
    domain = json["domain"];
    description = json["description"];
    followers = json["followers"];
    url = json["url"];
    icon = json["icon"];
    isBindEverphoto = json["isBindEverphoto"];
    hasEverphotoNote = json["hasEverphotoNote"];
    verified = json["verified"];
    verifications = json["verifications"];
    isFollowing = json["isFollowing"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["siteId"] = siteId;
    map["type"] = type;
    map["name"] = name;
    map["domain"] = domain;
    map["description"] = description;
    map["followers"] = followers;
    map["url"] = url;
    map["icon"] = icon;
    map["isBindEverphoto"] = isBindEverphoto;
    map["hasEverphotoNote"] = hasEverphotoNote;
    map["verified"] = verified;
    map["verifications"] = verifications;
    map["isFollowing"] = isFollowing;
    return map;
  }
}

/// img_id : 312529951
/// img_id_str : "312529951"
/// user_id : 3416599
/// title : "Optional("
/// excerpt : ""
/// width : 1798
/// height : 2398
/// description : ""

class Images {
  int imgId;
  String imgIdStr;
  int userId;
  String title;
  String excerpt;
  int width;
  int height;
  String description;

  Images(
      {this.imgId,
      this.imgIdStr,
      this.userId,
      this.title,
      this.excerpt,
      this.width,
      this.height,
      this.description});

  Images.fromJson(dynamic json) {
    imgId = json["imgId"];
    imgIdStr = json["imgIdStr"];
    userId = json["userId"];
    title = json["title"];
    excerpt = json["excerpt"];
    width = json["width"];
    height = json["height"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imgId"] = imgId;
    map["imgIdStr"] = imgIdStr;
    map["userId"] = userId;
    map["title"] = title;
    map["excerpt"] = excerpt;
    map["width"] = width;
    map["height"] = height;
    map["description"] = description;
    return map;
  }
}

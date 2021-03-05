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

class TuChongModel {
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
  List<ImagesBean> images;
  dynamic titleImage;
  List<String> tags;
  List<String> eventTags;
  List<dynamic> favoriteListPrefix;
  List<dynamic> rewardListPrefix;
  List<dynamic> commentListPrefix;
  String dataType;
  String createdAt;
  List<dynamic> sites;
  SiteBean site;
  String recomType;
  String rqtId;
  bool isFavorite;

  static TuChongModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TuChongModel tuChongModelBean = TuChongModel();
    tuChongModelBean.postId = map['post_id'];
    tuChongModelBean.type = map['type'];
    tuChongModelBean.url = map['url'];
    tuChongModelBean.siteId = map['site_id'];
    tuChongModelBean.authorId = map['author_id'];
    tuChongModelBean.publishedAt = map['published_at'];
    tuChongModelBean.passedTime = map['passed_time'];
    tuChongModelBean.excerpt = map['excerpt'];
    tuChongModelBean.favorites = map['favorites'];
    tuChongModelBean.comments = map['comments'];
    tuChongModelBean.rewardable = map['rewardable'];
    tuChongModelBean.parentComments = map['parent_comments'];
    tuChongModelBean.rewards = map['rewards'];
    tuChongModelBean.views = map['views'];
    tuChongModelBean.collected = map['collected'];
    tuChongModelBean.shares = map['shares'];
    tuChongModelBean.recommend = map['recommend'];
    tuChongModelBean.delete = map['delete'];
    tuChongModelBean.update = map['update'];
    tuChongModelBean.content = map['content'];
    tuChongModelBean.title = map['title'];
    tuChongModelBean.imageCount = map['image_count'];
    tuChongModelBean.images = []
      ..addAll((map['images'] as List ?? []).map((o) => ImagesBean.fromMap(o)));
    tuChongModelBean.titleImage = map['title_image'];
    tuChongModelBean.tags = []
      ..addAll((map['tags'] as List ?? []).map((o) => o.toString()));
    tuChongModelBean.favoriteListPrefix = map['favorite_list_prefix'];
    tuChongModelBean.rewardListPrefix = map['reward_list_prefix'];
    tuChongModelBean.commentListPrefix = map['comment_list_prefix'];
    tuChongModelBean.dataType = map['data_type'];
    tuChongModelBean.createdAt = map['created_at'];
    tuChongModelBean.sites = map['sites'];
    tuChongModelBean.site = SiteBean.fromMap(map['site']);
    tuChongModelBean.recomType = map['recom_type'];
    tuChongModelBean.rqtId = map['rqt_id'];
    tuChongModelBean.isFavorite = map['is_favorite'];
    return tuChongModelBean;
  }

  Map toJson() => {
        "post_id": postId,
        "type": type,
        "url": url,
        "site_id": siteId,
        "author_id": authorId,
        "published_at": publishedAt,
        "passed_time": passedTime,
        "excerpt": excerpt,
        "favorites": favorites,
        "comments": comments,
        "rewardable": rewardable,
        "parent_comments": parentComments,
        "rewards": rewards,
        "views": views,
        "collected": collected,
        "shares": shares,
        "recommend": recommend,
        "delete": delete,
        "update": update,
        "content": content,
        "title": title,
        "image_count": imageCount,
        "images": images,
        "title_image": titleImage,
        "tags": tags,
        "event_tags": eventTags,
        "favorite_list_prefix": favoriteListPrefix,
        "reward_list_prefix": rewardListPrefix,
        "comment_list_prefix": commentListPrefix,
        "data_type": dataType,
        "created_at": createdAt,
        "sites": sites,
        "site": site,
        "recom_type": recomType,
        "rqt_id": rqtId,
        "is_favorite": isFavorite,
      };
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

class SiteBean {
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
  List<dynamic> verificationList;
  bool isFollowing;

  static SiteBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SiteBean siteBean = SiteBean();
    siteBean.siteId = map['site_id'];
    siteBean.type = map['type'];
    siteBean.name = map['name'];
    siteBean.domain = map['domain'];
    siteBean.description = map['description'];
    siteBean.followers = map['followers'];
    siteBean.url = map['url'];
    siteBean.icon = map['icon'];
    siteBean.isBindEverphoto = map['is_bind_everphoto'];
    siteBean.hasEverphotoNote = map['has_everphoto_note'];
    siteBean.verified = map['verified'];
    siteBean.verifications = map['verifications'];
    siteBean.verificationList = map['verification_list'];
    siteBean.isFollowing = map['is_following'];
    return siteBean;
  }

  Map toJson() => {
        "site_id": siteId,
        "type": type,
        "name": name,
        "domain": domain,
        "description": description,
        "followers": followers,
        "url": url,
        "icon": icon,
        "is_bind_everphoto": isBindEverphoto,
        "has_everphoto_note": hasEverphotoNote,
        "verified": verified,
        "verifications": verifications,
        "verification_list": verificationList,
        "is_following": isFollowing,
      };
}

/// img_id : 312529951
/// img_id_str : "312529951"
/// user_id : 3416599
/// title : "Optional("
/// excerpt : ""
/// width : 1798
/// height : 2398
/// description : ""

class ImagesBean {
  int imgId;
  String imgIdStr;
  int userId;
  String title;
  String excerpt;
  int width;
  int height;
  String description;

  static const int crossAxisCount = 2;
  static const double spacing = 4;

  String get imageURL =>
      "https://photo.tuchong.com/" + "$userId" + "/f/" + "$imgId" + ".jpg";

  double imageHeightInWidth(double screenWidth) {
    if (isSquare) {
      return (screenWidth - spacing * 2) * height / width;
    }
    return ((screenWidth - spacing * (crossAxisCount + 1)) / crossAxisCount) *
        height /
        width;
  }

  bool get isSquare {
    return width >= height;
  }

  static ImagesBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ImagesBean imagesBean = ImagesBean();
    imagesBean.imgId = map['img_id'];
    imagesBean.imgIdStr = map['img_id_str'];
    imagesBean.userId = map['user_id'];
    imagesBean.title = map['title'];
    imagesBean.excerpt = map['excerpt'];
    imagesBean.width = map['width'];
    imagesBean.height = map['height'];
    imagesBean.description = map['description'];
    return imagesBean;
  }

  Map toJson() => {
        "img_id": imgId,
        "img_id_str": imgIdStr,
        "user_id": userId,
        "title": title,
        "excerpt": excerpt,
        "width": width,
        "height": height,
        "description": description,
      };
}

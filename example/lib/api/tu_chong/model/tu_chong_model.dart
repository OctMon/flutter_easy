import 'package:flutter_easy_example/api/tu_chong/model/image_list.dart';

import 'site.dart';

/// post_id : 92698382
/// type : "multi-photo"
/// url : "https://tuchong.com/16389644/92698382/"
/// site_id : "16389644"
/// author_id : "16389644"
/// published_at : "2021-05-05 13:27:38"
/// passed_time : "05月05日"
/// excerpt : "广州拍照 | 想把日常生活里的甜味分享给你"
/// favorites : 22307
/// comments : 6251
/// rewardable : true
/// parent_comments : "6012"
/// rewards : "1"
/// views : 279723
/// collected : false
/// shares : 2943
/// recommend : true
/// delete : false
/// update : false
/// content : "广州拍照 | 想把日常生活里的甜味分享给你"
/// title : ""
/// image_count : 10
/// imageList : [{"img_id":799740569,"img_id_str":"799740569","user_id":16389644,"title":"710937","excerpt":"","width":2048,"height":2048,"description":""},{"img_id":828183178,"img_id_str":"828183178","user_id":16389644,"title":"707077","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":970527403,"img_id_str":"970527403","user_id":16389644,"title":"707075","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":804983486,"img_id_str":"804983486","user_id":16389644,"title":"707073","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":1243288149,"img_id_str":"1243288149","user_id":16389644,"title":"707076","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":704844395,"img_id_str":"704844395","user_id":16389644,"title":"707072","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":811406007,"img_id_str":"811406007","user_id":16389644,"title":"707074","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":1006572035,"img_id_str":"1006572035","user_id":16389644,"title":"707078","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":1041044063,"img_id_str":"1041044063","user_id":16389644,"title":"707088","excerpt":"","width":6000,"height":3375,"description":""},{"img_id":722932342,"img_id_str":"722932342","user_id":16389644,"title":"707079","excerpt":"","width":6000,"height":3375,"description":""}]
/// title_image : null
/// tags : ["城市","街道","房子","旅游","广东","广州","城市的","季节","动漫","花城","烟火气","人间烟火气","温暖","羊城","浪漫","扫街","人文","带我看看，你的城市","扫街城市创意","大湾区城市探索者","人文纪实手册","街拍纪实手册","广州摄影圈","广州这座城","城市画册","最满意的风光照","生于街头"]
/// event_tags : ["带我看看，你的城市","扫街城市创意","大湾区城市探索者","人文纪实手册","街拍纪实手册","广州摄影圈","广州这座城","城市画册","最满意的风光照","生于街头"]
/// favorite_list_prefix : []
/// reward_list_prefix : []
/// comment_list_prefix : []
/// data_type : "post"
/// created_at : ""
/// sites : []
/// site : {"site_id":"16389644","type":"user","name":"Hobin-MK813","domain":"","description":"资深风光摄影师","followers":95184,"url":"https://tuchong.com/16389644/","icon":"https://sf6-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_16389644_2","is_bind_everphoto":false,"has_everphoto_note":true,"videos":2,"verified":true,"verifications":1,"verification_list":[{"verification_type":13,"verification_reason":"资深风光摄影师"}],"is_following":false}
/// recom_type : "热门"
/// rqt_id : "395425aac700d678f02d85762a65a5f4"
/// is_favorite : false

class TuChongModel {
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
  bool? rewardable;
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
  List<ImageList>? imageList;
  List<String>? tags;
  List<String>? eventTags;
  String? dataType;
  String? createdAt;
  List<Site>? sites;
  Site? site;
  String? recomType;
  String? rqtId;
  bool? isFavorite;

  TuChongModel(
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
      this.imageList,
      this.tags,
      this.eventTags,
      this.dataType,
      this.createdAt,
      this.sites,
      this.site,
      this.recomType,
      this.rqtId,
      this.isFavorite});

  TuChongModel.fromJson(dynamic json) {
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
    rewardable = json['rewardable'];
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
        imageList?.add(ImageList.fromJson(v));
      });
    }
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    eventTags =
        json['event_tags'] != null ? json['event_tags'].cast<String>() : [];
    dataType = json['data_type'];
    createdAt = json['created_at'];
    if (json['sites'] != null) {
      sites = [];
      json['sites'].forEach((v) {
        sites?.add(Site.fromJson(v));
      });
    }
    site = json['site'] != null ? Site.fromJson(json['site']) : null;
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
    map['rewardable'] = rewardable;
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
    if (sites != null) {
      map['sites'] = sites?.map((v) => v.toJson()).toList();
    }
    if (site != null) {
      map['site'] = site?.toJson();
    }
    map['recom_type'] = recomType;
    map['rqt_id'] = rqtId;
    map['is_favorite'] = isFavorite;
    return map;
  }
}

extension TuChongModelExtension on ImageList {
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

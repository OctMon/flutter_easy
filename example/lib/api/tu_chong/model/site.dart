import 'verification_list.dart';

/// site_id : "16389644"
/// type : "user"
/// name : "Hobin-MK813"
/// domain : ""
/// description : "资深风光摄影师"
/// followers : 95184
/// url : "https://tuchong.com/16389644/"
/// icon : "https://sf6-tccdn-tos.pstatp.com/obj/tuchong-avatar/ll_16389644_2"
/// is_bind_everphoto : false
/// has_everphoto_note : true
/// videos : 2
/// verified : true
/// verifications : 1
/// verification_list : [{"verification_type":13,"verification_reason":"资深风光摄影师"}]
/// is_following : false

class Site {
  String? siteId;
  String? type;
  String? name;
  String? domain;
  String? description;
  int? followers;
  String? url;
  String? icon;
  bool? isBindEverphoto;
  bool? hasEverphotoNote;
  int? videos;
  bool? verified;
  int? verifications;
  List<VerificationList>? verificationList;
  bool? isFollowing;

  Site({
      this.siteId, 
      this.type, 
      this.name, 
      this.domain, 
      this.description, 
      this.followers, 
      this.url, 
      this.icon, 
      this.isBindEverphoto, 
      this.hasEverphotoNote, 
      this.videos, 
      this.verified, 
      this.verifications, 
      this.verificationList, 
      this.isFollowing});

  Site.fromJson(dynamic json) {
    siteId = json['site_id'];
    type = json['type'];
    name = json['name'];
    domain = json['domain'];
    description = json['description'];
    followers = json['followers'];
    url = json['url'];
    icon = json['icon'];
    isBindEverphoto = json['is_bind_everphoto'];
    hasEverphotoNote = json['has_everphoto_note'];
    videos = json['videos'];
    verified = json['verified'];
    verifications = json['verifications'];
    if (json['verification_list'] != null) {
      verificationList = [];
      json['verification_list'].forEach((v) {
        verificationList?.add(VerificationList.fromJson(v));
      });
    }
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['site_id'] = siteId;
    map['type'] = type;
    map['name'] = name;
    map['domain'] = domain;
    map['description'] = description;
    map['followers'] = followers;
    map['url'] = url;
    map['icon'] = icon;
    map['is_bind_everphoto'] = isBindEverphoto;
    map['has_everphoto_note'] = hasEverphotoNote;
    map['videos'] = videos;
    map['verified'] = verified;
    map['verifications'] = verifications;
    if (verificationList != null) {
      map['verification_list'] = verificationList?.map((v) => v.toJson()).toList();
    }
    map['is_following'] = isFollowing;
    return map;
  }

}
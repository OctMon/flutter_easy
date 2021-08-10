/// verification_type : 13
/// verification_reason : "资深风光摄影师"

class Verification_list {
  int? verificationType;
  String? verificationReason;

  Verification_list({
      this.verificationType, 
      this.verificationReason});

  Verification_list.fromJson(dynamic json) {
    verificationType = json['verification_type'];
    verificationReason = json['verification_reason'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['verification_type'] = verificationType;
    map['verification_reason'] = verificationReason;
    return map;
  }

}
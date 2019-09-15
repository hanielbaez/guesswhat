import 'package:cloud_firestore/cloud_firestore.dart';

class Love {
  final bool state;
  final String userId;
  final String riddleId;
  final String thumbnailUrl;
  final String text;
  final Timestamp updateDate = Timestamp.now();

  Love({this.state, this.userId, this.riddleId, this.thumbnailUrl, this.text});

  factory Love.fromFireStore(Map<dynamic, dynamic> map) {
    return Love(state: map['state']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['state'] = this.state;
    map['userId'] = this.userId;
    map['riddleId'] = this.riddleId;
    map['thumbnailUrl'] = this.thumbnailUrl;
    map['text'] = this.text;
    map['updateDate'] = this.updateDate;
    return map;
  }
}

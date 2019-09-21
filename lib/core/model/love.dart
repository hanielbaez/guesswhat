import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Love {
  final bool state;
  final String ownerId;
  String userId;
  String displayName;
  final String riddleId;
  final String thumbnailUrl;
  final String text;
  final Timestamp updateDate = Timestamp.now();

  Love(
      {@required this.state,
      this.ownerId,
      this.userId,
      this.displayName,
      this.riddleId,
      this.thumbnailUrl,
      this.text});

  factory Love.fromFireStore(Map<dynamic, dynamic> map) {
    return Love(state: map['state']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['state'] = this.state;
    map['ownerId'] = this.ownerId;
    map['userId'] = this.userId;
    map['displayName'] = this.displayName;
    map['riddleId'] = this.riddleId;
    map['thumbnailUrl'] = this.thumbnailUrl;
    map['text'] = this.text;
    map['updateDate'] = this.updateDate;
    return map;
  }
}

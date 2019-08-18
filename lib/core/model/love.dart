import 'package:cloud_firestore/cloud_firestore.dart';

class Love {
  final bool state;
  final String userId;
  final String guessId;
  final Timestamp updateDate = Timestamp.now();

  Love({this.state, this.userId, this.guessId});

  factory Love.fromFireStore(Map<dynamic, dynamic> map) {
    return Love(state: map['state']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['state'] = this.state;
    map['userId'] = this.userId;
    map['guessId'] = this.guessId;
    map['updateDate'] = this.updateDate;
    return map;
  }
}

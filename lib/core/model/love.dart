import 'package:cloud_firestore/cloud_firestore.dart';

class Love {
  final bool state;
  final Timestamp updateDate = Timestamp.now();

  Love({this.state});

  factory Love.fromFireStore(Map<dynamic, dynamic> map) {
    return Love(state: map['state']);
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> map = Map<dynamic, dynamic>();
    map['state'] = this.state;
    map['updateDate'] = this.updateDate;
    return map;
  }
}

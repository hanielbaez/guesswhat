import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard {
  final String displayName;
  final Timestamp createdAt;

  LeaderBoard({this.displayName, this.createdAt});

  factory LeaderBoard.fromFirestore(document) {
    var data = document.data;
    return LeaderBoard(
      displayName: data['displayName'],
      createdAt: data['createdAt'],
    );
  }
}

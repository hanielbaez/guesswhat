import 'package:Tekel/core/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard {
  final User user;
  final Timestamp createdAt;

  LeaderBoard({this.user, this.createdAt});

  factory LeaderBoard.fromFirestore(document) {
    var data = document.data;
    var _user = User(
      uid: data['userId'],
      displayName: data['displayName'],
    );

    return LeaderBoard(
      user: _user,
      createdAt: data['createdAt'],
    );
  }
}

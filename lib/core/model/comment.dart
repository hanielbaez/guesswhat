import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  String id;
  String text;
  Map<dynamic, dynamic> user;
  Timestamp creationDate;
  Comment({this.id, @required this.text, @required this.user, @required this.creationDate});

  factory Comment.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Comment(
        id: doc.documentID,
        text: data['text'],
        user: data['user'],
        creationDate: data['creationDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['user'] = this.user;
    data['creationDate'] = this.creationDate;
    return data;
  }
}

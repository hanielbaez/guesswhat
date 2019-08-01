import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  String id;
  String text;
  Timestamp creationDate;
  Comment(
      {@required this.id, @required this.text, @required this.creationDate});

  factory Comment.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Comment(
        id: doc.documentID,
        text: data['text'],
        creationDate: data['creationDate']);
  }
}
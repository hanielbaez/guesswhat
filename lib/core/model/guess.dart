import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guess {
  String id;
  String userId;
  String secretText;
  String description;
  String videoURL;

  Guess(
      {@required this.id,
      @required this.userId,
      @required this.secretText,
      @required this.description,
      @required this.videoURL});

  factory Guess.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Guess(
        id: doc.documentID,
        userId: data['userId'],
        secretText: data['secretText'] ?? '',
        description: data['description'] ?? '',
        videoURL: data['video']);
  }
}

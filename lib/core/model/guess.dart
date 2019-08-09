import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guess {
  String id;
  String word;
  String description;
  String videoURL;
  String imageURL;
  Map<dynamic, dynamic> user;
  
  Timestamp creationDate;

  Guess(
      {@required this.id,
      @required this.word,
      @required this.description,
      this.videoURL,
      this.imageURL,
      @required this.user,
      @required this.creationDate});

  factory Guess.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Guess(
        id: doc.documentID,
        word: data['word'] ?? 'NOTWORDS',
        description: data['description'] ?? 'NOTDESCRIPTION',
        videoURL: data['videoURL'],
        imageURL: data['imageURL'],
        user: data['user'],
        creationDate: data['creationDate']);
  }
}

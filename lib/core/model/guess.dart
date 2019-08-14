import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guess {
  String id;
  String word;
  String description;
  String videoURL;
  String imageURL;
  Map<dynamic, dynamic> user;
  String address;
  Timestamp creationDate;

  Guess({
    @required this.id,
    @required this.word,
    @required this.description,
    @required this.user,
    @required this.creationDate,
    this.address,
    this.videoURL,
    this.imageURL,
  });

  ///Return a Guess Object
  factory Guess.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Guess(
        id: doc.documentID,
        word: data['word'] ?? '',
        description: data['description'] ?? '',
        videoURL: data['videoURL'],
        imageURL: data['imageURL'],
        address: data.containsKey('location')
            ? (data['location']['address']) ?? ''
            : '',
        user: data['user'],
        creationDate: data['creationDate']);
  }
}

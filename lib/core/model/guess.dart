import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guess {
  String id;
  String word;
  String description;
  String videoURL;
  String imageURL;
  String thumbnailURL;
  String address;
  Map<dynamic, dynamic> user;
  String loveCounter;
  String commentCounter;
  Timestamp creationDate;

  Guess({
    @required this.id,
    @required this.word,
    @required this.description,
    this.videoURL,
    this.imageURL,
    this.thumbnailURL,
    this.address,
    @required this.user,
    this.loveCounter,
    this.commentCounter,
    @required this.creationDate,
  });

  ///Return a Guess Object
  factory Guess.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    String _loveCounter = '';
    String _commentCounter = '';

    // The values of the counters can not be null o equal to 0
    if (data.containsKey('counter')) {
      if ((data['counter']['loveCounter'].toString() != 'null') &&
          (data['counter']['loveCounter'].toString() != '0')) {
        _loveCounter = data['counter']['loveCounter'].toString();
      }
      if ((data['counter']['commentCounter'].toString() != 'null') &&
          (data['counter']['commentCounter'].toString() != '0')) {
        _commentCounter = data['counter']['commentCounter'].toString();
      }
    }
    //TODO: Add a thumbnail
    return Guess(
        id: doc.documentID,
        word: data['word'] ?? '',
        description: data['description'] ?? '',
        videoURL: data['videoURL'],
        imageURL: data['imageURL'],
        thumbnailURL: data['thumbnailURL'] ?? null,
        address: data.containsKey('location')
            ? (data['location']['address']) ?? ''
            : '',
        user: data['user'],
        loveCounter: _loveCounter,
        commentCounter: _commentCounter,
        creationDate: data['creationDate']);
  }
}

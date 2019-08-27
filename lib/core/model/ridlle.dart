import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ridlle {
  String id;
  String answer;
  String description;
  String videoURL;
  String imageURL;
  String thumbnailURL;
  String address;
  Map<dynamic, dynamic> user;
  String loveCounter;
  String commentCounter;
  Timestamp creationDate;

  Ridlle({
    @required this.id,
    @required this.answer,
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

  ///Return a Ridlle Object
  factory Ridlle.fromFireStore(DocumentSnapshot doc) {
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

    return Ridlle(
        id: doc.documentID,
        answer: data['answer'] ?? '',
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

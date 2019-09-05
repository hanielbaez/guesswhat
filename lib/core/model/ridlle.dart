import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ridlle {
  String id;
  String ownerId;
  String answer;
  String description;
  String videoUrl;
  String imageUrl;
  String thumbnailUrl;
  String address;
  Map<dynamic, dynamic> user;
  String loves;
  String comments;
  Timestamp creationDate;

  Ridlle({
    @required this.id,
    @required this.ownerId,
    @required this.answer,
    @required this.description,
    this.videoUrl,
    this.imageUrl,
    this.thumbnailUrl,
    this.address,
    @required this.user,
    this.loves,
    this.comments,
    @required this.creationDate,
  });

  ///Return a Ridlle Object
  factory Ridlle.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    String _loves = '';
    String _comments = '';

    // The values of the counters can not be null o equal to 0
    if (data.containsKey('counter')) {
      if ((data['counter']['loves'].toString() != 'null') &&
          (data['counter']['loves'].toString() != '0')) {
        _loves = data['counter']['loves'].toString();
      }
      if ((data['counter']['comments'].toString() != 'null') &&
          (data['counter']['comments'].toString() != '0')) {
        _comments = data['counter']['comments'].toString();
      }
    }

    return Ridlle(
        id: doc.documentID,
        ownerId: data['user']['uid'],
        answer: data['answer'] ?? '',
        description: data['description'] ?? '',
        videoUrl: data['videoUrl'],
        imageUrl: data['imageUrl'],
        thumbnailUrl: data['thumbnailUrl'] ?? null,
        address: data.containsKey('location')
            ? (data['location']['address']) ?? ''
            : '',
        user: data['user'],
        loves: _loves,
        comments: _comments,
        creationDate: data['creationDate']);
  }
}

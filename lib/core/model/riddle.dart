import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Riddle {
  String id;
  String ownerId;
  String answer;
  String description;
  String videoUrl;
  String imageUrl;
  String thumbnailUrl;
  String text;
  String address;
  Map<dynamic, dynamic> user;
  String loves;
  String comments;
  Timestamp createdAt = Timestamp.now();

  Riddle({
    @required this.id,
    @required this.ownerId,
    @required this.answer,
    @required this.description,
    this.videoUrl,
    this.imageUrl,
    this.thumbnailUrl,
    this.text,
    this.address,
    @required this.user,
    this.loves,
    this.comments,
    @required this.createdAt,
  });

  ///Return a Riddle Object
  factory Riddle.fromFireStore(DocumentSnapshot doc) {
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

    return Riddle(
        id: doc.documentID,
        ownerId: data['user']['uid'],
        answer: data['answer'] ?? '',
        description: data['description'] ?? '',
        videoUrl: data['videoUrl'],
        imageUrl: data['imageUrl'],
        text: data['text'],
        thumbnailUrl: data['thumbnailUrl'] ?? null,
        address: data.containsKey('location')
            ? (data['location']['address']) ?? ''
            : '',
        user: data['user'],
        loves: _loves,
        comments: _comments,
        createdAt: data['createdAt']);
  }
}

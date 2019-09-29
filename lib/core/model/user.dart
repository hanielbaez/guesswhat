import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  String uid;
  String photoUrl;
  String displayName;
  String webSite;
  String biography;
  Map<dynamic, dynamic> counter;

  User(
      {@required this.uid,
      this.photoUrl,
      @required this.displayName,
      this.webSite = '',
      this.biography = '',
      this.counter});

  factory User.fromFirebaseUser({FirebaseUser user}) {
    return User(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl);
  }

  ///Retur a User object, if the DocumentSnapshot equal to null, return  null
  factory User.fromFireStore(DocumentSnapshot snap) {
    if (snap == null) return null;
    Map<String, dynamic> map = snap.data;
    return User(
        uid: snap.documentID,
        photoUrl: map['photoUrl'],
        displayName: map['displayName'],
        webSite: map['webSite'] ?? '',
        biography: map['biography'] ?? '',
        counter: map['counter'] ?? {'solved': 0});
  }

  factory User.fromMap(Map map) {
    return User(
      uid: map['uid'],
      photoUrl: map['photoUrl'],
      displayName: map['displayName'],
      webSite: map['webSite'] ?? '',
      biography: map['biography'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['uid'] = this.uid;
    map['photoUrl'] = this.photoUrl;
    map['displayName'] = this.displayName;
    map['webSite'] = this.webSite;
    map['biography'] = this.biography;

    return map;
  }
}

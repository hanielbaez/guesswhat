import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  String uid;
  String email;
  String photoURL;
  String displayName;
  String webSite;
  String biography;
  Timestamp lastSeen;

  User(
      {@required this.uid,
      this.email,
      this.photoURL,
      @required this.displayName,
      this.webSite = '',
      this.biography = '',
      this.lastSeen});

  factory User.fromFirebaseUser({FirebaseUser user}) {
    return User(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoUrl);
  }

  ///Retur a User object, if the DocumentSnapshot equal to null, return  null
  factory User.fromFireStore(DocumentSnapshot snap) {
    if (snap == null) return null;
    Map<String, dynamic> map = snap.data;
    return User(
      uid: snap.documentID,
      email: map['email'],
      photoURL: map['photoURL'],
      displayName: map['displayName'],
      webSite: map['webSite'] ?? '',
      biography: map['biography'] ?? '',
      lastSeen: map['lastSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['uid'] = this.uid;
    if (this.email != null) map['email'] = this.email;
    map['photoURL'] = this.photoURL;
    map['displayName'] = this.displayName;
    map['webSite'] = this.webSite;
    map['biography'] = this.biography;
    map['lastSeen'] = lastSeen;

    return map;
  }
}

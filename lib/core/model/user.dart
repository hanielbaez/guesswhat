import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  String uid;
  String email;
  String photoURL;
  String displayName;
  Timestamp lastSeen;

  User(
      {@required this.uid,
      this.email,
      @required this.photoURL,
      @required this.displayName,
      this.lastSeen});

  factory User.fromFirebaseUser({FirebaseUser user}) {
    return User(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoUrl);
  }

  factory User.fromFireStore(DocumentSnapshot snap) {
    Map<String, dynamic> map = snap.data;
    return User(
      uid: map['uid'],
      email: map['email'],
      photoURL: map['photoURL'],
      displayName: map['displayName'],
      lastSeen: map['lastSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['uid'] = this.uid;
    map['email'] = this.email;
    map['photoURL'] = this.photoURL;
    map['displayName'] = this.displayName;
    map['lastSeen'] = lastSeen;

    return map;
  }
}

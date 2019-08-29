import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Firestore _db = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();
final Future<FirebaseUser> _user = FirebaseAuth.instance.currentUser();

/// void function that get and store the device Token for futures FCM operations
saveDeviceToken() async {
  // Get the current user
  String uid = await _user.then(
    (value) {
      return value.uid;
    },
  );

  // Get the token for this device
  String fcmToken = await _fcm.getToken();

  // Save it to Firestore
  if (fcmToken != null) {
    var tokens = _db
        .collection('users')
        .document(uid)
        .collection('tokens')
        .document(fcmToken);

    await tokens.setData({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }
}

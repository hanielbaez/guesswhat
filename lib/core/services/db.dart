import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/love.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:guess_what/core/model/guess.dart';

//Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

//*USER*//

  //User profile data
  Future<User> getUser(FirebaseUser user) async {
    print(user.displayName);
    print(user.email);
    var snap = await _db.collection('users').document(user.uid).get();
    return User.fromFireStore(snap);
  }

  void updateUserData(User userData) {
    var user = User(
        uid: userData.uid,
        email: userData.email,
        displayName: userData.displayName,
        photoURL: userData.photoURL,
        lastSeen: Timestamp.now());
    _db
        .collection('users')
        .document(user.uid)
        .setData(user.toJson(), merge: true);
  }

  //* GUESS *//

  //Dowload guesses
  Future<List<Guess>> fectchGuesses() async {
    //Use to fech all Guesses
    final List<Guess> allGuesses = [];
    var snap = await _db
        .collection('guesses')
        .orderBy('creationDate', descending: true)
        .getDocuments();
    snap.documents.forEach(
      (document) {
        allGuesses.add(
          Guess.fromFireStore(document),
        );
      },
    );
    return allGuesses;
  }

  Future<Guess> getGuess() async {
    //Use to fech one Guess by it's ID
    var snap =
        await _db.collection('guesses').document('MFEYSUv3UTBbDZT0Gkkz').get();
    return Guess.fromFireStore(snap);
  }

  //Uploade
  Future<String> uploadToFireStore(File file) async {
    //Use to upload Image or Video to FireStore adn get the DownloadURL
    String baseName = basename(file.path);
    final String fileName = lookupMimeType(baseName) +
        '/' +
        Random().nextInt(10000).toString() +
        '$baseName';

    final StorageReference storageRef = _storage.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  void uploadGuess({Map<String, dynamic> guess}) {
    DocumentReference _ref = _db.collection('guesses').document();
    _ref
        .setData(guess)
        .catchError((error) => print('FireBase ERROR: $error'))
        .whenComplete(() => print('FireBase Complete'));
  }

  //* LOVE(Favorite) *//

  void updateLoveState({String customID, Love love}) {
    _db.collection('loveGuesses').document(customID).setData(love.toJson());
  }

  //* COMMENT *//

  //Fech all Commenst availables
  Stream<QuerySnapshot> getAllComments(String guessID) {
    //Use to fech all Comments
    return _db
        .collection('guesses')
        .document(guessID)
        .collection('comments')
        .snapshots();
  }

  Future<bool> uploadComment({Comment comment, String guessID}) {
    var _result;
    DocumentReference _ref = _db
        .collection('guesses')
        .document(guessID)
        .collection('comments')
        .document();
    _ref.setData(comment.toJson()).whenComplete(() {
      _result = valueHandle();
    }).catchError((onError) {
      _result = errorHandle(onError);
    });
    return _result;
  }

  //* HANDLE *//

  //Data error handle
  String errorHandle(error) {
    print('ERROR: ' + error?.toString());
    return error?.toString();
  }

  String valueHandle() {
    return 'success';
  }
}

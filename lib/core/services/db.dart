//Flutter and Dart import
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Self import
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/love.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/model/guess.dart';

///Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

//*USER*//

  ///Return a User object
  Future<User> getUser(FirebaseUser user) async {
    print(user.displayName);
    print(user.email);
    var snap = await _db.collection('users').document(user.uid).get();
    return User.fromFireStore(snap);
  }

  ///Update the user data at firestore
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

  //Fectch all gussess and order it by date
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

  ///Use to fech one Guess by it's ID
  Future<Guess> getGuess() async {
    var snap =
        await _db.collection('guesses').document('MFEYSUv3UTBbDZT0Gkkz').get();
    return Guess.fromFireStore(snap);
  }

  ///Upload media to FireStorage and return a Dowload URL
  Future<String> uploadToFireStore(File file) async {
    //Use to upload Image or Video to FireStore and get the DownloadURL
    String baseName = basename(file.path);
    String fileType = lookupMimeType(baseName) + '/';
    final String fileName =
        fileType + Random().nextInt(10000).toString() + '$baseName';

    final StorageReference storageRef = _storage.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  ///Return TRUE if upload new guess to FireStore success
  Future<void> uploadGuess(Map<String, dynamic> guess) async {
    DocumentReference _ref = _db.collection('guesses').document();
    _ref
        .setData(guess)
        .catchError(
          (error) => print('FireBase ERROR: $error'),
        )
        .whenComplete(() => print('FireBase Complete'));
  }

  //* GUESS DONE*//
  ///Set the data at Firebase
  void setGuessesDone({String customID}) {
    _db
        .collection('guessesDone')
        .document(customID)
        .setData({'creationDate': Timestamp.now()});
  }

  ///Return NULL is the user have not completed the Guess yet
  Future<DocumentSnapshot> getGuessesDone({String customID}) async {
    return await _db
        .collection('guessesDone')
        .document(customID)
        .get()
        .catchError((error) {
      print(error.toString());
    });
  }

  //* LOVE(Favorite) *//
  /* The customID is make out of the GuessId and the Authenticated UserId */

  void updateLoveState({String customID, Love love}) {
    _db.collection('loveGuesses').document(customID).setData(love.toJson());
  }

  Stream<Love> loveStream({String customID}) {
    return _db.collection('loveGuesses').document(customID).snapshots().map(
      (doc) {
        return Love.fromFireStore(doc.data);
      },
    );
  }

  //* COMMENT *//

  ///Fech all Comments availables by specifict guess
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

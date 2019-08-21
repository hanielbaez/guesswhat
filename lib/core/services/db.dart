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
import 'package:uuid/uuid.dart';

///Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

//*USER*//

  ///Return a User object
  Future<User> getUser(FirebaseUser user) async {
    try {
      var snap = await _db.collection('users').document(user.uid).get();
      return User.fromFireStore(snap);
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Update the user data at firestore
  void updateUserData(User userData) {
    try {
      var user = User(
        uid: userData.uid,
        email: userData.email,
        displayName: userData.displayName,
        photoURL: userData.photoURL,
        lastSeen: Timestamp.now(),
      );
      _db
          .collection('users')
          .document(user.uid)
          .setData(user.toJson(), merge: true);
    } catch (e) {
      print('$e');
      return null;
    }
  }

  //* GUESS *//

  //Fectch all gussess and order it by date
  Future<List<Guess>> fectchGuesses() async {
    try {
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
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Use to fech one Guess by it's ID
  /* Future<Guess> getGuess() async {
    var snap =
        await _db.collection('guesses').w;
    return Guess.fromFireStore(snap);
  } */

  ///Upload media to Firebase Storage and return a Dowload URL
  Future<String> uploadToFireStore(File file) async {
    try {
      // Generate a v4 (random) id
      var uuid = new Uuid();

      String baseName = basename(file.path);
      String fileType = lookupMimeType(baseName) + '/';
      final String fileName = fileType + uuid.v4() + '$baseName';

      final StorageReference storageRef = _storage.ref().child(fileName);
      final StorageUploadTask uploadTask = storageRef.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      return url;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return TRUE if upload new guess to FireStore success
  Future<void> uploadGuess(Map<String, dynamic> guess) async {
    DocumentReference _ref = _db.collection('guesses').document();
    _ref
        .setData(guess)
        .catchError(
          (error) => print('FireBase ERROR: $error'),
        )
        .whenComplete(
          () => print('FireBase Complete'),
        );
  }

  //* GUESS DONE*//
  ///Set the data at Firebase
  void setGuessesDone({String customID}) {
    try {
      _db.collection('guessesDone').document(customID).setData(
        {
          'creationDate': Timestamp.now(),
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return NULL is the user have not completed the Guess yet
  Future<DocumentSnapshot> getGuessesDone({String customID}) async {
    try {
      return await _db
          .collection('guessesDone')
          .document(customID)
          .get()
          .catchError(
        (error) {
          print(error.toString());
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  //* LOVE(Favorite) *//
  /* The customID is make out of the GuessId and the Authenticated UserId */

  ///Update the love data to FireStore
  void updateLoveState({String customID, Love love}) {
    try {
      _db.collection('loveGuesses').document(customID).setData(love.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a List of theloveGuesses by user
  Future<List> loveGuesses(String userId) async {
    try {
      final List loveList = [];

      var snap = await _db
          .collection('loveGuesses')
          .where('userId', isEqualTo: userId)
          .where('state', isEqualTo: true)
          .getDocuments();

      snap.documents.forEach(
        (document) {
          loveList.add(document.data);
        },
      );

      return loveList.isNotEmpty ? loveList : null;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a Love obj
  Stream<Love> loveStream({String customID}) {
    try {
      return _db.collection('loveGuesses').document(customID).snapshots().map(
        (doc) {
          return Love.fromFireStore(doc.data);
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  //* COMMENT *//

  ///Fech all Comments availables by specifict guess
  Stream<QuerySnapshot> getAllComments(String guessID) {
    try {
      //Use to fech all Comments
      return _db
          .collection('guesses')
          .document(guessID)
          .collection('comments')
          .snapshots();
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<bool> uploadComment({Comment comment, String guessID}) {
    try {
      var _result;
      DocumentReference _ref = _db
          .collection('guesses')
          .document(guessID)
          .collection('comments')
          .document();
      _ref.setData(comment.toJson());
      return _result;
    } catch (e) {
      print('$e');
      return null;
    }
  }
}

//Flutter and Dart import
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Self import
import 'package:Tekel/core/model/comment.dart';
import 'package:Tekel/core/model/love.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/model/supportContact.dart';
import 'package:uuid/uuid.dart';

///Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static Future<String> _uid() async =>
      await FirebaseAuth.instance.currentUser().then((user) {
        return user.uid;
      });

//*USER*//

  ///Return a User object
  Future<User> getUser({FirebaseUser user}) async {
    try {
      var snap = await _db.collection('users').document(await _uid()).get();
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
        webSite: userData.webSite,
        biography: userData.biography,
        lastSeen: Timestamp.now(),
      );
      _db.collection('users').document(user.uid).updateData(user.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  void supportContact({SupportContact support}) async {
    var ref = _db
        .collection('users')
        .document(await _uid())
        .collection('supportContacts')
        .document();
    ref.setData(await support.toJson());
  }

  //* RIDLDLE *//

  //Return a list of user Riddles
  Future<List> fectchUserRiddle({String userId}) async {
    try {
      final List riddleList = [];
      var snap = await _db
          .collection('riddles')
          .where('user.uid', isEqualTo: userId)
          .orderBy('creationDate', descending: true)
          .getDocuments();
      snap.documents.forEach(
        (document) {
          riddleList.add({
            'riddleId': document.documentID,
            'thumbnailUrl': document.data['thumbnailUrl'],
          });
        },
      );
      return riddleList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///Retur a riddle by the given ID
  Future<Riddle> getRiddle({String riddleId}) async {
    var snap = await _db.collection('riddles').document(riddleId).get();
    return Riddle.fromFireStore(snap);
  }

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
      print('Error uploadToFireStore. Error: $e');
      return null;
    }
  }

  ///Return TRUE if upload new riddle to FireStore success
  Future<void> uploadRiddle(Map<String, dynamic> riddle) async {
    DocumentReference _ref = _db.collection('riddles').document();
    _ref
        .setData(riddle)
        .catchError(
          (error) => print('FireBase ERROR: $error'),
        )
        .whenComplete(
          () => print('FireBase Complete'),
        );
  }

  ///* RIDDLE SOLVED BY*//
  ///Set the data at Firebase
  void setSolvedBy({String riddleId, String ownerId}) async {
    try {
      _db
          .collection('riddles')
          .document(riddleId)
          .collection('solvedBy')
          .document(await _uid())
          .setData(
        {
          'riddleId': riddleId,
          'userId': await _uid(),
          'ownerId': ownerId,
          'creationDate': Timestamp.now(),
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return NULL is the user have not completed the Riddle yet
  Future<DocumentSnapshot> getSolvedBy({String riddleId}) async {
    try {
      return await _db
          .collection('riddles')
          .document(riddleId)
          .collection('solvedBy')
          .document(await _uid())
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
  /* The customID is make out of the RidleId and the Authenticated UserId */

  ///Update the love data to FireStore
  void updateLoveState({String customID, Love love}) {
    try {
      _db.collection('loveRiddles').document(customID).setData(love.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a List of theloveRiddle by user
  Future<List> loveRiddle() async {
    try {
      final List loveList = [];

      var snap = await _db
          .collection('loveRiddles')
          .where('userId', isEqualTo: await _uid())
          .where('state', isEqualTo: true)
          .orderBy('updateDate', descending: true)
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
      return _db.collection('loveRiddles').document(customID).snapshots().map(
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

  ///Fech all Comments availables by specifict riddle
  Stream<QuerySnapshot> getAllComments(String riddleId) {
    try {
      //Use to fech all Comments
      return _db
          .collection('riddles')
          .document(riddleId)
          .collection('comments')
          .snapshots();
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<bool> uploadComment({Comment comment, String riddleId}) {
    try {
      var _result;
      DocumentReference _ref = _db
          .collection('riddles')
          .document(riddleId)
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

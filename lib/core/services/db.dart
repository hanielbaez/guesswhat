//Flutter and Dart import
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

//Self import
import 'package:Tekel/core/model/comment.dart';
import 'package:Tekel/core/model/love.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/model/supportContact.dart';

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
  Future<User> getUser({String uid}) async {
    try {
      var snap =
          await _db.collection('users').document(uid ?? await _uid()).get();
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
        photoUrl: userData.photoUrl,
        webSite: userData.webSite,
        biography: userData.biography,
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

  ///Upload media to Firebase Storage and return a Dowload Url
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
  void setSolvedBy(
      {String riddleId, String ownerId, String thumbnailUrl}) async {
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
          'thumbnailUrl': thumbnailUrl,
          'creationDate': Timestamp.now(),
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return NULL is the user have not completed the Riddle yet
  Future<DocumentSnapshot> isSolvedBy({String riddleId}) async {
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

  ///Return a list of all Riddles solve by user
  Future<List> getAllSolvedBy({String userId}) async {
    var documents = await _db
        .collectionGroup('solvedBy')
        .where('userId', isEqualTo: userId)
        .getDocuments();
    return documents.documents.toList();
  }

  //* LOVE(Favorite) *//
  /* The customID is make out of the RidleId and the Authenticated UserId */

  ///Update the love data to FireStore
  void updateLoveState({String riddleId, Love love}) async {
    try {
      _db
          .collection('riddles')
          .document(riddleId)
          .collection('lovedBy')
          .document(await _uid())
          .setData(love.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a List of theloveRiddle by user
  Future<List> loveRiddle() async {
    try {
      var documents = await _db
          .collectionGroup('lovedBy')
          .where('userId', isEqualTo: await _uid())
          .where('state', isEqualTo: true)
          .orderBy('updateDate', descending: true)
          .getDocuments();

      return documents.documents.toList();
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a Love obj
  Stream<Love> loveStream({String riddleId, String userId}) {
    try {
      return _db
          .collection('riddles')
          .document(riddleId)
          .collection('lovedBy')
          .document(userId)
          .snapshots()
          .map(
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

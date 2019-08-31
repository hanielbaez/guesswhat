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
import 'package:Tekel/core/model/ridlle.dart';
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
      _db
          .collection('users')
          .document(user.uid)
          .setData(user.toJson(), merge: true);
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

  //* RIDLLE *//

  //Fectch all ridlles and order it by date
  Future<List<Ridlle>> fectchRidlle() async {
    try {
      //Use to fech all Ridlles
      final List<Ridlle> allRidlle = [];
      var snap = await _db
          .collection('ridlles')
          .orderBy('creationDate', descending: true)
          .getDocuments();
      snap.documents.forEach(
        (document) {
          allRidlle.add(
            Ridlle.fromFireStore(document),
          );
        },
      );
      return allRidlle;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  //Return a list of user Ridlles
  Future<List> fectchUserRidlle({String userId}) async {
    try {
      final List ridlleList = [];
      var snap = await _db
          .collection('ridlles')
          .where('user.uid', isEqualTo: userId)
          .orderBy('creationDate', descending: true)
          .getDocuments();
      snap.documents.forEach(
        (document) {
          ridlleList.add({
            'ridlleId': document.documentID,
            'thumbnailUrl': document.data['thumbnailUrl'],
          });
        },
      );
      return ridlleList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///Retur a ridlle by the given ID
  Future<Ridlle> getRidlle({String ridlleId}) async {
    var snap = await _db.collection('ridlles').document(ridlleId).get();
    return Ridlle.fromFireStore(snap);
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

  ///Return TRUE if upload new ridlle to FireStore success
  Future<void> uploadRidlle(Map<String, dynamic> ridlle) async {
    DocumentReference _ref = _db.collection('ridlles').document();
    _ref
        .setData(ridlle)
        .catchError(
          (error) => print('FireBase ERROR: $error'),
        )
        .whenComplete(
          () => print('FireBase Complete'),
        );
  }

  ///* RIDLLE DONE*//
  ///Set the data at Firebase
  void setRidlleDone({String customID, String ridlleId}) async {
    try {
      _db.collection('ridllesDone').document(customID).setData(
        {
          'ridlleId': ridlleId,
          'userId': await _uid(),
          'creationDate': Timestamp.now(),
        },
      );
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return NULL is the user have not completed the Ridlle yet
  Future<DocumentSnapshot> getRidlleDone({String customID}) async {
    try {
      return await _db
          .collection('ridllesDone')
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
  /* The customID is make out of the RidleId and the Authenticated UserId */

  ///Update the love data to FireStore
  void updateLoveState({String customID, Love love}) {
    try {
      _db.collection('loveRidlles').document(customID).setData(love.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  ///Return a List of theloveRidlle by user
  Future<List> loveRidlle() async {
    try {
      final List loveList = [];

      var snap = await _db
          .collection('loveRidlles')
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
      return _db.collection('loveRidlles').document(customID).snapshots().map(
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

  ///Fech all Comments availables by specifict ridlle
  Stream<QuerySnapshot> getAllComments(String ridlleId) {
    try {
      //Use to fech all Comments
      return _db
          .collection('ridlles')
          .document(ridlleId)
          .collection('comments')
          .snapshots();
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<bool> uploadComment({Comment comment, String ridlleId}) {
    try {
      var _result;
      DocumentReference _ref = _db
          .collection('ridlles')
          .document(ridlleId)
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

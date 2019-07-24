import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:guess_what/core/model/guess.dart';

//Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Dowload
  Future<List<Guess>> fectchGuesses() async {
    //Use to fech all Guesses
    final List<Guess> allGuesses = [];
    var snap = await _db.collection('guess').getDocuments();
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
        await _db.collection('guess').document('MFEYSUv3UTBbDZT0Gkkz').get();
    return Guess.fromFireStore(snap);
  }

  //Uploade
  Future<String> uploadToFireStore(File file) async {
    //Use to upload Image or Video to FireStore adn get the DownloadURL
    String baseName = basename(file.path);
    final String fileName = '$baseName' + Random().nextInt(10000).toString();

    final StorageReference storageRef = _storage.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  void uploadGuess({Map<String, dynamic> guess}) {
    DocumentReference _ref = _db.collection('guess').document();
    _ref.setData(guess).catchError((error) => print('FireBase ERROR: $error')
    ).whenComplete(() => print('FireBase Complete')
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:guess_what/core/model/guess.dart';
import 'dart:async';

//Networks request
class DatabaseServices {
  final Firestore _db = Firestore.instance;

  Future<List<Guess>> fectchGuesses() async {
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
    var snap =
        await _db.collection('guess').document('MFEYSUv3UTBbDZT0Gkkz').get();
    return Guess.fromFireStore(snap);
  }
}

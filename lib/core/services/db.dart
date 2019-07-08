import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_what/core/model/guess.dart';
import 'dart:async';

class DatabaseServices{
  final Firestore _db = Firestore.instance;

  Future<Guess> getGuess() async {
    var snap = await _db.collection('guess').document('MFEYSUv3UTBbDZT0Gkkz').get();
    return Guess.fromFireStore(snap);
  }
}
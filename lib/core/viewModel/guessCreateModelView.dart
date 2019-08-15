import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';

class GuessCreateViewModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  bool loading = false;
  GuessCreateViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;
/* 
  Future<String> uploadFireStore({File file}) async {
    loading = true;
    //Upload Image/video
    return await _databaseServices.uploadToFireStore(file);
  } */

  /* Future<void> uploadFireBase({Map<String, dynamic> guess}) async {
    _databaseServices.uploadGuess(guess: guess);
  } */
}

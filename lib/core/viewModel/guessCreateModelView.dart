import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';

class GuessCreateViewModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  GuessCreateViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  Future<String> uploadFireStore({File file}) async { //Upload Image/video
    return await _databaseServices.uploadToFireStore(file); 
    //Scaffold.of(context).showSnackBar(SnackBar(context: Text('Uploaded Successfully')));
  }

  Future uploadFireBase({Map<String, dynamic> guess}) async {
    return await  _databaseServices.uploadGuess(guess: guess);
  }

}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';

class GuessCreateViewModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  bool loading = false;
  GuessCreateViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  Future<String> uploadFireStore({File file, BuildContext context}) async {
    loading = true;

    //Upload Image/video
    var url = await _databaseServices.uploadToFireStore(file);

    /* Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploaded Successfully'),
        ),
      ); */

    return url;
    //TODO: Show snackBar when upload is complete
  }

  void uploadFireBase({Map<String, dynamic> guess}) {
    return _databaseServices.uploadGuess(guess: guess);
  }
}

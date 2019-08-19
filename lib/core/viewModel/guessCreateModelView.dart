//Flutter and Dart import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class GuessCreateViewModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  Map<String, dynamic> guess = {
    'word': '',
    'description': '',
    'user': '',
    'location': '',
    'creationDate': ''
  };
  File file;
  bool loading = false;

  GuessCreateViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  getFile(File fileImage, File fileVideo) {
    file = fileImage ?? fileVideo;
  }

  void upload(BuildContext context) async {
    loading = true;
    notifyListeners();
    //Upload media to FireStore
    var _url =
        await Provider.of<DatabaseServices>(context).uploadToFireStore(file);

    //Get the media Type video/image
    var listSplit = lookupMimeType(file.path).split('/');
    listSplit[0] == 'image'
        ? guess['imageURL'] = _url
        : guess['videoURL'] = _url;

    await Provider.of<DatabaseServices>(context).uploadGuess(guess);

    Navigator.pop(context);
  }
}

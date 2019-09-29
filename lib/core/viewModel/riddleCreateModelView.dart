//Flutter and Dart import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/services/location.dart';

class RiddleCreateViewModel extends ChangeNotifier {
  Map<String, dynamic> riddle = {
    'answer': '',
    'description': '',
    'user': '',
    'location': '',
    'createdAt': ''
  };
  File file;
  bool loading = false;

  getFile(File fileImage, File fileVideo) {
    file = fileImage ?? fileVideo;
  }

  void upload(BuildContext context) async {
    loading = true;
    notifyListeners();

    //Upload media to FireStore and return a Dowload Url
    var _imageUrl =
        await Provider.of<DatabaseServices>(context).uploadToFireStore(file);

    //Get the media Type video/image
    var listSplit = lookupMimeType(file.path).split('/');
    listSplit[0] == 'image'
        ? riddle['imageUrl'] = _imageUrl
        : riddle['videoUrl'] = _imageUrl;

    //Upload a new Riddle to DataBase
    var location = await Provider.of<LocationServices>(context).getGeoPoint();
    await Provider.of<DatabaseServices>(context)
        .uploadRiddle(riddle: riddle, location: location);

    Navigator.pushReplacementNamed(context, '/');
  }
}

//Flutter and Dart import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';

class RidlleCreateViewModel extends ChangeNotifier {
  Map<String, dynamic> ridlle = {
    'answer': '',
    'description': '',
    'user': '',
    'location': '',
    'creationDate': ''
  };
  File file;
  bool loading = false;

  getFile(File fileImage, File fileVideo) {
    file = fileImage ?? fileVideo;
  }

  void upload(BuildContext context) async {
    loading = true;
    notifyListeners();

    img.Image image = img.decodeImage(File('${file.path}').readAsBytesSync());
    // Resize the image to a 200x? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(image, width: 200);

    //Get a temporary path
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/_thumbnail.png';

    // Save the thumbnail as a PNG
    var thumbnailFaile = File(tempPath)
      ..writeAsBytesSync(img.encodePng(thumbnail));

    //Upload media to FireStore and return a Dowload URL
    var _url =
        await Provider.of<DatabaseServices>(context).uploadToFireStore(file);

    var _thumbnailUrl = await Provider.of<DatabaseServices>(context)
        .uploadToFireStore(thumbnailFaile);

    ridlle['thumbnailUrl'] = _thumbnailUrl;

    //Get the media Type video/image
    var listSplit = lookupMimeType(file.path).split('/');
    listSplit[0] == 'image'
        ? ridlle['imageUrl'] = _url
        : ridlle['videoUrl'] = _url;

    //Upload a new Ridlle to DataBase
    await Provider.of<DatabaseServices>(context).uploadRidlle(ridlle);

    Navigator.pushNamed(context, '/');
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  Guess guess;
  bool isNotDone = true;
  File mediaFeche;
  VideoPlayerController videoController;
  File imageFile;

  VideoViewModel({this.guess});

  void getMedia() async {
    switch (await mediaType()) {
      case 'image':
        await getImage();
        print('$imageFile');
        break;
      case 'video':
        await getVideoController();
        print('$videoController');
        break;
      default:
        //TODO: Get a default image
        break;
    }
  }

  Future<String> mediaType() async {
    var mediaURL = this.guess.imageURL ?? this.guess.videoURL;
    mediaFeche = await CustomCacheManager()
        .getSingleFile('$mediaURL'); //Check cache for media
    var listSplit = lookupMimeType(mediaFeche.path).split('/');
    return listSplit[0];
  }

  //Sending null to the cache manager
  Future<void> getImage() async {
    if (isNotDone) {
      imageFile = mediaFeche;
      isNotDone = false;
      notifyListeners();
    }
  }

  Future<void> getVideoController() async {
    //Setup the videoController
    if (isNotDone) {
      videoController = VideoPlayerController.file(mediaFeche);
      await videoController.initialize();
      await videoController.setLooping(true);
      //await videoController.play();

      isNotDone = false;
      notifyListeners();
    }
  }
}

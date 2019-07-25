import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  final Guess guess;
  File mediaFeche;
  VideoPlayerController videoController;
  File imageFile;

  dynamic widget = buildNoiseTV();

  VideoViewModel({this.guess});

  void getMedia() async {
    if (mediaFeche == null) {
      widget = buildNoiseTV();
      switch (await mediaType()) {
        case 'image':
          await getImage();
          break;
        case 'video':
          await getVideoController();
          break;
        default:
          //TODO: Get a default image
          break;
      }
    }
  }

  //Return video or image
  Future<String> mediaType() async {
    var mediaURL = this.guess.imageURL ?? this.guess.videoURL;
    mediaFeche = await CustomCacheManager()
        .getSingleFile('$mediaURL'); //Check cache for media
    var listSplit = lookupMimeType(mediaFeche.path).split('/');
    return listSplit[0];
  }

  Future<void> getImage() async {
    imageFile = mediaFeche;
    print('notifyListeners');
    widget = buildImage();
    notifyListeners();
  }

//Setup the videoController
  Future<void> getVideoController() async {
    videoController = VideoPlayerController.file(mediaFeche);
    await videoController.initialize();
    await videoController.setLooping(true);
    //await videoController.play();
    widget = buildVideo();
    notifyListeners();
  }

//Costum widgets
  Image buildImage() {
    return Image.file(
      imageFile,
      fit: BoxFit.fitWidth,
      key: ValueKey('image'),
    );
  }

  VideoPlayer buildVideo() {
    return VideoPlayer(videoController);
  }

  static Image buildNoiseTV() {
    return Image.asset(
      'assets/images/noiseTv.gif',
      fit: BoxFit.cover,
      key: ValueKey('default'),
    );
  }
}

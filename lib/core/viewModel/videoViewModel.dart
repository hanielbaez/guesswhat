import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  final Guess guess;
  File mediaFeche;
  VideoPlayerController videoController;
  File imageFile;

  dynamic widget;

  VideoViewModel({this.guess});

  void getMedia() async {
    if (mediaFeche == null) {
      getThumbnail();
      switch (await mediaType()) {
        case 'image':
          await getImage();
          break;
        case 'video':
          await getVideoController();
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
    widget = buildImage();
    notifyListeners();
  }

//Setup the videoController
  Future<void> getVideoController() async {
    videoController = VideoPlayerController.file(mediaFeche);
    await videoController.initialize();
    await videoController.setLooping(true);
    await videoController.setVolume(0.0);
    await videoController.play();
    widget = buildVideo();
    notifyListeners();
  }

  Future<void> getThumbnail() async {
    imageFile = await CustomCacheManager().getSingleFile('${guess.thumbnail}');
    widget = buildThumbnail();
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

  AspectRatio buildVideo() {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
      key: ValueKey('video'),
    );
  }

  buildThumbnail() {
    return Stack(
      children: <Widget>[
        Center(
          child: Image.file(
            imageFile,
            fit: BoxFit.fitWidth,
            key: ValueKey('thumbnail'),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        )
      ],
    );
  }
}

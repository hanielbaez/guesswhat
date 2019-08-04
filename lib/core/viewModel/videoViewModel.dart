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
  File thumbnailFile;
  dynamic widget;

  Future<dynamic> future;

  VideoViewModel({this.guess});

  Future getMedia() async {
    if (mediaFeche == null) {
      switch (await mediaType()) {
        case 'image':
          return await getImage();
          break;
        case 'video':
          return await getVideoController();
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

  Future<File> getImage() async {
    imageFile = mediaFeche;
    widget = buildImage();
    return imageFile;
  }

//Setup the videoController
  Future<VideoPlayerController> getVideoController() async {
    videoController = VideoPlayerController.file(mediaFeche);
    await videoController.initialize();
    await videoController.setLooping(true);
    await videoController.setVolume(0.0);
    await videoController.play();
    widget = buildVideo();
    return videoController;
  }

//Costum image widgets
  Image buildImage() {
    return Image.file(
      imageFile,
      fit: BoxFit.fitWidth,
      key: ValueKey('image'),
    );
  }

  //Costum video widgets
  AspectRatio buildVideo() {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
      key: ValueKey('video'),
    );
  }

  //Costum thumbnail widgets
  Stack buildThumbnail() {
    return Stack(
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/noiseTv.gif',
            fit: BoxFit.fitWidth,
            key: ValueKey('thumbnail'),
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

import 'dart:io';
import 'dart:ui';
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

  dynamic widget;

  VideoViewModel({this.guess});

  void getMedia() async {
    if (mediaFeche == null) {
      widget = buildThumbnail();
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

  //TODO: Mineatura del video

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
    await videoController.setVolume(0.0);
    await videoController.play();
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

  AspectRatio buildVideo() {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
      key: ValueKey('video'),
    );
  }

  buildThumbnail() {
    CustomCacheManager().getSingleFile('${guess.thumbnail}').then((_thumbnail) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          child: Image.file(
            _thumbnail,
            fit: BoxFit.fitWidth,
            /* loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
                backgroundColor: Colors.white,
              ),
            );
          }, */
            key: ValueKey('thumbnail'),
          ),
        ),
      );
    });
  }
}

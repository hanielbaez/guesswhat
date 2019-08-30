import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:Tekel/core/model/ridlle.dart';
import 'package:mime/mime.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  final Ridlle ridlle;

  File mediaFeche;
  VideoPlayerController videoController;
  File imageFile;
  File thumbnailFile;
  dynamic widget;

  Future<dynamic> future;

  VideoViewModel({this.ridlle});

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
    var mediaUrl = this.ridlle.imageUrl ?? this.ridlle.videoUrl;
    try {
      mediaFeche = await CustomCacheManager()
          .getSingleFile('$mediaUrl'); //Check cache for media
    } catch (e) {
      print(e);
      return null;
    }

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
  PhotoView buildImage() {
    return PhotoView(
      backgroundDecoration: BoxDecoration(color: Colors.transparent),
      imageProvider: NetworkImage('${ridlle.imageUrl}'),
      maxScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      loadingChild: Stack(
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
      ),
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
}

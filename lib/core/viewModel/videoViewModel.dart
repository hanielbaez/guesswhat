//Fluter and Dart mport
import 'dart:math';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Self import
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:Tekel/core/model/riddle.dart';

class VideoViewModel extends ChangeNotifier {
  final Riddle riddle;

  File mediaFeche;
  VideoPlayerController videoController;
  File imageFile;
  File thumbnailFile;
  Widget widget = Container();

  Future<dynamic> future;

  VideoViewModel({this.riddle});

  Future getMedia() async {
    if (mediaFeche == null) {
      switch (await mediaType()) {
        case 'image':
          return await getImage();
          break;
        case 'video':
          return await getVideoController();
          break;
        case 'text':
          await buildText();
          break;
      }
    }
  }

  //Return video, image or text
  Future<String> mediaType() async {
    var mediaUrl = this.riddle.imageUrl ?? this.riddle.videoUrl;
    try {
      if (mediaUrl != null) {
        mediaFeche = await CustomCacheManager()
            .getSingleFile('$mediaUrl'); //Check cache for media
      } else {
        return 'text';
      }
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
  buildImage() {
    return PhotoView(
      imageProvider: NetworkImage(
        '${riddle.imageUrl}',
      ),
      maxScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      backgroundDecoration: BoxDecoration(color: Colors.black12),
      loadingChild: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/noiseTv.gif',
            fit: BoxFit.cover,
            key: ValueKey('thumbnail'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildText() {
    Random random = Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);
    widget = Container(
      color: Color.fromARGB(100, r, g, b),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            '${riddle.text}',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            minFontSize: 5,
            maxLines: 20,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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

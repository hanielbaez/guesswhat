import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  Guess guess;
  VideoPlayerController videoController;
  bool isNotDone = true;

  VideoViewModel({this.guess});

  Future<void> getVideoController() async {
/*     if (isNotDone) {
      videoController = VideoPlayerController.network('${guess.videoURL}');
      await videoController.initialize();
      await videoController.setLooping(true);
      await videoController.play();

      isNotDone = false;
      notifyListeners();
    } */
  }
}

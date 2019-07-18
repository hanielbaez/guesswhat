import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  Guess guess;
  VideoPlayerController videoController;
  bool isNotDone = true;

  VideoViewModel({this.guess});

  Future<void> getVideoController() async {
    if (isNotDone) {
      File fetchedFile = await CustomCacheManager()
          .getSingleFile('${guess.videoURL}'); //Manage Chache
      videoController = VideoPlayerController.file(fetchedFile);
      await videoController.initialize();
      await videoController.setLooping(true);
      await videoController.play();

      isNotDone = false;
      notifyListeners();
    }
  }
}

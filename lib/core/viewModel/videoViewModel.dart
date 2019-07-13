import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  DatabaseServices _dbServices;
  VideoPlayerController videoController;
  bool isNotDone = true;

  VideoViewModel({@required DatabaseServices dbServices})
      : _dbServices = dbServices;

  Future getVideoController() async {
    if (isNotDone) {
      videoController = VideoPlayerController.network(
          'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4');
      await videoController.initialize();
      await videoController.setLooping(true);
      await videoController.play();

      isNotDone = false;
      notifyListeners();
    }
  }
}

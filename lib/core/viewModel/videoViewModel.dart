import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  DatabaseServices _dbServices;
  VideoPlayerController videoController;

  bool _busy = false;
  bool get busy => _busy;

  VideoViewModel({@required DatabaseServices dbServices})
      : _dbServices = dbServices;

  Future<String> getVideo() async {
    setBusy(true);
    var guess = await _dbServices.getGuess();
    var video = guess.videoURL;

    setBusy(false);

    return video;
  }

  Future getVideoController() async {
    setBusy(true);
    VideoPlayerController _videoController;
    _videoController = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _videoController.setLooping(true);
        _videoController.play();
        videoController = _videoController;
        setBusy(false);
      });
  }

  void setBusy(bool value) {
    _busy = value;
    _busy == false ? notifyListeners() : null;
  }
}

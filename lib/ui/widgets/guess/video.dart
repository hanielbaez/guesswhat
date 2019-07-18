import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/guess/avatarIcon.dart';

import 'package:video_player/video_player.dart';

class VideoLayaout extends StatefulWidget {
  final VideoViewModel model;

  VideoLayaout({Key key, this.model}) : super(key: key);

  @override
  _VideoLayaoutState createState() => _VideoLayaoutState();
}

class _VideoLayaoutState extends State<VideoLayaout> {
  VideoViewModel model;

  @override
  void initState() {
    model = widget.model;
    if (model.isNotDone) {
      model.getVideoController();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (model.videoController != null) model.videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        !model.isNotDone
            ? VideoPlayer(model.videoController)
            : Stack(
                children: <Widget>[
                  Image.asset('assets/images/noiseTv.gif', fit: BoxFit.cover),
                ],
              ),
        BuildAvatarIcon(),
      ],
    );
  }
}


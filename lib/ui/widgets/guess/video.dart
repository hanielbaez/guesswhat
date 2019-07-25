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
      model.getMedia();
    }
    super.initState();
  }

  @override
  void dispose() {
    //if (model.videoController != null) model.videoController.dispose();
    model.videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: !model.isNotDone
          ? (model.imageFile != null
              ? Image.file(
                  model.imageFile,
                  fit: BoxFit.fitWidth,
                )
              : AspectRatio(
                //TODO: Fit the VIDEO LAYOUT 
                  aspectRatio: model.videoController.value.aspectRatio,
                  child: VideoPlayer(model.videoController),
                ))
          : Image.asset('assets/images/noiseTv.gif', fit: BoxFit.cover),
    );
  }
}

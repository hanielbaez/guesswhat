import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';

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
    model.videoController.dispose();
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
                  Image.asset('assets/images/noiseTv.gif',
                      fit: BoxFit.cover),
                
                ],
              ),
        BuildAvatarIcon(),
      ],
    );
  }
}

class BuildAvatarIcon extends StatelessWidget {
  const BuildAvatarIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'User Name',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

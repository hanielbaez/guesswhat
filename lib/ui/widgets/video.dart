import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class VideoLayaout extends StatefulWidget {
  @override
  _VideoLayaoutState createState() => _VideoLayaoutState();
}

class _VideoLayaoutState extends State<VideoLayaout> {
  /*  @override
  void dispose() {
    super.dispose();
    Consumer<VideoViewModel>(
      builder: (context, model, child) {
        model.dispose();
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoViewModel>(
      builder: (context, model, child) {
        model.getVideoController();
        return Stack(
          children: <Widget>[
            model.videoController != null
                ? VideoPlayer(model.videoController)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            BuildAvatarIcon(),
          ],
        );
      },
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

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class CharadaLayaout extends StatefulWidget {
  @override
  _CharadaLayaoutState createState() => _CharadaLayaoutState();
}

class _CharadaLayaoutState extends State<CharadaLayaout> {
  VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _videoController.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        VideoPlayer(_videoController),
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
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

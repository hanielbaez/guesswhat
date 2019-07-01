import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';


class Charada extends StatefulWidget {
  @override
  _CharadaState createState() => _CharadaState();
}

class _CharadaState extends State<Charada> {
  VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _videoController.value.isPlaying
                    ? _videoController.pause()
                    : _videoController.play();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Stack(
                children: <Widget>[
                  VideoPlayer(_videoController),
                  Padding(
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
                  ),
                  _videoController.value.isPlaying
                      ? Container()
                      : Center(
                          child: Opacity(
                            opacity: 0.3,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 250.0,
                            ),
                          ),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '????????',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0),
                    ),
                  ),
                  
     
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

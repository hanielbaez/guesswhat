import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';

class VideoLayaout extends StatefulWidget {
  final Guess guess;
  final VideoViewModel model;
  VideoLayaout({this.guess, this.model});

  @override
  _VideoLayaoutState createState() => _VideoLayaoutState();
}

class _VideoLayaoutState extends State<VideoLayaout> {
  @override
  void initState() {
    widget.model.getMedia();
    super.initState();
  }

  @override
  void dispose() {
    widget.model.videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: GestureDetector(
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            widget.model.widget ?? Container(),
            //TODO: Finish the Flare implementacion
            /*  FlareActor(
              "assets/flare/Success.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ), */
          ],
        ),
        onDoubleTap: () {
          //ON/OFF VOLUMEN
          widget.model.videoController.value.volume == 0.0
              ? widget.model.videoController.setVolume(1.0)
              : widget.model.videoController.setVolume(0.0);
        },
      ),
    );
  }
}

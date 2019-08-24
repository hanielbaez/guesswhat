//Flutter and Dart import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';

class VideoLayaout extends StatefulWidget {
  final Guess guess;
  final VideoViewModel model;
  final Stream shouldTriggerChange;

  VideoLayaout({this.guess, this.model, this.shouldTriggerChange});

  @override
  _VideoLayaoutState createState() => _VideoLayaoutState();
}

class _VideoLayaoutState extends State<VideoLayaout>
    with TickerProviderStateMixin {
  StreamSubscription streamSubscription;
  AnimationController fadeController;
  Animation fadeAnimation;

  @override
  initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerChange.listen((value) => success(value));
    fadeController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
  }

  @override
  void dispose() {
    widget.model.videoController?.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  void success(value) async {
    if (value == true) {
      setState(() {
        fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: GestureDetector(
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            FutureBuilder(
              future: widget.model.getMedia(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Check your network connection.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: try later, please');
                    return Center(
                      child: widget.model.widget,
                    );
                }
                return Text('Unreachable.');
              },
            ),
            FadeTransition(
                opacity: fadeAnimation, child: buildSuccessContainer())
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

  Container buildSuccessContainer() {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              SimpleLineIcons.getIconData('check'),
              color: Colors.black,
              size: 40.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('Success',
                style: TextStyle(color: Colors.black, fontSize: 40.0)),
          ],
        ),
      ),
    );
  }
}

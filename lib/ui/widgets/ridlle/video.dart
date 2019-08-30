//Flutter and Dart import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/core/model/ridlle.dart';
import 'package:Tekel/core/viewModel/videoViewModel.dart';

class VideoLayaout extends StatefulWidget {
  final Ridlle ridlle;
  final VideoViewModel model;
  final Stream shouldTriggerChange;

  VideoLayaout({this.ridlle, this.model, this.shouldTriggerChange});

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
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: Stack(
        fit: StackFit.expand,
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
                  return Center(child: widget.model.widget);
              }
              return Text('Unreachable.');
            },
          ),
          FadeTransition(opacity: fadeAnimation, child: buildSuccessContainer())
        ],
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

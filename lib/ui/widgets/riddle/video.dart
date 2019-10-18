//Flutter and Dart import
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/viewModel/videoViewModel.dart';

class VideoLayaout extends StatefulWidget {
  final Riddle riddle;
  final VideoViewModel model;
  final Stream shouldTriggerChange;
  final ConfettiController confettiController;

  VideoLayaout(
      {this.riddle,
      this.model,
      this.shouldTriggerChange,
      this.confettiController});

  @override
  _VideoLayaoutState createState() => _VideoLayaoutState();
}

class _VideoLayaoutState extends State<VideoLayaout>
    with TickerProviderStateMixin {
  StreamSubscription streamSubscription;

  @override
  initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerChange.listen((value) => success(value));
  }

  @override
  void dispose() {
    widget.model.videoController?.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  void success(value) async {
    if (value == true) {
      widget.confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.7,
      child: FutureBuilder(
        future: widget.model.getMedia(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Check your network connection.');
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Network connection error please try again later');
              return widget.model.widget;
          }
          return Text('Unreachable.');
        },
      ),
    );
  }
}

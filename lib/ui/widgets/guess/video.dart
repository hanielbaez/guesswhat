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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: widget.model.widget,
    );
  }
}

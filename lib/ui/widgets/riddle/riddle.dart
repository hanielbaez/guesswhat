//Flutter import
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/ui/widgets/custom/userBar.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/viewModel/letterViewModel.dart';
import 'package:Tekel/core/viewModel/videoViewModel.dart';
import 'package:Tekel/ui/widgets/custom/customSideKick.dart';
import 'package:Tekel/ui/widgets/riddle/actionsBar.dart';
import 'package:Tekel/ui/widgets/riddle/description.dart';
import 'package:Tekel/ui/widgets/riddle/video.dart';

class RiddleLayaout extends StatefulWidget {
  final Riddle riddle;

  RiddleLayaout({this.riddle});

  @override
  _RiddleLayaoutState createState() => _RiddleLayaoutState();
}

class _RiddleLayaoutState extends State<RiddleLayaout> {
  final changeNotifier = StreamController.broadcast();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: UserBar(
              user: User.fromMap(widget.riddle.user),
              timeStamp: widget.riddle.createdAt,
              address: widget.riddle.address,
            ),
          ),
          ChangeNotifierProvider<VideoViewModel>.value(
            value: VideoViewModel(riddle: widget.riddle),
            child: Consumer<VideoViewModel>(
              builder: (context, model, child) {
                return VideoLayaout(
                  riddle: widget.riddle,
                  model: model,
                  shouldTriggerChange: changeNotifier.stream,
                  confettiController: Provider.of<ConfettiController>(context),
                );
              },
            ),
          ),
          if (widget.riddle.answer.isNotEmpty)
            ChangeNotifierProvider<LettersViewModel>.value(
              value: LettersViewModel(
                  riddle: widget.riddle,
                  db: Provider.of(context),
                  user: Provider.of<AuthenticationServices>(context).profile,
                  changeNotifier: changeNotifier),
              child: CustomSidekick(),
            ),
          ActionBar(riddle: widget.riddle),
          if (widget.riddle.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomDescription(text: '${widget.riddle.description}'),
              ),
            ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}

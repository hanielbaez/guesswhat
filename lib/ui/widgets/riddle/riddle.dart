//Flutter import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
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
      //color: Colors.white,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: <Widget>[
          ChangeNotifierProvider<VideoViewModel>.value(
            value: VideoViewModel(riddle: widget.riddle),
            child: Consumer<VideoViewModel>(
              builder: (context, model, child) {
                return SizedBox.fromSize(
                  child: VideoLayaout(
                      riddle: widget.riddle,
                      model: model,
                      shouldTriggerChange: changeNotifier.stream),
                );
              },
            ),
          ),
          if (widget.riddle.answer.isNotEmpty)
            ChangeNotifierProvider<LettersViewModel>.value(
              value: LettersViewModel(
                  riddle: widget.riddle,
                  db: Provider.of(context),
                  user: Provider.of<DatabaseServices>(context).getUser(),
                  changeNotifier: changeNotifier),
              child: Consumer<LettersViewModel>(
                builder: (context, model, child) {
                  return CustomSidekick(
                    riddle: widget.riddle,
                    model: model,
                  );
                },
              ),
            ),
          if (widget.riddle.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomDescription(text: '${widget.riddle.description}'),
              ),
            ),
          ActionBar(riddle: widget.riddle),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}

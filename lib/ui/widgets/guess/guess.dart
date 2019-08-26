//Flutter import
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/custom/customSideKick.dart';
import 'package:guess_what/ui/widgets/custom/userBar.dart';
import 'package:guess_what/ui/widgets/guess/actionsBar.dart';
import 'package:guess_what/ui/widgets/guess/description.dart';
import 'package:guess_what/ui/widgets/guess/video.dart';

class GuessLayaout extends StatefulWidget {
  final Guess guess;

  GuessLayaout({this.guess});

  @override
  _GuessLayaoutState createState() => _GuessLayaoutState();
}

class _GuessLayaoutState extends State<GuessLayaout> {
  final changeNotifier = new StreamController.broadcast();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: UserBar(
              userData: widget.guess.user,
              timeStamp: widget.guess.creationDate,
              address: widget.guess.address,
            ),
          ),
          Hero(
            tag: widget.guess.id,
            child: ChangeNotifierProvider<VideoViewModel>.value(
              value: VideoViewModel(guess: widget.guess),
              child: Consumer<VideoViewModel>(
                builder: (context, model, child) {
                  return SizedBox.fromSize(
                    child: VideoLayaout(
                        guess: widget.guess,
                        model: model,
                        shouldTriggerChange: changeNotifier.stream),
                  );
                },
              ),
            ),
          ),
          if (widget.guess.answer.isNotEmpty)
            StreamBuilder<FirebaseUser>(
              stream: Provider.of<AuthenticationServices>(context).user(),
              builder: (context, userSnap) {
                if (userSnap.hasData) {
                  return ChangeNotifierProvider<LettersViewModel>.value(
                    value: LettersViewModel(
                        guess: widget.guess,
                        db: Provider.of(context),
                        user: userSnap.data,
                        changeNotifier: changeNotifier),
                    child: Consumer<LettersViewModel>(
                      builder: (context, model, child) {
                        return CustomSidekick(
                          guess: widget.guess,
                          model: model,
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          if (widget.guess.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomDescription(text: '${widget.guess.description}'),
              ),
            ),
          ActionBar(guess: widget.guess),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}

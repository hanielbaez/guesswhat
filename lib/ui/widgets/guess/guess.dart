//Flutter import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/custom/customSideKick.dart';
import 'package:guess_what/ui/widgets/custom/userBar.dart';
import 'package:guess_what/ui/widgets/guess/actionsBar.dart';
import 'package:guess_what/ui/widgets/guess/description.dart';
import 'package:guess_what/ui/widgets/guess/video.dart';

class GuessLayaout extends StatelessWidget {
  final Guess guess;

  GuessLayaout({this.guess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: UserBar(
            userData: guess.user,
            timeStamp: guess.creationDate,
            address: guess.address,
          ),
        ),
        ChangeNotifierProvider<VideoViewModel>.value(
          value: VideoViewModel(guess: guess),
          child: Consumer<VideoViewModel>(
            builder: (context, model, child) {
              return SizedBox.fromSize(
                child: VideoLayaout(guess: guess, model: model),
              );
            },
          ),
        ),
        if (guess.word.isNotEmpty)
          StreamBuilder<FirebaseUser>(
            stream: Provider.of<AuthenticationServices>(context).user(),
            builder: (context, userSnap) {
              if (userSnap.hasData) {
                return ChangeNotifierProvider<LettersViewModel>.value(
                  value: LettersViewModel(
                      guess: guess,
                      db: Provider.of(context),
                      user: userSnap.data),
                  child: Consumer<LettersViewModel>(
                    builder: (context, model, child) {
                      return CustomSidekick(
                        guess: guess,
                        model: model,
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        if (guess.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: CustomDescription(text: '${guess.description}'),
            ),
          ),
        ActionBar(guess: guess),
        Divider(
          color: Colors.white54,
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}

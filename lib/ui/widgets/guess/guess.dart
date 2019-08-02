import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/pages/commentPage.dart';
import 'package:guess_what/ui/widgets/costum/costumSideKick.dart';
import 'package:guess_what/ui/widgets/costum/userBar.dart';
import 'package:guess_what/ui/widgets/guess/description.dart';
import 'package:guess_what/ui/widgets/guess/video.dart';

import 'package:provider/provider.dart';

class GuessLayaout extends StatelessWidget {
  final Guess guess;

  GuessLayaout({this.guess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserBar(),
        SizedBox(
          height: 10.0,
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
        if (guess.word.isNotEmpty) //Consition for not guess word
          ChangeNotifierProvider<LettersViewModel>.value(
            value: LettersViewModel(guessWord: guess.word),
            child: Consumer<LettersViewModel>(
              builder: (context, model, child) {
                return CostumSidekick(
                  guess: guess,
                  model: model,
                );
              },
            ),
          ),
        if (guess.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: CostumDescription(text: '${guess.description}')),
          ),
        FlatButton.icon(
          icon: Icon(
            Icons.comment,
            color: Colors.white,
          ),
          label: Text(
            'Comment',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChangeNotifierProvider<CommentViewModel>.value(
                  value: CommentViewModel(
                    databaseServices: Provider.of(context),
                  ),
                  child: Consumer<CommentViewModel>(
                    builder: (context, model, child) {
                      return CommentPage(
                        model: model,
                        guess: guess,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
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

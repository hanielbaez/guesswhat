import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/costum/costumSideKick.dart';
import 'package:guess_what/ui/widgets/guess/description.dart';
import 'package:guess_what/ui/widgets/guess/video.dart';

import 'package:provider/provider.dart';

class GuessLayaout extends StatelessWidget {
  final Guess guess;

  GuessLayaout({this.guess});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          LimitedBox(
            maxHeight: 550.0,
            child: Stack(
              children: <Widget>[
                FractionallySizedBox(
                  //alignment: Alignment.topCenter,
                  heightFactor: 0.7,
                  child: ChangeNotifierProvider<VideoViewModel>.value(
                    value: VideoViewModel(guess: guess),
                    child: Consumer<VideoViewModel>(
                      builder: (context, model, child) =>
                          VideoLayaout(model: model),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ChangeNotifierProvider<LettersViewModel>.value(
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
                ),
              ],
            ),
          ),
          CostumDescription(text: '${guess.description}'),
          Divider(
            color: Colors.black26,
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

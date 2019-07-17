import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:guess_what/ui/widgets/lettersAnimatios.dart';

import 'package:guess_what/ui/widgets/video.dart';
import 'package:guess_what/ui/widgets/description.dart';
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
          AspectRatio(
            aspectRatio: 4 / 6.5,
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
                    value: LettersViewModel(word: guess.word),
                    child: Consumer<LettersViewModel>(
                      builder: (context, model, child) {
                        return LettersAnimations(
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

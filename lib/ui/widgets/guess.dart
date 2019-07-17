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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: ChangeNotifierProvider<VideoViewModel>.value(
                      value: VideoViewModel(guess: guess),
                      child: Consumer<VideoViewModel>(
                        builder: (context, model, child) =>
                            VideoLayaout(model: model),
                      ),
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
          CostumDescription(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
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

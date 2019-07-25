import 'package:flutter/material.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/letterViewModel.dart';
import 'package:guess_what/ui/widgets/costum/costumSideKick.dart';
import 'package:guess_what/ui/widgets/guess/description.dart';


import 'package:provider/provider.dart';

class GuessLayaout extends StatelessWidget {
  final Guess guess;

  GuessLayaout({this.guess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CostumDescription(text: '${guess.description}'),
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}

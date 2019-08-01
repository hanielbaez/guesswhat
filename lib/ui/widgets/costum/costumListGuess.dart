import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/widgets/guess/guess.dart';

class CostumListGuess extends StatefulWidget {
  final GuessModel model;
  final Function onModelReady;

  CostumListGuess({Key key, this.model, this.onModelReady}) : super(key: key);

  @override
  _CostumListGuessState createState() => _CostumListGuessState();
}

class _CostumListGuessState extends State<CostumListGuess> {
  GuessModel model;

  @override
  void initState() {
    model = widget.model;
    if (model.allGuesses.isEmpty) {
      model.getAllGuesses();
      print('GET ALL GUESSES');
    }
    super.initState();
  }

  @override
  void dispose() {
    model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: model.allGuesses.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: GuessLayaout(guess: model.allGuesses[index]),
        );
      },
    );
  }
}

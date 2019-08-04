import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/widgets/guess/guess.dart';

class CostumListGuess extends StatelessWidget {
  final GuessModel model;
  final Function onModelReady;

  CostumListGuess({Key key, this.model, this.onModelReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model.getAllGuesses(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          //return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Please wait...'),
                  SpinKitThreeBounce(
                    color: Colors.white,
                    size: 25.0,
                  ),
                ],
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return ListView.builder(
              itemCount: model.allGuesses.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: GuessLayaout(guess: model.allGuesses[index]),
                );
              },
            );
        }
      },
    );
  }
}

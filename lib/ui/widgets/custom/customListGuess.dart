//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/ui/widgets/guess/guess.dart';

class CustomListGuess extends StatelessWidget {
  final Function onModelReady;

  CustomListGuess({Key key, this.onModelReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DatabaseServices>(context).fectchGuesses(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //? Do i really nees this SWITCH
        switch (snapshot.connectionState) {
          case ConnectionState.none:
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
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: GuessLayaout(guess: snapshot.data[index]),
                );
              },
            );
        }
        return Text('Something went wrong, please try later');
      },
    );
  }
}

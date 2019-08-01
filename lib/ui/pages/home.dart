import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Coustom import
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/widgets/costum/costumListGuess.dart';
import '../widgets/costum/buttonPress.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text(
          'Tekel',
          style: TextStyle(color: Colors.yellowAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: Placeholder(
          fallbackWidth: 50,
          fallbackHeight: 50,
        ),
      ),
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider<GuessModel>.value(
        value: GuessModel(
          databaseServices: Provider.of(context),
        ),
        child: Consumer<GuessModel>(
          builder: (context, model, child) {
            return CostumListGuess(
              model: model,
              onModelReady: () => model.getAllGuesses(),
            );
          },
        ),
      ),
    );
  }
}

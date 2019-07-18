import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/widgets/guess/guess.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black45,
          onPressed: () {},
        ),
        title: Text(
          'GuessWhat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider<GuessModel>.value(
        value: GuessModel(
          databaseServices: Provider.of(context),
        ),
        child: Consumer<GuessModel>(
          builder: (context, model, child) {
            return CostumSwiper(
              model: model,
              onModelReady: () => model.getAllGuesses(),
            );
          },
        ),
      ),
    );
  }
}

class CostumSwiper extends StatefulWidget {
  final GuessModel model;
  final Function onModelReady;

  CostumSwiper({Key key, this.model, this.onModelReady}) : super(key: key);

  @override
  _CostumSwiperState createState() => _CostumSwiperState();
}

class _CostumSwiperState extends State<CostumSwiper> {
  GuessModel model;

  @override
  void initState() {
    model = widget.model;
    if (model.allGuesses.isEmpty) {
      model.getAllGuesses();
    }
    super.initState();
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

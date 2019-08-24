//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/ui/widgets/custom/customDrawer.dart';
import 'package:guess_what/ui/widgets/guess/guess.dart';
import 'package:guess_what/core/model/guess.dart';
import '../widgets/custom/buttonPress.dart';

class GuessPage extends StatefulWidget {
  final Guess guess;
  GuessPage(this.guess);

  @override
  _GuessPageState createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('menu')),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              SimpleLineIcons.getIconData('plus'),
              color: Colors.yellow,
            ),
            onPressed: () => onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text('Tekel'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Color.fromARGB(1, 191, 191, 191),
      body: ListView(
        children: <Widget>[
          GuessLayaout(
            guess: widget.guess,
          ),
        ],
      ),
    );
  }
}

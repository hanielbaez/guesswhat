//Flutter and Dart import
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customDrawer.dart';
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:provider/provider.dart';

class RiddlePage extends StatefulWidget {
  final Riddle riddle;
  RiddlePage(this.riddle);

  @override
  _RiddlePageState createState() => _RiddlePageState();
}

class _RiddlePageState extends State<RiddlePage> {
  ConfettiController controllerTopCenter;

  @override
  void initState() {
    controllerTopCenter = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  void dispose() {
    controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: ListenableProvider<ConfettiController>.value(
              value: controllerTopCenter,
              child: RiddleLayaout(
                riddle: widget.riddle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

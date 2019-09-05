//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customDrawer.dart';
import 'package:Tekel/ui/widgets/riddle/riddle.dart';
import 'package:Tekel/core/model/riddle.dart';
import '../widgets/custom/buttonPress.dart';

class RiddlePage extends StatefulWidget {
  final Riddle riddle;
  RiddlePage(this.riddle);

  @override
  _RiddlePageState createState() => _RiddlePageState();
}

class _RiddlePageState extends State<RiddlePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tekel'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      //backgroundColor: Color.fromARGB(1, 191, 191, 191),
      body: ListView(
        children: <Widget>[
          RiddleLayaout(
            riddle: widget.riddle,
          ),
        ],
      ),
    );
  }
}

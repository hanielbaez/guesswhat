//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/ui/widgets/custom/customDrawer.dart';
import 'package:guess_what/ui/widgets/ridlle/ridlle.dart';
import 'package:guess_what/core/model/ridlle.dart';
import '../widgets/custom/buttonPress.dart';

class RidllePage extends StatefulWidget {
  final Ridlle ridlle;
  RidllePage(this.ridlle);

  @override
  _RidllePageState createState() => _RidllePageState();
}

class _RidllePageState extends State<RidllePage> {
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
          RidlleLayaout(
            ridlle: widget.ridlle,
          ),
        ],
      ),
    );
  }
}

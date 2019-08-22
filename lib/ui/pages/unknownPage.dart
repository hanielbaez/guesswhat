//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/ui/widgets/custom/customDrawer.dart';
import '../widgets/custom/buttonPress.dart';

class UnknownPage extends StatelessWidget {
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
        title: Text(
          'Tekel',
          //style: TextStyle(color: Colors.yellowAccent),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Color.fromARGB(1, 191, 191, 191),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              SimpleLineIcons.getIconData('exclamation'),
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 20.0),
            Text('Page not found please try later'),
          ],
        ),
      ),
    );
  }
}

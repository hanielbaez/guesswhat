//Flutter and Dart import
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customDrawer.dart';
import 'package:Tekel/ui/widgets/custom/customListRiddle.dart';
import '../widgets/custom/buttonPress.dart';
import 'package:Tekel/core/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription subscription;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            SimpleLineIcons.getIconData('menu'),
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow[600], Colors.orange[400]],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  SimpleLineIcons.getIconData('plus'),
                  color: Colors.black,
                  semanticLabel: 'Create a riddle',
                ),
                onPressed: () {
                  subscription = Provider.of<AuthenticationServices>(context)
                      .profile
                      .listen(
                    (user) {
                      if (user != null) {
                        onButtonPressed(
                          context: context,
                          user: user,
                        ); //Add multimedia
                      } else {
                        _scaffoldKey.currentState.openDrawer();
                      }
                      subscription.cancel();
                    },
                  );
                },
              ),
            ),
          )
        ],
        title: Text(
          'Tekel',
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: CustomListRiddle(),
    );
  }
}

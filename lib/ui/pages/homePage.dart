//Flutter and Dart import
import 'package:Tekel/core/custom/paginationRiddles.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customDrawer.dart';
import 'package:Tekel/ui/widgets/custom/customListRiddle.dart';
import '../widgets/custom/buttonPress.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  SimpleLineIcons.getIconData('bell'),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('notificationsPage'),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Provider.of<DatabaseServices>(context)
                      .listenNotification(),
                  builder: (context, snapshot) {
                    if (!snapshot
                        .hasError) if (snapshot.data?.documents?.length > 0) {
                      return Positioned(
                        top: 20.0,
                        left: 25.0,
                        child: Container(
                          width: 15.5,
                          height: 15.5,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Text(
                            '${snapshot.data?.documents?.length}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      );
                    }
                    return Container();
                  })
            ],
          ),
          SizedBox(
            width: 15.0,
          ),
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
                  var currentUser =
                      Provider.of<DatabaseServices>(context).currentUser;
                  if (currentUser != null) {
                    //Add multimedia
                    onButtonPressed(
                      context: context,
                    );
                  } else {
                    _scaffoldKey.currentState.openDrawer();
                  }
                },
              ),
            ),
          ),
        ],
        title: Text(
          'Tekel',
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<PaginationViewModel>(
        builder: (context) => PaginationViewModel(),
        child: Consumer<PaginationViewModel>(
          builder: (cotext, model, child) => CustomListRiddle(
            model: model,
          ),
        ),
      ),
    );
  }
}

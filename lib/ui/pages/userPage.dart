//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Self import
import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/ui/widgets/custom/customGridView.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/db.dart';

class UserPage extends StatelessWidget {
  final User user;

  UserPage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          StreamBuilder(
            stream: Provider.of<AuthenticationServices>(context).user(),
            builder: (context, snapshot) {
              if (snapshot.hasData) if (!snapshot.hasError &&
                  snapshot.data.uid == user.uid) {
                return FlatButton.icon(
                  icon: Icon(SimpleLineIcons.getIconData('pencil')),
                  label: Text('Edit'),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, 'editUserPage',
                        arguments: user);
                  },
                );
              }
              return Container();
            },
          ),
        ],
        title: Text('${user.displayName}'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2.7,
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/noiseTv.gif',
                            image: user.photoURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 220),
                          child: AutoSizeText(
                            '${user.biography}',
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            //Some separation
            color: Colors.black.withOpacity(0.3),
          ),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: <Widget>[
                  TabBar(
                    indicatorColor: Colors.yellow[600],
                    labelColor: Colors.yellow[600],
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(
                          SimpleLineIcons.getIconData('puzzle'),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          SimpleLineIcons.getIconData('trophy'),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        FutureBuilder(
                          future: Provider.of<DatabaseServices>(context)
                              .fectchUserRiddle(userId: user.uid),
                          builder: (context, snapshot) {
                            if (snapshot
                                .hasData) 
                              return CustomGridView(
                                list: snapshot.data,
                              );
                            return Container();
                          },
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

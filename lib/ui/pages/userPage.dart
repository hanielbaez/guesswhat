//Flutter and Dart import
import 'package:Tekel/core/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
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
        title: Text('Tekel'),
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
                        Column(
                          children: <Widget>[
                            Text(
                              '${user.displayName}',
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '1.000.000 Members',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (user.biography.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${user.biography}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.yellow[600], Colors.orange[400]],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: FlatButton.icon(
                            icon: Icon(
                                SimpleLineIcons.getIconData('user-follow')),
                            //color: Colors.yellow,
                            label: Text(
                              'Join',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        RaisedButton.icon(
                          icon: Icon(SimpleLineIcons.getIconData('trophy')),
                          label: Text(
                            'Leaderboard',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: Provider.of<DatabaseServices>(context)
                .fectchUserRidlle(userId: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) //return Text('${snapshot.data}');
                return Expanded(
                  child: CustomGridView(
                    list: snapshot.data,
                  ),
                );
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

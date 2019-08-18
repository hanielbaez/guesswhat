//Flutter and Dart import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

//Self import
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/services/db.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<FirebaseUser>(
            stream: Provider.of<AuthenticationServices>(context).user(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SingOutLayout();
              }
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Not current connected');
                case ConnectionState.waiting:
                  return Text('Wating');
                case ConnectionState.active:
                case ConnectionState.done:
                  return SingInLayout(snapshot: snapshot);
                  break;
              }
              return Container(); //unreachable
            },
          ),
        ),
      ),
    );
  }
}

class SingInLayout extends StatelessWidget {
  final AsyncSnapshot<FirebaseUser> snapshot;

  const SingInLayout({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Container(
          height: 100.0,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10.0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white),
                ),
                child: FutureBuilder<User>(
                  future: Provider.of<DatabaseServices>(context)
                      .getUser(snapshot.data),
                  builder: (context, imageSnap) {
                    switch (imageSnap.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Icon(
                          SimpleLineIcons.getIconData('user'),
                          color: Colors.white,
                        );
                      case ConnectionState.done:
                        if (imageSnap.hasError)
                          return Text('Error: ${snapshot.error}');
                        return FadeInImage.assetNetwork(
                          placeholder: 'assets/images/noiseTv.gif',
                          image: imageSnap.data.photoURL,
                          fit: BoxFit.cover,
                        );
                    }
                    return Container();
                  },
                ),
              ),
              Text(snapshot.data.displayName),
            ],
          ),
        ),
        Divider(
          color: Colors.white24,
        ),
        ListTile(
          leading: Icon(
            SimpleLineIcons.getIconData('heart'),
            color: Colors.white,
          ),
          title: Text(
            'Loves',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            SimpleLineIcons.getIconData('present'),
            color: Colors.white,
          ),
          title: Text(
            'Share Tekel with friends',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            ShareExtend.share(
                "I invite you to try Tekel a fun word app, available on Google Play. Go get it!",
                "text");
          },
        ),
        ListTile(
            leading: Icon(
              SimpleLineIcons.getIconData('question'),
              color: Colors.white,
            ),
            title: Text(
              'Support',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              //TODO: Make a support page
            }),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(
                  color: Colors.white24,
                ),
                ListTile(
                    leading: Icon(
                      SimpleLineIcons.getIconData('logout'),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    title: Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Leave Tekel?',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                      child: Text(
                                        'Leave',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<AuthenticationServices>(
                                                context)
                                            .singOut();
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//Show this layaout when the user is SingOut
class SingOutLayout extends StatelessWidget {
  const SingOutLayout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Debes registrarte para continuar, es GRATIS',
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50.0,
        ),
        FacebookSignInButton(
          text: 'Sign in with Facebook',
          onPressed: () => Provider.of<AuthenticationServices>(context)
              .loginWithFacebook()
              .then(
            (response) {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text("$response"),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GoogleSignInButton(
          onPressed: () => Provider.of<AuthenticationServices>(context)
              .sigInWithGoogle()
              .then(
            (response) {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text("$response"),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Divider(
            color: Colors.white24,
          ),
        ),
        FlatButton.icon(
          label: Text('Sign in with Email'),
          color: Colors.white,
          icon: Icon(
            SimpleLineIcons.getIconData('envelope'),
            color: Colors.black,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

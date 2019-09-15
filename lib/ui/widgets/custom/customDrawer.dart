//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/buttonPress.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: StreamBuilder(
            stream: Provider.of<AuthenticationServices>(context).profile,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Please wait...'),
                        SpinKitThreeBounce(
                          color: Colors.black,
                          size: 50.0,
                        ),
                      ],
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) if (!snapshot.hasError) {
                    return SingInLayout(
                      user: snapshot.data,
                    );
                  }
                  return SingOutLayout();
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
  final User user;

  const SingInLayout({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('USER ID ${user.uid}');
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'userPage', arguments: user),
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                colors: [Colors.yellow[600], Colors.orange[400]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  width: 50,
                  height: 50,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/noiseTv.gif',
                    image: user.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  user.displayName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Card(
          color: Colors.white,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
            leading: Icon(
              SimpleLineIcons.getIconData('home'),
            ),
            title: Text(
              'Home',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) {
                if (route.settings.name != '/') {
                  Navigator.popAndPushNamed(context, '/');
                  return true;
                }
                return true;
              });
            },
          ),
        ),
        Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
            leading: Icon(
              SimpleLineIcons.getIconData('puzzle'),
            ),
            title: Text(
              'Create a Riddle',
            ),
            onTap: () {
              Navigator.pop(context);
              onButtonPressed(context: context, user: user);
            },
          ),
        ),
        Card(
          color: Colors.white,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
            leading: Icon(
              SimpleLineIcons.getIconData('heart'),
            ),
            title: Text(
              'Loved Riddles',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'lovePage', arguments: user.uid);
            },
          ),
        ),
        Card(
          color: Colors.white,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
            leading: Icon(
              SimpleLineIcons.getIconData('present'),
            ),
            title: Text(
              'Share Tekel with Friends',
            ),
            onTap: () {
              ShareExtend.share(
                  "I invite you to try Tekel a fun word app, available on Google Play. Go get it!",
                  "text");
            },
          ),
        ),
        Card(
          color: Colors.white,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
              leading: Icon(
                SimpleLineIcons.getIconData('question'),
              ),
              title: Text(
                'Support',
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'supportPage',
                    arguments: user);
              }),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    SimpleLineIcons.getIconData('logout'),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Leave Tekel?',
                            style: TextStyle(),
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
                                    Provider.of<AuthenticationServices>(context)
                                        .singOut();

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Register to create and share your riddles",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
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
          label: Text('Continue as a Guest'),
          color: Colors.white,
          icon: Icon(
            SimpleLineIcons.getIconData('user'),
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

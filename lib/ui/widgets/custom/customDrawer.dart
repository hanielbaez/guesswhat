import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:guess_what/core/viewModel/DrawerViewModel.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final DrawerViewModel model;

  const CustomDrawer({
    Key key,
    this.model,
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
                return SingOutLayout(model: model);
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
                  return SingInLayout(snapshot: snapshot, model: model);
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
  final DrawerViewModel model;

  const SingInLayout({Key key, this.snapshot, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Row(
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
                    color: Colors.white,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => model.signOut(),
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
    @required this.model,
  }) : super(key: key);

  final DrawerViewModel model;

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
          onPressed: () {
            // call FB authentication logic
            model.facebookLoging();
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        GoogleSignInButton(
          onPressed: () {
            //TODO: Inplemente Google SingIn
          },
        ),
        ListTile(
          leading: Icon(SimpleLineIcons.getIconData('logout')),
          title: Text('Logout'),
          onTap: () {},
        )
      ],
    );
  }
}

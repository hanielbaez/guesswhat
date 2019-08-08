import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/viewModel/DrawerViewModel.dart';

class CostumDrawer extends StatelessWidget {
  final DrawerViewModel model;

  const CostumDrawer({
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
          child: StreamBuilder(
            stream: model.userProfile,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SingOutLayout(model: model);
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print('Not current connected');
                  break;
                case ConnectionState.waiting:
                  print('Wating');
                  break;
                case ConnectionState.active:
                  print('Connected to a Stream');
                  return SingInLayout(snapshot: snapshot, model: model);
                  break;
                case ConnectionState.done:
                  print('Stream done');
                  return Container();
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
  final AsyncSnapshot<User> snapshot;
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
              child: Image.network(
                snapshot.data.photoURL,
                fit: BoxFit.fill,
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

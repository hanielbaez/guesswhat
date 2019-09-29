//Flutter and Dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/buttonPress.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/services/auth.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    User _currentUser = Provider.of<DatabaseServices>(context).currentUser;
    Widget child;

    void refresh() {
      setState(() {});
    }

    if (_currentUser != null) {
      child = SingInLayout(
        user: _currentUser,
        refreshUI: refresh,
      );
    } else {
      child = SingOutLayout();
    }

    return Drawer(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: child,
        ),
      ),
    );
  }
}

class SingInLayout extends StatelessWidget {
  final User user;
  final Function refreshUI;

  const SingInLayout({Key key, this.user, this.refreshUI}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Column(
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
                AppLocalizations.of(context).tr('drawer.home'),
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
                AppLocalizations.of(context).tr('drawer.create_your_riddle'),
              ),
              onTap: () {
                Navigator.pop(context);
                onButtonPressed(context: context);
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
                AppLocalizations.of(context).tr('drawer.your_loves'),
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
                AppLocalizations.of(context)
                    .tr('drawer.share_tekel_with_friends'),
              ),
              onTap: () {
                ShareExtend.share(
                    AppLocalizations.of(context).tr('drawer.share_text'),
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
                title: Text(AppLocalizations.of(context).tr('drawer.support')),
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
                      AppLocalizations.of(context).tr('drawer.log_out'),
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
                              AppLocalizations.of(context)
                                  .tr('drawer.leave_tekel?'),
                              style: TextStyle(),
                            ),
                            actions: <Widget>[
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .tr('drawer.cancel'),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .tr('drawer.leave'),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<AuthenticationServices>(
                                              context)
                                          .singOut()
                                          .then(
                                        (result) {
                                          if (result) {
                                            refreshUI();
                                          }
                                        },
                                      );

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
      ),
    );
  }
}

//Show this layaout when the user is SingOut
class SingOutLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context).tr('drawer.message'),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        FacebookSignInButton(
          text: AppLocalizations.of(context).tr('drawer.facebookButtonText'),
          onPressed: () async {
            var _response = await Provider.of<AuthenticationServices>(context)
                .loginWithFacebook();
            if (_response) {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).tr('drawer.successMessage')),
                ),
              );
            } else {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).tr('drawer.errorMessage')),
                ),
              );
            }
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        GoogleSignInButton(
          text: AppLocalizations.of(context).tr('drawer.googleButtonText'),
          onPressed: () => Provider.of<AuthenticationServices>(context)
              .sigInWithGoogle()
              .then(
            (response) {
              if (response) {
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .tr('drawer.successMessage')),
                  ),
                );
              } else {
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocalizations.of(context).tr('drawer.errorMessage')),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

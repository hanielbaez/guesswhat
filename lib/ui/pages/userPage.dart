//Flutter and Dart import
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
    var userData;
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
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
                    icon: Icon(
                      SimpleLineIcons.getIconData('pencil'),
                      size: 15.0,
                    ),
                    label:
                        Text(AppLocalizations.of(context).tr("userPage.edit")),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'editUserPage',
                          arguments: userData);
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
            FutureBuilder<User>(
                future: Provider.of<DatabaseServices>(context)
                    .getUser(uid: user.uid),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SpinKitThreeBounce(
                            color: Colors.black,
                            size: 25.0,
                          ),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: Please try later');
                      userData = snapshot.data;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 2.7,
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 75,
                                      width: 75,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/noiseTv.gif',
                                        image: snapshot.data.photoUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () => Navigator.pushNamed(
                                                  context, 'solvedByPage',
                                                  arguments: user),
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '${snapshot.data.counter['solved'] ?? 0}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .tr("userPage.solved"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    '${snapshot.data.counter['riddles'] ?? 0}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .tr("userPage.created"),
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
                                SizedBox(
                                  height: 10.0,
                                ),
                                ExpandablePanel(
                                  collapsed: Text(
                                    '${snapshot.data.biography}',
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Text(
                                    '${snapshot.data.biography}',
                                    softWrap: true,
                                    maxLines: 5,
                                  ),
                                  tapHeaderToExpand: true,
                                  tapBodyToCollapse: true,
                                  hasIcon: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }
                  return Container();
                }),
            SizedBox(height: 10.0),
            //TODO: Add pagination
            FutureBuilder(
              future: Provider.of<DatabaseServices>(context)
                  .fetchUserRiddle(userId: user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData)
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
      ),
    );
  }
}

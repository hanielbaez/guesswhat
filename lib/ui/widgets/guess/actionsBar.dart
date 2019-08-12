//Flutter import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/model/love.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/ui/pages/commentPage.dart';
import 'package:share_extend/share_extend.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/services/auth.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    Key key,
    @required this.guess,
  }) : super(key: key);

  final Guess guess;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: Provider.of<AuthenticationServices>(context).user(),
      builder: (context, userSnap) {
        if (userSnap.data != null)
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StreamBuilder<Love>(
                  stream: Provider.of<DatabaseServices>(context)
                      .loveStream(customID: guess.id + userSnap.data.uid),
                  builder: (context, loveSnap) {
                    var loveState = loveSnap?.data?.state ?? false;

                    return FlatButton.icon(
                      icon: loveState
                          ? Icon(
                              Icons.favorite,
                              color: Colors.yellow,
                            )
                          : Icon(SimpleLineIcons.getIconData('heart'),
                              color: Colors.white),
                      label: Text(
                        'Love',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (userSnap.data == null) {
                          Scaffold.of(context).openDrawer();
                          return null;
                        }

                        Provider.of<DatabaseServices>(context).updateLoveState(
                            customID: guess.id + userSnap.data.uid,
                            love: Love(state: !loveState));
                      },
                    );
                  }),
              FlatButton.icon(
                icon: Icon(
                  SimpleLineIcons.getIconData('bubbles'),
                  color: Colors.white,
                ),
                label: Text(
                  'Comment',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (userSnap.data == null) {
                    Scaffold.of(context).openDrawer();
                    return null;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CommentPage(
                          guess: guess,
                        );
                      },
                    ),
                  );
                },
              ),
              FlatButton.icon(
                icon: Icon(SimpleLineIcons.getIconData('share'),
                    color: Colors.white),
                label: Text(
                  'Share',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var f = await CustomCacheManager()
                      .getSingleFile('${guess.imageURL ?? guess.videoURL}');
                  var mimeType = lookupMimeType(f.path.split('/').first);
                  ShareExtend.share(f.path, mimeType);
                },
              ),
            ],
          ); //unattainable
        return Container(); //unattainable
      },
    );
  }
}

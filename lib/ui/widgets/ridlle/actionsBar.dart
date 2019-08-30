//Flutter import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Tekel/core/model/love.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/core/model/ridlle.dart';
import 'package:Tekel/ui/pages/commentPage.dart';
import 'package:share_extend/share_extend.dart';
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:Tekel/core/services/auth.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    Key key,
    @required this.ridlle,
  }) : super(key: key);

  final Ridlle ridlle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<FirebaseUser>(
          stream: Provider.of<AuthenticationServices>(context).user(),
          builder: (context, userSnap) {
            if (userSnap.data != null)
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder<Love>(
                    stream: Provider.of<DatabaseServices>(context)
                        .loveStream(customID: ridlle.id + userSnap.data.uid),
                    builder: (context, loveSnap) {
                      var loveState = loveSnap?.data?.state ?? false;

                      return FlatButton.icon(
                        icon: loveState
                            ? Icon(
                                Icons.favorite,
                                color: Colors.yellow,
                              )
                            : Icon(
                                SimpleLineIcons.getIconData('heart'),
                              ),
                        label: Text(
                          'Love',
                        ),
                        onPressed: () {
                          if (userSnap.data == null) {
                            Scaffold.of(context).openDrawer();
                            return null;
                          }

                          Provider.of<DatabaseServices>(context)
                              .updateLoveState(
                            customID: ridlle.id + userSnap.data.uid,
                            love: Love(
                              state: !loveState,
                              userId: userSnap.data.uid,
                              ridlleId: ridlle.id,
                              thumbnailUrl: ridlle.thumbnailUrl,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      SimpleLineIcons.getIconData('bubbles'),
                    ),
                    label: Text(
                      'Comment',
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
                              ridlle: ridlle,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      SimpleLineIcons.getIconData('share'),
                    ),
                    label: Text(
                      'Share',
                    ),
                    onPressed: () async {
                      var f = await CustomCacheManager().getSingleFile(
                          '${ridlle.imageUrl ?? ridlle.videoUrl}');
                      var mimeType = lookupMimeType(f.path.split('/').first);
                      ShareExtend.share(f.path, mimeType);
                    },
                  ),
                ],
              ); //unattainable
            return Container(); //unattainable
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ridlle.loveCounter.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${ridlle.loveCounter} Loves',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
            ridlle.commentCounter.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${ridlle.commentCounter} Comments',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}

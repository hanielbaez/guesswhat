//Flutter import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:share_extend/share_extend.dart';

//Self import
import 'package:Tekel/core/model/love.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/custom/customCacheManager.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    Key key,
    @required this.riddle,
  }) : super(key: key);

  final Riddle riddle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        StreamBuilder<Love>(
          stream: Provider.of<DatabaseServices>(context)
              .loveStream(riddleId: riddle.id),
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
                '${riddle.loves}',
              ),
              onPressed: () {
                var _uid =
                    Provider.of<DatabaseServices>(context).currentUser?.uid;
                if (_uid == null) {
                  Scaffold.of(context).openDrawer();
                  return null;
                }

                //! If the user is just log in, the "Love action" could be miss.
                Provider.of<DatabaseServices>(context).updateLoveState(
                  riddleId: riddle.id,
                  love: Love(
                    state: !loveState,
                    ownerId: riddle.ownerId,
                    riddleId: riddle.id,
                    text: riddle.text ?? '',
                    thumbnailUrl: riddle.thumbnailUrl,
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
            '${riddle.comments}',
          ),
          onPressed: () {
            var _uid = Provider.of<DatabaseServices>(context).currentUser?.uid;
            if (_uid == null) {
              Scaffold.of(context).openDrawer();
              return null;
            }
            Navigator.of(context).pushNamed('commentsPage', arguments: riddle);
          },
        ),
        FlatButton.icon(
          icon: Icon(
            SimpleLineIcons.getIconData('trophy'),
          ),
          label: Text(
            '${riddle.solvedBy}',
          ),
          onPressed: () async {
            //TODO: Navigate to the leaderboard
            /* var url = riddle.imageUrl ?? riddle.videoUrl;
            if (url != null) {
              var f = await CustomCacheManager().getSingleFile('$url');
              var mimeType = lookupMimeType(f.path.split('/').first);
              ShareExtend.share(f.path, mimeType);
            } else {
              ShareExtend.share(riddle.text, 'text');
            } */
          },
        ),
      ],
    );
  }
}

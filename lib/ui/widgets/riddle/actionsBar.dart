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
    String _uid = Provider.of<DatabaseServices>(context).currentUser?.uid;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        StreamBuilder<Love>(
          stream: Provider.of<DatabaseServices>(context)
              .loveStream(riddleId: riddle.id, userId: _uid),
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
                riddle.loves.isNotEmpty ? '${riddle.loves}' : '',
              ),
              onPressed: () {
                if (_uid == null) {
                  Scaffold.of(context).openDrawer();
                  return null;
                }

                Provider.of<DatabaseServices>(context).updateLoveState(
                  riddleId: riddle.id,
                  love: Love(
                    state: !loveState,
                    userId: _uid,
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
            riddle.comments.isNotEmpty ? '${riddle.comments}' : '',
          ),
          onPressed: () {
            if (_uid == null) {
              Scaffold.of(context).openDrawer();
              return null;
            }
            Navigator.of(context).pushNamed('commentsPage', arguments: riddle);
          },
        ),
        FlatButton.icon(
          icon: Icon(
            SimpleLineIcons.getIconData('share'),
          ),
          label: Text(
            '',
          ),
          onPressed: () async {
            var url = riddle.imageUrl ?? riddle.videoUrl;
            if (url != null) {
              var f = await CustomCacheManager().getSingleFile('$url');
              var mimeType = lookupMimeType(f.path.split('/').first);
              ShareExtend.share(f.path, mimeType);
            } else {
              ShareExtend.share(riddle.text, 'text');
            }
          },
        ),
      ],
    );
  }
}

//Flutter import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/costum/costumCacheManager.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';
import 'package:guess_what/ui/pages/commentPage.dart';
import 'package:share_extend/share_extend.dart';

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
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(SimpleLineIcons.getIconData('heart'),
                  color: Colors.white),
              label: Text(
                'Love',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (snapshot.data == null) {
                  Scaffold.of(context).openDrawer();
                  return null;
                }
              },
            ),
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
                  if (snapshot.data == null) {
                    Scaffold.of(context).openDrawer();
                    return null;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider<CommentViewModel>.value(
                          value: CommentViewModel(
                            databaseServices: Provider.of(context),
                          ),
                          child: Consumer<CommentViewModel>(
                            builder: (context, model, child) {
                              return CommentPage(
                                model: model,
                                guess: guess,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
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
      },
    );
  }
}

//Flutter and Dart import
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:mime/mime.dart';
import 'package:share_extend/share_extend.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

//Selft import
import 'package:Tekel/core/model/riddle.dart';
import 'package:Tekel/core/model/user.dart';

class UserBar extends StatelessWidget {
  final User user;
  final Timestamp timeStamp;
  final String address;
  final Riddle riddle;

  UserBar({this.user, this.timeStamp, this.address, this.riddle});

  @override
  Widget build(BuildContext context) {
    var langCode = Localizations.localeOf(context).languageCode;
    var language;

    switch (langCode) {
      case 'es':
        language = Language.SPANISH;
        break;
      default:
        language = Language.ENGLISH;
        break;
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'userPage', arguments: user),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/noiseTv.gif',
                    image: user.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Text(
                        '${user.displayName}'.split(' ')[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = .5
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        '${user.displayName}'.split(' ')[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (address == null ? '' : address + ' ・ ') +
                        TimeAgo.getTimeAgo(timeStamp.millisecondsSinceEpoch,
                            language: language),
                    style: TextStyle(
                      color: Color.fromARGB(255, 100, 100, 100),
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                SimpleLineIcons.getIconData('options-vertical'),
                color: Colors.black,
                size: 20.0,
              ),
              onPressed: () async {
                //TODO: Add option to report a problem
                if (riddle != null) {
                  var url = riddle.imageUrl ?? riddle.videoUrl;
                  if (url != null) {
                    var f = await CustomCacheManager().getSingleFile('$url');
                    var mimeType = lookupMimeType(f.path.split('/').first);
                    ShareExtend.share(f.path, mimeType);
                  } else {
                    ShareExtend.share(riddle.text, 'text');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

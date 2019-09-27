//Flutter and Dart import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

//Selft import
import 'package:Tekel/core/model/user.dart';

class UserBar extends StatelessWidget {
  final User user;
  final Timestamp timeStamp;
  final String address;

  UserBar({this.user, this.timeStamp, this.address});

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
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 35,
              height: 35,
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
    );
  }
}

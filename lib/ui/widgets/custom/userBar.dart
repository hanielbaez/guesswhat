//Flutter and Dart import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class UserBar extends StatelessWidget {
  final User user;
  final Timestamp timeStamp;
  final String address;

  UserBar({this.user, this.timeStamp, this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'userPage', arguments: user),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/noiseTv.gif',
              image: user.photoURL,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${user.displayName}'.split(' ')[0],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (address == null ? '' : address + ' ・ ') +
                    TimeAgo.getTimeAgo(
                      timeStamp.millisecondsSinceEpoch,
                    ),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
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

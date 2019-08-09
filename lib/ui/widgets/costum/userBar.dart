import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class UserBar extends StatelessWidget {
  final Map<dynamic, dynamic> userData;
  final Timestamp timeStamp;

  UserBar({this.userData, this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            border: Border.all(color: Colors.white),
          ),
          child: Image.network(
            userData['photoURL'].toString(),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${userData['displayName']}'.split(' ')[0] +
                  ' ・ ' +
                  TimeAgo.getTimeAgo(timeStamp.millisecondsSinceEpoch),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

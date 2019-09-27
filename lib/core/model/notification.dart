import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class NotificationModel {
  final String userId;
  final String displayName;
  final String actionId;
  final Icon icon;
  final bool viewed;
  final String type;
  final String timeAgo;

  NotificationModel(
      {@required this.userId,
      @required this.displayName,
      @required this.actionId,
      @required this.icon,
      @required this.type,
      @required this.viewed,
      this.timeAgo});

  factory NotificationModel.fromFirestore(DocumentSnapshot document) {
    Map map = document.data;
    var icon;
    switch (map['type']) {
      case 'comment':
        icon = Icon(SimpleLineIcons.getIconData('bubbles'), color: Colors.blue);
        break;
      case 'love':
        icon = Icon(SimpleLineIcons.getIconData('heart'), color: Colors.red);
        break;
      case 'solved':
        icon = Icon(SimpleLineIcons.getIconData('check'), color: Colors.green);
        break;
      default:
        icon = Icon(SimpleLineIcons.getIconData('info'), color: Colors.black);
        break;
    }

    return NotificationModel(
      userId: map['userId'],
      displayName: map['displayName'],
      actionId: map['actionId'],
      icon: icon,
      type: map['type'],
      viewed: map['viewed'],
      timeAgo: TimeAgo.getTimeAgo(
        map['createdAt'].millisecondsSinceEpoch,
      ),
    );
  }
}

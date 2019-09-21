import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class NotificationModel {
  final String userId;
  final String displayName;
  final String actionId;
  final IconData icon;
  final bool viewed;
  final String timeAgo;

  NotificationModel(
      {@required this.userId,
      @required this.displayName,
      @required this.actionId,
      @required this.icon,
      @required this.viewed,
      this.timeAgo});

  factory NotificationModel.fromFirestore(DocumentSnapshot document) {
    Map map = document.data;
    var iconData;
    switch (map['type']) {
      case 'comment':
        iconData = SimpleLineIcons.getIconData('bubbles');
        break;
      case 'love':
        iconData = SimpleLineIcons.getIconData('heart');
        break;
      case 'solved':
        iconData = SimpleLineIcons.getIconData('check');
        break;
      default:
        iconData = SimpleLineIcons.getIconData('info');
        break;
    }

    return NotificationModel(
      userId: map['userId'],
      displayName: map['displayName'],
      actionId: map['actionId'],
      icon: iconData,
      viewed: map['viewed'],
      timeAgo: TimeAgo.getTimeAgo(
        map['createdAt'].millisecondsSinceEpoch,
      ),
    );
  }
}

//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/model/notification.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
        ),
        leading: IconButton(
          //Costum Back Button
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<DatabaseServices>(context).streamNotification(),
        builder: (context, snapshot) {
          var documents = snapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var notification =
                  NotificationModel.fromFirestore(documents[index]);
              return ListTile(
                leading: Icon(
                  notification.icon,
                ),
                title: GestureDetector(
                    onTap: () {
                      //TODO: Navigate to the user page
                    },
                    child: Text('${notification.displayName}')),
                subtitle: Text('${notification.timeAgo}'),
              );
            },
          );
        },
      ),
    );
  }
}

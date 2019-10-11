//Flutter and Dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
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
    Provider.of<DatabaseServices>(context).switchViewed();
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr("notificationPage.title"),
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
            if (snapshot.hasData) if (!snapshot.hasError) {
              var documents = snapshot.data.documents;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var message = '';
                  var notification =
                      NotificationModel.fromFirestore(documents[index]);

                  switch (documents[index]['type']) {
                    case 'solved':
                      message = AppLocalizations.of(context)
                          .tr("notificationPage.solveAction");
                      break;
                    case 'love':
                      message = AppLocalizations.of(context).tr(
                        "notificationPage.loveAction",
                      );
                      break;
                    case 'comment':
                      message = AppLocalizations.of(context).tr(
                        "notificationPage.commentAction",
                      );
                      break;
                  }

                  return CustomListTile(
                      notification: notification, message: message);
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key key,
    @required this.notification,
    @required this.message,
  }) : super(key: key);

  final NotificationModel notification;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.icon,
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontFamily: 'NanumGothic',
          ),
          children: <TextSpan>[
            TextSpan(
              text: '${notification.displayName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: message,
            ),
          ],
        ),
      ),
      subtitle: Text('${notification.timeAgo}'),
    );
  }
}

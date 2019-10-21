//Flutter and Dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/model/leaderBoard.dart';

class RiddleTopSolversPage extends StatelessWidget {
  final String riddleId;

  RiddleTopSolversPage({this.riddleId});

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr("leaderBoardPage.title"),
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
        body: FutureBuilder<List<LeaderBoard>>(
          future: Provider.of<DatabaseServices>(context)
              .getTopSolvers(riddleId: riddleId),
          builder: (context, snapshot) {
            if (snapshot.hasData) if (!snapshot.hasError) {
              var documents = snapshot.data;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var _trophyColor = Colors.transparent;
                  switch (index) {
                    case 0:
                      _trophyColor = Color.fromARGB(255, 212, 175, 55);
                      break;
                    case 1:
                      _trophyColor = Color.fromARGB(255, 138, 149, 151);
                      break;
                    case 2:
                      _trophyColor = Color.fromARGB(255, 176, 141, 87);
                      break;
                  }

                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, 'userPage',
                        arguments: documents[index].user),
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: _trophyColor, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 15.0,
                            )
                          ]),
                      child: ListTile(
                        leading: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: 40.0),
                          textAlign: TextAlign.center,
                        ),
                        title: Text(
                          '${documents[index].user.displayName}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip,
                        ),
                        trailing: index < 3
                            ? Icon(
                                SimpleLineIcons.getIconData('trophy'),
                                color: _trophyColor,
                                size: 40.0,
                              )
                            : SizedBox(),
                        subtitle: Text(documents[index]
                            .createdAt
                            .toDate()
                            .toLocal()
                            .toString()),
                      ),
                    ),
                  );
                },
              );
            }
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    SimpleLineIcons.getIconData('trophy'),
                    color: Colors.black,
                    size: 50.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(AppLocalizations.of(context).tr("solvedPage.noSolved")),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

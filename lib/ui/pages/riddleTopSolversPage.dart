//Flutter and Dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/model/leaderBoard.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class RiddleTopSolversPage extends StatelessWidget {
  final String riddleId;

  RiddleTopSolversPage({this.riddleId});

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
                      _trophyColor = Colors.yellow[600];
                      break;
                    case 1:
                      _trophyColor = Colors.black45;
                      break;
                    case 2:
                      _trophyColor = Colors.brown;
                      break;
                  }

                  return Container(
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
                      title: GestureDetector(
                        onTap: () {
                          //TODO: Navigate to the user page
                        },
                        child: Text('${documents[index].displayName}'),
                      ),
                      trailing: index < 2
                          ? Icon(
                              SimpleLineIcons.getIconData('trophy'),
                              color: _trophyColor,
                              size: 40.0,
                            )
                          : Container(),
                      subtitle: Text(
                        TimeAgo.getTimeAgo(
                            documents[index].createdAt.millisecondsSinceEpoch,
                            language: language),
                      ),
                    ),
                  );
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

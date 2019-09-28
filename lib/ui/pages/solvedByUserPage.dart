//Flutter and Dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/ui/widgets/custom/customGridView.dart';

class SolvedByPage extends StatelessWidget {
  final User user;

  SolvedByPage({this.user});

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr("solvedPage.title"),
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
        backgroundColor: Colors.white,
        body: FutureBuilder<List>(
          future: Provider.of<DatabaseServices>(context)
              .getAllSolvedBy(userId: user.uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .tr("solvedPage.connectionError"),
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: SpinKitThreeBounce(
                    color: Colors.black,
                    size: 50.0,
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) return Text('Error');
                if (snapshot.hasData) {
                  return CustomGridView(
                    list: snapshot.data,
                  );
                } else {
                  return Container();
                }
            }
            return Text('Unattainable');
          },
        ),
      ),
    );
  }
}

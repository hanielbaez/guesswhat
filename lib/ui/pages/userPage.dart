//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/ui/widgets/custom/customGridView.dart';
import 'package:guess_what/core/model/user.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  final User user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserPage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${user.displayName}',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Provider.of<DatabaseServices>(context)
            .fectchUserRidlle(),
        builder: (context, snapshot) {
          if (snapshot.hasData) //return Text('${snapshot.data}');
            return CustomGridView(
              list: snapshot.data,
            );
          return Container();
        },
      ),
    );
  }
}

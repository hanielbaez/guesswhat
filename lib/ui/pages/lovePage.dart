//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/ui/widgets/custom/customGridView.dart';

class LovePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loved",
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
        future: Provider.of<DatabaseServices>(context).loveRiddle(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('Please try later'));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Please wait...'),
                    SpinKitThreeBounce(
                      color: Colors.black,
                      size: 50.0,
                    ),
                  ],
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                return CustomGridView(
                  list: snapshot.data,
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        SimpleLineIcons.getIconData('heart'),
                        color: Colors.yellow,
                        size: 50.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('You do not love any riddle yet'),
                    ],
                  ),
                );
              }
          }
          return Text('Unattainable');
        },
      ),
    );
  }
}

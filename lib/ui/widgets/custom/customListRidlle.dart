//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//Self import
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/ui/widgets/ridlle/ridlle.dart';

class CustomListRidlle extends StatelessWidget {
  final Function onModelReady;

  CustomListRidlle({Key key, this.onModelReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DatabaseServices>(context).fectchRidlle(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitThreeBounce(
                    color: Colors.black,
                    size: 50.0,
                  ),
                  Text('Please wait...'),
                ],
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: RidlleLayaout(ridlle: snapshot.data[index]),
                );
              },
            );
        }
        return Text('Something went wrong, please try later');
      },
    );
  }
}

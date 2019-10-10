//Flutter and dart import
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:location/location.dart';

class IntroPage extends StatelessWidget {
  final Location _location = Location();

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EasyLocalizationProvider(
          data: data,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).tr('introPage.title'),
                style: TextStyle(color: Colors.black, fontSize: 30.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              Icon(
                SimpleLineIcons.getIconData('location-pin'),
                size: 60.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                AppLocalizations.of(context).tr('introPage.message'),
                style: TextStyle(color: Colors.black54, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.0,
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.yellow[600], Colors.orange[400]],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: FlatButton(
                    child: Text(
                      AppLocalizations.of(context).tr('introPage.button_text'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool isGranted = await _location.requestPermission();
                      if (isGranted) {
                        await prefs.setBool('locationPermission', isGranted);
                        Navigator.of(context).pushReplacementNamed('homePage');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

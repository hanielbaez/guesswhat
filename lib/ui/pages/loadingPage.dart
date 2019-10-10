//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Selft import
import 'package:Tekel/ui/pages/homePage.dart';
import 'package:Tekel/ui/pages/introPage.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future getfromSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isGranted = prefs.get('locationPermission') ?? false;
    if (_isGranted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (contex) => HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    getfromSharePreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.black,
          size: 40.0,
        ),
      ),
    );
  }
}

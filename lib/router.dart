//Flutter and Dart import
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/ui/pages/ridllePage.dart';
import 'package:Tekel/ui/pages/homePage.dart';
import 'package:Tekel/ui/pages/lovePage.dart';
import 'package:Tekel/ui/pages/supportPage.dart';
import 'package:Tekel/ui/pages/unknownPage.dart';
import 'package:Tekel/ui/pages/userPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case 'lovePage':
      return MaterialPageRoute(
        builder: (context) => LovePage(),
      );
    case 'ridllePage':
      return MaterialPageRoute(
        builder: (context) => RidllePage(settings.arguments),
      );
    case 'userPage':
      return MaterialPageRoute(
        builder: (context) => UserPage(user: settings.arguments),
      );
    case 'supportPage':
      return MaterialPageRoute(
        builder: (context) => SupportPage(user: settings.arguments),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => UnknownPage(),
      );
  }
}

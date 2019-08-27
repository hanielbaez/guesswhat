//Flutter and Dart import
import 'package:flutter/material.dart';

//Self import
import 'package:guess_what/ui/pages/ridllePage.dart';
import 'package:guess_what/ui/pages/homePage.dart';
import 'package:guess_what/ui/pages/lovePage.dart';
import 'package:guess_what/ui/pages/supportPage.dart';
import 'package:guess_what/ui/pages/unknownPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case 'lovePage':
      return MaterialPageRoute(
        builder: (context) => LovePage(settings.arguments),
      );
    case 'ridllePage':
      return MaterialPageRoute(
        builder: (context) => RidllePage(settings.arguments),
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

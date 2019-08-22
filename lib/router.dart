import 'package:flutter/material.dart';
import 'package:guess_what/ui/pages/guessPage.dart';
import 'package:guess_what/ui/pages/homePage.dart';
import 'package:guess_what/ui/pages/lovePage.dart';
import 'package:guess_what/ui/pages/unknownPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
    case 'lovePage':
      return MaterialPageRoute(
          builder: (context) => LovePage(settings.arguments));
    case 'guessPage':
      return MaterialPageRoute(
        builder: (context) => GuessPage(settings.arguments),
      );
    default:
      return MaterialPageRoute(builder: (context) => UnknownPage());
  }
}

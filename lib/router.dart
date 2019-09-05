//Flutter and Dart import
import 'package:Tekel/ui/pages/commentPage.dart';
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/ui/pages/riddlePage.dart';
import 'package:Tekel/ui/pages/homePage.dart';
import 'package:Tekel/ui/pages/lovePage.dart';
import 'package:Tekel/ui/pages/supportPage.dart';
import 'package:Tekel/ui/pages/unknownPage.dart';
import 'package:Tekel/ui/pages/userPage.dart';
import 'package:Tekel/ui/pages/editUserPage.dart';

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
    case 'riddlePage':
      return MaterialPageRoute(
        builder: (context) => RiddlePage(settings.arguments),
      );
    case 'userPage':
      return MaterialPageRoute(
        builder: (context) => UserPage(user: settings.arguments),
      );
    case 'supportPage':
      return MaterialPageRoute(
        builder: (context) => SupportPage(user: settings.arguments),
      );
    case 'commentsPage':
      return MaterialPageRoute(
        builder: (context) => CommentPage(riddle: settings.arguments),
      );
    case 'editUserPage':
      return MaterialPageRoute(
        builder: (context) => EditUserPage(user: settings.arguments),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => UnknownPage(),
      );
  }
}

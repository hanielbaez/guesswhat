//Flutter and Dart import
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/ui/pages/riddlePage.dart';
import 'package:Tekel/ui/pages/homePage.dart';
import 'package:Tekel/ui/pages/lovePage.dart';
import 'package:Tekel/ui/pages/supportPage.dart';
import 'package:Tekel/ui/pages/unknownPage.dart';
import 'package:Tekel/ui/pages/userPage.dart';
import 'package:Tekel/ui/pages/editUserPage.dart';
import 'package:Tekel/ui/pages/commentPage.dart';
import 'package:Tekel/ui/pages/solvedByUserPage.dart';
import 'package:Tekel/ui/pages/textCreatePage.dart';
import 'package:page_transition/page_transition.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return PageTransition(
          child: HomePage(), type: PageTransitionType.rightToLeft);
    case 'lovePage':
      return PageTransition(
          child: LovePage(), type: PageTransitionType.leftToRight);
    case 'riddlePage':
      return PageTransition(
          child: RiddlePage(settings.arguments),
          type: PageTransitionType.leftToRight);
    case 'userPage':
      return PageTransition(
          child: UserPage(user: settings.arguments),
          type: PageTransitionType.leftToRight);
    case 'supportPage':
      return PageTransition(
          child: SupportPage(user: settings.arguments),
          type: PageTransitionType.leftToRight);
    case 'commentsPage':
      return PageTransition(
          child: CommentPage(riddle: settings.arguments),
          type: PageTransitionType.downToUp);
    case 'editUserPage':
      return PageTransition(
          child: EditUserPage(user: settings.arguments),
          type: PageTransitionType.leftToRight);
    case 'solvedByPage':
      return PageTransition(
          child: SolvedByPage(user: settings.arguments),
          type: PageTransitionType.leftToRight);
    case 'createTextRiddle':
      return PageTransition(
          child: TextCreatePage(), type: PageTransitionType.leftToRight);
    default:
      return MaterialPageRoute(
        builder: (context) => UnknownPage(),
      );
  }
}

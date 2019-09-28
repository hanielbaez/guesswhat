//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
import 'package:Tekel/ui/pages/notificationPage.dart';
import 'package:Tekel/ui/pages/riddleTopSolversPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Object argument = settings.arguments;
  switch (settings.name) {
    case '/':
      return PageTransition(
          child: HomePage(), type: PageTransitionType.rightToLeft);
    case 'lovePage':
      return PageTransition(
          child: LovePage(), type: PageTransitionType.leftToRight);
    case 'riddlePage':
      return PageTransition(
          child: RiddlePage(argument), type: PageTransitionType.leftToRight);
    case 'userPage':
      return PageTransition(
          child: UserPage(user: argument),
          type: PageTransitionType.leftToRight);
    case 'supportPage':
      return PageTransition(
          child: SupportPage(user: argument),
          type: PageTransitionType.leftToRight);
    case 'commentsPage':
      return PageTransition(
          child: CommentPage(riddle: argument),
          type: PageTransitionType.downToUp);
    case 'editUserPage':
      return PageTransition(
          child: EditUserPage(user: argument),
          type: PageTransitionType.leftToRight);
    case 'solvedByPage':
      return PageTransition(
          child: SolvedByPage(user: argument),
          type: PageTransitionType.leftToRight);
    case 'notificationsPage':
      return PageTransition(
          child: NotificationPage(), type: PageTransitionType.leftToRight);
    case 'createTextRiddle':
      return PageTransition(
          child: TextCreatePage(), type: PageTransitionType.leftToRight);
    case 'topSolversPage':
      return PageTransition(
          child: RiddleTopSolversPage(
            riddleId: argument,
          ),
          type: PageTransitionType.downToUp);
    default:
      return MaterialPageRoute(
        builder: (context) => UnknownPage(),
      );
  }
}
